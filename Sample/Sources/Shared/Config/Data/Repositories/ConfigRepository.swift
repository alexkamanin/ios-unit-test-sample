final class ConfigRepository: ConfigRepositoryProtocol {
    
    private let dataSource: ConfigDataSourceProtocol
    
    init(dataSource: ConfigDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func get() async throws -> Config {
        try await dataSource.get()
    }
}
