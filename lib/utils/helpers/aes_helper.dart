import 'dart:convert';
import 'dart:typed_data';
import 'package:investnation/environment/index.dart';
import 'package:pointycastle/export.dart';

const keySize = 32; // 32 byte key for AES-256
const iterationCount = 2;

class AesHelper {
  static const cbcMode = 'CBC';
  static const cfbMode = 'CFB';

  static Uint8List deriveKey(dynamic password,
      {String salt = '',
      int iterationCount = iterationCount,
      int derivedKeyLength = keySize}) {
    if (password == null || password.isEmpty) {
      throw ArgumentError('password must not be empty');
    }

    if (password is String) {
      password = createUint8ListFromString(password);
    }

    Uint8List saltBytes = createUint8ListFromString(salt);
    Pbkdf2Parameters params =
        Pbkdf2Parameters(saltBytes, iterationCount, derivedKeyLength);
    KeyDerivator keyDerivator = PBKDF2KeyDerivator(HMac(SHA1Digest(), 64));
    keyDerivator.init(params);

    return keyDerivator.process(password);
  }

  static Uint8List pad(Uint8List src, int blockSize) {
    var pad = PKCS7Padding();
    pad.init(null);

    int padLength = blockSize - (src.length % blockSize);
    var out = Uint8List(src.length + padLength)..setAll(0, src);
    pad.addPadding(out, src.length);

    return out;
  }

  static Uint8List unpad(Uint8List src) {
    var pad = PKCS7Padding();
    pad.init(null);

    int padLength = pad.padCount(src);
    int len = src.length - padLength;

    return Uint8List(len)..setRange(0, len, src);
  }

  static String encrypt(String password, String plaintext,
      {String mode = cbcMode}) {
    String salt = toASCII(Environment.salt);
    Uint8List derivedKey = deriveKey(password, salt: salt);
    KeyParameter keyParam = KeyParameter(derivedKey);
    BlockCipher aes = AESFastEngine();

    var ivStr = toASCII(Environment.initialVector);
    Uint8List iv = createUint8ListFromString(ivStr);

    BlockCipher cipher;
    ParametersWithIV params = ParametersWithIV(keyParam, iv);
    switch (mode) {
      case cbcMode:
        cipher = CBCBlockCipher(aes);
        break;
      case cfbMode:
        cipher = CFBBlockCipher(aes, aes.blockSize);
        break;
      default:
        throw ArgumentError('incorrect value of the "mode" parameter');
    }
    cipher.init(true, params);

    Uint8List textBytes = createUint8ListFromString(plaintext);
    Uint8List paddedText = pad(textBytes, aes.blockSize);
    Uint8List cipherBytes = _processBlocks(cipher, paddedText);

    return base64.encode(cipherBytes);
  }

  static String decrypt(String password, String ciphertext,
      {String mode = cbcMode}) {
    String salt = toASCII(Environment.salt);
    Uint8List derivedKey = deriveKey(password, salt: salt);
    KeyParameter keyParam = KeyParameter(derivedKey);
    BlockCipher aes = AESFastEngine();

    var ivStr = toASCII(Environment.initialVector);
    Uint8List iv = createUint8ListFromString(ivStr);
    Uint8List cipherBytesFromEncode = base64.decode(ciphertext);

    Uint8List cipherIvBytes =
        Uint8List(cipherBytesFromEncode.length + iv.length)
          ..setAll(0, iv)
          ..setAll(iv.length, cipherBytesFromEncode);

    BlockCipher cipher;

    ParametersWithIV params = ParametersWithIV(keyParam, iv);
    switch (mode) {
      case cbcMode:
        cipher = CBCBlockCipher(aes);
        break;
      case cfbMode:
        cipher = CFBBlockCipher(aes, aes.blockSize);
        break;
      default:
        throw ArgumentError('incorrect value of the "mode" parameter');
    }
    cipher.init(false, params);

    int cipherLen = cipherIvBytes.length - aes.blockSize;
    Uint8List cipherBytes = Uint8List(cipherLen)
      ..setRange(0, cipherLen, cipherIvBytes, aes.blockSize);
    Uint8List paddedText = _processBlocks(cipher, cipherBytes);
    Uint8List textBytes = unpad(paddedText);

    return String.fromCharCodes(textBytes);
  }

  static Uint8List _processBlocks(BlockCipher cipher, Uint8List inp) {
    var out = Uint8List(inp.lengthInBytes);

    for (var offset = 0; offset < inp.lengthInBytes;) {
      var len = cipher.processBlock(inp, offset, out, offset);
      offset += len;
    }

    return out;
  }
}

Uint8List createUint8ListFromString(String s) {
  Uint8List ret = Uint8List.fromList(s.codeUnits);

  return ret;
}

String toUtf8(value) {
  var encoded = utf8.encode(value);
  var decoded = utf8.decode(encoded);
  return decoded;
}

String toASCII(value) {
  var encoded = ascii.encode(value);
  var decoded = ascii.decode(encoded);
  return decoded;
}
