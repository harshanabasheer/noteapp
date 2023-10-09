
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/provider/provider_page.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function
  signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Settings", style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.account_box, color: Colors.black),
                    title: Text("Account", style: TextStyle(color: Colors.black)),
                    trailing: IconButton(
                      icon: Icon(Icons.logout, color: Colors.black),
                      onPressed: () {
                        signOut(context);
                      },
                    ),
                    onTap: () {
                      // Handle account item tap here
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: Text("Dark Mode", style: TextStyle(color: Colors.black)),
                    trailing: Switch(
                      value: themeNotifier.isDarkMode,
                      onChanged: (value) {
                        themeNotifier.toggleTheme();
                      },
                    ),
                    onTap: () {
                      themeNotifier.toggleTheme();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
