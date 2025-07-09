import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongusername = 0
    @State private var wrongpassword = 0
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green
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

                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongusername))

                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongpassword))

                    Button("Login") {
                        if username.lowercased() == "kevin" && password == "1234" {
                            isLoggedIn = true
                        } else {
                            wrongusername = username.lowercased() != "kevin" ? 2 : 0
                            wrongpassword = password != "1234" ? 2 : 0
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    LoggedInView()
                }
            }
        }
    }
}

struct LoggedInView: View {
    var body: some View {
        Text("You are logged in!")
            .font(.largeTitle)
            .padding()
            .navigationBarBackButtonHidden(false)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
