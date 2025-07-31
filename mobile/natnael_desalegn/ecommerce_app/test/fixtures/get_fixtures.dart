import 'dart:io';

String getFixture(String fileName) => File('test/fixtures/$fileName').readAsStringSync();