import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/learning_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerAttendance(Attendance attendance) async {
    await _firestore
        .collection('attendances')
        .doc(attendance.id)
        .set(attendance.toJson());
  }

  Future<void> registerMultiple(List<Attendance> attendances) async {
    final batch = _firestore.batch();
    for (var att in attendances) {
      final docRef = _firestore.collection('attendances').doc(att.id);
      batch.set(docRef, att.toJson());
    }
    await batch.commit();
  }

  Future<List<Attendance>> getAttendancesByClass(String classId) async {
    final snapshot = await _firestore
        .collection('attendances')
        .where('classId', isEqualTo: classId)
        .get();

    return snapshot.docs.map((doc) => Attendance.fromJson(doc.data())).toList();
  }

  Future<List<Attendance>> getAttendancesByStudent(String studentId) async {
    final snapshot = await _firestore
        .collection('attendances')
        .where('studentId', isEqualTo: studentId)
        .get();

    return snapshot.docs.map((doc) => Attendance.fromJson(doc.data())).toList();
  }
}
