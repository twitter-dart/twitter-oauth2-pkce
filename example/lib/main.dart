import 'package:example/scope.dart';
import 'package:example/twitter_oauth2_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final TwitterOAuth2 oauth2 = TwitterOAuth2(
                    redirectUri: 'org.example.android.oauth://callback/',
                    customUriScheme: 'org.example.android.oauth',
                  );

                  await oauth2.generateTokenWithPKCE(
                    clientId: 'YOUR_CLIENT_ID',
                    clientSecret: 'YOUR_CLIENT_SECRET',
                    scopes: Scope.values,
                  );
                },
                child: const Text('Push!'),
              )
            ],
          ),
        ),
      );
}
