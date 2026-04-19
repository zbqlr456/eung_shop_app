import 'package:flutter/services.dart';

class HangulJamoFormatter extends TextInputFormatter {
  const HangulJamoFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final composedText = composeHangulJamo(newValue.text);
    if (composedText == newValue.text) return newValue;

    return TextEditingValue(
      text: composedText,
      selection: TextSelection(
        baseOffset: _composeSelectionOffset(
          newValue.text,
          newValue.selection.baseOffset,
        ),
        extentOffset: _composeSelectionOffset(
          newValue.text,
          newValue.selection.extentOffset,
        ),
      ),
    );
  }
}

bool matchesHangulKeyword(String target, String keyword) {
  final compactKeyword = composeHangulJamo(
    keyword.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
  );
  final compactTarget = target.toLowerCase().replaceAll(RegExp(r'\s+'), '');

  if (compactKeyword.isEmpty) return true;
  if (compactTarget.contains(compactKeyword)) return true;
  if (hangulInitials(compactTarget).contains(compactKeyword)) return true;
  if (hangulCompatibilityJamo(compactTarget).contains(compactKeyword)) {
    return true;
  }

  return false;
}

int _composeSelectionOffset(String text, int offset) {
  if (offset < 0) return offset;
  if (offset > text.length) return composeHangulJamo(text).length;

  return composeHangulJamo(text.substring(0, offset)).length;
}

String composeHangulJamo(String value) {
  final buffer = StringBuffer();
  var index = 0;

  while (index < value.length) {
    final initialIndex = _initialConsonants.indexOf(value[index]);
    final hasVowelAfterInitial =
        initialIndex >= 0 &&
        index + 1 < value.length &&
        _vowels.contains(value[index + 1]);

    if (!hasVowelAfterInitial) {
      buffer.write(value[index]);
      index += 1;
      continue;
    }

    final vowelIndex = _vowels.indexOf(value[index + 1]);
    var finalIndex = 0;
    var step = 2;

    if (index + 2 < value.length) {
      final possibleFinal = _finalConsonants.indexOf(value[index + 2]);
      final isNextSyllableStart =
          index + 3 < value.length && _vowels.contains(value[index + 3]);

      if (possibleFinal > 0 && !isNextSyllableStart) {
        finalIndex = possibleFinal;
        step = 3;
      }
    }

    final syllableCode =
        _hangulBase +
        (initialIndex * _syllablesPerInitial) +
        (vowelIndex * _finalConsonants.length) +
        finalIndex;

    buffer.writeCharCode(syllableCode);
    index += step;
  }

  return buffer.toString();
}

String hangulInitials(String value) {
  final buffer = StringBuffer();

  for (final codeUnit in value.codeUnits) {
    final hangulIndex = codeUnit - _hangulBase;
    if (hangulIndex < 0 || hangulIndex > _hangulLast - _hangulBase) {
      buffer.writeCharCode(codeUnit);
      continue;
    }

    final initialIndex = hangulIndex ~/ _syllablesPerInitial;
    buffer.write(_initialConsonants[initialIndex]);
  }

  return buffer.toString();
}

String hangulCompatibilityJamo(String value) {
  final buffer = StringBuffer();

  for (final codeUnit in value.codeUnits) {
    final hangulIndex = codeUnit - _hangulBase;
    if (hangulIndex < 0 || hangulIndex > _hangulLast - _hangulBase) {
      buffer.writeCharCode(codeUnit);
      continue;
    }

    final initialIndex = hangulIndex ~/ _syllablesPerInitial;
    final vowelIndex =
        (hangulIndex % _syllablesPerInitial) ~/ _finalConsonants.length;
    final finalIndex = hangulIndex % _finalConsonants.length;

    buffer
      ..write(_initialConsonants[initialIndex])
      ..write(_vowels[vowelIndex])
      ..write(_finalConsonants[finalIndex]);
  }

  return buffer.toString();
}

const _hangulBase = 0xAC00;
const _hangulLast = 0xD7A3;
const _syllablesPerInitial = 21 * 28;

const _initialConsonants = [
  'ㄱ',
  'ㄲ',
  'ㄴ',
  'ㄷ',
  'ㄸ',
  'ㄹ',
  'ㅁ',
  'ㅂ',
  'ㅃ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅉ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ',
];

const _vowels = [
  'ㅏ',
  'ㅐ',
  'ㅑ',
  'ㅒ',
  'ㅓ',
  'ㅔ',
  'ㅕ',
  'ㅖ',
  'ㅗ',
  'ㅘ',
  'ㅙ',
  'ㅚ',
  'ㅛ',
  'ㅜ',
  'ㅝ',
  'ㅞ',
  'ㅟ',
  'ㅠ',
  'ㅡ',
  'ㅢ',
  'ㅣ',
];

const _finalConsonants = [
  '',
  'ㄱ',
  'ㄲ',
  'ㄳ',
  'ㄴ',
  'ㄵ',
  'ㄶ',
  'ㄷ',
  'ㄹ',
  'ㄺ',
  'ㄻ',
  'ㄼ',
  'ㄽ',
  'ㄾ',
  'ㄿ',
  'ㅀ',
  'ㅁ',
  'ㅂ',
  'ㅄ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ',
];
