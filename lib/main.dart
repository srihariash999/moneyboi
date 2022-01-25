import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyboi/Blocs/LoginBloc/login_bloc.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          ],
          child: MaterialApp(
            home: LoginPage(),
          ),
        ));
  }
}
