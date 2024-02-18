import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct VitAlzApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AuthenticatedView {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 250, maxHeight: 300)
                    Text("Welcome to VitAlz!")
                                .font(.title)
                                .foregroundColor(Color(red: 115/255, green: 79/255, blue: 150/255))
                                .fontWeight(.bold)
                }
            content: {
                    HomeView()
                }
            }
        }
    }
}
