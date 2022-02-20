import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/helpers/methods.dart';
import 'package:todo/model/task.dart';
import 'package:todo/ui/TaskViewPage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo/ui/firebase_help.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var radius = const Radius.circular(20);

  var doneTasks = [];

  final data = FirebaseFirestore.instance
      .collection('assignedTasks')
      .where('email', isEqualTo: '${FirebaseAuth.instance.currentUser!.email}')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 4, vsync: this);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Hi Swetan!!!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 12),
                            Text("Here's your task update today.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18)),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            logOut(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.exit_to_app),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    child: TabBar(
                      isScrollable: false,
                      controller: _tabController,
                      // labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(
                            child: Text("To Do",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                        Tab(
                            child: Text("In progress",
                                style: TextStyle(fontSize: 12.5))),
                        Tab(
                            child: Text("Blocked",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                        Tab(
                            child: Text("Done",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                      ],
                      indicator: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(radius)),
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: width * 1,
                    height: 620,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _fetchNewStatusTasks(),
                        _fetchInprogressStatusTasks(),
                        _fetchBlockedStatusTasks(),
                        // _fetchDoneStatusTasks()
                        _fetchDoneTasks(_auth.currentUser?.email)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   foregroundColor: Colors.white,
      //   backgroundColor: Colors.black,
      //   onPressed: () {
      //     Navigator.of(context).pushReplacement(MaterialPageRoute(
      //       builder: (context) => const CreateTask(),
      //     ));
      //   },
      //   child: const Icon(Icons.add, size: 30),
      // ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
            )
          ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_rounded, size: 30),
            ),
            BottomNavigationBarItem(
              label: 'Person',
              icon: Icon(Icons.person_rounded, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fetchOldTasks() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView.builder(
          itemCount: taskItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => TaskViewPage(task: taskItems[index]),
                  ));
                },
                child: PhysicalModel(
                  color: Colors.grey[400]!,
                  elevation: 1,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Task #${taskItems[index].taskNumber}",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              timeago.format(taskItems[index].datetime!),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "${taskItems[index].title}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: taskItems[index].tagColor,
                                ),
                                child: Text(
                                  "${taskItems[index].tag}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: taskItems[index].tagColor,
                                ),
                                child: Text(
                                  "Status: ${taskItems[index].status}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                  "${taskItems[index].startDate} - ${taskItems[index].endDate}"),
                              const Spacer(),
                              Text("${taskItems[index].commentCount}"),
                              const SizedBox(
                                width: 4,
                              ),
                              const Icon(Icons.chat_bubble_outline)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _fetchNewTasks() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView.builder(
            itemCount: taskItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: taskItems[index].tagColor,
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Task #${taskItems[index].taskNumber}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            timeago.format(taskItems[index].datetime!),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "${taskItems[index].title}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white),
                                color: taskItems[index].tagColor,
                              ),
                              child: Text(
                                "${taskItems[index].tag}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white),
                                color: taskItems[index].tagColor,
                              ),
                              child: Text(
                                "Status: ${taskItems[index].status}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      "Assigned by : ${taskItems[index].assignedBy}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      "${taskItems[index].startDate} - ${taskItems[index].endDate}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      );

  Widget _fetchNewStatusTasks() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView.builder(
            itemCount: taskItems.length,
            itemBuilder: (context, index) {
              if (taskItems[index].status == "New") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            TaskViewPage(task: taskItems[index]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: taskItems[index].tagColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Task #${taskItems[index].taskNumber}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                timeago.format(taskItems[index].datetime!),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "${taskItems[index].title}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text(
                                    "${taskItems[index].tag}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text(
                                    "Status: ${taskItems[index].status}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          "Assigned by : ${taskItems[index].assignedBy}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          "${taskItems[index].startDate} - ${taskItems[index].endDate}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0.0);
              }
            }),
      );

  Widget _fetchDoneStatusTasks() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView.builder(
            itemCount: taskItems.length,
            itemBuilder: (context, index) {
              if (taskItems[index].status == "Done") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            TaskViewPage(task: taskItems[index]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: taskItems[index].tagColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Task #${taskItems[index].taskNumber}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                timeago.format(taskItems[index].datetime!),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "${taskItems[index].title}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text(
                                    "${taskItems[index].tag}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text(
                                    "Status: ${taskItems[index].status}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text("Assigned by : ${taskItems[index].assignedBy}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text("${taskItems[index].startDate} - ${taskItems[index].endDate}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0.0);
              }
            }),
      );

  Widget _fetchInprogressStatusTasks() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView.builder(
            itemCount: taskItems.length,
            itemBuilder: (context, index) {
              if (taskItems[index].status == "In Progress") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => TaskViewPage(task: taskItems[index]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: taskItems[index].tagColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Task #${taskItems[index].taskNumber}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(timeago.format(taskItems[index].datetime!),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text("${taskItems[index].title}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Padding(
                                padding:const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text("${taskItems[index].tag}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text("Status: ${taskItems[index].status}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 12),
                                      const SizedBox(width: 8),
                                      Text("Assigned by : ${taskItems[index].assignedBy}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer,size: 12),
                                      const SizedBox(width: 8),
                                      Text("${taskItems[index].startDate} - ${taskItems[index].endDate}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0.0);
              }
            }),
      );

  Widget _fetchBlockedStatusTasks() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView.builder(
            itemCount: taskItems.length,
            itemBuilder: (context, index) {
              if (taskItems[index].status == "Blocked") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            TaskViewPage(task: taskItems[index]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: taskItems[index].tagColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Task #${taskItems[index].taskNumber}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(timeago.format(taskItems[index].datetime!),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text("${taskItems[index].title}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text("${taskItems[index].tag}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white),
                                    color: taskItems[index].tagColor,
                                  ),
                                  child: Text("Status: ${taskItems[index].status}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 12,),
                                      const SizedBox(width: 8,),
                                      Text("Assigned by : ${taskItems[index].assignedBy}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12,),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer, size: 12,),
                                      const SizedBox(width: 8,),
                                      Text("${taskItems[index].startDate} - ${taskItems[index].endDate}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0.0);
              }
            }),
      );

  Widget _fetchDoneTasks(email) => FutureBuilder(
    future: DBQuery.instanace.getTasksBySignedInUser(_auth.currentUser?.email),
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView.builder(
              itemCount: taskItems.length,
              itemBuilder: (context, index) {
                if (taskItems[index].status == "Done") {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              TaskViewPage(task: taskItems[index]),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: taskItems[index].tagColor,
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Task #${taskItems[index].taskNumber}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(timeago.format(taskItems[index].datetime!),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Text("${taskItems[index].title}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.white),
                                      color: taskItems[index].tagColor,
                                    ),
                                    child: Text("${taskItems[index].tag}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.white),
                                      color: taskItems[index].tagColor,
                                    ),
                                    child: Text("Status: ${taskItems[index].status}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today_outlined, size: 12),
                                        const SizedBox(width: 8),
                                        Text("Assigned by : ${taskItems[index].assignedBy}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer, size: 12),
                                        const SizedBox(width: 8),
                                        Text("${taskItems[index].startDate} - ${taskItems[index].endDate}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox(height: 0.0);
                }
              }),
        );
      }else{
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
