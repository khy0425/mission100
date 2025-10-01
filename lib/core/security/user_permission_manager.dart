import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 사용자 권한 타입
enum UserPermission {
  // 기본 권한
  readProfile,
  updateProfile,
  readWorkouts,
  createWorkouts,
  updateWorkouts,
  deleteWorkouts,

  // 프리미엄 권한
  accessPremiumFeatures,
  exportData,
  customWorkouts,
  advancedStats,

  // 관리자 권한
  adminAccess,
  manageUsers,
  systemSettings,

  // 특수 권한
  betaFeatures,
  debugAccess,
}

/// 사용자 역할
enum UserRole {
  guest, // 비회원
  user, // 일반 사용자
  premium, // 프리미엄 사용자
  beta, // 베타 테스터
  moderator, // 관리자
  admin, // 최고 관리자
}

/// 권한 검증 결과
class PermissionResult {
  final bool granted;
  final String? reason;
  final UserRole userRole;
  final List<UserPermission> permissions;

  const PermissionResult({
    required this.granted,
    this.reason,
    required this.userRole,
    required this.permissions,
  });

  factory PermissionResult.denied(String reason, UserRole role) {
    return PermissionResult(
      granted: false,
      reason: reason,
      userRole: role,
      permissions: [],
    );
  }

  factory PermissionResult.granted(
      UserRole role, List<UserPermission> permissions) {
    return PermissionResult(
      granted: true,
      userRole: role,
      permissions: permissions,
    );
  }
}

