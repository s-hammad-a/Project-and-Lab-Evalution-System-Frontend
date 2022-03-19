import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_evaluation_system/screens/faculty_login.dart';
import 'package:project_evaluation_system/services/auth.dart';
import 'package:provider/provider.dart';


class ScreenTemplate extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ScreenTemplate({Key? key}) : super(key: key);

  @override
  _ScreenTemplateState createState() => _ScreenTemplateState();
}

class _ScreenTemplateState extends State<ScreenTemplate> {
  @override
  Widget build(BuildContext context) {
    ScrollController scr = ScrollController();
    final user = Provider.of<User?>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    double fontSize = 20;
    double getWidth()
    {
      if(width<1000) {
        return 1000;
      } else {
        return width;
      }
    }
    void setFontSize()
    {
      if(width<1000) {
        fontSize = width/100;
      }
      else {
        fontSize = 35;
      }
    }
    String name = "Error";
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Scrollbar(
          controller: scr,
          isAlwaysShown: true,
          thickness: 20,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.teal,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: getWidth(),
                    color: Colors.grey[900],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Project Evaluation System',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox.shrink()),
                              SizedBox(
                                height: 40,
                                width: 120,
                                child: FlatButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(
                                        Icons.logout_rounded,
                                      ),
                                      Text(
                                        'Sign Out',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    AuthService().signOut();
                                    Navigator.popUntil(context,
                                        ModalRoute.withName('/facultyLogin'));
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height - 40,
                    width: getWidth(),
                    child: Row(
                      children: [
                        SizedBox(
                          height: height - 40,
                          width: 250,
                          child: Container(
                            color: Colors.brown[900],
                          ),
                        ),
                        SizedBox(
                          height: height - 40,
                          width: getWidth() - 250,
                          child: Container(
                            height: height - 40,
                            width: getWidth() - 250,
                            color: Colors.teal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 5, right: 5),
                                  child: Container(
                                    height: 40,
                                    width: getWidth() - 250,
                                    color: Colors.grey,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: height - 40,
                                          width: 300,
                                          child: Text(
                                            ' Courses',
                                            style: TextStyle(
                                              fontSize: fontSize + 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        const Expanded(
                                            child: SizedBox.shrink()),
                                        SizedBox(
                                          height: height - 40,
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: FlatButton(
                                              color: Colors.green[800],
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: const [
                                                  Text(
                                                    'Add New Course',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  Icon(
                                                    Icons.update,
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {

                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 10),
                                  child: Container(
                                    height: height - 120,
                                    width: getWidth() - 270,
                                    color: Colors.grey,
                                    child: SizedBox(
                                      height: height - 120,
                                      width: getWidth(),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: getWidth() - 270,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  3.0),
                                              child: Container(
                                                color: Colors.red[700],
                                                child: SizedBox(
                                                  height: 40,
                                                  width: getWidth() - 270,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 250,
                                                        child: Text(
                                                          '   Course Name',
                                                          style: TextStyle(
                                                            fontSize: fontSize,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                          textAlign: TextAlign
                                                              .left,
                                                        ),
                                                      ),
                                                      const Expanded(
                                                          child: SizedBox
                                                              .shrink()),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          'Class Name',
                                                          style: TextStyle(
                                                            fontSize: fontSize,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                          textAlign: TextAlign
                                                              .center,
                                                        ),
                                                      ),
                                                      const Expanded(
                                                          child: SizedBox
                                                              .shrink()),
                                                      SizedBox(
                                                        width: 250,
                                                        child: Text(
                                                          '  Project Reports',
                                                          style: TextStyle(
                                                            fontSize: fontSize,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                          textAlign: TextAlign
                                                              .center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height - 170,
                                            width: getWidth(),
                                            child: ListView.builder(
                                                itemCount: 3,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                      child: SizedBox(
                                                        height: 50,
                                                        width: getWidth() - 250,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: ListTile(
                                                                onTap: () {
                                                                  Navigator
                                                                      .pushNamed(
                                                                      context,
                                                                      '/allProject');
                                                                },
                                                                title: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .center,
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 50,
                                                                      width: 250,
                                                                      child: Align(
                                                                        alignment: Alignment
                                                                            .centerLeft,
                                                                        child: Text(
                                                                          'Course Name ${index +
                                                                              1}',
                                                                          style: TextStyle(
                                                                            fontSize: fontSize,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                          ),
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Expanded(
                                                                        child: SizedBox.shrink()
                                                                    ),
                                                                    SizedBox(
                                                                      height: 50,
                                                                      width: 150,
                                                                      child: Align(
                                                                        alignment: Alignment
                                                                            .center,
                                                                        child: Text(
                                                                          'BSE-5',
                                                                          style: TextStyle(
                                                                            fontSize: fontSize,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                          ),
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Expanded(
                                                                        child: SizedBox
                                                                            .shrink()
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 50,
                                                              width: 250,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .all(10),
                                                                child: FloatingActionButton
                                                                    .extended(
                                                                  backgroundColor: Colors
                                                                      .blue[900],
                                                                  label: Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .end,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .download_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      Text(
                                                                        'Project Report',
                                                                        style: TextStyle(
                                                                          fontSize: fontSize -
                                                                              5,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                        ),
                                                                        textAlign: TextAlign
                                                                            .left,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  onPressed: () {

                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  );
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
