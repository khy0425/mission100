import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ads/reward_ad_service.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/auth/auth_service.dart';

/// 리워드 광고 + 토큰 지급 검증 테스트 화면
///
/// 테스트 항목:
/// 1. 리워드 광고 로드
/// 2. 광고 시청 완료
/// 3. Firestore 토큰 지급 확인
/// 4. 일일 제한 확인
class RewardAdTestScreen extends StatefulWidget {
  const RewardAdTestScreen({super.key});

  @override
  State<RewardAdTestScreen> createState() => _RewardAdTestScreenState();
}

class _RewardAdTestScreenState extends State<RewardAdTestScreen> {
  final _rewardAdService = RewardAdService();
  final _logs = <String>[];
  bool _isLoading = false;
  int? _balanceBeforeAd;
  int? _balanceAfterAd;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _addLog('🔄 초기 데이터 로드 중...');
    final tokenService = Provider.of<ConversationTokenService>(context, listen: false);
    await tokenService.initialize();
    _addLog('✅ 현재 토큰 잔액: ${tokenService.balance}');

    // 광고 미리 로드
    await _rewardAdService.loadAd();
    _addLog('✅ 리워드 광고 로드 완료');
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    });
    debugPrint(message);
  }

  /// 리워드 광고 표시 및 토큰 지급 테스트
  Future<void> _testRewardAdWithToken() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _balanceBeforeAd = null;
      _balanceAfterAd = null;
    });

    try {
      final tokenService = Provider.of<ConversationTokenService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);

      _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━');
      _addLog('🎬 리워드 광고 + 토큰 지급 테스트 시작');
      _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━');

      // 1. 광고 시청 전 토큰 확인
      _balanceBeforeAd = tokenService.balance;
      _addLog('1️⃣ 광고 시청 전 토큰: $_balanceBeforeAd');

      // 2. 프리미엄 여부 확인
      final isPremium = !authService.hasAds;
      _addLog('2️⃣ 프리미엄 여부: ${isPremium ? 'Yes' : 'No'}');

      // 3. 광고 준비 확인
      if (!_rewardAdService.isAdReady) {
        _addLog('⚠️ 광고가 준비되지 않았습니다. 다시 로드합니다...');
        await _rewardAdService.loadAd();
        await Future.delayed(const Duration(seconds: 2));

        if (!_rewardAdService.isAdReady) {
          _addLog('❌ 광고 로드 실패');
          setState(() => _isLoading = false);
          return;
        }
      }

      _addLog('3️⃣ 광고 준비 완료 ✅');

      // 4. 광고 표시
      _addLog('4️⃣ 광고 표시 중...');
      bool adCompleted = false;
      bool rewardGranted = false;

      await _rewardAdService.showAd(
        onRewarded: () async {
          _addLog('🎁 광고 시청 완료! 토큰 지급 시작...');
          adCompleted = true;

          // 5. Cloud Function 호출 (토큰 지급)
          try {
            final success = await tokenService.earnFromRewardAd(isPremium: isPremium);
            if (success) {
              _addLog('✅ 토큰 지급 성공');
              rewardGranted = true;

              // 6. 업데이트된 토큰 확인
              await Future.delayed(const Duration(seconds: 1));
              _balanceAfterAd = tokenService.balance;
              final earned = _balanceAfterAd! - _balanceBeforeAd!;
              _addLog('6️⃣ 광고 시청 후 토큰: $_balanceAfterAd (+$earned)');

              // 검증 성공!
              _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━');
              _addLog('✅ 테스트 성공!');
              _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━');

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ 테스트 성공! +$earned 토큰 획득'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              _addLog('⚠️ 토큰 지급 실패 (일일 제한?)');
            }
          } catch (e) {
            _addLog('❌ 토큰 지급 오류: $e');
          }
        },
        onAdClosed: () {
          _addLog('🚪 광고 닫힘');
          if (!rewardGranted) {
            _addLog('⚠️ 광고를 끝까지 보지 않아 토큰이 지급되지 않았습니다');
          }
        },
        onAdFailedToShow: (error) {
          _addLog('❌ 광고 표시 실패: $error');
        },
      );
    } catch (e) {
      _addLog('❌ 테스트 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 토큰 테스트 추가
  Future<void> _addTestTokens() async {
    setState(() => _isLoading = true);
    try {
      final tokenService = Provider.of<ConversationTokenService>(context, listen: false);
      await tokenService.addTokensForTesting(10);
      _addLog('✅ 테스트 토큰 +10 추가');
    } catch (e) {
      _addLog('❌ 토큰 추가 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 토큰 초기화
  Future<void> _resetTestTokens() async {
    setState(() => _isLoading = true);
    try {
      final tokenService = Provider.of<ConversationTokenService>(context, listen: false);
      await tokenService.resetTokensForTesting();
      _addLog('✅ 토큰 초기화 완료');
    } catch (e) {
      _addLog('❌ 토큰 초기화 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 광고 다시 로드
  Future<void> _reloadAd() async {
    setState(() => _isLoading = true);
    try {
      await _rewardAdService.loadAd();
      _addLog('✅ 광고 로드 완료');
    } catch (e) {
      _addLog('❌ 광고 로드 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 로그 초기화
  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리워드 광고 + 토큰 테스트'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearLogs,
            tooltip: '로그 초기화',
          ),
        ],
      ),
      body: Column(
        children: [
          // 현재 상태 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.shade50,
            child: Consumer<ConversationTokenService>(
              builder: (context, tokenService, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 토큰 잔액: ${tokenService.balance}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('총 획득: ${tokenService.stats['lifetimeEarned']}'),
                    Text('총 사용: ${tokenService.stats['lifetimeSpent']}'),
                    const SizedBox(height: 8),
                    if (_balanceBeforeAd != null && _balanceAfterAd != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '전: $_balanceBeforeAd → 후: $_balanceAfterAd (${_balanceAfterAd! - _balanceBeforeAd!:+})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // 테스트 버튼들
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 메인 테스트 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testRewardAdWithToken,
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: const Text(
                      '리워드 광고 + 토큰 지급 테스트',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 보조 버튼들
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _reloadAd,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('광고 로드'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _addTestTokens,
                        icon: const Icon(Icons.add_circle, size: 20),
                        label: const Text('+10 토큰'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _resetTestTokens,
                        icon: const Icon(Icons.restore, size: 20),
                        label: const Text('초기화'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 로그 영역
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple.shade300),
              ),
              child: _logs.isEmpty
                  ? const Center(
                      child: Text(
                        '로그가 여기에 표시됩니다',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            log,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: log.contains('❌')
                                  ? Colors.red.shade300
                                  : log.contains('✅')
                                      ? Colors.green.shade300
                                      : log.contains('⚠️')
                                          ? Colors.orange.shade300
                                          : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // 상태 표시
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('처리 중...'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _rewardAdService.dispose();
    super.dispose();
  }
}
