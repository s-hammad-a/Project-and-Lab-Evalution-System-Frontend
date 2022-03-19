import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/Modules/screen_elements.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:project_evaluation_system/services/Googlesheet.dart';
import 'package:provider/provider.dart';

class FacultyMain extends StatefulWidget {
  const FacultyMain({Key? key}) : super(key: key);

  @override
  _FacultyMainState createState() => _FacultyMainState();
}

class _FacultyMainState extends State<FacultyMain> {
  String dropdownValue = 'Fall 2021';
  String id = " ";
  @override
  Widget build(BuildContext context) {
    List<Map> data = <Map>[];
    List<String> allSemesters = <String>[];

    final user = Provider.of<User?>(context);

    Future<void> getAllCourses() async {
      data = <Map>[];
      List<String> arr =  user!.email!.split("@");
      id = arr.first;
      id = "joddat";
      //id = "aleemahmed.buic";
      //id = 'adeel';
      List<Map> semesters = <Map>[];
      Response response = await get(Uri.parse("http://pesbuic.herokuapp.com/api/v1/fsc/faculty/$id"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> temp = res.split('},');
      int i = 0;
      allSemesters = <String>[];
      for (String element in temp) {
        semesters.add(jsonDecode("$element}"));
        allSemesters.add(semesters[i]['semester']);
        i++;
      }
      if(!allSemesters.contains('Fall 2021')) {
        allSemesters.add('Fall 2021');
      }
      response = await get(Uri.parse("http://pesbuic.herokuapp.com/api/v1/fsc/courses/$id/$dropdownValue"));
      res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
    }
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
    Widget listViewBuilder() {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade900),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0,10),
                      blurRadius: 4
                  )]
                ),
                //color: Colors.grey.shade100,
                width: getWidth() - 250,
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        onTap: () {
                          Navigator
                              .pushNamed(
                              context,
                              '/allProject', arguments: {
                            "courseID": data[index]['course_id'],
                            "semester": data[index]['semester'],
                          });
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
                                  data[index]['course_name'],
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
                                  data[index]['semester'],
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
              ),
            );
          }
      );
    }

    Widget tableColumns() {
      return Row(
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
              'Semester',
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
      );
    }

    Widget topStrip() {
      return Row(
        children: [
          SizedBox(
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(3.0),
            width: 200,
            child: FlatButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              color: Colors.lightGreen.shade400,
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
              onPressed: () async {
                GoogleSheet gs = GoogleSheet();
                Map map = await gs.getById();
                List<String> studentNames = map['studentNames'];
                List<String> studentIds = map['studentIds'];
                String courseId = map['courseId'];
                String courseName = map['courseName'];
                addNewCourse(context, studentNames, studentIds, courseId, courseName);
              },
            ),
          ),
        ],
      );
    }

    Widget dropDown() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade900),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        width: 360,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 40,
              width: 350,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward, color: Colors.black, size: 30.0,),
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: allSemesters
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }

    Widget leftSideMenu()
    {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                height: 50,
                hoverColor: Colors.black54,
                shape: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                //shape: const OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.white, width: 1.0)),
                onPressed:() {
                  //Navigator.pushNamedAndRemoveUntil(context, 'facultyMain', (route) => false);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/facultyMain');
                } ,
                child:const SizedBox(
                  width: 400,
                  child: Text( 'Courses',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              FlatButton(
                height: 50,
                hoverColor: Colors.black54,
                shape: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                //shape: const OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.white, width: 1.0)),
                onPressed:() {
                  //Navigator.pushNamedAndRemoveUntil(context, 'facultyMain', (route) => false);
                  Navigator.pop(context);
                  Navigator
                      .pushNamed(
                      context,
                      '/allProject', arguments: {
                    "courseID": 'ESC 498',
                    "semester": 'Fall 2021',
                  });
                },
                child: const SizedBox(
                  width: 400,
                  child: Text('Final Year Project',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,)
                  ),
                ),
              ),
            ]
        ),
      );
    }

    String name = "Error";
    if(user != null) {
      name = user.displayName!;
      return FutureBuilder(
        future: getAllCourses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ScreenElements.screenLayout(context: context, name: name, leftSide: leftSideMenu(), topStrip: topStrip(), tableColumns: tableColumns(), listViewBuilder: listViewBuilder(), dropDown: dropDown(), popScope: false);
          }
          else {
            return const LoadingPage();
          }
        },
      );
    }
    else
    {
      return const LandingPage();
    }
  }
  Future<void> addNewCourse(BuildContext context, List<String> studentNames, List<String> studentIds, String courseId, String courseName) async {
    ScrollController scr = ScrollController();
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                backgroundColor: Colors.grey.shade300,
                content: Container(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                  width: 700,
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0,4),
                            blurRadius: 4
                        )
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Text(
                          'Course ID: $courseId',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Text(
                          'Course Name: $courseName',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 300,
                        width: 500,
                        child: Scrollbar(
                          scrollbarOrientation: ScrollbarOrientation.right,
                          controller: scr,
                          isAlwaysShown: true,
                          thickness: 10,
                          child: SingleChildScrollView(
                            controller: scr,
                            scrollDirection: Axis.vertical,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: studentIds.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          studentIds[index],
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(
                                          studentNames[index],
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                );
                              },
                            ),
                          ),
                        )
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 700,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            color: Colors.grey,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0))),
                            onPressed: () async {
                              for(int i = 0; i < studentNames.length; i++) {
                                await post(
                                    Uri.parse(
                                        "http://pesbuic.herokuapp.com/api/v1/fsc/"),
                                    headers: <String, String>{
                                      'Content-Type':
                                      'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'student_id': studentIds[i],
                                      //'course_id': 'CSC 320',
                                      'course_id': courseId,
                                      'semester': 'Fall 2021',
                                      'faculty_id': id,
                                    }));
                              }
                              super.setState(() {

                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Add New Course',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}
