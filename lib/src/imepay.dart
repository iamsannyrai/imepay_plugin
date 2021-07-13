import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:imepay/src/merchant_info.dart';

import 'imepay_enum.dart';

class Imepay {
  static const MethodChannel _channel = const MethodChannel('imepay_plugin');

  final String _amount, _referenceId;
  final MerchantInfo _merchantInfo;
  final ImepayEnvironment _environment;

  Imepay(
      {@required MerchantInfo merchantInfo,
      String amount,
      String referenceId,
      ImepayEnvironment environment = ImepayEnvironment.test})
      : assert(merchantInfo != null),
        assert(amount != null),
        assert(referenceId != null),
        assert(environment != null),
        _merchantInfo = merchantInfo,
        _amount = amount,
        _referenceId = referenceId,
        _environment = environment;

  Future<dynamic> makePayment() async {
    try {
      Map<String, String> merchantInfo = {
        "merchantCode": _merchantInfo.code,
        "merchantName": _merchantInfo.name,
        "recordingUrl": _merchantInfo.recordingUrl,
        "module": _merchantInfo.module,
        "username": _merchantInfo.username,
        "password": _merchantInfo.password,
        "environment": describeEnum(_environment),
        "referenceId":_referenceId,
      };

      Map<String, dynamic> paymentInfo = {
        "amount": _amount,
        "referenceId": _referenceId,
      };
      var paymentResponse = await _channel
          .invokeMethod('payWithIME', [merchantInfo, paymentInfo]);

      print('payment response is $paymentResponse');

      return paymentResponse;
    } on PlatformException catch (e) {
      throw e;
    }
  }
}
