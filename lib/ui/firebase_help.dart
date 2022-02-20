import 'package:cloud_firestore/cloud_firestore.dart';

class DBQuery {
  static DBQuery get instanace => DBQuery();

  getUsersByDept(deptName) async {
    QuerySnapshot usersList = await FirebaseFirestore.instance
        .collection('users')
        .where('department', isEqualTo: deptName)
        .get();

    if (!usersList.docs.isEmpty) {
      return usersList.docs.toList();
    } else {
      return null;
    }
  }

  getTasksBySignedInUser(SignedInUserEmail) async {
    QuerySnapshot userTaskList = await FirebaseFirestore.instance
        .collection('assignedTasks')
        .where('Assigned by(email)', isEqualTo: SignedInUserEmail)
        .get();

    if (!userTaskList.docs.isEmpty) {
      return userTaskList.docs.toList();

    } else {
      return null;
    }
  }
}