import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/learning_model.dart';

class LearningService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- TAUGHT CONTENT (Aulas Ministradas) ---

  Future<void> addTaughtContent(TaughtContent content) async {
    await _firestore
        .collection('taught_contents')
        .doc(content.id)
        .set(content.toJson());
  }

  Future<List<TaughtContent>> getTaughtContentsByClass(String classId) async {
    final snapshot = await _firestore
        .collection('taught_contents')
        .where('classId', isEqualTo: classId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => TaughtContent.fromJson(doc.data())).toList();
  }

  // --- CHALLENGES ---

  Future<void> addChallenge(Challenge challenge) async {
    await _firestore
        .collection('challenges')
        .doc(challenge.id)
        .set(challenge.toJson());
  }

  Future<List<Challenge>> getActiveChallengesByClass(String classId) async {
    final now = DateTime.now().toIso8601String();
    
    // Firestore limitação: não permite > em múltiplas propriedades. 
    // Filtramos localmente se precisarmos de ranges muito complexos
    final snapshot = await _firestore
        .collection('challenges')
        .where('classId', isEqualTo: classId)
        .where('status', isEqualTo: ChallengeStatus.active.toString().split('.').last)
        .get();

    return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
  }

  // --- QUESTIONS ---

  Future<void> addQuestion(Question question) async {
    await _firestore
        .collection('questions')
        .doc(question.id)
        .set(question.toJson());
  }

  Future<List<Question>> getQuestionsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList();
  }

  // --- EXERCISES ---

  Future<void> addExercise(Exercise exercise) async {
    await _firestore
        .collection('exercises')
        .doc(exercise.id)
        .set(exercise.toJson());
  }
}
