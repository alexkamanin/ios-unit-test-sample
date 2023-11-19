import XCTest
@testable import SampleApp

final class UserRepositoryTest: XCTestCase {

    private let localDataSource = UserLocalDataSourceProtocolMock()
    private let remoteDataSource = UserRemoteDataSourceProtocolMock()
    private lazy var repository = UserRepository(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
    
    private let user = User(firstName: "firstName", middleName: nil, lastName: "lastName")

    func test_WHEN_get_AND_local_data_source_returns_user_EXPECT_user() async throws {
        let expected = user
        
        localDataSource.getHandler = { return self.user }
        
        let actual = try await repository.get()
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_WHEN_get_AND_local_data_source_returns_user_EXPECT_not_get_user_from_remote_data_source() async throws {
        localDataSource.getHandler = { return self.user }
        
        let _ = try await repository.get()
        
        XCTAssert(remoteDataSource.getCallCount == 0)
    }
    
    func test_WHEN_get_AND_local_data_source_not_returns_user_EXPECT_get_user_from_remote_data_source() async throws {
        localDataSource.getHandler = { return nil }
        remoteDataSource.getHandler = { return self.user }
        
        let _ = try await repository.get()
        
        XCTAssert(remoteDataSource.getCallCount == 1)
    }
    
    func test_WHEN_get_AND_local_data_source_not_returns_user_AND_remote_data_source_returns_user_EXPECT_user() async throws {
        let expected = user
        
        localDataSource.getHandler = { return nil }
        remoteDataSource.getHandler = { return self.user }
        
        let actual = try await repository.get()
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_WHEN_get_AND_local_data_source_not_returns_user_AND_remote_data_source_returns_user_EXPECT_set_user_to_local_data_source() async throws {
        let expected = user
        
        localDataSource.getHandler = { return nil }
        remoteDataSource.getHandler = { return self.user }
        
        let _ = try await repository.get()
        
        let actual = localDataSource.setArgValues.first
        XCTAssertEqual(expected, actual)
    }
}
