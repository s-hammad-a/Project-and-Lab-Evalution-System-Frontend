import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_evaluation_system/Modules/FirebaseStorage.dart';
import 'package:project_evaluation_system/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsheets/gsheets.dart';

class FL extends StatefulWidget {
  const FL({Key? key}) : super(key: key);

  @override
  _FLState createState() => _FLState();
}

class _FLState extends State<FL> {
  final AuthService _auth = AuthService();
  TextEditingController uid = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    Firebase.initializeApp();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.teal,
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Project Evaluation System",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40,),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: SizedBox(
                    height: 25,
                    width: 400,
                    child: Text(
                      'Faculty ID',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                      ),
                    ),
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    width: 400,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: const UnderlineInputBorder(),
                        hintText: 'Faculty ID',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17.0
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 35,
                        )
                      ),
                      controller: uid,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 400,
                        child: Text(
                          'Password',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                        ),
                      )
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    width: 400,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: const UnderlineInputBorder(),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      controller: pass,
                      obscureText: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    width: 300,
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.grey[900],
                      //height: 40,
                      //minWidth: 300,
                      onPressed: () async {
                        /*User? user = await _auth.signInWithEmailAndPassword(uid.text, pass.text);
                        if(user != null) {
                          Navigator.pushNamed(context, '/facultyMain');
                        }
                        else {
                          user!.uid.length > 3;
                        }*/
                      },
                      label: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    width: 300,
                    child: FloatingActionButton.extended(
                      icon: const Icon(
                        Icons.window_rounded,
                      ),
                      backgroundColor: Colors.grey[900],
                      //height: 40,
                      //minWidth: 300,
                      onPressed: () async {
                        User? user = await _auth.signInWithMicrosoft();
                        //Navigator.pushNamed(context, '/facultyMain');
                      },
                      label: const Text(
                        'Sign In With Microsoft',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
