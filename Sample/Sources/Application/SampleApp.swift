import SwiftUI

@main
struct SampleApp: App {
    
    private let viewModel: UserViewModel
    
    init() {
        let userLocalDataSource: UserLocalDataSourceProtocol = UserLocalDataSource()
        let userRemoteDataSource: UserRemoteDataSourceProtocol = UserRemoteDataSource()
        let userRepository: UserRepositoryProtocol = UserRepository(localDataSource: userLocalDataSource, remoteDataSource: userRemoteDataSource)
        let getUserUseCase = GetUserUseCase(repository: userRepository)
        let configDataSource: ConfigDataSourceProtocol = ConfigDataSource()
        let configRepository: ConfigRepositoryProtocol = ConfigRepository(dataSource: configDataSource)
        let getConfigUseCase = GetConfigUseCase(repository: configRepository)
        
        self.viewModel = UserViewModel(getUserUseCase: getUserUseCase, getConfigUseCase: getConfigUseCase)
    }
    
    var body: some Scene {
        WindowGroup {
            UserView(viewModel: viewModel)
        }
    }
}
