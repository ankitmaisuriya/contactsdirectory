import 'package:contactsdirectory/ContactPOJO.dart';
import 'package:contactsdirectory/DBHelper.dart';
import 'package:contactsdirectory/main.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyContactDetails extends StatefulWidget {
  //const MyContactDetails({super.key});

  ContactPOJO contactPOJO;

  MyContactDetails({super.key, required this.contactPOJO});

  @override
  State<MyContactDetails> createState() => _MyContactDetailsState();
}

class _MyContactDetailsState extends State<MyContactDetails> {
  int _selectedPage = 0;
  String gender = "Choose";
  final _formKey = GlobalKey<FormState>();
  final DBHelper _dbHelper = DBHelper();
  bool readOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Contacts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  disabledColor: Colors.grey,
                color: Colors.white,
                  onPressed: _selectedPage == 1 ? () async {
                    if(!_formKey.currentState!.validate())return;
                    _formKey.currentState!.save();/**/
                    await updateRecords(widget.contactPOJO);
                  } : null,
                  icon:  Icon(Icons.save),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Move this contact to the Trash."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _dbHelper.removeContact(
                                  widget.contactPOJO.id!,
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                                setState;
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
                // Icon(Icons.save, color: Colors.white, ),
                // InkWell(
                //   child: Icon(Icons.delete, color: Colors.white),
                //   onTap: () {
                //
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                // Name
                TextFormField(
                  key: ValueKey('nameField'),
                  initialValue: widget.contactPOJO.name,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter name";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.contactPOJO.name = newValue,
                ),
                SizedBox(height: 16),

                // Phone
                TextFormField(
                  initialValue: widget.contactPOJO.phone,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter phone number";
                    }
                    if (value.length != 10) {
                      return "Phone number must be 10 digits";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.contactPOJO.phone = newValue,
                ),
                SizedBox(height: 16),

                // Email
                TextFormField(
                  initialValue: widget.contactPOJO.email,
                  readOnly: readOnly,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    if (!value.contains("@")) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                  onSaved:  (newValue) => widget.contactPOJO.email = newValue,
                ),
                SizedBox(height: 16),

                // Address
                TextFormField(
                  initialValue: widget.contactPOJO.address,
                  readOnly: readOnly,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter address";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.contactPOJO.address = newValue,
                ),
                SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Gender"),
                  value: widget.contactPOJO.gender,
                  items: [ "Male", "Female"].map((g) {
                    return DropdownMenuItem(value: g, child: Text(g));
                  }).toList(),
                  //onChanged: (v) => gender = v!,
                  onChanged: readOnly ? null : (value) => gender = value!,
                    onSaved: (newValue) => widget.contactPOJO.gender = newValue,
                ),

                SizedBox(height: 20),

                // ElevatedButton(
                //   child: Text("Submit"),
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       print("Form Submitted!");
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (value) {
          _selectedPage = value;
          /*if (_selectedPage == 1) {
            readOnly = false;
          }*/
          readOnly = _selectedPage != 1;
          if (_selectedPage == 2) {
              Share.share(
                '${widget.contactPOJO.name} : ${widget.contactPOJO.phone}',
              subject: 'Contact Detail:',
            ) ;
          }
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.delete,),
          //   label: "Delete",
          // ),
        ],
      ),
    );
  }

  updateRecords(ContactPOJO contactPOJO) async {
    print(contactPOJO.name);
    await _dbHelper.updateContact(contactPOJO);
  }
}
