import 'package:easy_localization/easy_localization.dart';
import 'package:eskan/root/splash_screen/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(
    EasyLocalization(
      fallbackLocale: Locale('en'),
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      child: EskanApp(initialLink),
    ),
  );
}
