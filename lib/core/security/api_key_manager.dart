import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 키 보안 관리자
class ApiKeyManager {
  static final ApiKeyManager _instance = ApiKeyManager._internal();
  factory ApiKeyManager() => _instance;
  ApiKeyManager._internal();

  static const String _keyPrefix = 'secure_api_';
  static const String _saltKey = 'api_salt_key';

  // 앱 고유 식별자 (실제 운영에서는 더 복잡한 값 사용)
  static const String _appSecret = 'mission100_2024_secure_key';

  /// API 키 암호화 저장
  Future<void> storeApiKey(String keyName, String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 솔트 생성 또는 가져오기
      final String salt = prefs.getString(_saltKey) ?? _generateSalt();
      if (!prefs.containsKey(_saltKey)) {
        await prefs.setString(_saltKey, salt);
      }

      // 키 암호화
      final encryptedKey = _encryptApiKey(apiKey, salt);

      // 암호화된 키 저장
      await prefs.setString('$_keyPrefix$keyName', encryptedKey);

      debugPrint('API 키 암호화 저장 완료: $keyName');
    } catch (e) {
      debugPrint('API 키 저장 실패: $e');
      rethrow;
    }
  }

  /// API 키 복호화 조회
  Future<String?> getApiKey(String keyName) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 솔트 가져오기
      final salt = prefs.getString(_saltKey);
      if (salt == null) {
        debugPrint('솔트가 없어서 API 키를 복호화할 수 없습니다');
        return null;
      }

      // 암호화된 키 가져오기
      final encryptedKey = prefs.getString('$_keyPrefix$keyName');
      if (encryptedKey == null) {
        debugPrint('API 키를 찾을 수 없습니다: $keyName');
        return null;
      }

      // 키 복호화
      final decryptedKey = _decryptApiKey(encryptedKey, salt);
      return decryptedKey;
    } catch (e) {
      debugPrint('API 키 조회 실패: $e');
      return null;
    }
  }

  /// 환경별 API 키 로드
  Future<Map<String, String>> loadEnvironmentKeys() async {
    final keys = <String, String>{};

    try {
      // 개발/테스트 환경에서는 assets에서 로드
      if (kDebugMode) {
        final configString =
            await rootBundle.loadString('assets/config/dev_config.json');
        final config = jsonDecode(configString) as Map<String, dynamic>;
        final apiKeys = config['api_keys'] as Map<String, dynamic>?;

        if (apiKeys != null) {
          for (final entry in apiKeys.entries) {
            keys[entry.key] = entry.value.toString();
          }
        }
      } else {
        // 운영 환경에서는 암호화된 키 사용
        final keyNames = [
          'firebase_api_key',
          'admob_app_id',
          'admob_banner_id',
          'admob_interstitial_id',
          'in_app_purchase_key',
        ];

        for (final keyName in keyNames) {
          final key = await getApiKey(keyName);
          if (key != null) {
            keys[keyName] = key;
          }
        }
      }
    } catch (e) {
      debugPrint('환경별 API 키 로드 실패: $e');
    }

    return keys;
  }

  /// API 키 유효성 검증
  bool validateApiKey(String keyName, String apiKey) {
    if (apiKey.isEmpty) {
      debugPrint('API 키가 비어있습니다: $keyName');
      return false;
    }

    // 키별 특정 형식 검증
    switch (keyName) {
      case 'firebase_api_key':
        return apiKey.startsWith('AIza') && apiKey.length == 39;
      case 'admob_app_id':
        return apiKey.startsWith('ca-app-pub-') && apiKey.contains('~');
      case 'admob_banner_id':
      case 'admob_interstitial_id':
        return apiKey.startsWith('ca-app-pub-') && apiKey.contains('/');
      default:
        return apiKey.length >= 10; // 최소 길이 검증
    }
  }

  /// 모든 API 키 삭제 (로그아웃 시 사용)
  Future<void> clearAllApiKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_keyPrefix) || key == _saltKey) {
          await prefs.remove(key);
        }
      }

      debugPrint('모든 API 키 삭제 완료');
    } catch (e) {
      debugPrint('API 키 삭제 실패: $e');
    }
  }

  /// API 키 암호화
  String _encryptApiKey(String apiKey, String salt) {
    // 간단한 XOR 암호화 (실제 운영에서는 AES 등 강력한 암호화 사용)
    final keyBytes = utf8.encode(apiKey);
    final saltBytes = utf8.encode(salt + _appSecret);
    final encryptedBytes = <int>[];

    for (int i = 0; i < keyBytes.length; i++) {
      encryptedBytes.add(keyBytes[i] ^ saltBytes[i % saltBytes.length]);
    }

    return base64Encode(encryptedBytes);
  }

  /// API 키 복호화
  String _decryptApiKey(String encryptedKey, String salt) {
    // XOR 복호화
    final encryptedBytes = base64Decode(encryptedKey);
    final saltBytes = utf8.encode(salt + _appSecret);
    final decryptedBytes = <int>[];

    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ saltBytes[i % saltBytes.length]);
    }

    return utf8.decode(decryptedBytes);
  }

  /// 랜덤 솔트 생성
  String _generateSalt() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = timestamp + _appSecret;
    final bytes = utf8.encode(random);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  /// API 키 로테이션 (주기적 변경)
  Future<void> rotateApiKeys() async {
    try {
      debugPrint('API 키 로테이션 시작...');

      // 기존 키들 백업
      final backupKeys = <String, String>{};
      final keyNames = [
        'firebase_api_key',
        'admob_app_id',
        'admob_banner_id',
        'admob_interstitial_id'
      ];

      for (final keyName in keyNames) {
        final key = await getApiKey(keyName);
        if (key != null) {
          backupKeys[keyName] = key;
        }
      }

      // 새로운 솔트로 재암호화
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_saltKey);

      for (final entry in backupKeys.entries) {
        await storeApiKey(entry.key, entry.value);
      }

      debugPrint('API 키 로테이션 완료');
    } catch (e) {
      debugPrint('API 키 로테이션 실패: $e');
    }
  }

  /// 키 무결성 검증
  Future<bool> verifyKeyIntegrity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final salt = prefs.getString(_saltKey);

      if (salt == null) {
        return false;
      }

      // 주요 키들이 복호화 가능한지 확인
      final testKeys = ['firebase_api_key', 'admob_app_id'];
      for (final keyName in testKeys) {
        final key = await getApiKey(keyName);
        if (key != null && !validateApiKey(keyName, key)) {
          debugPrint('키 무결성 검증 실패: $keyName');
          return false;
        }
      }

      return true;
    } catch (e) {
      debugPrint('키 무결성 검증 중 오류: $e');
      return false;
    }
  }
}

/// API 키 보안 설정
class ApiSecurityConfig {
  static const Duration keyRotationInterval = Duration(days: 30);
  static const int maxKeyAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);

  static bool get isDebugMode => kDebugMode;
  static bool get isReleaseMode => kReleaseMode;

  /// 환경별 보안 레벨
  static SecurityLevel get currentSecurityLevel {
    if (kDebugMode) {
      return SecurityLevel.development;
    } else if (kProfileMode) {
      return SecurityLevel.testing;
    } else {
      return SecurityLevel.production;
    }
  }
}

/// 보안 레벨 열거형
enum SecurityLevel {
  development,
  testing,
  production,
}
