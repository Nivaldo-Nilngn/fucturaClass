import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../auth/services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends Notifier<bool> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  bool build() => false; // isLoading state

  Future<void> updateProfile({
    required String phone,
    required String address,
    required String city,
    required DateTime birthDate,
    required String motherName,
    required String fatherName,
    required String financialResponsible,
    required String legalResponsible,
    required String email,
  }) async {
    state = true;
    try {
      final authState = ref.read(authViewModelProvider);
      final currentUser = authState.user;
      
      if (currentUser == null) throw Exception('Usuário não logado');

      final updatedUser = currentUser.copyWith(
        phone: phone,
        address: address,
        city: city,
        birthDate: birthDate,
        motherName: motherName,
        fatherName: fatherName,
        financialResponsible: financialResponsible,
        legalResponsible: legalResponsible,
        email: email,
        isProfileComplete: true,
      );

      // Update in Firestore
      await _authService.updateUserProfile(updatedUser);

      // Award 100 points
      await _firestore.collection('extracts').add({
        'userId': updatedUser.id,
        'points': 100,
        'description': 'Bônus por Perfil Completo',
        'date': FieldValue.serverTimestamp(),
      });

      // Update local state in AuthViewModel so the app reacts to the new user state
      ref.read(authViewModelProvider.notifier).updateUserLocally(updatedUser);
      
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    } finally {
      state = false;
    }
  }
}

final profileViewModelProvider = NotifierProvider<ProfileViewModel, bool>(() {
  return ProfileViewModel();
});
