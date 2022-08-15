import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/Modules/screen_elements.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

class StudentMain extends StatefulWidget {
  const StudentMain({Key? key}) : super(key: key);

  @override
  _StudentMainState createState() => _StudentMainState();
}

class _StudentMainState extends State<StudentMain> {
  //String server = "localhost:5000";
  //String server = "pesbuic.herokuapp.com";
  String server = "projectandlabevaluation.herokuapp.com";
  String dropdownValue = 'Spring 2022';
  List<Map> marks = <Map>[];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    List<Map> data = <Map>[];
    final user = Provider.of<User?>(context);
    List<int> projectIds = <int>[];
    List<String> projectNames = <String>[];
    List<bool> projectStatus = <bool>[];
    List<String> projectCourse = <String>[];
    List<String> allSemesters = <String>[];
    List<String> ids = <String>[];
    List<String> names = <String>[];
    List<Map> faculty = <Map>[];
    List<Map> courses = <Map>[];
    List<Map> student = <Map>[];

    void processData()
    {
      for (var element in data) {
        if(!projectIds.contains(element['project_id'])) {
          projectIds.add(element['project_id']);
          projectNames.add(element['project_name']);
          projectStatus.add(element['status']);
          projectCourse.add(element['course_name']);
        }
      }
    }

    double getWidth()
    {
      if(width<1250) {
        return 1250;
      } else {
        return width;
      }
    }

