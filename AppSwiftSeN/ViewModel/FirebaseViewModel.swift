//
//  FirebaseViewModel.swift
//  FiresbaseDemo
//
//  Created by German David Vertel Narvaez on 3/02/25.
//


import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class FirebaseViewModel: ObservableObject {
    
    @Published var isLogged = false
    
    // Enum para manejar errores personalizados
    enum AuthError: Error {
        case invalidCredentials
        case weakPassword
        case emailAlreadyInUse
        case networkError
        case unknown
    }
    
    // Función para manejar errores de Firebase
    func handleAuthError(_ error: Error) -> AuthError {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidCredentials
        case AuthErrorCode.wrongPassword.rawValue:
            return .invalidCredentials
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknown
        }
    }
    
    // Función para iniciar sesión
    func login(email: String, password: String, completion: @escaping (_ done: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                print("User logged in: \(user.uid)")
                self.isLogged = true // Actualiza el estado de inicio de sesión
                completion(true)
            } else if let error = error {
                print("Error en Firebase: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Error en la app")
                completion(false)
            }
        }
    }



    
    
    // Función para registrar un usuario
    func createUser(name: String, email: String, password: String, confirPassword: String, completion: @escaping (_ done: Bool) -> Void) {
        // Validar que las contraseñas coincidan
        guard password == confirPassword else {
            print("Las contraseñas no coinciden")
            completion(false)
            return
        }
        
        // Validar que la contraseña sea segura
        guard isPasswordValid(password) else {
            print("La contraseña no es segura")
            completion(false)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                print("User registered: \(user.uid)")
                self.isLogged = true // Actualiza el estado de inicio de sesión
                completion(true)
            } else if let error = error {
                print("Error en Firebase de registro: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Error en la app")
                completion(false)
            }
        }
    }
    
    // Función para validar la seguridad de la contraseña
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // Función para cerrar sesión
    func cerrarSesion() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isLogged = false
                UserDefaults.standard.removeObject(forKey: "sesion")
            }
            print("Sesión cerrada exitosamente")
        } catch {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }

    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false)
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            if let error = error {
                print("Error en Google Sign-In: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let user = result?.user else {
                completion(false)
                return
            }
            guard let idToken = user.idToken?.tokenString else {
                completion(false)
                return
            }
            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error autenticando con Firebase: \(error.localizedDescription)")
                    completion(false)
                } else {
                    DispatchQueue.main.async {
                        self.isLogged = true
                    }
                    completion(true)
                }
            }
        }
    }
}

