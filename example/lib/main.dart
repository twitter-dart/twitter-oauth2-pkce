import 'package:example/scope.dart';
import 'package:example/twitter_oauth2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Example()));
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String? _bearerToken;
  String? _refreshToken;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$_bearerToken'),
              Text('$_refreshToken'),
              ElevatedButton(
                onPressed: () async {
                  final oauth2 = TwitterOAuth2(
                    clientId: 'YOUR_CLIENT_ID',
                    clientSecret: 'YOUR_CLIENT_SECRET',
                    redirectUri: 'org.example.android.oauth://callback/',
                    customUriScheme: 'org.example.android.oauth',
                  );

                  final response = await oauth2.executeAuthCodeFlowWithPKCE(
                    scopes: Scope.values,
                  );

                  super.setState(() {
                    _bearerToken = response.accessToken;
                    _refreshToken = response.refreshToken;
                  });
                },
                child: const Text('Push!'),
              )
            ],
          ),
        ),
      );
}
