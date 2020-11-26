import 'package:meta/meta.dart';

/// These information will be provided by IMEPay
@immutable
class MerchantInfo {
  final String code;
  final String name;
  final String recordingUrl;
  final String module;
  final String username;
  final String password;

  MerchantInfo(
      {@required this.code,
      @required this.name,
      @required this.recordingUrl,
      @required this.module,
      @required this.username,
      @required this.password});

  @override
  String toString() =>
      "code:$code, name:$name, recordingUrl: $recordingUrl, module:$module, username:$username, password:$password";
}
