import SwiftUI
import Firebase
import FirebaseAuth

struct RegistrationView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var pass: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = "" // Mensaje de error para mostrar al usuario
    @StateObject var register = FirebaseViewModel()
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Top illustration
            HStack(spacing: 20) {
                Image("person2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            // Title
            Text("Registro")
                .font(.title)
                .fontWeight(.bold)
            
            // Registration form
            VStack(spacing: 15) {
                TextField("Nombre Completo", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8),
                        alignment: .trailing
                    )
                
                TextField("Correo Electronico", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .overlay(
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8),
                        alignment: .trailing
                    )
                
                SecureField("Contraseña", text: $pass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8),
                        alignment: .trailing
                    )
                
                SecureField("Confirmar contraseña", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8),
                        alignment: .trailing
                    )
            }
            .padding(.horizontal)
            
            // Mostrar mensaje de error si existe
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            // Registration buttons
            VStack(spacing: 15) {
                Button(action: {
                    // Validar que las contraseñas coincidan
                    guard pass == confirmPassword else {
                        errorMessage = "Las contraseñas no coinciden"
                        return
                    }
                    
                    // Validar que la contraseña sea segura
                    guard isPasswordValid(pass) else {
                        errorMessage = "La contraseña debe tener al menos 8 caracteres, incluyendo letras y números."
                        return
                    }
                    
                    // Registrar al usuario
                    register.createUser(name: name, email: email, password: pass, confirPassword: confirmPassword) { done in
                        if done {
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.isLogged.toggle()
                        } else {
                            errorMessage = "Error en el registro. Por favor, inténtalo de nuevo."
                        }
                    }
                }) {
                    Text("Registrar")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    // Función para validar la seguridad de la contraseña
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

#Preview {
    RegistrationView()
}
