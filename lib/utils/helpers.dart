String money(double value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < rounded.length; i++) {
    final position = rounded.length - i;
    buffer.write(rounded[i]);
    if (position > 1 && position % 3 == 1) buffer.write('.');
  }
  return '\$${buffer.toString()}';
}

int asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}

double asDouble(dynamic value, [double fallback = 0]) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value') ?? fallback;
}

String asString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = '$value';
  return text.isEmpty ? fallback : text;
}
