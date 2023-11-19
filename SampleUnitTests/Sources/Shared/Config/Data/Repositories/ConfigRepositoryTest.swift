import XCTest
@testable import SampleApp

final class ConfigRepositoryTest: XCTestCase {

    private let dataSource = ConfigDataSourceProtocolMock()
    private lazy var repository = ConfigRepository(dataSource: dataSource)
    
    private let config = Config(enabled: true)

    func test_WHEN_get_AND_EXPECT_config() async throws {
        let expected = config
        
        dataSource.getHandler = { return self.config }
        
        let actual = try await repository.get()
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_WHEN_get_AND_EXPECT_getting_config_from_data_source() async throws {
        dataSource.getHandler = { return self.config }
        
        let _ = try await repository.get()
        
        XCTAssert(dataSource.getCallCount == 1)
    }
}
