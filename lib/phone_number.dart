import 'countries.dart';

class NumberTooLongException implements Exception {}

class NumberTooShortException implements Exception {}

class InvalidCharactersException implements Exception {}

class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;
  String countryFlag;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
    required this.countryFlag,
  });

  factory PhoneNumber.fromCompleteNumber({required String completeNumber , required String countryFlag}) {
    if (completeNumber == "") {
      return PhoneNumber(countryISOCode: "", countryCode: "", number: "" , countryFlag: "");
    }

    try {
      Country country = getCountry(completeNumber , countryFlag);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber.substring(1 + country.dialCode.length + country.regionCode.length);
      } else {
        number = completeNumber.substring(country.dialCode.length + country.regionCode.length);
      }
      return PhoneNumber(
          countryISOCode: country.code, countryCode: country.dialCode + country.regionCode, number: number, countryFlag: country.flag);
    } on InvalidCharactersException {
      rethrow;
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      return PhoneNumber(countryISOCode: "", countryCode: "", number: "", countryFlag: "");
    }
  }

  bool isValidNumber() {
    Country country = getCountry(completeNumber , countryFlag);
    if (number.length < country.minLength) {
      throw NumberTooShortException();
    }

    if (number.length > country.maxLength) {
      throw NumberTooLongException();
    }
    return true;
  }

  String get completeNumber {
    return countryCode + number;
  }

  static Country getCountry(String phoneNumber , String countryFlag) {
    if (phoneNumber == "") {
      throw NumberTooShortException();
    }

    final validPhoneNumber = RegExp(r'^[+0-9]*[0-9]*$');

    if (!validPhoneNumber.hasMatch(phoneNumber)) {
      throw InvalidCharactersException();
    }

    if (phoneNumber.startsWith('+')) {
      return countries
          .firstWhere((country) => phoneNumber.substring(1).startsWith(country.dialCode + country.regionCode) && country.flag == countryFlag);
    }
    return countries.firstWhere((country) => phoneNumber.startsWith(country.dialCode + country.regionCode) && country.flag == countryFlag);
  }

  @override
  String toString() => 'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}
