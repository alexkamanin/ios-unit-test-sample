final class UserRepository: UserRepositoryProtocol {
    
    private final let localDataSource: UserLocalDataSourceProtocol
    private final let remoteDataSource: UserRemoteDataSourceProtocol
    
    init(
        localDataSource: UserLocalDataSourceProtocol,
        remoteDataSource: UserRemoteDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func get() async throws -> User {
        if let user = localDataSource.get() {
            return user
        }
        
        let user = try await remoteDataSource.get()
        localDataSource.set(user)
        return user
    }
}
