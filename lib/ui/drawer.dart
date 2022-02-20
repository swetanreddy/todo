import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/helpers/methods.dart';

class mainDrawer extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: DrawerHeader(
              child: Column(
                children: [
                  Text("${_auth.currentUser!.displayName}",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const Spacer(),
                  Text("${_auth.currentUser!.email}",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () { },
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text("Assigned",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: null,
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text("Log out",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              logOut(context);
            },
          )
        ],
      ),
    );
  }
}
