import 'dart:convert';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/Modules/FirebaseStorage.dart';
import 'package:project_evaluation_system/Modules/screen_elements.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

class FacultyProposals extends StatefulWidget {
  const FacultyProposals({Key? key}) : super(key: key);

  @override
  _FacultyProposalsState createState() => _FacultyProposalsState();
}

class _FacultyProposalsState extends State<FacultyProposals> {
  @override
  Widget build(BuildContext context) {
    List<Map> data = <Map>[];
    List<DateTime> picked = <DateTime>[];
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if(args==null) {
      Navigator.popAndPushNamed(context, 'wrapper');
    }
    int projectId = args['projectId'];
    String projectName = args['projectName'];
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

    String getText(int index) {
      if(data[index]['proposal_file'] == null && DateTime.now().isBefore(DateTime.parse(data[index]['deadline']))) {
        return "Upload File";
      }
      else if(data[index]['proposal_file'] != null && DateTime.now().isBefore(DateTime.parse(data[index]['deadline']))) {
        return "Delete";
      }
      else {
        return "Deadline Exceeded";
      }
    }

    Widget getColumn() {
      if(student) {
        return const SizedBox(
          width: 150,
          child: Text(
            'Action',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight
                  .bold,
            ),
            textAlign: TextAlign
                .center,
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
        return SizedBox(
          width: 150,
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
                await put(Uri.parse(
                    "http://pesbuic.herokuapp.com/api/v1/proposal/uploadproposal/$projectId/${index +
                        1}"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String?>{
                    'proposal_file': location,
                  }),
                );
                setState(() {

                });
              }
              else if(getText(index) == 'Delete') {
                await put(Uri.parse(
                    "http://pesbuic.herokuapp.com/api/v1/proposal/uploadproposal/$projectId/${index +
                        1}"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String?>{
                    'proposal_file': null,
                  }),
                );
                setState(() {

                });
              }
            },
          ),
        );
      }
      else {
        return const SizedBox.shrink();
      }
    }

    Future<void> getAllCourses() async {
      Response response = await get(Uri.parse("http://pesbuic.herokuapp.com/api/v1/proposal/$projectId"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      //print(allData);
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
    }

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double getWidth() {
      if (width < 1250) {
        return 1250;
      } else {
        return width;
      }
    }

    Widget listViewBuilder() {
      List<TextEditingController> comments = <TextEditingController>[];
      return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            Color color;
            Color color2;
            if(data[index]['proposal_file'] != null) {
              color = Colors.grey.shade300;
            }
            else {
              color = Colors.red.shade700;
            }
            if(data[index]['proposal_file'] != null) {
              color2 = Colors.lightGreen.shade300;
            }
            else if(data[index]['proposal_file'] == null && DateTime.now().isBefore(DateTime.parse(data[index]['deadline']))) {
              color2 = Colors.lightGreen.shade300;
            }
            else {
              color2 = Colors.red.shade300;
            }
            comments.add(TextEditingController(text: data[index]['comments']));
            picked.add(DateTime.parse(data[index]['deadline']));
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
                  //color: color2,
                  child: SizedBox(
                    width: getWidth(),
                    child: ListTile(
                      onTap: () {

                      },
                      title: SizedBox(
                        height: 50,
                        width: getWidth(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center,
                          mainAxisAlignment: MainAxisAlignment
                              .center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Proposal ${index +
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
                            const Expanded(child: SizedBox.shrink()),
                            SizedBox(
                              width: 430,
                              child: TextFormField(
                                readOnly: student,
                                onEditingComplete: () async {
                                  await put(Uri.parse("http://pesbuic.herokuapp.com/api/v1/proposal/addcomment/$projectId/${index+1}"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'comments': comments[index].text,
                                    }),
                                  );
                                  setState(() {

                                  });
                                },
                                textAlignVertical: TextAlignVertical
                                    .center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .grey[200],
                                    border: const UnderlineInputBorder(),
                                    hintText: 'Comments',
                                    hintStyle: const TextStyle(
                                        color: Colors
                                            .black,
                                        fontSize: 20.0
                                    ),
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight
                                          .bold,
                                      color: Colors
                                          .black,
                                      fontSize: 35,
                                    )
                                ),
                                controller: comments[index],
                              ),
                            ),
                            const Expanded(child: SizedBox.shrink()),
                            SizedBox(
                              width: 150,
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
                                          .black87,
                                    ),
                                    Text(
                                      'Proposal File',
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
                                onPressed: () async {
                                  /*HttpClient client = HttpClient();
                                  client.getUrl(Uri.parse("https://firebasestorage.googleapis.com/v0/b/project-evaluation-system.appspot.com/o/uploads%2Ftest.docx?alt=media&token=7145c0e7-1635-46ce-82f4-f750650525f0"))
                                      .then((HttpClientRequest request) {
                                    // Optionally set up headers...
                                    // Optionally write to the
                                    return request.close();
                                  })
                                      .then((HttpClientResponse response) {
                                  });
                                 Response response = await get(Uri.parse("https://firebasestorage.googleapis.com/v0/b/project-evaluation-system.appspot.com/o/uploads%2Ftest.docx?alt=media&token=7145c0e7-1635-46ce-82f4-f750650525f0"),headers: {
                                    "Access-Control-Allow-Origin": "*"
                                 });
                                 print(response.body);
                                  Response response = await put(Uri.parse("https://firebasestorage.googleapis.com/v0/b/project-evaluation-system.appspot.com/o/uploads%2Ftest.docx?alt=media&token=7145c0e7-1635-46ce-82f4-f750650525f0"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'comments': comments[index].text,
                                    }),
                                  );*/
                                  window.open(data[index]['proposal_file'],"_blank");
                                },
                              ),
                            ),
                            const Expanded(child: SizedBox.shrink()),
                            getButton(index),
                            const Expanded(child: SizedBox.shrink()),
                            SizedBox(
                              height: 50,
                              width: 130,
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
                                  onPressed: () async {
                                    if(!student) {
                                      picked[index] = (await ScreenElements().selectDate(context, picked[index]))!;
                                      await put(Uri.parse("http://pesbuic.herokuapp.com/api/v1/proposal/changedeadline/$projectId/${index+1}"),
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
            width: 100,
            child: Text(
              ' Proposals',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight
                    .bold,
              ),
              textAlign: TextAlign
                  .left,
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          const SizedBox(
            width: 450,
            child: Text(
              'Comments',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight
                    .bold,
              ),
              textAlign: TextAlign
                  .center,
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          const SizedBox(
            width: 150,
            child: Text(
              'Proposal File',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight
                    .bold,
              ),
              textAlign: TextAlign
                  .center,
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          getColumn(),
          const Expanded(child: SizedBox.shrink()),
          const SizedBox(
            width: 130,
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
          const SizedBox(width: 12),
        ],
      );
    }

    Widget topStrip() {
      if(student) {
        return Text(
          projectName,
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
              flex: 9,
              child: Text(
                projectName,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: FlatButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                color: Colors.lightGreen.shade400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end,
                  children: const [
                    Text(
                      'Add new Proposal',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      Icons.update,
                    ),
                  ],
                ),
                onPressed: () async {
                  await post(Uri.parse("http://pesbuic.herokuapp.com/api/v1/proposal/"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, dynamic>{
                        'proposal_id': data.length+1,
                        'project_id' : projectId,
                        'deadline': DateTime.now().toString(),
                      }));
                  setState(() {

                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: FlatButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                color: Colors.lightGreen.shade400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end,
                  children: const [
                    Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon(
                      Icons.update,
                    ),
                  ],
                ),
                onPressed: () async {
                  await put(Uri.parse("http://pesbuic.herokuapp.com/api/v1/projects/$projectId"),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, bool>{
                      'status': true,
                    }),
                  );
                  Navigator.pop(context);
                },
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
    if(user != null) {
      checkUser();
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
}
