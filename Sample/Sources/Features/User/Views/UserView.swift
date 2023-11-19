import SwiftUI

struct UserView: View {
    
    @ObservedObject var viewModel: UserViewModel
    
    private var configEnabledBinding: Binding<Bool> {
        Binding(
            get: { viewModel.state.asContentData()?.config.enabled ?? false },
            set: { viewModel.changeConfig(enabled: $0) }
        )
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
                case .initial: EmptyView()
                case .loading: LoadingView()
                case .content(let data): ContentView(data: data, configEnabledBinding: configEnabledBinding)
                case .error: ErrorView()
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
    
    struct LoadingView: View {
        
        var body: some View {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
    struct ContentView: View {
        
        let data: UserState.ContentData
        @Binding var configEnabledBinding: Bool
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("First name: \(data.user.firstName)")
                
                if let middleName = data.user.middleName {
                    Text("Middle name: \(middleName)")
                }

                Text("Last name: \(data.user.lastName)")
                    .foregroundColor(data.config.enabled ? .red : .blue)
                
                Toggle("Change config", isOn: $configEnabledBinding)
            }
            .padding()
        }
    }
    
    struct ErrorView: View {
        
        var body: some View {
            Text("error")
        }
    }
}

struct Loading: PreviewProvider {
    
    static var previews: some View {
        UserView.LoadingView()
    }
}

struct Content: PreviewProvider {
    
    static var previews: some View {
        let user = User(firstName: "Ivan", middleName: nil, lastName: "Ivanov")
        let config = Config(enabled: true)
        let data = UserState.ContentData(user: user, config: config)
        
        UserView.ContentView(data: data, configEnabledBinding: .constant(false))
    }
}
