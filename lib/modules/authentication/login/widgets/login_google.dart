
import 'package:aviato_finance/components/application_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Instancia de GoogleSignIn
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;


class SignInScreenGoogle extends StatefulWidget {
  @override
  _SignInScreenGoogleState createState() => _SignInScreenGoogleState();
}

class _SignInScreenGoogleState extends State<SignInScreenGoogle> {
Future<void> _signInWithGoogle() async {
  try {
    // Inicia el proceso de inicio de sesión con Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      // Si el usuario cancela el inicio de sesión
      return;
    }

    // Obtiene la autenticación de Google
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Crea las credenciales de Firebase con el token de acceso y el ID del token
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Inicia sesión en Firebase con las credenciales de Google
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    
    // Muestra el nombre del usuario autenticado (opcional)
    print("Usuario autenticado: ${userCredential.user?.displayName}");
    
    // Aquí puedes navegar a la siguiente pantalla después de la autenticación
    Navigator.pushReplacementNamed(context, '/home');
  } catch (error) {
    // Si ocurre algún error en el proceso de inicio de sesión
    print("Error de autenticación: $error");
  }
}
@override
  Widget build(BuildContext context) {
    return ApplicationButton(
            type: ButtonType.contrast,
            onPressed: _signInWithGoogle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  width: 60,
                  "https://imgs.search.brave.com/cMeR-TEzSzc3L_T_t4c0ZKSZu5B4BxkMPGrZ48urikE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4x/Lmljb25maW5kZXIu/Y29tL2RhdGEvaWNv/bnMvZ29vZ2xlLXMt/bG9nby8xNTAvR29v/Z2xlX0ljb25zLTA5/LTUxMi5wbmc",
                ),
                Text("Sign in with Google"),
              ],
            ),
          );
  }
}