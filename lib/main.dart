import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pack_app/providers/activity_level_provider.dart';
import 'package:pack_app/providers/app_localizations.dart';
import 'package:pack_app/providers/food_to_avoid_provider.dart';
import 'package:pack_app/providers/user_registration_provider.dart';
import 'package:pack_app/screens/Dashboard/nav_bar.dart';
import 'package:pack_app/services/language_selection.dart';
import 'package:pack_app/widgets/Animation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('userBox');
  await Hive.openBox('bannersBox');

  final isLoggedIn = await checkLoggedInStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()), // Add LocaleNotifier
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

Future<bool> checkLoggedInStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff124734)),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          locale: localeNotifier.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AE'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported, otherwise use the first locale
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          home: isLoggedIn ? BottomNavbar(selectedIndex: 0) : ImageSequenceAnimation(),
        );
      },
    );
  }
}
