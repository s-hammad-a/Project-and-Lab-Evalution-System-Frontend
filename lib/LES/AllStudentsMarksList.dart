import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

class AllStudentsMarksList extends StatefulWidget {
  const AllStudentsMarksList({Key? key}) : super(key: key);

  @override
  State<AllStudentsMarksList> createState() => _AllStudentsMarksListState();
}

class _AllStudentsMarksListState extends State<AllStudentsMarksList> {
  late List<TextEditingController> controllerList;
  late List<TextEditingController> journalList;
  late List<int> radioIds;
  String server = "projectandlabevaluation.herokuapp.com";
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if(args==null) {
      Navigator.popAndPushNamed(context, 'wrapper');
    }
    String courseName = args['course_name'];
    String courseId = args['course_id'];
    String semester = args['semester'];
    String labName = args['lab_name'];
    int labNumber = args['lab_number'];
    List<Map> data = <Map>[];
    String id = " ";
    final user = Provider.of<User?>(context);
    bool student = false;
    void checkUser()
    {
      if(!user!.email!.contains("student"))
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

    Future<void> getAllStudents() async {
      data = <Map>[];
      controllerList = <TextEditingController>[];
      journalList = <TextEditingController>[];
      radioIds = <int>[];
      List<String> arr =  user!.email!.split("@");
      id = arr.first;
      id = "asohail.buic";
      Response response = await get(Uri.parse("http://$server/api/v1/lab/studentdata/$id/Spring 2022/$courseId/$labNumber"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
      int sum = 0;
      for(int i = 0; i<data.length; i++){
        sum = data[i]['implementation'] +
            data[i]['knowledge'] +
            data[i]['demo'] +
            data[i]['report'];
        controllerList.add(TextEditingController(text: sum.toString()));
        journalList.add(TextEditingController(text: data[i]['journal'].toString()));
        if(sum == 0) {
          radioIds.add(2);
        }
        else {
          radioIds.add(1);
        }
      }
    }

    String name = "error";
    if(user != null) {
      checkUser();
      name = user.displayName!;
      return FutureBuilder(
        future: getAllStudents(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.grey.shade50,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Lab Evaluation System',
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(88, 133, 158, 100),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          Text(
                            courseName, //put lab name variable here
                            style: const TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w800,
                              //fontFamily: 'Times New Roman',
                              letterSpacing: 0.5,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 3),
                        child: Text(
                          'Semester: $semester', //put lab/room variable here
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.w800,
                            //fontFamily: 'Times New Roman',
                            letterSpacing: 0.5,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: SizedBox(
                          width: width-100,
                          child: Text(
                            "Lab Name: $labName",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w800,
                              //fontFamily: 'Times New Roman',
                              letterSpacing: 0.5,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      getDivider(),
                      //card used as a main card, other studentMarksCardTemplate are nested in it
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return studentMarksCardTemplate(context, data[index], index, labNumber, courseId, id);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
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
  Widget studentMarksCardTemplate(BuildContext context, var data, int index, int labNumber, String courseId, String facultyId) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3, top: 3, bottom: 0),
                  child: Text(
                    '${(index+1).toString()}. ', //Counter for students
                    style: const TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w800,
                      //fontFamily: 'Times New Roman',
                      letterSpacing: 0.5,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: width - 100,
                  child: Text(
                    data['student_name'], //put student name variable here
                    style: const TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.5,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                SizedBox(
                  width: 285,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: radioIds[index],
                                  onChanged: (val) async {
                                    radioButtonItem = 'Marked';
                                    radioIds[index] = 1;
                                    await put(Uri.parse("http://$server/api/v1/lab/"),
                                        headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode(<String, dynamic>{
                                        'implementation' : 5,
                                        'demo' : 5,
                                        'knowledge' : 5,
                                        'report' : 5,
                                        'fsc_id' : facultyId + data['student_id'] + courseId + 'Spring 2022',
                                        'lab_number' : labNumber,
                                        }),
                                    );
                                    setState(() {

                                    });
                                  },
                                ),
                                const Text(
                                  'Marked',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: radioIds[index],
                                  onChanged: (val) async {
                                    radioButtonItem = 'unMarked';
                                    radioIds[index] = 2;
                                    await put(Uri.parse("http://$server/api/v1/lab/"),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, dynamic>{
                                        'implementation' : 0,
                                        'demo' : 0,
                                        'knowledge' : 0,
                                        'report' : 0,
                                        'fsc_id' : facultyId + data['student_id'] + courseId + 'Spring 2022',
                                        'lab_number' : labNumber,
                                      }),
                                    );
                                    setState(() {

                                    });
                                  },
                                ),
                                const Text(
                                  'UnMarked',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 1, right: 0),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            enabled: false,
                            style: const TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              fillColor: Color.fromRGBO(88, 133, 158, 100),
                            ),
                            controller: controllerList[index],
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 4, right: 1, bottom: 3),
                        child: Row(
                          children: [
                            FlatButton.icon(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.grey.shade50,
                                    contentPadding: const EdgeInsets.all(2),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10.0))),
                                    content: SizedBox(
                                      height: 600,
                                      width: width<700 ? width - 50 : width - 200,
                                      child: rubericsMarksCard(context, data, index, width, data['student_id'], labNumber, courseId, facultyId),
                                    ),
                                  ),
                                );
                                setState(() {

                                });
                              },
                              icon: const Icon(Icons.border_color_outlined, size: 30),
                              label: const Text(
                                'Edit',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Row(
                    children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 25, bottom: 0, right: 0, top: 15),
                          child: Text(
                            "Journal",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5, right: 0, top: 8),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: TextField(
                              /*onEditingComplete: () async {
                              print("ed");
                              await put(Uri.parse("http://$server/api/v1/lab/journal/"),
                                  headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                  'journal' : journalList[index].text,
                                  'fsc_id' : facultyId + data['student_id'] + courseId + 'Spring 2022',
                                  'lab_number' : labNumber,
                                  }),
                              );
                            },*/
                              onSubmitted: (val) async {
                                if(int.parse(val) >5 )
                                {
                                  val = 5.toString();
                                }
                                else if (int.parse(val) <0){
                                  val = 0.toString();
                                }
                                await put(Uri.parse(
                                    "http://$server/api/v1/lab/journal/"),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    'journal': val,
                                    'fsc_id': facultyId + data['student_id'] +
                                        courseId + 'Spring 2022',
                                    'lab_number': labNumber,
                                  }),
                                );
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(88, 133, 158, 100),
                              ),
                              controller: journalList[index],
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ),
                    ]
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}


// Ruberics marks card where getRuberics card will be get called
Widget rubericsMarksCard(BuildContext context, var data, int index, double width, String studentId, int labNumber, String courseId, String facultyId) {
  return Card(
    elevation: 2,
    color: Colors.grey.shade50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: getRuberics(context, data['implementation'], data['knowledge'], data['demo'], data['report'], data['student_name'], index, width, studentId, labNumber, courseId, facultyId), //demo name for ruberic name, pass ruberics name here i.e ruberic 1
  );
}

//Radio Button options
enum MarkedStatus { marked, unMarked }
String radioButtonItem = 'ONE';
int id = 1;

MarkedStatus _markedStatus =
    MarkedStatus.marked; //Initial status of radio button
//Card for students marks in a lab


//class for number counter
class RubericNumberCounter extends StatefulWidget {
  int count; // variable to set ruberic marks
  RubericNumberCounter({Key? key, required this.count}) : super(key: key);
  int getCount()
  {
    return count;
  }

  @override
  State<StatefulWidget> createState() {
    return _RubericNumberCounterState();
  }
}

class _RubericNumberCounterState extends State<RubericNumberCounter> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.blue.shade300,
                ),
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      if(widget.count>0) {
                        widget.count -= 1;
                      }
                    });
                  },
                ),
                Text(
                  widget.count.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if(widget.count<5)
                        {
                          widget.count += 1;
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//Function to return ruberics for ruberic card
Widget getRuberics(BuildContext context, int rubericOne, int rubericTwo, int rubericThree, int rubericFour, String name, int index, double width, String studentId, int labNumber, String courseId, String facultyId) {
  String server = "projectandlabevaluation.herokuapp.com";
  RubericNumberCounter rubOne = RubericNumberCounter(count: rubericOne);
  RubericNumberCounter rubTwo = RubericNumberCounter(count: rubericTwo);
  RubericNumberCounter rubThree = RubericNumberCounter(count: rubericThree);
  RubericNumberCounter rubFour = RubericNumberCounter(count: rubericFour);
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 5, bottom: 0),
              child: Text(
                '${index + 1}. ', //Counter for students or enrollment numbr
                style: const TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.w800,
                  // fontFamily: 'Times New Roman',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              width: width<700 ? width - 141 : width - 300,
              child: Text(
                name, //student name variable
                style: const TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.w800,
                  // fontFamily: 'Times New Roman',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
        getDivider(), //function to return divider(line)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
              child: Text(
                '1. ', //Counter for Ruberic
                style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.w800,
                  // fontFamily: 'Times New Roman',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ),
            Text(
              'Implementation', //Ruberic name variable which comes from parameters
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.w800,
                // fontFamily: 'Times New Roman',
                letterSpacing: 0.5,
                fontSize: 25,
              ),
            ),
          ],
        ),
        //RubericNumberCounter(count: rubericOne), // Function which return ruberic marks which can be increased or decreased
        rubOne,
        getDivider(), //function to return divider(line)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
              child: Text(
                '2. ', //Counter for ruberic number
                style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.w800,
                  // fontFamily: 'Times New Roman',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ),
            Text(
              'Knowledge', //Ruberic name variable which comes from parameters
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.w800,
                // fontFamily: 'Times New Roman',
                letterSpacing: 0.5,
                fontSize: 25,
              ),
            ),
          ],
        ),
        //RubericNumberCounter(count: rubericTwo), // Function which return ruberic marks which can be increased or decreased
        rubTwo,
        getDivider(), //function to return divider(line)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
              child: Text(
                '3. ', //Counter for ruberic number
                style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.w800,
                  // fontFamily: 'Times New Roman',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ),
            Text(
              'Demo', //Ruberic name variable which comes from parameters
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.w800,
                // fontFamily: 'Times New Roman',
                letterSpacing: 0.5,
                fontSize: 25,
              ),
            ),
          ],
        ),
        //RubericNumberCounter(count: rubericThree), // Function which return ruberic marks which can be increased or decreased
        rubThree,
        getDivider(), //function to return divider(line)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
              child: Text(
                '4. ', //Counter for ruberic number
                style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.w800,
                  // fontFamily: 'Times New Roman',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),
              ),
            ),
            Text(
              'Report', //Ruberic name variable which comes from parameters
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.w800,
                // fontFamily: 'Times New Roman',
                letterSpacing: 0.5,
                fontSize: 25,
              ),
            ),
          ],
        ),
        //RubericNumberCounter(count: rubericFour), // Function which return ruberic marks which can be increased or decreased
        rubFour,
        getDivider(), //function to return divider(line)
        Row(
          // Row for Buttons (cancel or done)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0, top: 2),
              child: SizedBox(
                height: 35,
                width: 80,
                child: RaisedButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 20),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue.shade100)),
                  onPressed: () {
                    Navigator.pop(context);
                  }, //put cancel button functionality here
                  color: Colors.blue.shade100,
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  splashColor: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: SizedBox(
                height: 35,
                width: 80,
                child: RaisedButton(
                  child: const Text(
                    "Done",
                    style: TextStyle(fontSize: 20),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey.shade300)),
                  onPressed: () async {
                    await put(Uri.parse("http://$server/api/v1/lab/"),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, dynamic>{
                          'implementation' : rubOne.count,
                          'demo' : rubTwo.count,
                          'knowledge' : rubThree.count,
                          'report' : rubFour.count,
                          'fsc_id' : facultyId + studentId + courseId + 'Spring 2022',
                          'lab_number' : labNumber,
                        }),
                    );
                    Navigator.pop(context);
                  }, //put done button functionality here
                  color: Colors.blue.shade100,
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  splashColor: Colors.grey,
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

//function to get divider
Widget getDivider() {
  return const Padding(
    padding: EdgeInsets.all(0.0),
    child: Divider(
      color: Colors.black,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    ),
  );
}
