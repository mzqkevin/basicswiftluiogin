import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = false
    @State private var wrongPassword = false
    @State private var isLoggedIn = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    
    private let fieldWidth: CGFloat = 300
    private let fieldHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 10
    private let validUsername = "kevin"
    private let validPassword = "1234"
    private let primaryColor = Color.green
    private let accentColor = Color.blue
    private let errorColor = Color.red
    private let fieldSpacing: CGFloat = 16
    private let verticalPadding: CGFloat = 20
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [primaryColor, primaryColor.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
                
                
                Circle()
                    .scale(1.7)
                    .foregroundColor(.blue.opacity(0.15))
                
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white.opacity(0.5))
                
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                
        
                VStack(spacing: verticalPadding) {
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Username", systemImage: "person.fill")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        TextField("Enter username", text: $username)
                            .textFieldStyle(CustomTextFieldStyle(
                                isInvalid: wrongUsername
                            ))
                    }
                    .frame(width: fieldWidth, height: fieldHeight)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Password", systemImage: "lock.fill")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        SecureField("Enter password", text: $password)
                            .textFieldStyle(CustomTextFieldStyle(
                                isInvalid: wrongPassword
                            ))
                    }
                    .frame(width: fieldWidth, height: fieldHeight)
                    
                    
                    if wrongUsername || wrongPassword {
                        VStack(alignment: .leading, spacing: 4) {
                            if wrongUsername {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text("Invalid username")
                                }
                            }
                            if wrongPassword {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text("Invalid password")
                                }
                            }
                        }
                        .font(.caption)
                        .foregroundColor(errorColor)
                        .padding(8)
                        .background(errorColor.opacity(0.1))
                        .cornerRadius(6)
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // MARK: - Login Button
                    Button(action: authenticate) {
                        Text("Sign In")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(accentColor)
                            .cornerRadius(cornerRadius)
                            .shadow(color: accentColor.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                    .frame(width: fieldWidth)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 32)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                SecureView(isLoggedIn: $isLoggedIn)
            }
        }
    }
    
    
    private func authenticate() {
        withAnimation {
            wrongUsername = false
            wrongPassword = false
            
            
            if username.lowercased() != validUsername {
                wrongUsername = true
            }
            
            if password != validPassword {
                wrongPassword = true
            }
            
            
            if !wrongUsername && !wrongPassword {
                isLoggedIn = true
            }
        }
    }
}


struct CustomTextFieldStyle: TextFieldStyle {
    var isInvalid: Bool
    
    func _body(configuration: TextField<Self.Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isInvalid ? Color.red : Color.clear,
                        lineWidth: 2
                    )
            )
    }
}


struct SecureView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Button(action: { isLoggedIn = false }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding()
                
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Welcome!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("You have successfully logged in")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}