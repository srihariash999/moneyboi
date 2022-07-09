import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Blocs/ForgotPasswordBloc/forgotpassword_bloc.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Constants/box_names.dart';
import 'package:moneyboi/Controllers/chart_screen_controller.dart';
import 'package:moneyboi/Controllers/hive_controller.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Controllers/login_controller.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Controllers/repayment_single_controller.dart';
import 'package:moneyboi/Controllers/repayments_main_controller.dart';
import 'package:moneyboi/Screens/home/home_page.dart';
import 'package:moneyboi/Screens/login/login_page.dart';
import 'package:moneyboi/Theme/dark_theme.dart';
import 'package:moneyboi/Theme/light_theme.dart';
import 'package:moneyboi/Theme/theme_controller.dart';
import 'package:moneyboi/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox(authBoxName);
  await Hive.openBox(generalBoxName);
  await Hive.openBox<bool>(themeBoxName);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    // var _fcm = FirebaseMessaging.onMessage;

    // _fcm.listen((event) {
    //   print(" event: $event");
    // });

    Get.put<HiveService>(HiveService());
    Get.put<ThemeController>(ThemeController()..onInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Box _authBox = Hive.box(authBoxName);
    final _token = _authBox.get('token');

    final _themeController = Get.find<ThemeController>();

    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<HomeScreenController>(
      () => HomeScreenController(),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
    Get.lazyPut<ChartScreenController>(
      () => ChartScreenController(),
      fenix: true,
    );
    Get.lazyPut<RepaymentsMainController>(
      () => RepaymentsMainController(),
      fenix: true,
    );

    Get.lazyPut<RepaymentsSingleController>(
      () => RepaymentsSingleController(),
      fenix: true,
    );

    return GetBuilder<ThemeController>(
      builder: (context) {
        debugPrint("token : $_token");
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MoneyBoi',
          builder: BotToastInit(),
          theme: _themeController.currentTheme.value ? lightTheme : darkTheme,
          navigatorObservers: [BotToastNavigatorObserver()],
          home: MultiBlocProvider(
            providers: [
              BlocProvider<SignupBloc>(
                create: (context) => SignupBloc(),
              ),
              BlocProvider<ForgotPasswordBloc>(
                create: (context) {
                  return ForgotPasswordBloc();
                },
              ),
            ],
            child: _token != null ? const HomePage() : LoginPage(),
            // child: GetBuilder<ThemeController>(
            //   builder: (context) {
            //     if (_token != null) return const HomePage();
            //     return LoginPage();
            //   },
            // ),
          ),
        );
      },
    );
  }
}
