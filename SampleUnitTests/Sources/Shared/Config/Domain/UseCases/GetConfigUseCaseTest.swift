import XCTest
@testable import SampleApp

final class GetConfigUseCaseTest: XCTestCase {

    private let repository = ConfigRepositoryProtocolMock()
    private lazy var useCase = GetConfigUseCase(repository: repository)

    private let config = Config(enabled: true)
    
    func test_WHEN_call_as_function_EXPECT_config() async throws {
        let expected = config
        repository.getHandler = { return self.config }
        
        let actual = try await useCase()
        
        XCTAssertEqual(expected, actual)
    }

    func test_WHEN_call_as_function_EXPECT_getting_config_from_repository() async throws {
        repository.getHandler = { return self.config }
        
        let _ = try await useCase()

        XCTAssert(repository.getCallCount == 1)
    }
}
