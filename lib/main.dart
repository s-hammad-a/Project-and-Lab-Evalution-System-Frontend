import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_evaluation_system/LES/AllStudentsMarksList.dart';
import 'package:project_evaluation_system/LES/home.dart';
import 'package:project_evaluation_system/LES/all_labs.dart';
import 'package:project_evaluation_system/screens/LoadingPage.dart';
import 'package:project_evaluation_system/screens/all_projects.dart';
import 'package:project_evaluation_system/screens/faculty_main.dart';
import 'package:project_evaluation_system/screens/faculty_proposals.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:project_evaluation_system/screens/project_meetings.dart';
import 'package:project_evaluation_system/screens/student_main.dart';
import 'package:project_evaluation_system/services/auth.dart';
import 'package:project_evaluation_system/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return  StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, err) => null,
      child: MaterialApp(
        home: const Wrapper(),
        //initialRoute: '/facultyLogin',
        routes: {
          '/facultyMain': (context) => const FacultyMain(),
          '/facultyProposal': (context) => const FacultyProposals(),
          '/allProject': (context) => const AllProjects(),
          '/projectMeetings': (context) => const ProjectMeetings(),
          '/landingPage': (context) => const LandingPage(),
          '/wrapper': (context) => const Wrapper(),
          '/loading': (context) => const LoadingPage(),
          '/markList': (context) => const AllStudentsMarksList(),
          '/lesHome': (context) => const Home(),
          '/allLabs': (context) => const AllLabs(),
          '/studentMain': (context) => const StudentMain(),
        },
      ),
    );
  }
}



/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    StorageManager sm = StorageManager();
    return  FutureBuilder(
      future: sm.uploadFile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //sm.uploadFile();
          return Container();
      },
    );
  }
}*/