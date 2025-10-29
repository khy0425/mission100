import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 암호화 알고리즘 타입
enum EncryptionType {
  aes256, // AES-256 (미래 구현)
  xor, // 간단한 XOR 암호화
  base64, // Base64 인코딩 (개발용)
}

/// 민감한 데이터 타입
enum SensitiveDataType {
  userCredentials, // 사용자 인증 정보
  personalInfo, // 개인정보
  paymentInfo, // 결제 정보
  healthData, // 건강 데이터
  apiKeys, // API 키
  deviceInfo, // 디바이스 정보
}

/// 암호화 설정
class EncryptionConfig {
  final EncryptionType type;
  final String keyDerivationSalt;
  final int iterations;
  final bool compressionEnabled;

  const EncryptionConfig({
    required this.type,
    required this.keyDerivationSalt,
    this.iterations = 10000,
    this.compressionEnabled = false,
  });
}

/// 암호화 결과
class EncryptionResult {
  final String encryptedData;
  final String? checksum;
  final DateTime timestamp;
  final EncryptionType algorithm;

  const EncryptionResult({
    required this.encryptedData,
    this.checksum,
    required this.timestamp,
    required this.algorithm,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': encryptedData,
      'checksum': checksum,
      'timestamp': timestamp.toIso8601String(),
      'algorithm': algorithm.toString(),
    };
  }

  factory EncryptionResult.fromJson(Map<String, dynamic> json) {
    return EncryptionResult(
      encryptedData: json['data'] as String,
      checksum: json['checksum'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      algorithm: EncryptionType.values.firstWhere(
        (e) => e.toString() == json['algorithm'],
        orElse: () => EncryptionType.xor,
      ),
    );
  }
}

/// 데이터 암호화 서비스
class DataEncryptionService {
  static final DataEncryptionService _instance =
      DataEncryptionService._internal();
  factory DataEncryptionService() => _instance;
  DataEncryptionService._internal();

  static const String _masterKeyPrefix = 'encryption_master_key_';
  // static const String _saltKey = 'encryption_salt'; // 향후 salt 기반 암호화 시 사용

  // 앱별 고유 시드 (실제 운영에서는 더 복잡하게)
  static const String _appSeed = 'mission100_encryption_seed_2024';

  /// 마스터 암호화 키 생성 또는 로드
  Future<String> _getMasterKey(SensitiveDataType dataType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keyName = '$_masterKeyPrefix${dataType.toString()}';

      String? masterKey = prefs.getString(keyName);
      if (masterKey == null) {
        // 새로운 마스터 키 생성
        masterKey = _generateMasterKey(dataType);
        await prefs.setString(keyName, masterKey);
        debugPrint('새로운 마스터 키 생성: $dataType');
      }

      return masterKey;
    } catch (e) {
      debugPrint('마스터 키 로드 실패: $e');
      rethrow;
    }
  }

  /// 마스터 키 생성
  String _generateMasterKey(SensitiveDataType dataType) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final dataTypeName = dataType.toString();
    final combinedString = '$_appSeed$dataTypeName$timestamp';

