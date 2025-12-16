import 'package:telephony/telephony.dart';
import 'sms_parser.dart';

class SmsService {
  final Telephony _telephony = Telephony.instance;
  Future<void> start() async {
    final granted = await _telephony.requestPhoneAndSmsPermissions ?? false;
    if (!granted) return;
    _telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        final body = message.body ?? '';
        final parsed = SmsParser.parse(body);
        if (parsed != null) {
          final sign = parsed.isCredit ? '+' : '-';
          final amt = parsed.amount.toStringAsFixed(2);
          print('SMS_TXN $sign$amt ${parsed.category} ${parsed.merchant}');
        }
      },
      listenInBackground: false,
    );
  }
}
