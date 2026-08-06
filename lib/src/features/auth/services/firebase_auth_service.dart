import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login com CPF e Senha
  Future<AppUser?> loginWithCpf(String cpf, String password) async {
    try {
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final mockEmail = '$cleanCpf@fuctura.com';
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: mockEmail,
        password: password,
      );

      if (userCredential.user != null) {
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

  // Cadastro de novo Aluno com Bônus de 50 Pontos (Regra de Negócio)
  Future<AppUser?> registerWithCpf(String name, String cpf, String password, {String? academyId}) async {
    try {
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final mockEmail = '$cleanCpf@fuctura.com';

      // 1. Criar usuário no Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: mockEmail,
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        // 2. Criar objeto AppUser (Aluno)
        final newUser = AppUser(
          id: uid,
          name: name,
          cpf: cleanCpf,
          role: UserRole.student,
          academyId: academyId,
          createdAt: DateTime.now(),
          isActive: true,
        );

        // 3. Salvar na coleção 'users'
        await _firestore.collection('users').doc(uid).set(newUser.toJson());

        // 4. Registrar Extrato de +50 Pontos (Bônus de Cadastro)
        await _firestore.collection('extracts').add({
          'userId': uid,
          'points': 50,
          'description': 'Cadastro de Aluno (Bônus Boas-Vindas)',
          'date': FieldValue.serverTimestamp(),
        });

        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Este CPF já está cadastrado.');
      }
      throw Exception('Falha no cadastro: ${e.message}');
    } catch (e) {
      throw Exception('Falha ao cadastrar: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateUserProfile(AppUser updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.id).update(updatedUser.toJson());
    } catch (e) {
      throw Exception('Falha ao atualizar perfil: $e');
    }
  }
}
