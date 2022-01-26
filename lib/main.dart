import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Blocs/HomeScreenBloc/homescreen_bloc.dart';
import 'package:moneyboi/Blocs/LoginBloc/login_bloc.dart';
import 'package:moneyboi/Blocs/ProfileBloc/profile_bloc.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Screens/home_page.dart';
import 'package:moneyboi/Screens/login_page.dart';
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

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoneyBoi',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(),
            ),
            BlocProvider<SignupBloc>(
              create: (context) => SignupBloc(),
            ),
            BlocProvider<HomeScreenBloc>(create: (context) {
              return HomeScreenBloc();
            }),
            BlocProvider<ProfileBloc>(create: (context) {
              return ProfileBloc();
            }),
          ],
          child: MaterialApp(
            home: _token != null ? const HomePage() : LoginPage(),
          ),
        ));
  }
}
