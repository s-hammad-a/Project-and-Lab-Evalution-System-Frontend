import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_evaluation_system/Modules/screen_elements.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:provider/provider.dart';

class AllProjects extends StatefulWidget {
  const AllProjects({Key? key}) : super(key: key);

  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  List<Map> marks = <Map>[];
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if(args==null) {
      Navigator.popAndPushNamed(context, 'wrapper');
    }
    String course = args['courseID'];
    String semester = args['semester'];
    List<Map> data = <Map>[];
    final user = Provider.of<User?>(context);
    List<int> projectIds = <int>[];
    List<String> projectNames = <String>[];
    List<bool> projectStatus = <bool>[];
    List<String> ids = <String>[];

    void processData()
    {
      for (var element in data) {
        if(!projectIds.contains(element['project_id'])) {
          projectIds.add(element['project_id']);
          projectNames.add(element['project_name']);
          projectStatus.add(element['status']);
        }
      }
    }

    Future<void> getAllCourses() async {
      List<String> arr =  user!.email!.split("@");
      String id = arr.first;
      id = "asohail.buic";
      //id = 'adeel';
      //id ='joddat';
      Response response = await get(Uri.parse("http://pesbuic.herokuapp.com/api/v1/group/project/$id/$course/$semester"));
      String res = response.body.substring(1,response.body.length-2);
      List<String> allData = res.split('},');
      for (String element in allData) {
        data.add(jsonDecode("$element}"));
      }
    }

    Future<void> getMarks(int projectId) async {
      marks = <Map>[];
      for(int i = 0; i < ids.length; i++) {
        Response response = await get(Uri.parse("http://pesbuic.herokuapp.com/api/v1/group/${ids[i]}/$projectId"));
        String res = response.body.substring(1,response.body.length-1);
        //print("dsfsdfdsf$element}");
        marks.add(jsonDecode(res));
      }
    }

    Widget listViewBuilder() {
      return FutureBuilder(
        future: getAllCourses(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          processData();
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
                return  Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0,10),
                                blurRadius: 4
                            )]
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: ListTile(
                              onLongPress: () async {
                                List<String> names = <String>[];
                                ids = <String>[];
                                for(int i = 0; i < data.length; i++) {
                                  if(data[i]['project_id'] == projectIds[index]) {
                                    names.add(data[i]['student_name']);
                                    ids.add(data[i]['student_id']);
                                    await getMarks(data[i]['project_id']);
                                  }
                                }
                                await showAlert(context, names, ids, projectIds[index]);
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
                                height: 60,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        projectNames[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index2) {
                                            if(data[index2]['project_id'] == projectIds[index]) {
                                              return Text(
                                                '${data[index2]['student_name']}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
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
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: FlatButton(
                                        shape: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87, width: 1.0)),
                                        color: Colors.grey.shade300,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              'Proposals',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
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
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
          );
        },
      );
    }

    Widget tableColumns() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              '   Project Name',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '  Student Names',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '  Proposals',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '  Status',
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
      return const Text(
        ' Projects',
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      );
    }

    Widget leftSideMenu()
    {
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

    String name = "error";
    if(user != null) {
      name = user.displayName!;
      return ScreenElements.screenLayout(context: context, name: name, leftSide: leftSideMenu(), topStrip: topStrip(), tableColumns: tableColumns(), listViewBuilder: listViewBuilder(), dropDown: const SizedBox.shrink(), popScope: true);
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

  Map tabBarView (List<String> names)
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
    return {
      'widgets' : widget,
      'TEC' : list,
    };
  }

  Future<void> showAlert(BuildContext context, List<String> names, List<String> ids, int projectID) async {
    String value = 'Select a Complex Activity';
    List<String> complexActivities = <String>['Select a Complex Activity', 'Preamble', 'Range of Conflicting Requirements', 'Depth of analysis required', 'Depth of Knowledge required', 'Familiarity of Issues' , 'Extent of applicable codes'];
    Map map = tabBarView(names);
    List<Widget> widgets = map['widgets'];
    List<TextEditingController> list = map['TEC'];
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return DefaultTabController(
                length: ids.length,
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  backgroundColor: Colors.grey[600],
                  title: TabBar(
                    tabs: tabs(names),
                  ),
                  content: SizedBox(
                    width: 700,
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 700,
                          height: 290,
                          child: TabBarView(
                            children: widgets,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 700,
                          child: Row(
                            children: [
                              const Text(
                                'Complex Activity:  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 400,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 40,
                                      width: 400,
                                      child: DropdownButton<String>(
                                        value: value,
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
                                            value = newValue!;
                                          });
                                        },
                                        items: complexActivities
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
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            minWidth: 120,
                            color: Colors.deepPurple.shade700,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0))),
                            onPressed: () async {
                              print(projectID);
                              int j = 0;
                              for(int i = 0; i<list.length; i = i+4) {
                                print(ids[j]);
                                await put(
                                    Uri.parse(
                                        "http://pesbuic.herokuapp.com/api/v1/group/update/${ids[j++]}/$projectID"),
                                    headers: <String, String>{
                                      'Content-Type':
                                      'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, int>{
                                      'implementation': int.parse(list[i].text == 'null' ? '0' : list[i].text),
                                      'demo': int.parse(list[i+1].text == 'null' ? '0' : list[i+1].text),
                                      'knowledge': int.parse(list[i+2].text == 'null' ? '0' : list[i+2].text),
                                      'report': int.parse(list[i+3].text == 'null' ? '0' : list[i+3].text),
                                    }));
                              }
                              Navigator.pop(context);
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
                  ),
                ),
              );
            }
        )
    );
  }
}
