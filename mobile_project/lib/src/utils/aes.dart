import 'package:encrypt/encrypt.dart';

class Aes {
  static String mtencrypt(String content) {
    final plainText = content;
    final key = Key.fromUtf8('2>+*&XE7m8X+d8J{');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String mtdecrypt(String content) {
    final key = Key.fromUtf8('2>+*&XE7m8X+d8J{');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(content, iv: iv);
    return decrypted;
  }
}
