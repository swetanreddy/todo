import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/startup.dart';
import 'package:todo/ui/HomePage.dart';
import 'package:todo/ui/firebase_help.dart';
import 'package:todo/ui/firebase_help.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();
  String taskTitle = '';
  String taskDescription = '';
  String? bucketValue;
  String? statusValue;
  String? assignedToUserName;
  String? assignedToUserEmail;

  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _taskDescription = TextEditingController();
  final TextEditingController dateinput = TextEditingController();

  bool showUsers = false;

  var usersDeptArray = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DropdownMenuItem<String>> get bucketDropDownItems {
    List<DropdownMenuItem<String>> departmentItems = [
      const DropdownMenuItem(child: Text("Finance"), value: "Finance"),
      const DropdownMenuItem(child: Text("HR"), value: "HR"),
      const DropdownMenuItem(child: Text("IT"), value: "IT"),
      const DropdownMenuItem(child: Text("CRM"), value: "CRM"),
      const DropdownMenuItem(child: Text("Site Visit"), value: "Site Visit"),
      const DropdownMenuItem(child: Text("Executive"), value: "Executive"),
      const DropdownMenuItem(child: Text("Legal Advice"), value: "Legal Advice"),
    ];
    return departmentItems;
  }

  List<DropdownMenuItem<String>> get statusDropDownItems {
    List<DropdownMenuItem<String>> statusItems = [
      const DropdownMenuItem(child: Text("TO DO"), value: "TO DO"),
      const DropdownMenuItem(child: Text("Incomplete"), value: "Incomplete"),
      const DropdownMenuItem(child: Text("Blocked"), value: "Blocked"),
      const DropdownMenuItem(child: Text("Completed"), value: "Completed"),
    ];
    return statusItems;
  }

  CollectionReference assignedTasks = FirebaseFirestore.instance.collection('assignedTasks');

  Future<void> addUser() {
    return assignedTasks
        .add({
          'Task Title': _taskTitle.text,
          'Task Description': _taskDescription.text,
          'created on': DateFormat("yyyy-MM-dd").format(DateTime.now()),
          'due data': dateinput.text,
          'Assigned by(email)': _auth.currentUser?.email,
          'Assigned by(name)': _auth.currentUser?.displayName,
          'Assigned to(name)': assignedToUserName,
          'Assigned to(email)': assignedToUserName,
          'department': bucketValue,
          'status': statusValue,
        })
        .then((value) => print("Task Created"))
        .catchError((error) => print("Failed to create task: $error"));
  }

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_rounded),
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => startUpPgae()),
            );
          },
        ),
        title: const Text(
          "Create New Task",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 10.0, right: 10.0),
            child: Column(
              children: [
                selectDepartment(),
                const SizedBox(height: 20),
                selectUser(),
                const SizedBox(height: 20),
                buildTaskTitle(),
                const SizedBox(height: 20),
                buildTaskDescription(),
                const SizedBox(height: 20),
                buildDateInput(),
                const SizedBox(height: 20),
                setStatus(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addUser();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const startUpPgae(),
            ));
          }
        },
        label: const Text("Submit"),
        icon: const Icon(Icons.add_box),
      ),
    );
  }

  Widget buildTaskTitle() => TextFormField(
      controller: _taskTitle,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLength: 30,
      onSaved: (value) {
        setState(() {
          taskTitle = value!;
          value = _taskTitle.text;
        });
      });

  Widget buildTaskDescription() => TextFormField(
      controller: _taskDescription,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.length < 4) {
          return 'Enter at least 20 characters';
        } else {
          return null;
        }
      },
      maxLength: 250,
      maxLines: 6,
      onSaved: (value) {
        setState(() {
          taskDescription = value!;
          value = _taskDescription.text;
        });
      });

  Widget buildDateInput() => TextFormField(
        controller: dateinput,
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), labelText: "Select a Due Date"),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            print(formattedDate);
            setState(() {
              dateinput.text = formattedDate;
            });
          } else {
            print("Date is not selected");
          }
        },
      );

  Widget setStatus() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Set Status", style: TextStyle(fontSize: 18)),
      const SizedBox(height: 5.0),
      DropdownButtonFormField(
          hint: const Text(
            "Set Status",
            style: TextStyle(color: Colors.black),
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            filled: false,
            fillColor: Colors.black,
          ),
          value: statusValue,
          validator: (value) =>
          value == null ? "Set Status" : null,
          dropdownColor: Colors.grey,
          onChanged: (String? newValue) {
            setState(() {
              statusValue = newValue!;
            });
          },
          items: statusDropDownItems),
    ],
  );

  Widget selectDepartment() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Select Department", style: TextStyle(fontSize: 18)),
      const SizedBox(height: 5.0),
      DropdownButtonFormField(
          hint: const Text(
            "Select Department",
            style: TextStyle(color: Colors.black),
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            filled: false,
            fillColor: Colors.black,
          ),
          validator: (value) =>
          value == null ? "Select Department" : null,
          dropdownColor: Colors.grey,
          value: bucketValue,
          onChanged: (String? newValue) async {
            //call firebase function to get users where department == 'newValue'
            var x = await DBQuery.instanace.getUsersByDept(newValue);
            var y = await DBQuery.instanace.getTasksBySignedInUser(_auth.currentUser?.email);
            print(y[0].data());
            print(newValue);
            setState(() {
              bucketValue = newValue!;
              usersDeptArray = x;
            });
          },
          items: bucketDropDownItems),
    ],
  );

  Widget selectUser() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Select User", style: TextStyle(fontSize: 18)),
      const SizedBox(height: 5.0),
      DropdownButtonFormField(
          hint: const Text(
            "Select User",
            style: TextStyle(color: Colors.black),
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            filled: false,
            fillColor: Colors.black,
          ),
          validator: (value) =>
          value == null ? "Select User" : null,
          dropdownColor: Colors.grey,
          value: assignedToUserName,
          onChanged: (String? newValue) {
            setState(() {
              assignedToUserName = newValue!;
            });
          },
          items: usersDeptArray.map((val) {
            print("val is $val");
            return DropdownMenuItem(
                child: Text("${val['displayName']}"),
                value: "${val['displayName']}");
          }).toList()),
    ],
  );

}
