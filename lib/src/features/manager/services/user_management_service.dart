import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Registra um novo usuário criando uma instância secundária do Firebase Auth
  /// Isso evita que o Administrador seja deslogado ao criar a conta.
  Future<void> createUser({
    required String name,
    required String cpf,
    required UserRole role,
    required String password,
    String? academyId,
    String? classId,
  }) async {
    final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    final mockEmail = '$cleanCpf@fuctura.com';

    // Cria um app temporário apenas para registrar o usuário
    FirebaseApp tempApp = await Firebase.initializeApp(
      name: 'UserCreationApp',
      options: Firebase.app().options,
    );

    try {
      final tempAuth = FirebaseAuth.instanceFor(app: tempApp);
      
      // Cria o login do Firebase Auth
      final userCredential = await tempAuth.createUserWithEmailAndPassword(
        email: mockEmail,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Monta o modelo de usuário
      final newUser = AppUser(
        id: uid,
        name: name,
        cpf: cleanCpf,
        role: role,
        academyId: academyId,
        classId: classId,
        createdAt: DateTime.now(),
        isActive: true,
      );

      // Grava os detalhes complementares no Firestore
      await _firestore.collection('users').doc(uid).set(newUser.toJson());

    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    } finally {
      // Deleta o app temporário para não ocupar memória
      await tempApp.delete();
    }
  }

  /// Recupera todos os usuários de um determinado papel
  Future<List<AppUser>> getUsersByRole(UserRole role) async {
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: role.toString().split('.').last)
        .get();

    return query.docs.map((doc) => AppUser.fromJson(doc.data())).toList();
  }
}
