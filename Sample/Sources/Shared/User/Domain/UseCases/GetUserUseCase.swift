/// @mockable
class GetUserUseCase {
    
    private final let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func callAsFunction() async throws -> User {
        try await repository.get()
    }
}
