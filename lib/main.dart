import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:malikia_tv/pages/splash.dart';

import 'configs/size_config.dart';

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp( LayoutBuilder(
      builder: (context, constraints){

    return OrientationBuilder(builder: (context,orientation){
      SizeConfi().init(constraints, orientation);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Malikia TV',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          //const Locale('en'),

          Locale('fr')
        ],
        theme: ThemeData(
          primaryColor: Colors.blue[800],
          accentColor: Colors.blue,
          // Define the default font family.
          fontFamily: 'CeraPro',
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        home: SplashScreen(),
        builder: EasyLoading.init(),
      );
    });
  })

  );
}

