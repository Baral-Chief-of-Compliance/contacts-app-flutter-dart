import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_contacts/database/contact_db.dart';
import 'package:flutter_app_contacts/model/contact.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future <List<Contact>>? futureContacts;
  final contactDB = ContactDB();

  String contactName = "";
  String contactSurname = "";
  String contactPhone = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fecthContacts();
  }

  void fecthContacts() {
    setState(() {
      futureContacts = contactDB.fetchAll();
    });
  }

  void clearFrom(){
    contactName = "";
    contactSurname = "";
    contactPhone = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Контакты", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),)
      ),
      body:
        FutureBuilder<List<Contact>>(
          future: futureContacts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final contacts = snapshot.data!;

              return contacts.isEmpty 
                ? const Center(
                    child: Text(
                      "Нету контактов...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.grey
                      )
                    ),
                )
                : ListView.separated(
                  separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];

                    return Card(
                      key: Key(contact.phone),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('${contact.name} ${contact.surname}'),
                            subtitle: Text(contact.phone),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton.icon(
                                icon: Icon(Icons.call, color: Colors.blue),
                                label: const Text('ПОЗВОНИТЬ', style: TextStyle(color: Colors.blue),),
                                onPressed: () async{
                                  await FlutterPhoneDirectCaller.callNumber(contact.phone);
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: Icon(Icons.delete, color: Colors.red),
                                label: const Text('УДАЛИТЬ', style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                    contactDB.delete(contact.id);
                                    fecthContacts();
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
            }
          }
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                elevation: 24.0,
                title: Text(
                    'Добавить контакт',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                actions: [
                  IconButton(
                  icon: Icon(Icons.cancel),
                  //label: const Text("ОТМЕНА"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop()
                ),

                  IconButton(
                    icon: Icon(Icons.person_add),
                    //label: const Text('ДОБАВИТЬ'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () async {
                      contactDB.create(name: contactName, surname: contactSurname, phone: contactPhone);
                      clearFrom();
                      fecthContacts();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)
                          ),
                          //labelText: 'Имя',
                          hintText: 'Имя',
                      ),
                      onChanged: (String value) {
                        contactName = value;
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),

                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                          ),
                          //labelText: 'Фамилия',
                          hintText: 'Фамилия',
                      ),
                      onChanged: (String value) {
                        contactSurname = value;
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),

                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call),
                          border: OutlineInputBorder(),
                          //labelText: 'Телефон',
                          hintText: 'Телефон',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)
                          ),


                      ),
                      onChanged: (String value) {
                        contactPhone = value;
                      },
                    ),
                  ],
                )
              );
            });
          },
          child: Icon(
              Icons.person_add,
              color: Colors.white
          )
        ),
    );
  }
}
