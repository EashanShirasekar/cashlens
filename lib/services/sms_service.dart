import 'package:telephony/telephony.dart';
import 'package:flutter/foundation.dart';
import 'sms_parser.dart';

class SmsService {
  final Telephony _telephony = Telephony.instance;
  Future<void> start({void Function(ParsedTransaction)? onParsed}) async {
    final granted = await _telephony.requestPhoneAndSmsPermissions ?? false;
    if (!granted) return;
    _telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        final body = message.body ?? '';
        final parsed = SmsParser.parse(body);
        if (parsed != null) {
          final sign = parsed.isCredit ? '+' : '-';
          final amt = parsed.amount.toStringAsFixed(2);
          debugPrint('SMS_TXN $sign$amt ${parsed.category} ${parsed.merchant}');
          if (onParsed != null) {
            onParsed(parsed);
          }
        }
      },
      listenInBackground: false,
    );
  }
}
