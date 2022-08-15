import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

class AllLabs extends StatefulWidget {
  const AllLabs({Key? key}) : super(key: key);

  @override
  _AllLabsState createState() => _AllLabsState();
}

class _AllLabsState extends State<AllLabs> {
  String server = "projectandlabevaluation.herokuapp.com";
  @override
  Widget build(BuildContext context) {
    TextEditingController labName = TextEditingController();
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if(args==null) {
      Navigator.popAndPushNamed(context, 'wrapper');
    }
    String courseName = args['course_name'];
    String courseId = args['course_id'];
    String semester = args['semester'];
    List<Map> data = <Map>[];
    final user = Provider.of<User?>(context);
    bool student = false;
    void checkUser()
    {
      if(user!.email!.contains("student"))
      {
        student = true;
      }
      else {
        student = false;
      }
    }
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    Future<void> getAllLabs() async {
      List<String> arr =  user!.email!.split("@");
      String id = arr.first;
      id = "asohail.buic";
      Response response = await get(Uri.parse("http://$server/api/v1/lab/labdata/$id/$semester/$courseId"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      print(allData);
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
    }

    String name = "error";
    if(user != null) {
      checkUser();
      name = user.displayName!;
      return FutureBuilder(
        future: getAllLabs(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Lab Evaluation System',style: TextStyle(
                    fontSize: 20,
                  // fontWeight: FontWeight.bold,

                ),),
                centerTitle: true,
                backgroundColor: const Color.fromRGBO(88, 133, 158, 100),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        SizedBox(
                          width: 155,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left:4 ),
                                child: Icon(Icons.paste, color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 7, bottom: 5),
                                child: Text(
                                  'All Labs',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    // fontFamily: 'Times New Roman',
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0, bottom: 5),
                              child: SizedBox(
                                height: 35,
                                width: 120,
                                child: FloatingActionButton.extended(
                                    elevation: 2,
                                    shape: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue.shade100, width: 1.0),
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:     Colors.grey.shade50,
                                            shape: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                            ),
                                            title: Container(

                                              height: 150,
                                              width: 350,
                                              color: Colors.grey.shade50,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Lab Name: ',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      SizedBox(
                                                        height: 70,
                                                        width: 200,
                                                        child: TextFormField(
                                                          controller: labName,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.blue.shade500,
                                                        ),
                                                        color: const Color.fromRGBO(88, 133, 158, 100),
                                                        borderRadius: BorderRadius.circular(5)),
                                                    // height: 30,
                                                    // width: 100,
                                                    child:RaisedButton(
                                                      elevation: 0,
                                                      color:  Colors.blue.shade100,
                                                      child: const Text(
                                                        'Create',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if(labName.text.isNotEmpty){
                                                          List<String> arr =
                                                              user.email!
                                                                  .split("@");
                                                          String id = arr.first;
                                                          id = "asohail.buic";
                                                          await post(
                                                              Uri.parse(
                                                                  "http://$server/api/v1/lab/"),
                                                              headers: <String,
                                                                  String>{
                                                                'Content-Type':
                                                                    'application/json; charset=UTF-8',
                                                              },
                                                              body: jsonEncode(<
                                                                  String,
                                                                  dynamic>{
                                                                'faculty_id':
                                                                    id,
                                                                'course_id':
                                                                    courseId,
                                                                'semester':
                                                                    'Spring 2022',
                                                                'lab_name':
                                                                    labName
                                                                        .text,
                                                                'weightage': 0,
                                                              }));
                                                          super.setState(() {});
                                                          Navigator.pop(
                                                              context);
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
                                    },
                                    label: const Text(
                                      '+ Assessment',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                              child: SizedBox(
                                height: 35,
                                width: 120,
                                child: FloatingActionButton.extended(
                                    elevation: 2,
                                    shape: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue.shade100, width: 1.0),
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                    onPressed: () async {
                                      List<String> arr =  user.email!.split("@");
                                      String id = arr.first;
                                      //id = "asohail.buic";
                                      await post(
                                          Uri.parse("http://$server/api/v1/lab/"),
                                          headers: <String, String>{
                                            'Content-Type':
                                            'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode(<String, dynamic>{
                                            'faculty_id' : id,
                                            'course_id' : courseId,
                                            'semester' : 'Spring 2022',
                                            'lab_name': 'Midterm',
                                            'weightage' : 1,
                                          })
                                      );
                                      setState(() {

                                      });
                                    },
                                    label: const Text(
                                      'Midterm',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                              child: SizedBox(
                                height: 35,
                                width:120 ,
                                child: FloatingActionButton.extended(
                                    elevation: 2,
                                    shape: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue.shade100, width: 1.0),
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                    onPressed: () async {
                                      List<String> arr =  user.email!.split("@");
                                      String id = arr.first;
                                      id = "asohail.buic";
                                      await post(
                                          Uri.parse("http://$server/api/v1/lab/"),
                                          headers: <String, String>{
                                            'Content-Type':
                                            'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode(<String, dynamic>{
                                            'faculty_id' : id,
                                            'course_id' : courseId,
                                            'semester' : 'Spring 2022',
                                            'lab_name': 'Final',
                                            'weightage' : 2,
                                          })
                                      );
                                      setState(() {

                                      });
                                    },
                                    label: const Text(
                                      'Final',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    )
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return labsCardTemplate(context, data[index], courseName, courseId, semester);
                        },
                      ),
                    ),
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
}
Widget labsCardTemplate(BuildContext context, var data, String courseName, String courseId, String semester) {
  Size size = MediaQuery.of(context).size;
  double height = size.height;
  double width = size.width;
  return Card(
    elevation: 2,
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
        //path to next page
        Navigator.pushNamed(context, '/markList', arguments: {
          'course_name' : courseName,
          'course_id' : courseId,
          'semester' : semester,
          'lab_name' : data['lab_name'],
          'lab_number' : data['lab_number'],
        });
      },
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SizedBox(
              width: (width/20)*14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5.0),
                        child: Text(
                          'Lab No. ${data['lab_number']}', //put lab variable name here
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            // fontFamily: 'Times New Roman',
                            letterSpacing: 0.5,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,top: 5),
                    child: Row(
                      children: [
                        const Text(
                          'Title: ',
                          style: TextStyle(
                            color: Colors.black,
                            // fontFamily: 'Times New Roman',
                            letterSpacing: 0.5,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: ((width/20)*10) - 10,
                          child: Text(
                            data['lab_name'], //put lab/room name variable here
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: Colors.black,
                              // fontFamily: 'Times New Roman',
                              letterSpacing: 0.5,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                    height: 5,
                  ),
                ],
              ),
            ),
            /*SizedBox(
              width: (width/20)*3.5,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: ((width/20)*3.5) - 8,
                  height: 35,
                  child: FlatButton.icon(
                    onPressed: () {
                      //path to next page
                      //Navigator.pushNamed(context, '/markList');
                      Navigator.pushNamed(context, '/allLabs');
                    },
                    icon: const Icon(Icons.border_color_outlined),
                    label: const SizedBox.shrink(),
                    //label: const Text('Start Evaluation'),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width<700 ? ((width/20)*3.5) - 3 : ((width/20)*4) + 10,
              height: 70,
              child: FlatButton.icon(
                onPressed: () {
                  //path to next page
                  Navigator.pushNamed(context, '/markList', arguments: {
                    'course_name' : courseName,
                    'course_id' : courseId,
                    'semester' : semester,
                    'lab_name' : data['lab_name'],
                    'lab_number' : data['lab_number'],
                  });
                  //Navigator.pushNamed(context, '/allLabs');
                },
                icon: const Icon(Icons.border_color_outlined),
                label: width<700 ? const SizedBox.shrink() : const Text('Start Evaluation'),
                //label: const Text('Start Evaluation'),
              ),
            )*/
          ],
        ),
      ),
    ),
  );
}
