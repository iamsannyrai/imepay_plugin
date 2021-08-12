import 'dart:convert';

ImePaymentResponse imePaymentResponseFromJson(String str) =>
    ImePaymentResponse.fromJson(json.decode(str));

String imePaymentResponseToJson(ImePaymentResponse data) =>
    json.encode(data.toJson());

class ImePaymentResponse {
  ImePaymentResponse({
    this.amount,
    this.responseDescription,
    this.refId,
    this.msisdn,
    this.transactionId,
    this.responseCode,
  });

  final String amount;
  final String responseDescription;
  final String refId;
  final String msisdn;
  final String transactionId;
  final String responseCode;

  factory ImePaymentResponse.fromJson(Map<String, dynamic> json) =>
      ImePaymentResponse(
        amount: json["amount"],
        responseDescription: json["responseDescription"],
        refId: json["refId"],
        msisdn: json["msisdn"],
        transactionId: json["transactionId"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "responseDescription": responseDescription,
        "refId": refId,
        "msisdn": msisdn,
        "transactionId": transactionId,
        "responseCode": responseCode,
      };
}
