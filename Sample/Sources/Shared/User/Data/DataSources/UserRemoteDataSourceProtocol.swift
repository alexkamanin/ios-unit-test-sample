import Foundation

/// @mockable
protocol UserRemoteDataSourceProtocol {
    
    func get() async throws -> User
}

final class UserRemoteDataSource: UserRemoteDataSourceProtocol {

    private var user = User(firstName: "Ivan", middleName: nil, lastName: "Ivanov")
    
    func get() async throws -> User {
        sleep(3)
        return self.user
    }
}
