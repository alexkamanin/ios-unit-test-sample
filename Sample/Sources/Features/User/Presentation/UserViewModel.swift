import Foundation

@MainActor
final class UserViewModel: ObservableObject {
    
    private let getUserUseCase: GetUserUseCase
    private let getConfigUseCase: GetConfigUseCase
    
    @Published private(set) var state: UserState = .initial
    
    init(
        getUserUseCase: GetUserUseCase,
        getConfigUseCase: GetConfigUseCase
    ) {
        self.getUserUseCase = getUserUseCase
        self.getConfigUseCase = getConfigUseCase
    }
    
    func load() {
        state = .loading
        
        Task {
            do {
                async let userAsync = getUserUseCase()
                async let configAsync = getConfigUseCase()
                
                let (user, config) = try await (userAsync, configAsync)
                state = .content(UserState.ContentData(user: user, config: config))
            } catch {
                state = .error
            }
        }
    }
    
    func changeConfig(enabled: Bool) {
        guard var contentData = state.asContentData() else { return }
        contentData.config.enabled = enabled
        
        state = .content(contentData)
    }
}
