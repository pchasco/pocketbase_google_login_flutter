import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Run pocketbase server with --http="YOUR-NON-LOOPBACK-IP:8090" so that your android device can reach the interface
const ip = "";
const redirectUri = "";
const clientId = "";
const callbackUrlScheme = "https";

void main() {
  final client = PocketBase("http://$ip:8090");

  GetIt.I.registerSingleton<PocketBase>(client);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? googleId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: const Text("Login"),
                onPressed: () async {
                  await doit(context);
                }),
            Text(googleId ?? "not signed in"),
          ],
        ),
      ),
    );
  }

  Future<void> doit(BuildContext context) async {
    final client = GetIt.I.get<PocketBase>();
    final authMethods = await client.users.listAuthMethods();
    final google = authMethods.authProviders.where((am) => am.name.toLowerCase() == "google").first;
    final responseUrl =
        await FlutterWebAuth.authenticate(url: "${google.authUrl}$redirectUri", callbackUrlScheme: callbackUrlScheme);

    final parsedUri = Uri.parse(responseUrl);
    final code = parsedUri.queryParameters['code']!;
    //final state = parsedUri.queryParameters['state']!;
    //if (google.state != state) {
    //  throw "oops";
    //}

    var result = await client.users.authViaOAuth2("google", code, google.codeVerifier, redirectUri);
    setState(() {
      googleId = result.user!.id;
    });
  }
}
