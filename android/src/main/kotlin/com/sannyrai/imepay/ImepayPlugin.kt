package com.sannyrai.imepay

import android.app.Activity
import androidx.annotation.NonNull
import com.swifttechnology.imepaysdk.ENVIRONMENT
import com.swifttechnology.imepaysdk.IMEPayment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** ImepayPlugin */
public class ImepayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "imepay")
        channel.setMethodCallHandler(this)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "imepay")
            channel.setMethodCallHandler(ImepayPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "payWithIME" -> {
                val arguments = call.arguments as ArrayList<*>
                val merchantInfo = arguments.elementAt(0) as HashMap<*, *>
                val paymentInfo: HashMap<*, *> = arguments.elementAt(1) as HashMap<*, *>

                //merchant detail
                val merchantCode = merchantInfo["merchantCode"] as String
                val merchantName = merchantInfo["merchantName"] as String
                val recordingUrl = merchantInfo["recordingUrl"] as String
                val module = merchantInfo["module"] as String
                val username = merchantInfo["username"] as String
                val password = merchantInfo["password"] as String
                val environment = merchantInfo["environment"] as String
                //payment detail
                val price = paymentInfo["amount"] as String
                val referenceId = paymentInfo["referenceId"] as String

                val imePayment: IMEPayment

                imePayment = if (environment == "live") {
                    IMEPayment(activity, ENVIRONMENT.LIVE)
                } else {
                    IMEPayment(activity, ENVIRONMENT.TEST)
                }

                imePayment.performPayment(
                        merchantCode, merchantName, recordingUrl, price, referenceId, module, username, password
                ) { responseCode, responseDescription, transactionId, msisdn, amount, refId ->
                    val paymentResponse: HashMap<String, String> = HashMap()
                    when (responseCode) {
                        // Transaction was successfully executed and verified
                        100 -> {
                            paymentResponse["responseCode"] = "100"
                            paymentResponse["responseDescription"] = responseDescription!!
                            paymentResponse["transactionId"] = transactionId!!
                            paymentResponse["msisdn"] = msisdn!!
                            paymentResponse["amount"] = amount!!
                            paymentResponse["refId"] = refId!!
                        }
                        // Transaction request was successfully sent, but could not get verified. 
                        // The customer executing the payment will get an SMS for the confirmation.
                        101 -> {
                            paymentResponse["responseCode"] = "101"
                            paymentResponse["refId"] = refId!!
                        }
                    }
                    result.success(paymentResponse)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }

}
