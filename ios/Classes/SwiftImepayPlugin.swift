import Flutter
import UIKit

public class SwiftImepayPlugin: NSObject, FlutterPlugin {

  public var channel:FlutterMethodChannel

  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "imepay", binaryMessenger: registrar.messenger())
    let instance = SwiftImepayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "payWithIME" {
        let arguments = call.arguments
        let merchantInfo = arguments[0] as? [Any:Any]
        let paymentInfo = arguments[1] as? [Any:Any]

        //merchant detail
        let merchantCode = merchantInfo["merchantCode"] as? String
        let merchantName = merchantInfo["merchantName"] as? String
        let recordingUrl = merchantInfo["recordingUrl"] as? String
        let module = merchantInfo["module"] as? String
        let username = merchantInfo["username"] as? String
        let password = merchantInfo["password"] as? String
        let environment = merchantInfo["environment"] as? String
        //payment detail
        let price = paymentInfo["amount"] as? String
        let referenceId = paymentInfo["referenceId"] as? String

        var manager: IMPPaymentManager

        if environment == "live" {
            manager = IMPPaymentManager(environment: Live)
        } else {
            manager = IMPPaymentManager(environment: Test)
        }

        manager?.pay(withUsername: username , password: password, merchantCode: merchantCode, merchantName: merchantName, merchantUrl: recordingUrl, deliveryUrl: "", amount: price, referenceId: referenceId, module: module, success: { (transactionInfo) in
            let paymentResponse: [String: String] = [:]
            if transactionInfo.responseCode == 100{
                paymentResponse["responseCode"] = String(100)
                paymentResponse["responseDescription"] = transactionInfo.responseDescription
                paymentResponse["transactionId"] = transactionInfo.transactionId
                paymentResponse["msisdn"] = transactionInfo.customerMsisdn
                paymentResponse["amount"] = transactionInfo.amount
                paymentResponse["refId"] = transactionInfo.referenceId

                channel.invokeMethod("onSuccess", paymentResponse)

            } else if transactionInfo.responseCode == 101 {
                paymentResponse["responseCode"] = String(101)
                paymentResponse["refId"] = transactionInfo.referenceId
                paymentResponse["responseDescription"] = "Transaction Failed"
                channel.invokeMethod("onFailure", paymentResponse)
            }
        }, failure: { (transactionInfo, errorMessage) in
            let paymentResponse: [String: String] = [:]
            paymentResponse["refId"] = transactionInfo?.referenceId
            paymentResponse["responseDescription"] = errorMessage
            channel.invokeMethod("onFailure", paymentResponse)
        })
    }
  }
}
