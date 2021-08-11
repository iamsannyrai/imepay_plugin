import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:imepay_flutter/src/merchant_info.dart';
import 'package:imepay_flutter/src/payment_response.dart';

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

  Future<void> makePayment({
    @required Function(ImePaymentResponse) onSuccess,
    @required Function(String) onFailure,
  }) async {
    try {
      Map<String, String> merchantInfo = {
        "merchantCode": _merchantInfo.code,
        "merchantName": _merchantInfo.name,
        "recordingUrl": _merchantInfo.recordingUrl,
        "module": _merchantInfo.module,
        "username": _merchantInfo.username,
        "password": _merchantInfo.password,
        "environment": describeEnum(_environment),
        "referenceId": _referenceId,
      };

      Map<String, dynamic> paymentInfo = {
        "amount": _amount,
        "referenceId": _referenceId,
      };
      _channel.invokeMethod('payWithIME', [merchantInfo, paymentInfo]);

      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case "onSuccess":
            final imePaymentResponse = ImePaymentResponse.fromJson(
                Map<String, dynamic>.from(call.arguments));
            onSuccess(imePaymentResponse);
            break;

          case "onFailure":
            onFailure(call.arguments);
            break;
        }
      });
    } on PlatformException catch (e) {
      throw e;
    }
  }
}
