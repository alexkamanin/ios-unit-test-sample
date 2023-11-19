/// @mockable
protocol UserLocalDataSourceProtocol {
    
    func get() -> User?
    
    func set(_ user: User)
}

final class UserLocalDataSource: UserLocalDataSourceProtocol {
    
    private var user: User?
    
    func get() -> User? {
        self.user
    }
    
    func set(_ user: User) {
        self.user = user
    }
}
