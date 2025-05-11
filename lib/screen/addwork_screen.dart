import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/screen/home_screen.dart';
import 'package:listify/screen/login_screen.dart';

class AddWork extends StatefulWidget {
  @override
  State<AddWork> createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Important to avoid overflow
      appBar: AppBar(
        title: Text('Listify'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Description Field
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            // Buttons (Wrapped in Column to ensure layout adjustment)
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter all fields before adding.',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          addMyData();
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.cancel),
                      label: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to add data to Firestore
  void addMyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Work')
          .doc(titleController.text)
          .set({
        "uid": uid,
        "title": titleController.text,
        "description": descriptionController.text,
      });

      print('Data Inserted');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      print('Error adding data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add data.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
