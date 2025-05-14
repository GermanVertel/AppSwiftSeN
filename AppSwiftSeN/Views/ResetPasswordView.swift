import SwiftUI
import Firebase
import FirebaseAuth

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""
    @Environment(\.dismiss) var dismiss
    
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
            Text("Restablecer Contraseña")
                .font(.title)
                .fontWeight(.bold)
            
            // Description
            Text("Ingresa tu correo electrónico y te enviaremos las instrucciones para restablecer tu contraseña")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Email field
            VStack(spacing: 15) {
                TextField("Correo Electrónico", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .overlay(
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8),
                        alignment: .trailing
                    )
            }
            .padding(.horizontal)
            
            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            // Success message
            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding(.top, 10)
            }
            
            // Reset button
            Button(action: {
                resetPassword()
            }) {
                Text("Enviar Instrucciones")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValidEmail(email) ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isValidEmail(email))
            .padding(.horizontal)
            
            // Back button
            Button(action: {
                dismiss()
            }) {
                Text("Volver al Inicio de Sesión")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.top)
        }
        .padding()
    }
    
    // Validación del formato del correo electrónico
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // Función para restablecer la contraseña
    private func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = "Error al enviar el correo. Verifica tu dirección de correo electrónico."
                successMessage = ""
                print("Error al enviar el correo de restablecimiento: \(error.localizedDescription)")
            } else {
                successMessage = "Se ha enviado un correo de restablecimiento a \(email)"
                errorMessage = ""
                print("Correo de restablecimiento enviado exitosamente.")
                
                // Esperar 2 segundos y luego cerrar la vista
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ResetPasswordView()
} 