    Future<void> getAllCourses() async {
      courses = <Map>[];
      faculty = <Map>[];
      student = <Map>[];
      Response response = await get(Uri.parse("http://$server/api/v1/faculty/"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      for (String element in allData) {
        faculty.add(jsonDecode("$element}"));
      }
      response = await get(Uri.parse("http://$server/api/v1/courses/"));
      res = response.body.substring(1,response.body.length-2);
      allData = res.split('},');
      //print(allData);
      for (String element in allData) {
        courses.add(jsonDecode("$element}"));
      }
      response = await get(Uri.parse("http://$server/api/v1/students/"));
      res = response.body.substring(1,response.body.length-2);
      allData = res.split('},');
      //print(allData);
      for (String element in allData) {
        student.add(jsonDecode("$element}"));
      }
      Map map = {
        'course_name': "Select Course",
      };
      courses.add(map);
      map = {
        'faculty_name': "Select Faculty",
      };
      faculty.add(map);
      map = {
        'student_id': "Select Student",
      };
      student.add(map);
      List<String> arr =  user!.email!.split("@");
      String id = arr.first;
      //id = "01-131192-032";
      response = await get(Uri.parse("http://$server/api/v1/fsc/student/$id"));
      res = response.body.substring(1,response.body.length-2);
      List<String> temp = res.split('},');
      List<Map> semesters = <Map>[];
      int i = 0;
      allSemesters = <String>[];
      for (String element in temp) {
        semesters.add(jsonDecode("$element}"));
        allSemesters.add(semesters[i]['semester']);
        i++;
      }
      if(!allSemesters.contains('Spring 2022')) {
        allSemesters.add('Spring 2022');
      }
      response = await get(Uri.parse("http://$server/api/v1/projects/data/$id/$dropdownValue"));
      res = response.body.substring(1,response.body.length-2);
      allData = res.split('},');
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
      processData();
    }

    Future<void> getMarks(int projectId) async {
      marks = <Map>[];
      for(int i = 0; i < ids.length; i++) {
        Response response = await get(Uri.parse("http://$server/api/v1/group/${ids[i]}/$projectId"));
        print(response.body);
        String res = response.body.substring(1,response.body.length-1);
        marks.add(jsonDecode(res));
      }
    }

    /*Widget leftSideMenu()
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
                    "semester": 'Spring 2022',
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
                    "semester": 'Spring 2022',
                  });
                },
                child: const SizedBox(
                  width: 400,
                  child: Text('Go to LES',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,)
                  ),
                ),
              ),
            ]
        ),
      );
    }*/

    Widget listViewBuilder() {
      return ListView.builder(
          itemCount: projectIds.length,
          itemBuilder: (context, index) {
            String status;
            Color color;
            if(projectStatus[index]) {
              status = "Approved";
              color = Colors.lightGreen.shade300;
            }
            else {
              status = "Pending";
              color = Colors.red.shade300;
            }
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: projectStatus[index] ? Colors.lightGreen.shade400 : Colors.red.shade400),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0,10),
                            blurRadius: 4
                        )]
                  ),
                  //color: color,
                  child: SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            onLongPress: () async {
                              names = <String>[];
                              ids = <String>[];
                              for(int i = 0; i < data.length; i++) {
                                if(data[i]['project_id'] == projectIds[index]) {
                                  names.add(data[i]['student_name']);
                                  ids.add(data[i]['student_id']);
                                  await getMarks(data[i]['project_id']);
                                }
                              }
                              await showAlert(context, names, ids);
                            },
                            onTap: () async{
                              if(projectStatus[index]) {
                                await Navigator.pushNamed(
                                    context, '/projectMeetings', arguments: {
                                  'projectName': projectNames[index],
                                  'projectId': projectIds[index],
                                });
                                setState(() {

                                });
                              }
                            },
                            title: SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 255,
                                    child: Text(
                                      projectNames[index],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox.shrink(),),
                                  SizedBox(
                                    width: 190,
                                    child: Center(
                                      child: Text(
                                        projectCourse[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black87,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox.shrink(),),
                                  SizedBox(
                                    width: 230,
                                    child: ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (context, index2) {
                                          if(data[index2]['project_id'] == projectIds[index]) {
                                            return Text(
                                              '${data[index2]['student_name']}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          }
                                          else {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                    ),
                                  ),
                                  const Expanded(child: SizedBox.shrink(),),
                                  SizedBox(
                                    //height: 50,
                                    width: 150,
                                    child: FlatButton(
                                      shape: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0)),
                                      color: Colors.grey.shade400,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black87,
                                          ),
                                          Text(
                                            'Proposals',
                                            style: TextStyle(
                                              fontSize: 17,
                                              //fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await Navigator.pushNamed(context, '/facultyProposal', arguments: {
                                          'projectName': projectNames[index],
                                          'projectId' : projectIds[index],
                                        });
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        SizedBox(
                          width: 120,
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              //fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            );
          }
      );
    }

    Widget tableColumns() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            width: 255,
            child: Text(
              ' Project Name',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(child: SizedBox.shrink(),),
          SizedBox(
            width: 190,
            child: Center(
              child: Text(
                'Course Names',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(child: SizedBox.shrink(),),
          SizedBox(
            width: 230,
            child: Text(
              'Student Names',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: SizedBox.shrink(),),
          SizedBox(
            width: 150,
            child: Text(
              'Proposals',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 13,),
          SizedBox(
            width: 120,
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    Widget topStrip() {
      return Row(
        children: [
          SizedBox(
            height: height - 40,
            width: 300,
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                ' Projects',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
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
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen.shade600, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                color: Colors.lightGreen.shade400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end,
                  children: const [
                    Text(
                      'Add New Project',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Icon(
                      Icons.update,
                    ),
                  ],
                ),
                onPressed: () async {
//                  addNewProject(context);
                  addNewProject(context, faculty, courses, student);
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget dropDown() {
      processData();
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        width: 220,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SizedBox(
            height: 40,
            width: 200,
            child: DropdownButton2<String>(
              buttonDecoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              dropdownDecoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              dropdownWidth: 220,
              value: dropdownValue,
              icon: Expanded(
                child: Row(
                  children: const [
                    Expanded(child: SizedBox.shrink()),
                    Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30.0,),
                  ],
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              underline: Container(
                height: 1,
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
      );
    }

    String name = "error";
    if(user != null) {
      name = user.displayName!;
      return FutureBuilder(
        future: getAllCourses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ScreenElements.screenLayout(context: context, name: name, type: "student", topStrip: topStrip(), tableColumns: tableColumns(), listViewBuilder: listViewBuilder(), dropDown: dropDown(), popScope: false);
          }
          else {
            /*return const Center(
              child: CircularProgressIndicator(),
            );*/
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

  List<Tab> tabs (List<String> names)
  {
    List<Tab> widget = <Tab>[];
    for(int i = 0; i<names.length; i++) {
      Tab tab = Tab(
        icon: const Icon(
          Icons.person_rounded,
          color: Colors.black,
        ),
        child: Text(
          names[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      widget.add(tab);
    }
    return widget;
  }

  List<Widget> tabBarView (List<String> names)
  {
    List<Widget> widget = <Widget>[];
    int num = names.length;
    List<TextEditingController> list = <TextEditingController>[];
    for(int i = 0; i< num; i++) {
      list.add(TextEditingController(text: marks[i]['implementation'] != null ? marks[i]['implementation'].toString() : ''));
      list.add(TextEditingController(text: marks[i]['demo'] != null ? marks[i]['demo'].toString() : ''));
      list.add(TextEditingController(text: marks[i]['knowledge'] != null ? marks[i]['knowledge'].toString() : ''));
      list.add(TextEditingController(text: marks[i]['report'] != null ? marks[i]['report'].toString() : ''));
    }
    int j = 0;
    for(int i = 0; i<names.length; i++) {
      Widget wid = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 150,
                child: Text(
                  'Implementation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  enabled: false,
                  onEditingComplete: () {
                    marks[i]['implementation'] = int.parse(list[j].text);
                  },
                  controller: list[j++],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 150,
                child: Text(
                  'Demo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  enabled: false,
                  onEditingComplete: () {
                    marks[i]['demo'] = int.parse(list[j].text);
                  },
                  controller: list[j++],
                  keyboardType: TextInputType.number,

                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 150,
                child: Text(
                  'Knowledge',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  enabled: false,
                  onEditingComplete: () {
                    marks[i]['knowledge'] = int.parse(list[j].text);
                  },
                  controller: list[j++],
                  keyboardType: TextInputType.number,

                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 150,
                child: Text(
                  'Report',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  enabled: false,
                  onEditingComplete: () {
                    marks[i]['report'] = int.parse(list[j].text);
                  },
                  controller: list[j++],
                  keyboardType: TextInputType.number,

                ),
              ),
            ],
          ),
        ],
      );
      widget.add(wid);
    }
    return widget;
  }

  /*List<Widget> tabBarView (List<String> names)
  {
    List<Widget> widget = <Widget>[];
    for(int i = 0; i<names.length; i++) {
      Widget wid = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Implementation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  controller: TextEditingController(text: marks[i]['implementation'].toString()),
                  enabled: false,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Demo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  controller: TextEditingController(text: marks[i]['demo'].toString()),
                  enabled: false,
                  keyboardType: TextInputType.number,

                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Knowledge',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  controller: TextEditingController(text: marks[i]['knowledge'].toString()),
                  enabled: false,
                  keyboardType: TextInputType.number,

                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Report',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFormField(
                  controller: TextEditingController(text: marks[i]['report'].toString()),
                  enabled: false,
                  keyboardType: TextInputType.number,

                ),
              ),
            ],
          ),
        ],
      );
      widget.add(wid);
    }
    return widget;
  }*/

  Future<void> showAlert(BuildContext context, List<String> names, List<String> ids) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return DefaultTabController(
                length: ids.length,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),
                  backgroundColor: Colors.grey.shade300,
                  title: TabBar(
                    indicatorColor: Colors.grey.shade900,
                    tabs: tabs(names),
                  ),
                  content: SizedBox(
                    width: 700,
                    height: 350,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 700,
                          height: 300,
                          child: TabBarView(
                            children: tabBarView(names),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 700,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              color: Colors.grey.shade400,
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Okay',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
  Future<void> addNewProject(BuildContext context, List<Map> faculty, List<Map> courses, List<Map> student) async {
    TextEditingController ctr = TextEditingController();
    String studentValue1 = "Select Student";
    String studentValue2 = "Select Student";
    String studentValue3 = "Select Student";
    String courseValue = "Select Course";
    String facultyValue = "Select Faculty";
    bool check = false;
    for(int i = 0; i< faculty.length; i++) {
      if(faculty[i]['faculty_name'] == 'Select Faculty'){
        check = true;
      }
    }
    if(!check) {
      Map map = {
        'course_name': "Select Course",
      };
      courses.add(map);
      map = {
        'faculty_name': "Select Faculty",
      };
      faculty.add(map);
      map = {
        'student_id': "Select Student",
      };
      student.add(map);
    }
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                ),
                backgroundColor: Colors.grey.shade300,
                content: Container(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                  width: 700,
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
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
                        child: Row(
                          children: [
                            const Text(
                              'Project Name:  ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              width: 350,
                              child: TextFormField(
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                                cursorColor: Colors.black,
                                controller: ctr,
                                textAlignVertical: TextAlignVertical
                                    .center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .grey.shade200,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                                    ),
                                    hintText: 'Project Name',
                                    hintStyle: const TextStyle(
                                        color: Colors
                                            .black,
                                        fontSize: 20.0
                                    ),
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight
                                          .bold,
                                      color: Colors
                                          .white,
                                      fontSize: 35,
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Row(
                          children: [
                            const Padding(
                              padding: const EdgeInsets.only(right:57.0),
                              child:  Text(
                                'Course:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width:350,
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey.shade200,
                              child: DropdownButton2<String>(
                                buttonDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                value: courseValue,
                                icon: Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(child: SizedBox.shrink()),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30.0,),
                                    ],
                                  ),
                                ),
                                scrollbarAlwaysShow: true,
                                scrollbarThickness: 8,
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
                                    courseValue = newValue!;
                                  });
                                },
                                items: courses
                                    .map<DropdownMenuItem<String>>((Map value) {
                                  return DropdownMenuItem<String>(
                                    value: value['course_name'],
                                    child: Text(value['course_name']),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right:55.0),
                              child:  Text(
                                'Faculty:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width:350,
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey.shade200,
                              child: DropdownButton2<String>(
                                buttonDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                scrollbarAlwaysShow: true,
                                scrollbarThickness: 8,
                                value: facultyValue,
                                icon: Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(child: SizedBox.shrink()),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30.0,),
                                    ],
                                  ),
                                ),
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
                                    facultyValue = newValue!;
                                  });
                                },
                                items: faculty
                                    .map<DropdownMenuItem<String>>((Map value) {
                                  return DropdownMenuItem<String>(
                                    value: value['faculty_name'],
                                    child: Text(value['faculty_name']),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Row(
                          children: [
                            const Padding(
                              padding:  EdgeInsets.only(right:33.0),
                              child:  Text(
                                'Student 1:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width:350,
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey.shade200,
                              child: DropdownButton2<String>(
                                buttonDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownWidth: 350,
                                scrollbarAlwaysShow: true,
                                scrollbarThickness: 8,
                                value: studentValue1,
                                icon: Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(child: SizedBox.shrink()),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30.0,),
                                    ],
                                  ),
                                ),
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
                                    studentValue1 = newValue!;
                                  });
                                },
                                items: student
                                    .map<DropdownMenuItem<String>>((Map value) {
                                  return DropdownMenuItem<String>(
                                    value: value['student_id'],
                                    child: Text(value['student_id']),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right:33.0),
                              child: Text(
                                'Student 2:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(width:350,
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey.shade200,
                              child: DropdownButton2<String>(
                                buttonDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownWidth: 350,
                                scrollbarAlwaysShow: true,
                                scrollbarThickness: 8,
                                value: studentValue2,
                                icon: Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(child: SizedBox.shrink()),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30.0,),
                                    ],
                                  ),
                                ),
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
                                    studentValue2 = newValue!;
                                  });
                                },
                                items: student
                                    .map<DropdownMenuItem<String>>((Map value) {
                                  return DropdownMenuItem<String>(
                                    value: value['student_id'],
                                    child: Text(value['student_id']),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right:33.0),
                              child: Text(
                                'Student 3:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width:350,
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey.shade200,
                              child: DropdownButton2<String>(
                                buttonDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                dropdownWidth: 350,
                                scrollbarAlwaysShow: true,
                                scrollbarThickness: 8,
                                value: studentValue3,
                                icon: Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(child: SizedBox.shrink()),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30.0,),
                                    ],
                                  ),
                                ),
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
                                    studentValue3 = newValue!;
                                  });
                                },
                                items: student
                                    .map<DropdownMenuItem<String>>((Map value) {
                                  return DropdownMenuItem<String>(
                                    value: value['student_id'],
                                    child: Text(value['student_id']),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 700,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            color: Colors.grey,
                            shape: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.0)),
                            onPressed: () async {
                              if(ctr.text.isNotEmpty && studentValue1 != 'Select Student' && facultyValue != 'Select Faculty' && courseValue != 'Select Course') {
                                String courseId = " ";
                                String facultyId = " ";
                                for(int i = 0; i<faculty.length; i++) {
                                  if(faculty[i]['faculty_name'] == facultyValue) {
                                    facultyId = faculty[i]['faculty_id'];
                                  }
                                }
                                for(int i = 0; i<courses.length; i++) {
                                  if(courses[i]['course_name'] == courseValue) {
                                    courseId = courses[i]['course_id'];
                                  }
                                }
                                Response response  = await post(Uri.parse("http://$server/api/v1/projects/"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'project_name': ctr.text,
                                      'fsc_id': facultyId + studentValue1 + courseId + 'Spring 2022',
                                    })
                                );
                                print("Gsgsdg");
                                print(response.body);
                                Map map = jsonDecode(response.body);
                                int id = map['project_id'];
                                /*response = await post(Uri.parse("http://$server/api/v1/group/"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, dynamic>{
                                      'fsc_id': facultyId + courseId + studentValue1 + 'Spring 2022',
                                      'project_id' : id,
                                    })
                                );*/
                                if(studentValue2 != 'Select Student') {
                                  response = await post(Uri.parse("http://$server/api/v1/group/"),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, dynamic>{
                                        'fsc_id': facultyId + studentValue2 + courseId + 'Spring 2022',
                                        'project_id' : id,
                                      })
                                  );
                                }
                                if(studentValue3 != 'Select Student') {
                                  response = await post(Uri.parse("http://$server/api/v1/group/"),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, dynamic>{
                                        'fsc_id': facultyId + studentValue3 + courseId + 'Spring 2022',
                                        'project_id' : id,
                                      })
                                  );
                                }
                                super.setState(() {

                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Add New Project',
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
