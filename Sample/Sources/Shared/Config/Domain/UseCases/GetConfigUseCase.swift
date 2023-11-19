/// @mockable
class GetConfigUseCase {
    
    private let repository: ConfigRepositoryProtocol
    
    init(repository: ConfigRepositoryProtocol) {
        self.repository = repository
    }
    
    func callAsFunction() async throws -> Config {
        try await repository.get()
    }
}