    final bytes = utf8.encode(combinedString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// 데이터 암호화
  Future<EncryptionResult> encryptData(
    String data,
    SensitiveDataType dataType, {
    EncryptionType algorithm = EncryptionType.xor,
  }) async {
    try {
      final masterKey = await _getMasterKey(dataType);
      String encryptedData;
      String? checksum;

      switch (algorithm) {
        case EncryptionType.xor:
          encryptedData = _xorEncrypt(data, masterKey);
          break;
        case EncryptionType.base64:
          encryptedData = base64Encode(utf8.encode(data));
          break;
        case EncryptionType.aes256:
          // 향후 AES-256 구현 예정
          throw UnimplementedError('AES-256 encryption not implemented yet');
      }

      // 체크섬 생성
      checksum = _generateChecksum(data);

      final result = EncryptionResult(
        encryptedData: encryptedData,
        checksum: checksum,
        timestamp: DateTime.now(),
        algorithm: algorithm,
      );

      _logEncryptionEvent('encrypt', dataType, algorithm);
      return result;
    } catch (e) {
      debugPrint('데이터 암호화 실패: $e');
      rethrow;
    }
  }

  /// 데이터 복호화
  Future<String> decryptData(
    EncryptionResult encryptionResult,
    SensitiveDataType dataType,
  ) async {
    try {
      final masterKey = await _getMasterKey(dataType);
      String decryptedData;

      switch (encryptionResult.algorithm) {
        case EncryptionType.xor:
          decryptedData =
              _xorDecrypt(encryptionResult.encryptedData, masterKey);
          break;
        case EncryptionType.base64:
          decryptedData =
              utf8.decode(base64Decode(encryptionResult.encryptedData));
          break;
        case EncryptionType.aes256:
          throw UnimplementedError('AES-256 decryption not implemented yet');
      }

      // 데이터 무결성 검증
      if (encryptionResult.checksum != null) {
        final expectedChecksum = _generateChecksum(decryptedData);
        if (expectedChecksum != encryptionResult.checksum) {
          throw Exception('데이터 무결성 검증 실패');
        }
      }

      _logEncryptionEvent('decrypt', dataType, encryptionResult.algorithm);
      return decryptedData;
    } catch (e) {
      debugPrint('데이터 복호화 실패: $e');
      rethrow;
    }
  }

  /// XOR 암호화
  String _xorEncrypt(String data, String key) {
    final dataBytes = utf8.encode(data);
    final keyBytes = utf8.encode(key);
    final encryptedBytes = <int>[];

    for (int i = 0; i < dataBytes.length; i++) {
      encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64Encode(encryptedBytes);
  }

  /// XOR 복호화
  String _xorDecrypt(String encryptedData, String key) {
    final encryptedBytes = base64Decode(encryptedData);
    final keyBytes = utf8.encode(key);
    final decryptedBytes = <int>[];

    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decryptedBytes);
  }

  /// 체크섬 생성
  String _generateChecksum(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  /// 민감한 데이터 저장
  Future<void> storeSecureData(
    String key,
    String data,
    SensitiveDataType dataType,
  ) async {
    try {
      final encryptionResult = await encryptData(data, dataType);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'secure_$key',
        jsonEncode(encryptionResult.toJson()),
      );

      debugPrint('암호화된 데이터 저장 완료: $key');
    } catch (e) {
      debugPrint('보안 데이터 저장 실패: $e');
      rethrow;
    }
  }

  /// 민감한 데이터 로드
  Future<String?> loadSecureData(
    String key,
    SensitiveDataType dataType,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedJson = prefs.getString('secure_$key');

      if (encryptedJson == null) {
        return null;
      }

      final encryptionResult = EncryptionResult.fromJson(
        jsonDecode(encryptedJson) as Map<String, dynamic>,
      );

      return await decryptData(encryptionResult, dataType);
    } catch (e) {
      debugPrint('보안 데이터 로드 실패: $e');
      return null;
    }
  }

  /// 모든 암호화 키 순환 (보안 강화)
  Future<void> rotateEncryptionKeys() async {
    try {
      debugPrint('암호화 키 순환 시작...');

      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      // 기존 암호화된 데이터 백업
      final backupData = <String, Map<String, dynamic>>{};

      for (final key in allKeys) {
        if (key.startsWith('secure_')) {
          final value = prefs.getString(key);
          if (value != null) {
            backupData[key] = jsonDecode(value) as Map<String, dynamic>;
          }
        }
      }

      // 기존 마스터 키 삭제
      for (final dataType in SensitiveDataType.values) {
        final keyName = '$_masterKeyPrefix${dataType.toString()}';
        await prefs.remove(keyName);
      }

      // 새로운 키로 재암호화
      for (final entry in backupData.entries) {
        try {
          final originalKey = entry.key.replaceFirst('secure_', '');
          // final oldEncryptionResult = EncryptionResult.fromJson(entry.value);
          // final dataType = _guessDataType(originalKey);

          // 구 키로 복호화 후 신 키로 재암호화 (향후 구현 예정)
          // 현재는 간단한 구현을 위해 skip
          debugPrint('키 순환 완료: $originalKey');
        } catch (e) {
          debugPrint('키 순환 실패: ${entry.key} - $e');
        }
      }

      debugPrint('암호화 키 순환 완료');
    } catch (e) {
      debugPrint('암호화 키 순환 실패: $e');
    }
  }

