import 'package:bus_app/screens/admin/students/add_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:bus_app/app/theme/app_theme.dart';
import 'package:bus_app/screens/onboarding/owner_info_page.dart';
import 'package:bus_app/screens/auth/admin_login.dart';
import 'package:bus_app/screens/auth/login_selection.dart';
import 'package:bus_app/screens/auth/parent_otp_login.dart';
import 'package:bus_app/screens/admin/dashboard.dart';
import 'package:bus_app/screens/parent/parent_home.dart';
import 'package:bus_app/screens/admin/students/student_list.dart';
import 'package:bus_app/screens/admin/students/student_details.dart';
import 'package:bus_app/screens/admin/students/add_student.dart';
import 'package:bus_app/screens/admin/students/edit_student.dart';



class AppRoutes {
  // -------- Route Names --------
  static const String ownerInfo = '/owner-info';
  static const String loginSelection = '/login-selection';
  static const String adminLogin = '/admin-login';
  static const String parentOtpLogin = '/parent-otp-login';
  static const String adminDashboard = '/admin-dashboard';
  static const String settings = '/settings';
  static const String parentHome = '/parent-home';
  static const String addStudent = '/add-student';
  static const String studentDetails = '/student-details';
  static const String studentList = '/student-list';
  static const String editStudent = '/edit-student';


  




  // -------- Route Map --------
  static Map<String, WidgetBuilder> routes = {
    ownerInfo: (context) => const OwnerInfoPage(),
    loginSelection: (context) => const LoginSelectionPage(),
    adminLogin: (context) => const AdminLoginPage(),
    // parentOtpLogin: (context) => const ParentOtpLoginPage(),
    // parentHome: (context) => const ParentHomePage(),
    adminDashboard: (context) => const AdminDashboard(),
    // settings: (context ) => const Settings(),
    parentHome: (context) => const ParentHomePage(),
    addStudent: (context) => const AddStudentPage(), // Replace with AddStudentPage when implemented
    studentList: (context) => const StudentListPage(),
    studentDetails: (context) => const StudentDetailsPage(),
    editStudent: (context) => const EditStudentPage(),



  };
}
