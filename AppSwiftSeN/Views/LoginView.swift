//
//  LoginView.swift
//  FiresbaseDemo
//
//  Created by German David Vertel Narvaez on 3/02/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import LocalAuthentication

struct LoginView: View {
    @State private var email = ""
    @State private var pass = ""
    @State private var rememberPassword: Bool = false
    @State private var navigateToRegister = false
    @State private var errorMessage: String = "" // Mensaje de error para mostrar al usuario
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Top illustration
                HStack(spacing: 20) {
                    Image("person2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                // Welcome text
                Text("Bienvenido")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Terms text
                /*HStack {
                    Text("By signing in you are agreeing our")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Link("Term and privacy policy", destination: URL(string: "https://yourapp.com/terms")!)
                        .font(.footnote)
                }*/
                
                // Login form
                VStack(spacing: 15) {
                    TextField("Correo electronico", text: $email)
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
                    
                    /*Toggle("Recordar contraseña", isOn: $rememberPassword)
                        .font(.footnote)*/
                    
                    HStack {
                        Spacer()
                        Button("Restablecer contraseña ") {
                            resetPassword()
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // Mostrar mensaje de error si existe
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // Login buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // Validar que el formulario sea válido
                        guard isValidForm else {
                            errorMessage = "Por favor, completa todos los campos correctamente."
                            return
                        }
                        
                        login.login(email: email, password: pass) { done in
                            if done {
                                UserDefaults.standard.set(true, forKey: "sesion")
                                loginShow.isLogged.toggle()
                            } else {
                                errorMessage = "Credenciales incorrectas. Por favor, inténtalo de nuevo."
                            }
                        }
                    }) {
                        Text("Iniciar Sesion")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isValidForm ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isValidForm)
                    
                    NavigationLink(destination: RegistrationView()) {
                        Text("Registrarse")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                
                // Touch ID login
                VStack(spacing: 10) {
                    Text("Inicio de sesion con Face ID")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        authenticateWithBiometrics()
                    }) {
                        Image(systemName: "faceid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
    }
    
    // Validación del formulario
    private var isValidForm: Bool {
        return !email.isEmpty && !pass.isEmpty && isValidEmail(email)
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
                errorMessage = "No se pudo enviar el correo de restablecimiento. Verifica tu dirección de correo electrónico."
                print("Error al enviar el correo de restablecimiento: \(error.localizedDescription)")
            } else {
                errorMessage = "Se ha enviado un correo de restablecimiento a \(email)."
                print("Correo de restablecimiento enviado exitosamente.")
            }
        }
    }
    
    // Autenticación biométrica (Face ID)
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Verificamos qué tipo de biometría está disponible
            let biometryType = context.biometryType
            
            if biometryType == .faceID {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, 
                    localizedReason: "Inicia sesión con Face ID") { success, error in
                    DispatchQueue.main.async {
                        if success {
                            print("Autenticación con Face ID exitosa")
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.isLogged.toggle()
                        } else {
                            errorMessage = "La autenticación con Face ID falló. Por favor, inténtalo de nuevo."
                            print("Error en la autenticación con Face ID: \(error?.localizedDescription ?? "Error desconocido")")
                        }
                    }
                }
            } else {
                errorMessage = "Face ID no está disponible en este dispositivo."
                print("Face ID no está disponible")
            }
        } else {
            errorMessage = "Tu dispositivo no soporta Face ID."
            print("El dispositivo no soporta autenticación biométrica")
        }
    }
}


#Preview {
    LoginView()
}
