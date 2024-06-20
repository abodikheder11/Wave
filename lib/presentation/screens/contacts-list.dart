import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsListPage extends StatefulWidget {
  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  List<Contact> _contacts = [];
  List<String> _registeredUserNumbers = [];

  @override
  void initState() {
    super.initState();
    // _getRegisteredUsers();
  }

  // Future<void> _getRegisteredUsers() async {
  //   // Make HTTP GET request to your backend API endpoint
  //   Uri uri = Uri.parse('https://your-backend-api.com/registered-users');
  //   http.Response response = await http.get(uri);
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     List<String> registeredUserNumbers =
  //     data.map((user) => user['phoneNumber']).toList();
  //     setState(() {
  //       _registeredUserNumbers = registeredUserNumbers;
  //     });
  //   } else {
  //     // Handle API error
  //   }
  // }

  // Future<void> _getContacts() async {
  //   // Request permission to access contacts
  //   // bool permissionGranted = await ContactsService.requestPermission();
  //
  //   if (permissionGranted) {
  //     // Retrieve contacts
  //     List<Contact> contacts = await ContactsService.getContacts();
  //     setState(() {
  //       _contacts = contacts;
  //     });
  //   } else {
  //     // Handle permission denied
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          bool isRegisteredUser =
          _registeredUserNumbers.contains(contact.phones?.first.value);
          return ListTile(
            title: Text(contact.displayName ?? ''),
            // subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.value : ''),
            trailing: isRegisteredUser
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.remove_circle, color: Colors.red),
            // Add more contact information as needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _getContacts();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
