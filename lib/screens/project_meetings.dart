import 'dart:convert';
import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/Modules/FirebaseStorage.dart';
import 'package:project_evaluation_system/Modules/screen_elements.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

import 'LoadingPage.dart';

class ProjectMeetings extends StatefulWidget {
  const ProjectMeetings({Key? key}) : super(key: key);

  @override
  _ProjectMeetingsState createState() => _ProjectMeetingsState();
}

class _ProjectMeetingsState extends State<ProjectMeetings> {
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if(args==null) {
      Navigator.popAndPushNamed(context, 'wrapper');
    }
    List<DateTime> picked = <DateTime>[];
    int projectId = args['projectId'];
    String projectName = args['projectName'];
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


    Future<void> getAllCourses() async {
      Response response = await get(Uri.parse("http://pesbuic.herokuapp.com/api/v1/projectFiles/files/$projectId"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      //print(allData);
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
      //print(data.length);
    }

    String getText(int index) {
      if(data[index]['project_file'] == null && DateTime.now().isBefore(DateTime.parse(data[index]['deadline']))) {
        return "Upload File";
      }
      else if(data[index]['project_file'] != null && DateTime.now().isBefore(DateTime.parse(data[index]['deadline']))) {
        return "Delete";
      }
      else {
        return "Deadline Exceeded";
      }
    }

    Widget getColumn() {
      if(student) {
        return const SizedBox(
          height: 50,
          width: 150,
          child: Align(
            alignment: Alignment
                .centerLeft,
            child: Text(
              '      Actions',
              style: TextStyle(
                fontSize: 20,
                color: Colors
                    .black,
                fontWeight: FontWeight
                    .bold,
              ),
              textAlign: TextAlign
                  .left,
            ),
          ),
        );
      }
      else {
        return const SizedBox.shrink();
      }
    }

    Widget getButton(int index)
    {
      if(student) {
        return Container(
          height: 50,
          width: 150,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: FlatButton(
            shape: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getText(index) == 'Upload File' ? Colors.black87 : Colors.transparent,
                  width: 1.0
                )
            ),
            color: getText(index) == 'Deadline Exceeded' ? Colors.transparent : Colors.grey.shade400,
            child: Text(
              getText(index),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight
                    .bold,
                color: Colors
                    .black,
              ),
              textAlign: TextAlign
                  .center,
            ),
            onPressed: () async {
              if(getText(index) == 'Upload File') {
                StorageManager sm = StorageManager();
                String? location = await sm.uploadFile();
                await put(
                  Uri.parse(
                      "http://pesbuic.herokuapp.com/api/v1/projectFiles/upload/$projectId/${index + 1}"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String?>{
                    'project_file': location,
                  }),
                );
                //await getAllCourses();
                setState(() {});
              }
              else if(getText(index) == 'Delete') {
                await put(
                  Uri.parse(
                      "http://pesbuic.herokuapp.com/api/v1/projectFiles/upload/$projectId/${index + 1}"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String?>{
                    'project_file': null,
                  }),
                );
                //await getAllCourses();
                setState(() {});
              }
            },
          ),
        );
      }
      else {
        return const SizedBox.shrink();
      }
    }
    Size size = MediaQuery.of(context).size;
    double width = size.width;
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
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            picked.add(DateTime.parse(data[index]['deadline']));
            Color color;
            Color color2;
            if(data[index]['project_file'] != null) {
              color = Colors.grey.shade300;
            }
            else {
              color = Colors.red.shade700;
            }
            if(data[index]['project_file'] != null) {
              color2 = Colors.lightGreen.shade300;
            }
            else if(data[index]['project_file'] == null && DateTime.now().isBefore(DateTime.parse(data[index]['deadline']))) {
              color2 = Colors.lightGreen.shade300;
            }
            else {
              color2 = Colors.red.shade300;
            }
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: color2,
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0,10),
                          blurRadius: 4
                      )]
                  ),
                  child: SizedBox(
                    width: getWidth() - 270,
                    child: ListTile(
                      onTap: () {

                      },
                      title: SizedBox(
                        height: 50,
                        width: getWidth(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: Align(
                                alignment: Alignment
                                    .centerLeft,
                                child: Text(
                                  'Meeting ${index +
                                      1}',
                                  style: const TextStyle(
                                    fontSize: 20,
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
                                child: SizedBox
                                    .shrink()),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets
                                    .fromLTRB(
                                    5, 10, 5,
                                    10),
                                child: FlatButton(
                                  shape: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0)),
                                  color: color,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: const [
                                      Icon(
                                        Icons
                                            .download_rounded,
                                        color: Colors
                                            .black,
                                      ),
                                      Text(
                                        'Project File',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight
                                              .bold,
                                          color: Colors
                                              .black,
                                        ),
                                        textAlign: TextAlign
                                            .left,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    if(data[index]['project_file'] != null) {
                                      window.open(data[index]['project_file'],"_blank");
                                    }
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                                child: SizedBox
                                    .shrink()),
                            SizedBox(
                              height: 50,
                              width: 220,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 170,
                                    child: Padding(
                                      padding: const EdgeInsets
                                          .fromLTRB(
                                          5,
                                          10,
                                          5,
                                          10),
                                      child: FlatButton(
                                        shape: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87, width: 1.0)),
                                        color: Colors
                                            .grey.shade400,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: const [
                                            Icon(
                                              Icons
                                                  .edit,
                                              color: Colors
                                                  .black,
                                            ),
                                            Text(
                                              'Edit Log Report',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight
                                                    .bold,
                                                color: Colors
                                                    .black,
                                              ),
                                              textAlign: TextAlign
                                                  .left,
                                            ),
                                          ],
                                        ),
                                        onPressed: () async{
                                          await showAlert(context, projectId, index+1, data[index]['achievements'], data[index]['supervisor_comments'], data[index]['next_meeting']);
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Padding(
                                      padding: const EdgeInsets
                                          .fromLTRB(
                                          5,
                                          10,
                                          5,
                                          10),
                                      child: FlatButton(
                                        shape: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87, width: 1.0)),
                                        color: Colors
                                            .grey.shade400,
                                        child: const Icon(
                                          Icons
                                              .download_rounded,
                                          color: Colors
                                              .black,
                                          size: 20,
                                        ),
                                        onPressed: () {

                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                                child: SizedBox
                                    .shrink()),
                            getButton(index),
                            const Expanded(child: SizedBox.shrink()),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets
                                    .fromLTRB(
                                    5, 10, 5,
                                    10),
                                child: FlatButton(
                                  color: Colors
                                      .transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      const Icon(
                                        Icons
                                            .date_range_rounded,
                                        color: Colors
                                            .black,
                                      ),
                                      Text(
                                        "${picked[index].day}/${picked[index].month}/${picked[index].year}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight
                                              .bold,
                                          color: Colors
                                              .black,
                                        ),
                                        textAlign: TextAlign
                                            .left,
                                      ),
                                    ],
                                  ),
                                  onPressed: () async{
                                    if(!student) {
                                      picked[index] = (await ScreenElements().selectDate(context, picked[index]))!;
                                      await put(Uri.parse("http://pesbuic.herokuapp.com/api/v1/projectFiles/changedeadline/$projectId/${index+1}"),
                                        headers: <String, String>{
                                          'Content-Type': 'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode(<String, String>{
                                          'deadline': picked[index].toString(),
                                        }),
                                      );
                                      setState(() {

                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
          const SizedBox(
            height: 40,
            width: 110,
            child: Align(
              alignment: Alignment
                  .centerLeft,
              child: Text(
                '   Meetings',
                style: TextStyle(
                  fontSize: 20,
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
          const Expanded(child: SizedBox
              .shrink()),
          const SizedBox(
            height: 40,
            width: 150,
            child: Align(
              alignment: Alignment
                  .center,
              child: Text(
                ' Project Files',
                style: TextStyle(
                  fontSize: 20,
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
          const Expanded(child: SizedBox
              .shrink()),
          const SizedBox(
            height: 40,
            width: 220,
            child: Align(
              alignment: Alignment
                  .center,
              child: Text(
                'Log Reports',
                style: TextStyle(
                  fontSize: 20,
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
          const Expanded(child: SizedBox
              .shrink()),
          getColumn(),
          const Expanded(child: SizedBox.shrink()),
          const SizedBox(
            height: 40,
            width: 160,
            child: Align(
              alignment: Alignment
                  .center,
              child: Text(
                'Deadlines',
                style: TextStyle(
                  fontSize: 20,
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
        ],
      );
    }

    Widget topStrip() {
      if(student) {
        return Text(
          ' $projectName',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        );
      }
      else {
        return Row(
          children: [
            Expanded(
              child: Text(
                ' $projectName',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 3.0),
            SizedBox(
              height: 70,
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FlatButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  color: Colors.lightGreen.shade400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    children: const [
                      Text(
                        'New Meeting',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight
                              .bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Icon(
                        Icons.update,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await post(Uri.parse("http://pesbuic.herokuapp.com/api/v1/projectFiles/"),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, dynamic>{
                          'file_id': data.length+1,
                          'project_id' : projectId,
                          'deadline': DateTime.now().toString(),
                        }));
                    setState(() {

                    });
                  },
                ),
              ),
            ),
          ],
        );
      }
    }

    Widget leftSideMenu()
    {
      if(!student){
        return Center(
          child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            FlatButton(
              height: 50,
              hoverColor: Colors.black54,
              shape: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
              ),
              //shape: const OutlineInputBorder(
              //borderSide: BorderSide(color: Colors.white, width: 1.0)),
              onPressed: () {
                //Navigator.pushNamedAndRemoveUntil(context, 'facultyMain', (route) => false);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/facultyMain');
              },
              child: const SizedBox(
                width: 400,
                child: Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 22,
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
              onPressed: () {
                //Navigator.pushNamedAndRemoveUntil(context, 'facultyMain', (route) => false);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/allProject', arguments: {
                  "courseID": 'ESC 498',
                  "semester": 'Fall 2021',
                });
              },
              child: const SizedBox(
                width: 400,
                child: Text('Final Year Project',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    )),
              ),
            ),
          ]),
        );
      }
      else {
        return const SizedBox.shrink();
      }
    }

    String name = "error";
    checkUser();
    if(user != null) {
      name = user.displayName!;
      return FutureBuilder(
        future: getAllCourses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ScreenElements.screenLayout(context: context, name: name, leftSide: leftSideMenu(), topStrip: topStrip(), tableColumns: tableColumns(), listViewBuilder: listViewBuilder(), dropDown: const SizedBox.shrink(), popScope: true);
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

  Future<void> showAlert(BuildContext context, int projectId, int fileId, String? achievements, String? comments, String? nextMeeting) async {
    String text = ' ';
    String text1 = achievements ?? ' ';
    String text2 = comments ?? ' ';
    String text3 = nextMeeting ?? ' ';
    TextEditingController textControl1 = TextEditingController(text: text1);
    TextEditingController textControl2 = TextEditingController(text: text2);
    TextEditingController textControl3 = TextEditingController(text: text3);
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                backgroundColor: Colors.grey[600],
                title: SizedBox(
                  width: 1000,
                  height: 510,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: 5,
                        controller: textControl1,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Achievements',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            )
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: textControl2,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "SuperVisor's Comments",
                            labelStyle: TextStyle(
                              fontSize: 20,
                            )
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: textControl3,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Next Meeting',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            )
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red[900],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: 120,
                            child: FlatButton(
                              shape: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87, width: 1.0)),
                              color: Colors.blue[800],
                              onPressed: () async {
                                try {
                                  achievements = textControl1.text;
                                  comments = textControl2.text;
                                  nextMeeting = textControl3.text;
                                  await put(Uri.parse("http://pesbuic.herokuapp.com/api/v1/projectFiles/addinfo/$projectId/$fileId"),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, String?>{
                                        'achievements': achievements,
                                        'supervisor_comments': comments,
                                        'next_meeting': nextMeeting,
                                      }));
                                  Navigator.pop(context);
                                }
                                catch (ex) {
                                  setState(() => text = "Incorrect input");
                                }
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

}
