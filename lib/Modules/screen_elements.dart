import 'package:flutter/material.dart';
import 'package:project_evaluation_system/services/auth.dart';

class ScreenElements
{
  static Widget screenTopStrip(BuildContext context, String name) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double getWidth()
    {
      if(width<1250) {
        return 1250;
      } else {
        return width;
      }
    }
    return Container(
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
                fontSize: 30,
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
                  child: TextButton(
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
                          ModalRoute.withName('/wrapper'));
                      Navigator.pushNamed(context, '/wrapper');
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget leftSideMenu(double height, Widget buttons) {
    return
      SizedBox(
        height: height - 40,
        width: 250,
        child: Container(
          color: const Color(-10395295),
          child: buttons,
        ),
      );
  }

  static Widget mobileLeftSideMenu(double height, Widget buttons) {
    return
      SizedBox(
        height: height - 40,
        width: 50,
        child: Container(
          color: const Color(-10395295),
          child: buttons,
        ),
      );
  }

  static Widget studentMenu(BuildContext context)
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
                Navigator.pushNamed(context, '/studentMain');
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
          ]
      ),
    );
  }
  static Widget facultyMenu(BuildContext context)
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
            FlatButton(
              height: 50,
              hoverColor: Colors.black54,
              shape: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
              ),
              //shape: const OutlineInputBorder(
              //borderSide: BorderSide(color: Colors.white, width: 1.0)),
              onPressed:() {
                Navigator.pushNamed(context, '/lesHome');
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
  }

  static Widget rightMenuContainer(BuildContext context, Widget topStrip, Widget tableColumns, Widget listViewBuilder, Widget dropDown) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    double getWidth()
    {
      if(width<1250) {
        return 1250;
      } else {
        return width;
      }
    }
    return SizedBox(
      height: height - 40,
      width: getWidth() - 250,
      child: Container(
        height: height - 40,
        width: getWidth() - 250,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 5, right: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                width: getWidth() - 250,
                //color: Colors.grey.shade200,
                child: topStrip
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5, right: 5, top: 5),
              child: Container(
                height: height - 117,
                width: getWidth() - 270,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  height: height - 120,
                  width: getWidth(),
                  child: Column(
                    children: [
                      dropDown,
                      const SizedBox(height: 5,),
                      SizedBox(
                        height: 40,
                        width: getWidth() - 270,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 40,
                              width: getWidth() - 270,
                              child: tableColumns
                          ),
                        ),
                      ),
                      const SizedBox(height: 3.0,),
                      SizedBox(
                        height: height - 210,
                        width: getWidth(),
                        child: listViewBuilder
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  static Widget screenLayout({required BuildContext context, required String name, required String type, required Widget topStrip, required Widget tableColumns, required Widget listViewBuilder, required Widget dropDown, required bool popScope}) {
    Size size = MediaQuery.of(context).size;
    Widget leftSide;
    if(type == "student") {
      leftSide = studentMenu(context);
    }
    else {
      leftSide = facultyMenu(context);
    }
    double height = size.height;
    double width = size.width;
    double getWidth()
    {
      if(width<1250) {
        return 1250;
      } else {
        return width;
      }
    }
    ScrollController scr = ScrollController();
    return WillPopScope(
      onWillPop: () async => popScope,
      child: Scaffold(
        body: Scrollbar(
          scrollbarOrientation: ScrollbarOrientation.bottom,
          controller: scr,
          isAlwaysShown: false,
          thickness: 10,
          child: SingleChildScrollView(
            controller: scr,
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.teal,
              child: Column(
                children: [
                  ScreenElements.screenTopStrip(context, name),
                  SizedBox(
                    height: height - 40,
                    width: getWidth(),
                    child: Row(
                      children: [
                        leftSideMenu(height, leftSide),
                        rightMenuContainer(context, topStrip, tableColumns, listViewBuilder, dropDown),
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

  Future<DateTime?> selectDate(BuildContext context, DateTime? now) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now ?? DateTime.now(),
        firstDate: now ?? DateTime.now(),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 10)
    );
    picked = picked!.add(const Duration(days: 1));
    return picked;
  }
}
