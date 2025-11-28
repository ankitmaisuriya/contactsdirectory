import 'package:blur/blur.dart';
import 'package:contactsdirectory/ContactDetails.dart';
import 'package:contactsdirectory/ContactPOJO.dart';
import 'package:contactsdirectory/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final DBHelper _dbHelper = DBHelper();
  List<ContactPOJO> _list = [];
  List<ContactPOJO> filteredList = [];
  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    loadContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        // removes bottom shadow line
        scrolledUnderElevation: 0,
        // for Material 3
        bottomOpacity: 0,
        shape: Border(bottom: BorderSide(color: Colors.transparent, width: 0)),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.blue,
        actions: [
          _isSearching
              ? IconButton(
                  onPressed: () {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Close')));
                    setState(() {
                      _isSearching = false;
                      searchController.clear();
                      loadContacts();
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                )
              : IconButton(
                  onPressed: () {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Search')));
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search, color: Colors.white),
                ),
        ],
        title: _isSearching
            ? Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white70),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (value) {
                    print(value);
                    searchResult(value);
                  },
                ),
              )
            : Text(
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
          showPopupDialog(context);
        },
      ),
      body: Center(
        child: _list.isEmpty
            ? Text(
                'No contacts found.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  ContactPOJO contact = filteredList[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          contact.name!.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      title: Text(
                        contact.name!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Wrap(
                        children: [
                          Blur(
                            borderRadius: BorderRadius.circular(20),
                            blur: 3.0,
                            blurColor: Theme.of(context).canvasColor,
                            child: Text(contact.phone!),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 16,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyContactDetails(contactPOJO: contact),
                          ),
                        );
                        loadContacts();

                        // Handle tap
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contact Details')));
                      },
                    ),
                  );
                },
                itemCount: filteredList.length,
              ),
      ),
    );
  }

  void showPopupDialog(BuildContext context) {
    TextEditingController _editingControllerName = TextEditingController();
    TextEditingController _editingControllerPhone = TextEditingController();
    String? errorTextName, errorTextPhone;
    bool visible = false;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Add Contact'),
            shadowColor: Colors.black12,
            alignment: Alignment.center,
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                TextField(
                  maxLines: 1,
                  controller: _editingControllerName,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                    errorText: errorTextName,
                  ),
                ),
                TextField(
                  maxLength: 10,
                  controller: _editingControllerPhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  obscureText: visible ? false : true,
                  decoration: InputDecoration(
                    labelText: "Phone No",
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (visible) {
                          visible = false;
                        } else {
                          visible = true;
                        }
                        setState(() {});
                      },
                      icon: visible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(),
                    errorText: errorTextPhone,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _editingControllerName.text = '';
                  _editingControllerPhone.text = '';
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (_editingControllerName.text.isEmpty ||
                      _editingControllerPhone.text.isEmpty) {
                    errorTextName = 'Please Enter Your FullName.';
                    errorTextPhone = "Please Enter Phone Number.";
                  } else {
                    ContactPOJO contactPOJO = ContactPOJO(
                      name: _editingControllerName.text,
                      phone: _editingControllerPhone.text,
                    );
                    _dbHelper.addContact(contactPOJO);
                    _editingControllerName.text = '';
                    _editingControllerPhone.text = '';
                    Navigator.pop(context);
                    loadContacts();
                  }

                  setState(() {});
                },
                child: Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadContacts() async {
    _list = await _dbHelper.showContact();
    _list.sort(
      (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
    );
    setState(() {
      filteredList = _list;
    });
  }

  void searchResult(String str) {
    setState(() {
      filteredList = _list
          .where(
            (element) =>
                element.name!.toLowerCase().contains(str.toLowerCase()),
          )
          .toList();
    });
  }
}
