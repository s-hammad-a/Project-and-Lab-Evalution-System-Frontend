// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String server = "projectandlabevaluation.herokuapp.com";
  @override
  Widget build(BuildContext context) {
    String id = "error";
    List<Map> data = <Map>[];
    Map weightage = {};
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    final user = Provider.of<User?>(context);
    bool student = false;
    void checkUser()
    {
      if(!user!.email!.contains("student")) {
        student = true;
      }
      else {
        student = false;
      }
    }

    Future<void> getAllCourses() async {
      List<String> arr =  user!.email!.split("@");
      id = arr.first;
      //id = "asohail.buic";
      //id = "rafiahassan.buic";
      //id = "asohail.buic";
      Response response = await get(Uri.parse("http://$server/api/v1/lab/courses/$id"));
      print(response.body);
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      print(allData);
      for (String element in allData) {
        Map map = jsonDecode("$element}");
        String temp = map['course_name'];
        if(temp.contains('Lab') || temp.contains('lab')) {
            data.add(map);
        }
      }
      if(data.isNotEmpty) {
        response = await get(Uri.parse("http://$server/api/v1/weightage/$id${data[0]['course_id']}Spring 2022"));
        res = response.body.substring(1,response.body.length-2);
        allData = res.split('},');
        print(allData);
        for (String element in allData) {
          weightage = jsonDecode("$element}");
        }
      }
      //print(response.body);
    }

    String name = "error";
    if(user != null) {
      checkUser();
      name = user.displayName!;
      return FutureBuilder(
        future: getAllCourses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Lab Evaluation System'),
                centerTitle: true,
                backgroundColor: Color.fromRGBO(88, 133, 158, 100),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Icon(Icons.paste, color: Colors.black),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Labs Assigned',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            // fontFamily: 'Times New Roman',
                            letterSpacing: 0.5,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        SizedBox(width: 15),
                      ],
                    ),
                    //labsAssignedCardTemplate(context), //put these in listview
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return labsAssignedCardTemplate(context, data[index], weightage, id);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
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

  //Card design for the lab assigned
  Widget labsAssignedCardTemplate(BuildContext context, var data, var weightage, String id) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/allLabs', arguments: {
            'course_name' : data['course_name'],
            'course_id' : data['course_id'],
            'semester' : data['semester'],
          });
        },
        onLongPress: () async {
          TextEditingController assessment = TextEditingController(text: weightage['assessments'].toString());
          TextEditingController midterm = TextEditingController(text: weightage['midterm'].toString());
          TextEditingController finals = TextEditingController(text: weightage['finals'].toString());
          TextEditingController journal = TextEditingController(text: weightage['journal'].toString());
          /*TextEditingController assessment = TextEditingController(text: '40');
        TextEditingController midterm = TextEditingController(text: '20');
        TextEditingController finals = TextEditingController(text: '20');
        TextEditingController journal = TextEditingController(text: '20');*/
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey.shade100,
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                title: SizedBox(
                  height: 350,
                  width: 250,
                  // color: Colors.grey.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Assessments: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            height: 70,
                            width: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              //enabled: false,
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(88, 133, 158, 100),
                              ),
                              controller: assessment,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Midterm:          ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            height: 70,
                            width: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              //enabled: false,
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(88, 133, 158, 100),
                              ),
                              controller: midterm,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Finals:              ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            height: 70,
                            width: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              //enabled: false,
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(88, 133, 158, 100),
                              ),
                              controller: finals,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Journals:         ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            height: 70,
                            width: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              //enabled: false,
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(88, 133, 158, 100),
                              ),
                              controller: journal,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(

                            border: Border.all(
                              width: 1,
                              color: Colors.blue.shade100,
                            ),
                            color:  Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          elevation: 0,
                          color:  Colors.blue.shade100,
                          // foregroundColor: Colors.blue.shade100,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () async {
                            if((int.parse(assessment.text) + int.parse(journal.text) + int.parse(midterm.text) + int.parse(finals.text)) == 100){
                              await put(
                                Uri.parse(
                                    "http://$server/api/v1/weightage/$id${data['course_id']}Spring 2022"),
                                headers: <String, String>{
                                  'Content-Type':
                                  'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, int>{
                                  'assessments': int.parse(assessment.text),
                                  'journal': int.parse(journal.text),
                                  'midterm': int.parse(midterm.text),
                                  'finals': int.parse(finals.text),
                                }),
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          setState(() {

          });
        },
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data["course_name"], //put lab variable name here
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Times New Roman',
                      letterSpacing: 0.5,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Text(
                      'Semester: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        // fontFamily: 'Times New Roman',
                        letterSpacing: 0.5,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      data['semester'], //put lab/room name variable here
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        // fontFamily: 'Times New Roman',
                        letterSpacing: 0.5,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}