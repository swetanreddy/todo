import 'package:flutter/material.dart';

class Task {
  String? taskNumber;
  String? title;
  String? assignedTo;
  String? assignedBy;
  String? tag;
  String? status;
  String? description;
  String? startDate;
  String? endDate;
  DateTime? datetime;
  int? commentCount;
  Color? tagColor;

  Task({this.taskNumber, this.title, this.assignedBy, this.assignedTo, this.tag, this.status, this.description, this.startDate, this.endDate, this.datetime, this.commentCount,
    this.tagColor});
}

List<Task> taskItems = [
  Task(
      taskNumber: "216",
      title: "Incorrect action message",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      tag: "ux-issue",
      status: "New",
      startDate: "June 8",
      endDate: "June 10",
      commentCount: 104,
      tagColor: Colors.purple,
      datetime: DateTime.now()),
  Task(
      taskNumber: "208",
      title: "Return to the old design",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      tag: "customer feedback",
      status: "In Progress",
      startDate: "July 20",
      endDate: "July 25",
      commentCount: 0,
      tagColor: Colors.green,
      datetime: DateTime.now().subtract(Duration(days: 30 * 4))),
  Task(
      taskNumber: "196",
      title: "Document adding feature",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      tag: "features",
      status: "In Progress",
      startDate: "June 17",
      endDate: "June 20",
      commentCount: 8,
      tagColor: Colors.deepOrangeAccent,
      datetime: DateTime.now().subtract(Duration(days: 10))),
  Task(
      taskNumber: "196",
      title: "Document adding feature",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      tag: "features",
      status: "Done",
      startDate: "June 17",
      endDate: "June 20",
      commentCount: 8,
      tagColor: Colors.deepOrangeAccent,
      datetime: DateTime.now().subtract(Duration(days: 10))),
  Task(
      taskNumber: "196",
      title: "Document adding feature",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      tag: "features",
      status: "Done",
      startDate: "June 17",
      endDate: "June 20",
      commentCount: 8,
      tagColor: Colors.deepOrangeAccent,
      datetime: DateTime.now().subtract(Duration(days: 10))),
  Task(
      taskNumber: "104",
      title: "Verifying emails",
      tag: "v2.0",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      status: "Done",
      startDate: "June 17",
      endDate: "June 20",
      commentCount: 21,
      tagColor: Colors.indigo,
      datetime: DateTime.now().subtract(Duration(days: 10))),

  Task(
      taskNumber: "162",
      title: "Flutter document",
      tag: "fea",
      status: "New",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      startDate: "June 17",
      endDate: "June 20",
      commentCount: 8,
      tagColor: Colors.indigo,
      datetime: DateTime.now().subtract(Duration(days: 2))),

  Task(
      taskNumber: "162",
      title: "Flutter document",
      tag: "fea",
      status: "Blocked",
      assignedBy: "Test Profile 1",
      assignedTo: "Test Profile 2",
      startDate: "June 17",
      endDate: "June 20",
      commentCount: 8,
      tagColor: Colors.indigo,
      datetime: DateTime.now().subtract(Duration(days: 2))),
];