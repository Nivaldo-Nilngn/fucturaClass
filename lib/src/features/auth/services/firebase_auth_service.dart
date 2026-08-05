import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login com CPF e Senha
  // Nota: No Firebase Auth nativo não existe "Login por CPF", então
  // a estratégia comum é criar um e-mail falso com o CPF (ex: 11111111111@fuctura.com)
  // ou usar Custom Auth Tokens gerados por uma Cloud Function.
  // Aqui adotaremos a estratégia do e-mail mockado para simplificar o MVP.
  Future<AppUser?> loginWithCpf(String cpf, String password) async {
    try {
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final mockEmail = '$cleanCpf@fuctura.com';
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: mockEmail,
        password: password,
      );

      if (userCredential.user != null) {
        // Buscar dados adicionais no Firestore
        final doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (doc.exists) {
          return AppUser.fromJson(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Falha ao autenticar no Firebase: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
