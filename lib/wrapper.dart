import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_evaluation_system/screens/faculty_main.dart';
import 'package:project_evaluation_system/screens/landing_page.dart';
import 'package:project_evaluation_system/screens/student_main.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
    const Wrapper({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final user = Provider.of<User?>(context);
        if(user == null) {
            return const LandingPage();
        }
        else if(user.email!.contains("student"))
        {
            return const StudentMain();
        }
        else {
            return const FacultyMain();
        }
    }
}
