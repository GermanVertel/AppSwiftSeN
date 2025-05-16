import SwiftUI

struct MenuHamburguesaView: View {
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        Menu {
            Button(action: {
                firebaseViewModel.cerrarSesion()
            }) {
                Label("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right")
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    MenuHamburguesaView()
        .environmentObject(FirebaseViewModel())
} 