/// @mockable
protocol ConfigRepositoryProtocol {
    
    func get() async throws -> Config
}
