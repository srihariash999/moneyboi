import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Blocs/ForgotPasswordBloc/forgotpassword_bloc.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Controllers/chart_screen_controller.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Controllers/login_controller.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Controllers/repayment_single_controller.dart';
import 'package:moneyboi/Controllers/repayments_main_controller.dart';
import 'package:moneyboi/Screens/home/home_page.dart';
import 'package:moneyboi/Screens/login/login_page.dart';
import 'package:path_provider/path_provider.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('authBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Box _authBox = Hive.box('authBox');
    final _token = _authBox.get('token');

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyBoi',
      builder: BotToastInit(),
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
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: _token != null ? const HomePage() : LoginPage(),
        ),
      ),
    );
  }
}
