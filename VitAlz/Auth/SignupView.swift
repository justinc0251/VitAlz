import SwiftUI
import Combine
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
  case email
  case fullName
  case password
  case confirmPassword
  case birthdate
}

struct SignupView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

private func signUpWithEmailPassword() {
    viewModel.errorMessage = ""
    guard viewModel.password == viewModel.confirmPassword else {
        viewModel.errorMessage = "Passwords do not match."
        return
    }
    
    Task {
        let signUpResult = await viewModel.signUpWithEmailPassword()
        if signUpResult {
            dismiss()
        } else {
            DispatchQueue.main.async {
            if viewModel.errorMessage.isEmpty {
                    viewModel.errorMessage = "Sign up failed. Please try again."
                }
            }
        }
    }
}


  var body: some View {
    VStack {
      Image("SignUp")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(minHeight: 300, maxHeight: 400)
      Text("Sign up")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
    HStack {
        Image(systemName: "person.fill")
        TextField("Full Name", text: $viewModel.fullName)
            .textInputAutocapitalization(.words)
            .disableAutocorrection(true)
            .focused($focus, equals: .fullName)
            .submitLabel(.next)
            .onSubmit {
                self.focus = .email
            }
    }
    .padding(.vertical, 6)
    .background(Divider(), alignment: .bottom)
    .padding(.bottom, 4)
        
      HStack {
        Image(systemName: "at")
        TextField("Email", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)

      HStack {
        Image(systemName: "lock")
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .confirmPassword
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)

      HStack {
        Image(systemName: "lock")
        SecureField("Confirm password", text: $viewModel.confirmPassword)
          .focused($focus, equals: .confirmPassword)
          .submitLabel(.go)
          .onSubmit {
            signUpWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
        HStack(spacing: 0) {
            Image(systemName: "calendar")
                .padding(.trailing, 6)
            Text("Birthdate")
                .fontWeight(.ultraLight)
                .padding(.vertical, 6)
                .padding(.trailing, 6)
            DatePicker(
                "",
                selection: $viewModel.birthdate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(DefaultDatePickerStyle())
            .labelsHidden()
        }
        .background(Divider(), alignment: .bottom)
        .frame(maxWidth: .infinity, alignment: .leading)      .padding(.bottom, 8)






      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: signUpWithEmailPassword) {
        if viewModel.authenticationState != .authenticating {
          Text("Sign up")
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        else {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      }
      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      HStack {
        Text("Already have an account?")
        Button(action: { viewModel.switchFlow() }) {
          Text("Log in")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding([.top, .bottom], 50)

    }
    .listStyle(.plain)
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}

struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignupView()
      SignupView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
