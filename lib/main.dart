import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'auth_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _platformVersion = 'Unknown';
  final rowndPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();
    rowndPlugin.configure("key_rvykyqmv3pt3rfqqao0mq9xt");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(rowndPlugin),
      child: MaterialApp(
        title: 'Example App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state == AuthState.authenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state == AuthState.authenticated) {
                return MyHomePage();
              } else {
                return LoginPage();
              }
            },
          ),
        ),
        routes: {
          '/home': (context) => MyHomePage(),
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My example app'),
      ),
      body: Column(children: [
        Center(child: Text('Welcome to my example app!')),
        ElevatedButton(
            onPressed: () async {
              authCubit.signIn();
            },
            child: Text('Sign in')),
      ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<AuthCubit>();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My example app'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Column(children: [
          Center(child: Text('Welcome to my home page!')),
          ElevatedButton(
              onPressed: () async {
                authCubit.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text("Sign out")),
        ]),
      );
    });
  }
}
