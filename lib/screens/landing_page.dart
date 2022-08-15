import 'package:flutter/material.dart';
import 'package:project_evaluation_system/services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scr = ScrollController();
    final AuthService _auth = AuthService();
    return Scaffold(
      body: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.bottom,
        controller: scr,
        isAlwaysShown: false,
        thickness: 10,
        child: SingleChildScrollView(
          controller: scr,
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 786,
            width: 1387,
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(110, 25, 110, 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0,4),
                      blurRadius: 4
                    )
                  ]
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 10, bottom: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Project Evaluation',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'System',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          const SizedBox(
                            width: 400,
                            child: Text(
                              'With Project Evaluation System (PES), say good bye to submission of hard copy proposals, headache of maintaining student project results, keeping track of project proposals and FYP meeting record.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 400,
                            child: Text(
                              'Made by Hassan Masood, Syed Hammad Ali and M.Mamoon Haider.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
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
                                  shape: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  icon: Image.asset(
                                    'assets/MS logo.jpg',
                                    width: 20,
                                    height: 20,
                                  ),
                                  backgroundColor: Colors.cyanAccent,
                                  //height: 40,
                                  //minWidth: 300,
                                  onPressed: () async {
                                    await _auth.signInWithMicrosoft();
                                  },
                                  label: const Text(
                                    'Sign In With Microsoft',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
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
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/PES Logo.png',
                          width: 550,
                          height: 300,
                        ),
                        const SizedBox(height: 40,),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
