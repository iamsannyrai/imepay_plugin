import 'package:flutter/material.dart';
import 'package:flutter_imepay/flutter_imepay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterImepay _imepay;
  MerchantInfo _merchantInfo;

  @override
  void initState() {
    super.initState();

    _merchantInfo = MerchantInfo(
      code: 'JEEVEE',
      name: 'jeeveehealth',
      recordingUrl: 'https://devapi.jvtests.com/v1/payments/records',
      module: 'JEEVEE',
      username: 'Jeevee',
      password: 'IME1234',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ImePay'),
        ),
        body: Center(
          child: MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Pay with IME',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                _imepay = FlutterImepay(
                  merchantInfo: _merchantInfo,
                  amount: '200.0',
                  referenceId: 'hello world',
                  environment: ImepayEnvironment.test,
                );
                _imepay.makePayment(onSuccess: (response) {
                  print("success is $response");
                }, onFailure: (message) {
                  print("failure: $message");
                });
              } catch (e) {
                print(e);
              }
            },
          ),
        ),
      ),
    );
  }
}
