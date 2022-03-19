import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_evaluation_system/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FacultyLogin extends StatefulWidget {
  const FacultyLogin({Key? key}) : super(key: key);

  @override
  _FacultyLoginState createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  final AuthService _auth = AuthService();
  TextEditingController uid = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.teal,
        body: Padding(
          padding: EdgeInsets.only(top: height/8),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Welcome to Project Evaluation System",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height/16),
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height/16),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Center(
                        child: SizedBox(
                          height: height/30,
                          width: width/4,
                          child: const Text(
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
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: SizedBox(
                          height: height/16,
                          width: width/4,
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
                    SizedBox(height: height/36,),
                    Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Center(
                            child: SizedBox(
                              height: height/30,
                              width: width/4,
                              child: const Text(
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
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: SizedBox(
                          height: height/16,
                          width: width/4,
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
                    SizedBox(height: height/32,),
                    Center(
                      child: SizedBox(
                        height: height/16,
                        width: width/5,
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.grey[900],
                          //height: 40,
                          //minWidth: 300,
                          onPressed: () async {
                            User? user = await _auth.signInWithEmailAndPassword(uid.text, pass.text);
                            if(user != null) {
                              Navigator.pushNamed(context, '/facultyMain');
                            }
                            else {
                              user!.uid.length > 3;
                            }
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
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
