import Foundation

/// @mockable
protocol ConfigDataSourceProtocol {
    
    func get() async throws -> Config
}

final class ConfigDataSource: ConfigDataSourceProtocol {
    
    private let config = Config(enabled: true)
    
    func get() async throws -> Config {
        sleep(2)
        return self.config
    }
}
