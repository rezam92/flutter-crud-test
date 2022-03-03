import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_crud_test/application/extension/string.dart';

void main() {
  group('string extension', () {
    test(
      'check valid email',
      () async {
        var isValid = 'test@test.com'.isValidEmail;
        expect(isValid, true);
        isValid = 'test@tesom'.isValidEmail;
        expect(isValid, false);
      },
    );

    test(
      'check string length',
      () async {

        var isValid =  'AmirReza'.isValidString();
        expect(isValid, true);

        isValid = '@mirReza'.isValidString();
        expect(isValid, false);

        isValid = 'MohammadReza'.isValidString(maxLength: 5);
        expect(isValid, false);

        isValid = 'A'.isValidString(minLength: 3);
        expect(isValid, false);
      },
    );
  });
}
