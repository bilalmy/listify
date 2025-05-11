import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/screen/login_screen.dart';
import 'package:listify/screen/addwork_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final uid=FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),

      // Main body content
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simplified "Your Tasks" Heading
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Work').where('uid',isEqualTo: uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (!snapshot.hasData) {
                  return Center(child: Text('No tasks found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];

                    return ListTile(
                      leading: CircleAvatar(radius:11,child: Text("${index + 1}",style: TextStyle(color: Colors.white),),backgroundColor: Colors.black,),
                      title: Text(doc['title']),
                      subtitle: Text(doc['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: CircleAvatar(child: Icon(Icons.done, color: Colors.white,),backgroundColor: Colors.redAccent,radius: 12,),
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('Work')
                                    .doc(doc.id)
                                    .delete();
                              } catch (e) {
                                print("Error deleting: $e");
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },

                );
              },
            ),
          )

        ],
      ),

      // Floating Action Button to add new task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWork()),
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
      ),
    );
  }

}