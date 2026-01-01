import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = false
    @State private var wrongPassword = false
    @State private var showPassword = false
    @State private var isLoggingIn = false
    @State private var isLoggedIn = false
    
    let verticalPadding: CGFloat = 16
    let horizontalPadding: CGFloat = 24
    let errorColor = Color(red: 1.0, green: 0.4, blue: 0.3)
    let successColor = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.90, green: 0.95, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: verticalPadding) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .default))
                            .foregroundColor(.black)
                        
                        Text("Sign in to your account")
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20)
                    
                    VStack(alignment: .leading, spacing: verticalPadding) {
                        // Username Field
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Username", systemImage: "person.fill")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.black)
                            
                            TextField("Enter your username", text: $username)
                                .textFieldStyle(
                                    CustomTextFieldStyle(
                                        isInvalid: wrongUsername,
                                        backgroundColor: Color.white.opacity(0.8)
                                    )
                                )
                            
                            if wrongUsername {
                                Label("Invalid username", systemImage: "exclamationmark.circle.fill")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .foregroundColor(errorColor)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Label("Password", systemImage: "lock.fill")
                                    .font(.system(size: 14, weight: .semibold, design: .default))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if showPassword {
                                TextField("Enter password", text: $password)
                                    .textFieldStyle(
                                        CustomTextFieldStyle(
                                            isInvalid: wrongPassword,
                                            backgroundColor: Color.white.opacity(0.8)
                                        )
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            } else {
                                SecureField("Enter password", text: $password)
                                    .textFieldStyle(
                                        CustomTextFieldStyle(
                                            isInvalid: wrongPassword,
                                            backgroundColor: Color.white.opacity(0.8)
                                        )
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            if wrongPassword {
                                Label("Invalid password", systemImage: "exclamationmark.circle.fill")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .foregroundColor(errorColor)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                        .frame(height: 8)
                    
                    // Login Button
                    Button(action: authenticate) {
                        if isLoggingIn {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .tint(.white)
                                Text("Signing in...")
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                            }
                        } else {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.5, blue: 1.0),
                                Color(red: 0.1, green: 0.4, blue: 0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.3), radius: 8, x: 0, y: 4)
                    .disabled(isLoggingIn)
                    .opacity(isLoggingIn ? 0.8 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isLoggingIn)
                    
                    NavigationLink(destination: SecureView(), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 40)
            }
        }
    }
    
    private func authenticate() {
        withAnimation {
            isLoggingIn = true
            wrongUsername = false
            wrongPassword = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                if username.isEmpty {
                    wrongUsername = true
                }
                if password.isEmpty {
                    wrongPassword = true
                }
                
                if !wrongUsername && !wrongPassword {
                    isLoggedIn = true
                }
                
                isLoggingIn = false
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    let isInvalid: Bool
    let backgroundColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isInvalid ? Color(red: 1.0, green: 0.4, blue: 0.3) : Color.clear,
                        lineWidth: 2
                    )
            )
            .font(.system(size: 15, weight: .regular, design: .default))
    }
}

struct SecureView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.90, green: 0.95, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                            Text("Back")
                                .font(.system(size: 16, weight: .regular, design: .default))
                        }
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 1.0))
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
                    
                    Text("Welcome!")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Text("You have successfully logged in")
                        .font(.system(size: 16, weight: .regular, design: .default))
                       1
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Logout")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 1.0, green: 0.4, blue: 0.3))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.vertical, 20)
            }
            .padding(24)
        }
    }
}

#Preview {
    ContentView()
}