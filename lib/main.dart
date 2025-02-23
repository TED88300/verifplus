import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/0-splashScreen.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

late CameraDescription firstCamera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DbTools.gTED = kDebugMode;
  Widget defaultHome = const SplashScreen();
  final cameras = await availableCameras();
  firstCamera = cameras.first;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'App',
    theme: ThemeData(
      useMaterial3: false,
      cardTheme: const CardTheme(
        surfaceTintColor: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFf6f6f6),
      primarySwatch: MaterialColor(
        gColors.primary.value,
        gColors.getSwatch(gColors.primary),
      ),
    ),


    localizationsDelegates: const [
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      MonthYearPickerLocalizations.delegate,
      FlutterQuillLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('fr', '')
    ],
    locale: const Locale('fr'),

    home: defaultHome,
  ));
}
