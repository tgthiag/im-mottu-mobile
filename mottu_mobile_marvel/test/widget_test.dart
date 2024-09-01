import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print('Error loading .env file: $e');
    }
  });

  test('Dotenv loads environment public variable', () {
    final apiKey = dotenv.env['MARVEL_PUBLIC_KEY'];
    expect(apiKey, isNotNull);
  });
  test('Dotenv loads environment private variables', () {
    final apiKey = dotenv.env['MARVEL_PRIVATE_KEY'];
    expect(apiKey, isNotNull);
  });
}
