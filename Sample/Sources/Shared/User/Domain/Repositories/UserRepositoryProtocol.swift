/// @mockable
protocol UserRepositoryProtocol {
    
    func get() async throws -> User
}
