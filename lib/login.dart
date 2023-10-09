
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/notes.dart';
import 'package:noteapp/provider/provider_page.dart';
import 'package:noteapp/signup.dart';
import 'package:provider/provider.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();

  Future<void> login() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotesAdd()),);
      } else {
        print("Login failed: User is null");
      }
    } catch (e) {
      print("Exception during login: $e");
    }
  }
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello there,\nWelcome back",style: TextStyle(fontSize: 30,color: Colors.black,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15),
                  child:TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                      hintText: "User Name",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  )
              ),
              SizedBox(height: 20,),
              Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                    ),

                  )
              ),
              SizedBox(height: 20,),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left:15.0,right: 15),
                child: ElevatedButton(onPressed: (){
                  login();
                },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black54,minimumSize: const Size.fromHeight(50), //
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),

                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 15,color: Colors.white),),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                },
                child: const  Text('Create New Account', style: TextStyle(fontSize: 15,color: Colors.black)),
              ),


            ],
          ),
        ),
      ),

    );
  }
}
