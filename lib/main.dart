import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      home: MyContacts(),
    ),
  );
}

class MyContacts extends StatefulWidget {
  const MyContacts({super.key});

  @override
  State<MyContacts> createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Contacts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.contact_phone),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Contact'),
                shadowColor: Colors.black12,
                alignment: Alignment.center,
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Phone No",
                        border: OutlineInputBorder(),
                      ),
                    ),

                  ],
                ),
                actions: [
                  TextButton(onPressed: () {

                  }, child: Text("Cancel"),),
                  TextButton(onPressed: () {

                  }, child: Text("Save"),),
                ],
              );
            },
          );
        },
      ),
      body: Center(
        child: Text(
          'No contacts found.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
