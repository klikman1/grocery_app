import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:techno_mobile/Pages/TestingPage.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';

import 'Provider/CartProvider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final myCameras = await availableCameras();
  runApp(MyApp(cameras: myCameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(create: (context) => ProductProvider())
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: TestingPage(cameras: cameras)
            // home: ContainerPage(),
          );
        });
  }
}
