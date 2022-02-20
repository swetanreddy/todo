import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo/model/task.dart';
import 'package:todo/startup.dart';
import 'package:todo/ui/HomePage.dart';
import 'package:todo/ui/TaskEditPage.dart';
import 'package:todo/ui/TaskHomePage.dart';

class TaskViewPage extends StatefulWidget {
  Task? task;

  TaskViewPage({Key? key, this.task}) : super(key: key);

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: PhysicalModel(
                  elevation: 2,
                  color: Colors.grey,
                  child: Container(
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const startUpPgae()));
                                    },
                                  icon: const Icon(Icons.arrow_back)),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            "${widget.task?.title}",
                            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TaskEditPage()));
                                },
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "${widget.task?.title}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: widget.task?.tagColor,
                              ),
                              child: Text(
                                "${widget.task?.tag}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Text(
                            "${timeago.format(widget.task!.datetime!)}",
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Of course, deeply understanding your users and their needs is the foundation"
                              "of any food product. But that also means understanding all types of users"
                              "and cases",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Deadline: "),
                            ),
                            Text(
                              "${widget.task?.endDate}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Text(
                                  "Status: ${widget.task?.status}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 32,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Assigned to"),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Reporter"),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 24,
                      ),
                      const Text(
                        "Comments",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              size: 32,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Leave the first comment",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                flex: 20),
            Expanded(
                child: PhysicalModel(
                  color: Colors.grey,
                  elevation: 2,
                  child: Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: _textEditingController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add a comment...",
                                  hintStyle: TextStyle(color: Colors.black54)),
                            )),
                        IconButton(
                            onPressed: () {
                              if (_textEditingController.text.length > 0) {
                                print(_textEditingController.text);
                              }
                            },
                            icon: const Icon(Icons.send)),
                      ],
                    ),
                  ),
                ),
                flex: 2),
          ],
        ),
      ),
    );
  }
}