import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: "Describtion"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isEdit ? "Update" : "Submit",
                ),
              ))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // get the data
    final todo = widget.todo;
    if (todo == null) {
      print("you can not call updated without todo data");
      return;
    }
    final id = todo["_id"];
    //final isCompleted = todo["is_completed"];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //http://api.nstack.in/v1/todos/63c934df7853c766acf4f10a

    //Submit updated data to the server
    final url = "http://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
    });
    //show success or fail
    if (response.statusCode == 200) {
      showSuccessMessage("Update success");
    } else {
      showErroMessage("Update failed ");
    }
  }

  Future<void> submitData() async {
    // Get the data
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //Submit the Data
    final url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
    });

    //show success or fail
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage("Creation success");
    } else {
      showErroMessage("creation failed ");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErroMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
