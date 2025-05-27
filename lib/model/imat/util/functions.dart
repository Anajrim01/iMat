import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

dbugPrint(message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

String normalizeString(String input) {
  if (input.isEmpty) return input;

  // Replace underscores with spaces
  String spaced = input.split('.').last.replaceAll('_', ' ');

  // Split into words, capitalize each one, and join with spaces
  List<String> words = spaced.toLowerCase().split(' ');
  words =
      words
          .map(
            (word) =>
                word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1)}'
                    : '',
          )
          .toList();

  return words.join(' ');
}

/// Saves a string value to SharedPreferences asynchronously
Future<bool> saveString(String key, String value) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    return true;
  } catch (e) {
    dbugPrint('Error saving string: $e');
    return false;
  }
}

/// Retrieves a string value from SharedPreferences asynchronously
Future<String?> getString(String key, {String? defaultValue}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  } catch (e) {
    dbugPrint('Error retrieving string: $e');
    return defaultValue;
  }
}

/// Removes a value from SharedPreferences asynchronously
Future<bool> removeValue(String key) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    return true;
  } catch (e) {
    dbugPrint('Error removing value: $e');
    return false;
  }
}

String formatCardNumber(String cardNumber) {
  // Formatera kortnumret för visning (t.ex. 1234 5678 9012 3456)
  return cardNumber
      .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ')
      .trim();
}

String? detectCardType(String cardNumber) {
  // En enkel metod för att upptäcka korttyp baserat på kortnummer
  final int cardNumberLength = cardNumber.replaceAll(' ', '').length;
  if (cardNumber.startsWith('4') &&
      (cardNumberLength == 13 || cardNumberLength == 16)) {
    return 'Visa';
  } else if (cardNumber.startsWith('5') && cardNumberLength == 16) {
    return 'Mastercard';
  } else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
    return 'American Express';
  }
  return null; // Okänd korttyp
}
