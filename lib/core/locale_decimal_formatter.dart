import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocaleDecimalFormatter extends TextInputFormatter {
  const LocaleDecimalFormatter(this.separator);

  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    final other = separator == ',' ? '.' : ',';

    if (text.contains(other)) {
      text = text.replaceAll(other, separator);
    }

    final buffer = StringBuffer();
    for (final char in text.characters) {
      if (char == separator || RegExp(r'\d').hasMatch(char)) {
        buffer.write(char);
      }
    }
    text = buffer.toString();

    final parts = text.split(separator);
    if (parts.length > 2) {
      text = parts.first + separator + parts.sublist(1).join();
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
