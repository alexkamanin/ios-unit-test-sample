import XCTest
@testable import SampleApp

final class GetUserUseCaseTest: XCTestCase {

    private let repository = UserRepositoryProtocolMock()
    private lazy var useCase = GetUserUseCase(repository: repository)

    private let user = User(firstName: "firstName", middleName: nil, lastName: "lastName")
    
    func test_WHEN_call_as_function_EXPECT_user() async throws {
        let expected = user
        repository.getHandler = { return self.user }
        
        let actual = try await useCase()
        
        XCTAssertEqual(expected, actual)
    }

    func test_WHEN_call_as_function_EXPECT_getting_user_from_repository() async throws {
        repository.getHandler = { return self.user }
        
        let _ = try await useCase()

        XCTAssert(repository.getCallCount == 1)
    }
}
