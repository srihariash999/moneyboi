import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneyboi/Constants/box_names.dart';
import 'package:moneyboi/Controllers/categories_controller.dart';
import 'package:moneyboi/Controllers/chart_screen_controller.dart';
import 'package:moneyboi/Controllers/forgot_password_controller.dart';
import 'package:moneyboi/Controllers/hive_controller.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Controllers/login_controller.dart';
import 'package:moneyboi/Controllers/previous_expenses_controller.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Controllers/repayment_single_controller.dart';
import 'package:moneyboi/Controllers/repayments_main_controller.dart';
import 'package:moneyboi/Controllers/signup_controller.dart';
import 'package:moneyboi/Screens/home/home_page.dart';
import 'package:moneyboi/Screens/login/login_page.dart';
import 'package:moneyboi/Theme/dark_theme.dart';
import 'package:moneyboi/Theme/light_theme.dart';
import 'package:moneyboi/Theme/theme_controller.dart';
import 'package:moneyboi/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
    Get.put<HiveService>(HiveService());
    Get.put<ThemeController>(ThemeController()..onInit());
    super.initState();
  }

  @override
  Widget build(BuildContext rootContext) {
    final Box _authBox = Hive.box(authBoxName);
    final _token = _authBox.get('token');

    Get.put<CategoriesController>(CategoriesController());

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

    Get.lazyPut<PreviousExpensesController>(
      () => PreviousExpensesController(),
      fenix: true,
    );

    Get.lazyPut<SignupController>(
      () => SignupController(),
      fenix: true,
    );

    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
      fenix: true,
    );

    return GetBuilder<ThemeController>(
      builder: (controller) {
        debugPrint("token : $_token");
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MoneyBoi',
          builder: BotToastInit(),
          theme: controller.currentTheme.value ? lightTheme : darkTheme,
          navigatorObservers: [BotToastNavigatorObserver()],
          home: _token != null ? const HomePage() : LoginPage(),
        );
      },
    );
  }
}
