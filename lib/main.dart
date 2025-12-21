import 'package:flutter/material.dart';
import 'package:bus_app/app/theme/app_theme.dart';
import 'package:bus_app/screens/onboarding/owner_info_page.dart';
import 'package:bus_app/app/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(

        debugShowCheckedModeBanner: false,

        initialRoute: AppRoutes.ownerInfo,
        routes: AppRoutes.routes,

        theme: AppTheme.light(),
        
        home: const OwnerInfoPage(),
  );

  }
}