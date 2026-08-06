import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_rule_model.dart';

class BusinessRulesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'settings/business_rules/rules';

  /// Recupera todas as regras de negócio
  Future<List<BusinessRule>> getRules() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .get();

      final rules = snapshot.docs.map((doc) => BusinessRule.fromJson(doc.data(), doc.id)).toList();
      rules.sort((a, b) {
        final catCompare = a.category.compareTo(b.category);
        if (catCompare != 0) return catCompare;
        return a.order.compareTo(b.order);
      });
      return rules;
    } catch (e) {
      throw Exception('Erro ao carregar regras de negócio: $e');
    }
  }

  /// Recupera as regras escutando em tempo real (Stream)
  Stream<List<BusinessRule>> streamRules() {
    return _firestore
        .collection(_collectionPath)
        .snapshots()
        .map((snapshot) {
          final rules = snapshot.docs.map((doc) => BusinessRule.fromJson(doc.data(), doc.id)).toList();
          rules.sort((a, b) {
            final catCompare = a.category.compareTo(b.category);
            if (catCompare != 0) return catCompare;
            return a.order.compareTo(b.order);
          });
          return rules;
        });
  }

  /// Adiciona uma nova regra
  Future<void> addRule(BusinessRule rule) async {
    try {
      await _firestore.collection(_collectionPath).add(rule.toJson());
    } catch (e) {
      throw Exception('Erro ao adicionar regra: $e');
    }
  }

  /// Atualiza uma regra existente
  Future<void> updateRule(BusinessRule rule) async {
    try {
      final data = rule.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collectionPath).doc(rule.id).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar regra: $e');
    }
  }

  /// Remove uma regra
  Future<void> deleteRule(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao excluir regra: $e');
    }
  }
}

final businessRulesServiceProvider = Provider<BusinessRulesService>((ref) {
  return BusinessRulesService();
});

final businessRulesStreamProvider = StreamProvider.autoDispose<List<BusinessRule>>((ref) {
  final service = ref.read(businessRulesServiceProvider);
  return service.streamRules();
});
