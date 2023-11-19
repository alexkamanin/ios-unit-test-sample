import XCTest
@testable import SampleApp

@MainActor
final class UserViewModelTest: XCTestCase {

    private let getUserUseCase = GetUserUseCaseMock()
    private let getConfigUseCase = GetConfigUseCaseMock()
    private lazy var viewModel = UserViewModel(getUserUseCase: getUserUseCase, getConfigUseCase: getConfigUseCase)
    
    private let userExpectation = XCTestExpectation(description: String(describing: GetUserUseCase.self))
    private let configExpectation = XCTestExpectation(description: String(describing: GetConfigUseCase.self))
    
    private let user = User(firstName: "firstName", middleName: nil, lastName: "lastName")
    private let config = Config(enabled: true)
    
    func test_WHEN_init_EXPECT_initial_state() throws {
        XCTAssertEqual(.initial, viewModel.state)
    }
    
    func test_WHEN_load_EXPECT_loading_state() throws {
        getUserUseCase.callAsFunctionHandler = {
            return self.user
        }
        getConfigUseCase.callAsFunctionHandler = {
            return self.config
        }
        
        viewModel.load()

        XCTAssertEqual(.loading, viewModel.state)
    }
    
    func test_WHEN_load_AND_user_loaded_EXPECT_content_state() async throws {
        let contentData = UserState.ContentData(user: user, config: config)
        
        getUserUseCase.callAsFunctionHandler = {
            defer { self.userExpectation.fulfill() }
            return self.user
        }
        getConfigUseCase.callAsFunctionHandler = {
            defer { self.configExpectation.fulfill() }
            return self.config
        }

        viewModel.load()

        await fulfillment(of: [userExpectation, configExpectation])
        XCTAssertEqual(.content(contentData), viewModel.state)
    }
    
    func test_WHEN_load_EXPECT_get_user() async throws {
        getUserUseCase.callAsFunctionHandler = {
            defer { self.userExpectation.fulfill() }
            return self.user
        }
        getConfigUseCase.callAsFunctionHandler = {
            defer { self.configExpectation.fulfill() }
            return self.config
        }

        viewModel.load()

        await fulfillment(of: [userExpectation, configExpectation])
        XCTAssert(getUserUseCase.callAsFunctionCallCount == 1)
    }
    
    func test_WHEN_load_EXPECT_get_config() async throws {
        getUserUseCase.callAsFunctionHandler = {
            defer { self.userExpectation.fulfill() }
            return self.user
        }
        getConfigUseCase.callAsFunctionHandler = {
            defer { self.configExpectation.fulfill() }
            return self.config
        }

        viewModel.load()

        await fulfillment(of: [userExpectation, configExpectation])
        XCTAssert(getConfigUseCase.callAsFunctionCallCount == 1)
    }
    
    func test_WHEN_load_AND_get_user_returns_error_EXPECT_error_state() async throws {
        getUserUseCase.callAsFunctionHandler = {
            defer { self.userExpectation.fulfill() }
            throw NSError(domain: "Some error", code: -1)
        }
        getConfigUseCase.callAsFunctionHandler = {
            defer { self.configExpectation.fulfill() }
            return self.config
        }

        viewModel.load()

        await fulfillment(of: [userExpectation, configExpectation])
        XCTAssertEqual(.error, viewModel.state)
    }
    
    func test_WHEN_load_AND_get_config_returns_error_EXPECT_error_state() async throws {
        getUserUseCase.callAsFunctionHandler = {
            defer { self.userExpectation.fulfill() }
            return self.user
        }
        getConfigUseCase.callAsFunctionHandler = {
            defer { self.configExpectation.fulfill() }
            throw NSError(domain: "Some error", code: -1)
        }

        viewModel.load()

        await fulfillment(of: [userExpectation, configExpectation])
        XCTAssertEqual(.error, viewModel.state)
    }
    
    func test_WHEN_change_config_EXPECT_content_state_with_changed_config() async throws {
        let initialConfig = Config(enabled: false)
        let changedConfig = Config(enabled: true)
        let contentData = UserState.ContentData(user: user, config: changedConfig)
        
        getUserUseCase.callAsFunctionHandler = {
            defer { self.userExpectation.fulfill() }
            return self.user
        }
        getConfigUseCase.callAsFunctionHandler = {
            defer { self.configExpectation.fulfill() }
            return initialConfig
        }
        viewModel.load()
        await fulfillment(of: [userExpectation, configExpectation])
        
        viewModel.changeConfig(enabled: true)

        XCTAssertEqual(.content(contentData), viewModel.state)
    }
}
