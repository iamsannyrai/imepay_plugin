import 'package:flutter/material.dart';
import 'package:imepay/imepay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Imepay _imepay;
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
              _imepay = Imepay(
                merchantInfo: _merchantInfo,
                amount: '200.0',
                referenceId: 'hello world',
                environment: ImepayEnvironment.test,
              );
              var response = await _imepay.makePayment();
              print('Response is $response');
            },
          ),
        ),
      ),
    );
  }
}
