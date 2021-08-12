 
import Flutter
import UIKit
import IMEPay

public class SwiftFlutterImepayPlugin: NSObject, FlutterPlugin {


  public var channel:FlutterMethodChannel

  var manager: IMPPaymentManager?

  public init(channel:FlutterMethodChannel) {
     self.channel = channel
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "imepay_plugin", binaryMessenger: registrar.messenger())
    
    let instance = SwiftFlutterImepayPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     if call.method == "payWithIME" {
         guard let arguments = call.arguments as? [Any] else {
           return
         }
         let merchantInfo = arguments[0] as? [String:Any]
         let paymentInfo = arguments[1] as? [String:Any]

         //merchant detail
         let merchantCode = merchantInfo?["merchantCode"] as? String
         let merchantName = merchantInfo?["merchantName"] as? String
         let recordingUrl = merchantInfo?["recordingUrl"] as? String
         let module = merchantInfo?["module"] as? String
         let username = merchantInfo?["username"] as? String
         let password = merchantInfo?["password"] as? String
         let environment = merchantInfo?["environment"] as? String
         //payment detail
         let price = paymentInfo?["amount"] as? String
         let referenceId = paymentInfo?["referenceId"] as? String
        if environment == "live" {
            manager = IMPPaymentManager(environment: Live)
        } else {
            manager = IMPPaymentManager(environment: Test)
        }


        manager?.pay(withUsername: username , password: password, merchantCode: merchantCode, merchantName: merchantName, merchantUrl: recordingUrl, amount: price, referenceId: referenceId, module: module, success: { [self] (transactionInfo) in
            var paymentResponse: [String: String] = [:]
            if transactionInfo!.responseCode == 100{
                 paymentResponse["responseCode"] = String(100)
                paymentResponse["responseDescription"] = transactionInfo?.responseDescription
                 paymentResponse["transactionId"] = transactionInfo?.transactionId
                 paymentResponse["msisdn"] = transactionInfo?.customerMsisdn
                 paymentResponse["amount"] = transactionInfo?.amount
                 paymentResponse["refId"] = transactionInfo?.referenceId

                 channel.invokeMethod("onSuccess", arguments: paymentResponse)

            } else if transactionInfo?.responseCode == 101 {
                 paymentResponse["responseCode"] = String(101)
                 paymentResponse["refId"] = transactionInfo?.referenceId
                 paymentResponse["responseDescription"] = "Transaction Failed"
                 channel.invokeMethod("onFailure", arguments: paymentResponse)
             }
         }, failure: { (transactionInfo, errorMessage) in
            var paymentResponse: [String: String] = [:]
             paymentResponse["refId"] = transactionInfo?.referenceId
             paymentResponse["responseDescription"] = errorMessage
            self.channel.invokeMethod("onFailure", arguments: paymentResponse)
         })
     }
  }
}