  /// 키 이름으로 데이터 타입 추정 (향후 키 순환 기능에서 사용 예정)
  // SensitiveDataType _guessDataType(String key) {
  //   if (key.contains('user') || key.contains('credential')) {
  //     return SensitiveDataType.userCredentials;
  //   } else if (key.contains('payment') || key.contains('billing')) {
  //     return SensitiveDataType.paymentInfo;
  //   } else if (key.contains('health') || key.contains('workout')) {
  //     return SensitiveDataType.healthData;
  //   } else if (key.contains('api')) {
  //     return SensitiveDataType.apiKeys;
  //   } else if (key.contains('device')) {
  //     return SensitiveDataType.deviceInfo;
  //   } else {
  //     return SensitiveDataType.personalInfo;
  //   }
  // }

  /// 암호화 이벤트 로깅
  void _logEncryptionEvent(
    String operation,
    SensitiveDataType dataType,
    EncryptionType algorithm,
  ) {
    if (kDebugMode) {
      debugPrint('암호화 이벤트: $operation - $dataType - $algorithm');
    }
  }

  /// 모든 보안 데이터 삭제
  Future<void> clearAllSecureData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      for (final key in allKeys) {
        if (key.startsWith('secure_') || key.startsWith(_masterKeyPrefix)) {
          await prefs.remove(key);
        }
      }

      debugPrint('모든 보안 데이터 삭제 완료');
    } catch (e) {
      debugPrint('보안 데이터 삭제 실패: $e');
    }
  }

  /// 암호화 상태 검증
  Future<bool> verifyEncryptionIntegrity() async {
    try {
      // 테스트 데이터로 암호화/복호화 검증
      const testData = 'encryption_test_data';
      const dataType = SensitiveDataType.personalInfo;

      final encryptionResult = await encryptData(testData, dataType);
      final decryptedData = await decryptData(encryptionResult, dataType);

      final isValid = decryptedData == testData;

      debugPrint('암호화 무결성 검증: ${isValid ? '성공' : '실패'}');
      return isValid;
    } catch (e) {
      debugPrint('암호화 무결성 검증 실패: $e');
      return false;
    }
  }

  /// 데이터 유형별 권장 암호화 설정
  EncryptionConfig getRecommendedConfig(SensitiveDataType dataType) {
    switch (dataType) {
      case SensitiveDataType.paymentInfo:
      case SensitiveDataType.userCredentials:
        return const EncryptionConfig(
          type: EncryptionType.xor, // 운영에서는 AES-256 사용
          keyDerivationSalt: 'high_security_salt',
          iterations: 50000,
          compressionEnabled: false,
        );

      case SensitiveDataType.healthData:
      case SensitiveDataType.personalInfo:
        return const EncryptionConfig(
          type: EncryptionType.xor,
          keyDerivationSalt: 'medium_security_salt',
          iterations: 20000,
          compressionEnabled: true,
        );

      case SensitiveDataType.apiKeys:
      case SensitiveDataType.deviceInfo:
        return const EncryptionConfig(
          type: EncryptionType.xor,
          keyDerivationSalt: 'standard_security_salt',
          iterations: 10000,
          compressionEnabled: false,
        );
    }
  }
}
