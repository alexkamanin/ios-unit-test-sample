enum UserState: Equatable {

    case initial
    case loading
    case content(ContentData)
    case error
    
    struct ContentData: Equatable {
        let user: User
        var config: Config
    }
}

extension UserState {
    
    func asContentData() -> UserState.ContentData? {
        guard case .content(let contentData) = self else { return nil }
        return contentData
    }
}