/// 사용자 권한 관리자
class UserPermissionManager {
  static final UserPermissionManager _instance =
      UserPermissionManager._internal();
  factory UserPermissionManager() => _instance;
  UserPermissionManager._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserRole? _cachedUserRole;
  List<UserPermission>? _cachedPermissions;
  DateTime? _lastCacheUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 30);

  /// 현재 사용자 역할 조회
  Future<UserRole> getCurrentUserRole() async {
    try {
      // 캐시된 값이 유효한 경우 반환
      if (_cachedUserRole != null &&
          _lastCacheUpdate != null &&
          DateTime.now().difference(_lastCacheUpdate!) < _cacheValidDuration) {
        return _cachedUserRole!;
      }

      final user = _auth.currentUser;
      if (user == null) {
        _updateCache(UserRole.guest, []);
        return UserRole.guest;
      }

      // Firestore에서 사용자 역할 조회
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // 새 사용자인 경우 기본 역할 설정
        await _createDefaultUserRecord(user.uid);
        _updateCache(UserRole.user, _getPermissionsForRole(UserRole.user));
        return UserRole.user;
      }

      final userData = userDoc.data()!;
      final roleString = userData['role'] as String? ?? 'user';
      final role = _parseUserRole(roleString);

      // 구독 상태 확인하여 프리미엄 권한 결정
      if (role == UserRole.user) {
        final isPremium = await _checkPremiumStatus(user.uid);
        final finalRole = isPremium ? UserRole.premium : UserRole.user;
        _updateCache(finalRole, _getPermissionsForRole(finalRole));
        return finalRole;
      }

      _updateCache(role, _getPermissionsForRole(role));
      return role;
    } catch (e) {
      debugPrint('사용자 역할 조회 실패: $e');
      _updateCache(UserRole.guest, []);
      return UserRole.guest;
    }
  }

  /// 특정 권한 확인
  Future<PermissionResult> checkPermission(UserPermission permission) async {
    try {
      final role = await getCurrentUserRole();
      final permissions = _getPermissionsForRole(role);

      if (permissions.contains(permission)) {
        return PermissionResult.granted(role, permissions);
      }

      return PermissionResult.denied(
        '권한이 없습니다: ${permission.toString()}',
        role,
      );
    } catch (e) {
      debugPrint('권한 확인 실패: $e');
      return PermissionResult.denied('권한 확인 중 오류 발생', UserRole.guest);
    }
  }

  /// 여러 권한 동시 확인
  Future<Map<UserPermission, bool>> checkMultiplePermissions(
    List<UserPermission> permissions,
  ) async {
    final result = <UserPermission, bool>{};
    final userRole = await getCurrentUserRole();
    final userPermissions = _getPermissionsForRole(userRole);

    for (final permission in permissions) {
      result[permission] = userPermissions.contains(permission);
    }

    return result;
  }

  /// 권한 요구사항 검증
  Future<bool> requirePermissions(
      List<UserPermission> requiredPermissions) async {
    final results = await checkMultiplePermissions(requiredPermissions);
    return results.values.every((granted) => granted);
  }

  /// 사용자 역할별 권한 목록
  List<UserPermission> _getPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.guest:
        return [
          UserPermission.readProfile,
        ];

      case UserRole.user:
        return [
          UserPermission.readProfile,
          UserPermission.updateProfile,
          UserPermission.readWorkouts,
          UserPermission.createWorkouts,
          UserPermission.updateWorkouts,
          UserPermission.deleteWorkouts,
        ];

      case UserRole.premium:
        return [
          // 기본 사용자 권한
          ...(_getPermissionsForRole(UserRole.user)),
          // 프리미엄 권한
          UserPermission.accessPremiumFeatures,
          UserPermission.exportData,
          UserPermission.customWorkouts,
          UserPermission.advancedStats,
        ];

      case UserRole.beta:
        return [
          // 프리미엄 권한
          ...(_getPermissionsForRole(UserRole.premium)),
          // 베타 권한
          UserPermission.betaFeatures,
        ];

      case UserRole.moderator:
        return [
          // 베타 권한
          ...(_getPermissionsForRole(UserRole.beta)),
          // 관리 권한
          UserPermission.manageUsers,
        ];

      case UserRole.admin:
        return UserPermission.values; // 모든 권한
    }
  }

  /// 프리미엄 구독 상태 확인
  Future<bool> _checkPremiumStatus(String userId) async {
    try {
      final subscriptionQuery = await _firestore
          .collection('subscriptions')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      return subscriptionQuery.docs.isNotEmpty;
    } catch (e) {
      debugPrint('프리미엄 상태 확인 실패: $e');
      return false;
    }
  }

  /// 기본 사용자 레코드 생성
  Future<void> _createDefaultUserRecord(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'permissions': _getPermissionsForRole(UserRole.user)
            .map((p) => p.toString())
            .toList(),
      });
    } catch (e) {
      debugPrint('기본 사용자 레코드 생성 실패: $e');
    }
  }

  /// 문자열을 UserRole로 파싱
  UserRole _parseUserRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'guest':
        return UserRole.guest;
      case 'user':
        return UserRole.user;
      case 'premium':
        return UserRole.premium;
      case 'beta':
        return UserRole.beta;
      case 'moderator':
        return UserRole.moderator;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }

  /// 캐시 업데이트
  void _updateCache(UserRole role, List<UserPermission> permissions) {
    _cachedUserRole = role;
    _cachedPermissions = permissions;
    _lastCacheUpdate = DateTime.now();
  }

  /// 캐시 무효화
  void invalidateCache() {
    _cachedUserRole = null;
    _cachedPermissions = null;
    _lastCacheUpdate = null;
  }

  /// 사용자 역할 업데이트 (관리자 전용)
  Future<bool> updateUserRole(String userId, UserRole newRole) async {
    try {
      // 현재 사용자가 관리자인지 확인
      final currentUserRole = await getCurrentUserRole();
      if (currentUserRole != UserRole.admin &&
          currentUserRole != UserRole.moderator) {
        debugPrint('권한 없음: 사용자 역할 변경은 관리자만 가능');
        return false;
      }

      await _firestore.collection('users').doc(userId).update({
        'role': newRole.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
        'permissions':
            _getPermissionsForRole(newRole).map((p) => p.toString()).toList(),
      });

      // 해당 사용자의 캐시 무효화 (현재 사용자인 경우)
      if (userId == _auth.currentUser?.uid) {
        invalidateCache();
      }

      debugPrint('사용자 역할 업데이트 완료: $userId -> $newRole');
      return true;
    } catch (e) {
      debugPrint('사용자 역할 업데이트 실패: $e');
      return false;
    }
  }

  /// 권한 로깅
  void _logPermissionCheck(UserPermission permission, bool granted) {
    if (kDebugMode) {
      debugPrint('권한 확인: ${permission.toString()} -> ${granted ? '허용' : '거부'}');
    }
  }

  /// 보안 이벤트 로깅
  Future<void> _logSecurityEvent(
      String event, Map<String, dynamic> details) async {
    try {
      if (kReleaseMode) {
        await _firestore.collection('securityLogs').add({
          'event': event,
          'details': details,
          'userId': _auth.currentUser?.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'ip': 'unknown', // 실제 구현에서는 IP 주소 수집
        });
      } else {
        debugPrint('보안 이벤트: $event - $details');
      }
    } catch (e) {
      debugPrint('보안 로그 저장 실패: $e');
    }
  }

  /// 권한 위반 처리
  Future<void> handlePermissionViolation(
    UserPermission permission,
    String context,
  ) async {
    await _logSecurityEvent('permission_violation', {
      'permission': permission.toString(),
      'context': context,
      'userRole': (await getCurrentUserRole()).toString(),
    });

    // 심각한 권한 위반의 경우 사용자 차단 등의 조치 가능
    debugPrint('권한 위반 감지: $permission in $context');
  }

  /// 현재 사용자 권한 목록 조회
  Future<List<UserPermission>> getCurrentUserPermissions() async {
    if (_cachedPermissions != null &&
        _lastCacheUpdate != null &&
        DateTime.now().difference(_lastCacheUpdate!) < _cacheValidDuration) {
      return _cachedPermissions!;
    }

    final role = await getCurrentUserRole();
    return _getPermissionsForRole(role);
  }

  /// 디버그용 권한 정보 출력
  Future<void> printUserPermissions() async {
    if (kDebugMode) {
      final role = await getCurrentUserRole();
      final permissions = await getCurrentUserPermissions();

      debugPrint('=== 사용자 권한 정보 ===');
      debugPrint('역할: $role');
      debugPrint('권한 목록:');
      for (final permission in permissions) {
        debugPrint('  - ${permission.toString()}');
      }
      debugPrint('========================');
    }
  }
}
