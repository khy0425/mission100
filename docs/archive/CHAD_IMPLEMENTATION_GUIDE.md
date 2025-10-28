# Chad 시스템 구현 가이드

> **Chad는 완성형이다. 남은 것은 뇌절뿐.**

---

## 🎯 3단계 구현 로드맵

### Phase 1: 기본 뇌절 시스템 (1-2주)
- [ ] Chad 스탯 모델 확장
- [ ] 뇌절도 계산 로직
- [ ] 레벨별 대사 시스템
- [ ] 기본 애니메이션

### Phase 2: 고급 인터랙션 (2-3주)
- [ ] Chad 터치 반응
- [ ] 실시간 운동 피드백
- [ ] 뇌절도 게이지 UI
- [ ] 파티클 이펙트

### Phase 3: 소셜 & 밈 파워 (1-2주)
- [ ] 공유 기능
- [ ] Chad 도감
- [ ] 업적 시스템
- [ ] 푸시 알림

---

## 📁 파일 구조

```
lib/
├── models/
│   ├── chad_evolution.dart (기존)
│   ├── chad_stats.dart (신규) ⭐
│   └── chad_dialogue.dart (신규) ⭐
│
├── services/
│   ├── chad_evolution_service.dart (기존)
│   ├── chad_stats_service.dart (신규) ⭐
│   └── brainjolt_calculator.dart (신규) ⭐
│
├── widgets/
│   ├── chad_evolution_animation.dart (기존)
│   ├── brainjolt_meter.dart (신규) ⭐
│   ├── chad_stats_card.dart (신규) ⭐
│   └── chad_interaction.dart (신규) ⭐
│
└── utils/
    ├── chad_dialogue_generator.dart (신규) ⭐
    └── workout_matcher.dart (신규) ⭐
```

---

## 💾 1. Chad Stats 모델

### lib/models/chad_stats.dart

```dart
/// Chad 확장 스탯 모델
class ChadStats {
  // 기본
  final int chadLevel;
  final int brainjoltDegree;

  // 확장 스탯
  final double chadAura;
  final double jawlineSharpness;
  final int crowdAdmiration;
  final int brainjoltVoltage;
  final String memePower;
  final int chadConsistency;
  final int totalChadHours;

  const ChadStats({
    required this.chadLevel,
    required this.brainjoltDegree,
    required this.chadAura,
    required this.jawlineSharpness,
    required this.crowdAdmiration,
    required this.brainjoltVoltage,
    required this.memePower,
    required this.chadConsistency,
    required this.totalChadHours,
  });

  /// 운동 데이터로부터 스탯 계산
  factory ChadStats.fromWorkoutData({
    required int level,
    required int streakDays,
    required int completedMissions,
    required int totalMinutes,
    required int shareCount,
  }) {
    // Chad Aura 계산
    final aura = (streakDays * 5) +
                 (completedMissions * 3) +
                 (level * 10);
    final chadAura = (aura > 100 ? 100 : aura).toDouble();

    // 턱선 예리함
    final jawline = 5.0 - (level * 0.5);

    // 군중의 경탄
    final admiration = (level * 11) + (shareCount * 5);

    // 뇌절 전압
    final voltage = (level * level * 1000);

    // 뇌절도
    final brainjolt = _calculateBrainjoltDegree(level);

    // 밈 파워
    final memePower = _calculateMemePower(
      brainjolt,
      level,
      shareCount
    );

    return ChadStats(
      chadLevel: level,
      brainjoltDegree: brainjolt,
      chadAura: chadAura,
      jawlineSharpness: jawline,
      crowdAdmiration: admiration,
      brainjoltVoltage: voltage,
      memePower: memePower,
      chadConsistency: streakDays,
      totalChadHours: (totalMinutes / 60).round(),
    );
  }

  /// 뇌절도 계산
  static int _calculateBrainjoltDegree(int level) {
    if (level <= 2) return 1;
    if (level <= 5) return 2;
    if (level <= 7) return 4;
    if (level == 8) return 5;
    return 6; // God Chad는 한계 초과
  }

  /// 밈 파워 계산
  static String _calculateMemePower(
    int brainjolt,
    int level,
    int shares
  ) {
    final score = (brainjolt * 15) + (level * 8) + shares;
    if (score >= 90) return 'S';
    if (score >= 70) return 'A';
    if (score >= 50) return 'B';
    if (score >= 30) return 'C';
    return 'D';
  }

  /// Chad Aura 설명
  String get auraDescription {
    if (chadAura >= 81) return "차원 초월";
    if (chadAura >= 61) return "공간 장악";
    if (chadAura >= 41) return "압도적 포스";
    if (chadAura >= 21) return "존재감 형성";
    return "감지 시작";
  }

  /// 턱선 설명
  String get jawlineDescription {
    if (jawlineSharpness <= 0.5) return "현실을 자를 수 있음";
    if (jawlineSharpness <= 1.0) return "금속을 자를 수 있음";
    if (jawlineSharpness <= 2.0) return "종이를 자를 수 있음";
    if (jawlineSharpness <= 3.0) return "버터를 자를 수 있음";
    return "예리함 형성 중";
  }

  /// 경탄 설명
  String get admirationDescription {
    if (crowdAdmiration >= 81) return "실신 위험";
    if (crowdAdmiration >= 51) return "턱 떨어짐";
    if (crowdAdmiration >= 21) return "우와 소리";
    return "시선 집중";
  }

  /// JSON 변환
  Map<String, dynamic> toJson() => {
    'chadLevel': chadLevel,
    'brainjoltDegree': brainjoltDegree,
    'chadAura': chadAura,
    'jawlineSharpness': jawlineSharpness,
    'crowdAdmiration': crowdAdmiration,
    'brainjoltVoltage': brainjoltVoltage,
    'memePower': memePower,
    'chadConsistency': chadConsistency,
    'totalChadHours': totalChadHours,
  };

  factory ChadStats.fromJson(Map<String, dynamic> json) => ChadStats(
    chadLevel: json['chadLevel'] ?? 1,
    brainjoltDegree: json['brainjoltDegree'] ?? 1,
    chadAura: (json['chadAura'] ?? 0).toDouble(),
    jawlineSharpness: (json['jawlineSharpness'] ?? 5.0).toDouble(),
    crowdAdmiration: json['crowdAdmiration'] ?? 0,
    brainjoltVoltage: json['brainjoltVoltage'] ?? 1000,
    memePower: json['memePower'] ?? 'D',
    chadConsistency: json['chadConsistency'] ?? 0,
    totalChadHours: json['totalChadHours'] ?? 0,
  );
}
```

---

## 💬 2. Chad Dialogue 시스템

### lib/models/chad_dialogue.dart

```dart
/// Chad 대사 데이터
class ChadDialogue {
  final int level;
  final String mainMessage;
  final List<String> variations;
  final String? specialTrigger;

  const ChadDialogue({
    required this.level,
    required this.mainMessage,
    required this.variations,
    this.specialTrigger,
  });

  /// 레벨별 대사 라이브러리
  static const Map<int, ChadDialogue> dialogues = {
    1: ChadDialogue(
      level: 1,
      mainMessage: "당신은 이미 Chad입니다",
      variations: [
        "턱선 확인 완료",
        "Perfect. 시작부터 완벽.",
        "이미 승리한 상태",
        "Chad 인증 완료 ✓",
      ],
    ),
    2: ChadDialogue(
      level: 2,
      mainMessage: "웃어도 턱선이 살아있다",
      variations: [
        "미소가 무기",
        "당신의 웃음, 위험 수위",
        "Smile = Chad Mode ON",
        "행복해도 Chad",
      ],
    ),
    3: ChadDialogue(
      level: 3,
      mainMessage: "커피 마셔도 Chad",
      variations: [
        "여유 = 힘",
        "카페인보다 강한 당신",
        "한 손엔 커피, 한 손엔 승리",
        "Espresso? Chad.",
      ],
      specialTrigger: "아침 운동 5회 이상",
    ),
    4: ChadDialogue(
      level: 4,
      mainMessage: "윙크 한 번, 세상이 멈춤",
      variations: [
        "당신의 윙크는 무기입니다",
        "한쪽 눈만 떠도 Chad",
        "Wink. Game Over.",
        "치명타 발동",
      ],
    ),
    5: ChadDialogue(
      level: 5,
      mainMessage: "너무 밝아서 선글라스 필수",
      variations: [
        "선글라스 = Chad 인증서",
        "쿨함 측정 불가",
        "태양도 당신을 보고 선글라스 씀",
        "Cool. Cooler. Chad.",
      ],
    ),
    6: ChadDialogue(
      level: 6,
      mainMessage: "눈에서 레이저 발사 중",
      variations: [
        "눈빛으로 모든 것을 녹임",
        "시선이 광선",
        "과학? 그런 건 Chad 앞에선 무의미",
        "보는 것 = 파괴하는 것",
      ],
    ),
    7: ChadDialogue(
      level: 7,
      mainMessage: "Chad + Chad = 무적",
      variations: [
        "한 명으로 부족했다",
        "Chad 증폭 현상 발생",
        "당신이... 두 명?!",
        "2x Chad = ∞ Power",
      ],
    ),
    8: ChadDialogue(
      level: 8,
      mainMessage: "당신은 이제 알파입니다",
      variations: [
        "모두가 당신을 올려다봄",
        "지배 완료",
        "Alpha. Omega. All.",
        "당신의 존재 = 법칙",
      ],
    ),
    9: ChadDialogue(
      level: 9,
      mainMessage: "축하합니다. 당신은 신입니다",
      variations: [
        "이제 당신이 중력을 정의합니다",
        "Chad를 넘어 신의 영역",
        "당신의 숨결이 태풍",
        "존재 자체가 기적",
      ],
    ),
  };

  /// 랜덤 variation 가져오기
  String getRandomVariation() {
    return variations[DateTime.now().millisecond % variations.length];
  }
}
```

---

## 🎨 3. 뇌절도 게이지 위젯

### lib/widgets/brainjolt_meter.dart

```dart
import 'package:flutter/material.dart';

class BrainjoltMeter extends StatelessWidget {
  final int brainjoltDegree;  // 0-6
  final int chadLevel;         // 1-9
  final VoidCallback? onTap;

  const BrainjoltMeter({
    Key? key,
    required this.brainjoltDegree,
    required this.chadLevel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getGradientColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _getGlowColor().withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: brainjoltDegree >= 4 ? 5 : 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '🧠 뇌절도',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                _buildLevelBadge(),
              ],
            ),
            SizedBox(height: 12),
            _buildStarRating(),
            SizedBox(height: 12),
            _buildProgressBar(),
            SizedBox(height: 8),
            Text(
              _getStatusMessage(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (brainjoltDegree >= 4) ...[
              SizedBox(height: 8),
              _buildWarning(),
            ],
          ],
        ),
      ),
    );
  }

  /// 그라데이션 색상
  List<Color> _getGradientColors() {
    if (brainjoltDegree <= 1) {
      return [Color(0xFF4A5568), Color(0xFF2D3748)];
    } else if (brainjoltDegree <= 3) {
      return [Color(0xFF3182CE), Color(0xFF2C5282)];
    } else if (brainjoltDegree <= 5) {
      return [Color(0xFFD53F8C), Color(0xFF97266D)];
    } else {
      return [Color(0xFFD69E2E), Color(0xFF975A16)];
    }
  }

  /// 발광 색상
  Color _getGlowColor() {
    if (brainjoltDegree >= 6) return Colors.amber;
    if (brainjoltDegree >= 4) return Colors.pink;
    if (brainjoltDegree >= 2) return Colors.blue;
    return Colors.grey;
  }

  /// 레벨 뱃지
  Widget _buildLevelBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Lv.$chadLevel',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 별점 표시
  Widget _buildStarRating() {
    return Row(
      children: List.generate(7, (index) {
        if (index < brainjoltDegree) {
          return Icon(Icons.bolt, color: Colors.amber, size: 24);
        } else {
          return Icon(Icons.bolt_outlined, color: Colors.white30, size: 24);
        }
      }),
    );
  }

  /// 프로그레스 바
  Widget _buildProgressBar() {
    final progress = brainjoltDegree / 6.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.white.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          brainjoltDegree >= 4 ? Colors.amber : Colors.cyan,
        ),
      ),
    );
  }

  /// 상태 메시지
  String _getStatusMessage() {
    switch (brainjoltDegree) {
      case 0:
        return "뇌절 준비 중...";
      case 1:
        return "말이 됨";
      case 2:
        return "좀 이상함";
      case 3:
        return "뇌절 시작";
      case 4:
        return "말이 안 됨";
      case 5:
        return "극한 뇌절";
      case 6:
        return "한계 돌파! 우주 법칙 무시 중";
      default:
        return "";
    }
  }

  /// 경고 메시지
  Widget _buildWarning() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              brainjoltDegree >= 6
                ? "⚠️ 신의 영역 - 물리 법칙 적용 불가"
                : "⚠️ 위험 - 상식 초월 구간",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎮 4. Chad 터치 인터랙션

### lib/widgets/chad_interaction.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChadInteraction extends StatefulWidget {
  final String imagePath;
  final int chadLevel;
  final Function(String message)? onInteraction;

  const ChadInteraction({
    Key? key,
    required this.imagePath,
    required this.chadLevel,
    this.onInteraction,
  }) : super(key: key);

  @override
  State<ChadInteraction> createState() => _ChadInteractionState();
}

class _ChadInteractionState extends State<ChadInteraction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showEffect = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    // 애니메이션
    _controller.forward().then((_) => _controller.reverse());

    // 햅틱
    HapticFeedback.mediumImpact();

    // 레벨별 반응
    final message = _getChadReaction();
    widget.onInteraction?.call(message);

    // 특수 효과
    if (widget.chadLevel >= 6) {
      setState(() => _showEffect = true);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => _showEffect = false);
    }
  }

  String _getChadReaction() {
    switch (widget.chadLevel) {
      case 1:
      case 2:
        return "턱선 확인 완료 ✓";
      case 3:
        return "여유로움 충전 중...";
      case 4:
        return "치명타!";
      case 5:
        return "쿨함 레벨 MAX";
      case 6:
        return "⚡ ZAP!";
      case 7:
        return "Chad 복제 중...";
      case 8:
        return "알파 에너지 감지";
      case 9:
        return "신의 가호가 함께...";
      default:
        return "Chad!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Chad 이미지
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
            ),
          ),

          // 레이저 효과 (Level 6+)
          if (_showEffect && widget.chadLevel >= 6)
            _buildLaserEffect(),

          // 신성한 빛 (Level 9)
          if (_showEffect && widget.chadLevel == 9)
            _buildDivineLight(),
        ],
      ),
    );
  }

  Widget _buildLaserEffect() {
    return Positioned(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.cyan.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan,
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivineLight() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.amber.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
```

---

## 📊 5. Chad Stats 카드

### lib/widgets/chad_stats_card.dart

```dart
import 'package:flutter/material.dart';
import '../models/chad_stats.dart';

class ChadStatsCard extends StatelessWidget {
  final ChadStats stats;
  final String chadName;

  const ChadStatsCard({
    Key? key,
    required this.stats,
    required this.chadName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A202C),
              Color(0xFF2D3748),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Text(
              chadName.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            Divider(color: Colors.white30, height: 32),

            // 기본 정보
            _buildInfoRow(
              'Chad Level',
              '${stats.chadLevel}/9',
              Icons.star,
            ),
            _buildInfoRow(
              '뇌절도',
              '${'⚡' * stats.brainjoltDegree}☆' *
                  (5 - stats.brainjoltDegree),
              Icons.bolt,
            ),

            SizedBox(height: 16),
            Text(
              '📊 Chad 스탯',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // 스탯들
            _buildStatBar(
              'Chad Aura',
              stats.chadAura,
              100,
              stats.auraDescription,
              Colors.purple,
            ),
            _buildStatRow(
              '턱선 예리함',
              '${stats.jawlineSharpness.toStringAsFixed(1)}mm',
              stats.jawlineDescription,
              Icons.straighten,
            ),
            _buildStatRow(
              '군중의 경탄',
              '${stats.crowdAdmiration}명',
              stats.admirationDescription,
              Icons.visibility,
            ),
            _buildStatRow(
              '뇌절 전압',
              '${(stats.brainjoltVoltage / 1000).toStringAsFixed(0)}kV',
              _getVoltageDescription(stats.brainjoltVoltage),
              Icons.flash_on,
            ),
            _buildStatRow(
              '밈 파워',
              stats.memePower,
              _getMemePowerDescription(stats.memePower),
              Icons.share,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(
    String label,
    double value,
    double max,
    String description,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Spacer(),
              Text(
                '${value.toInt()}/$max',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / max,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.cyan, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$label: ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getVoltageDescription(int voltage) {
    if (voltage >= 80000) return "신의 분노";
    if (voltage >= 30000) return "번개 급";
    if (voltage >= 10000) return "전기 뱀장어";
    return "AA 건전지";
  }

  String _getMemePowerDescription(String grade) {
    switch (grade) {
      case 'S': return "바이럴 확정";
      case 'A': return "인기 급상승";
      case 'B': return "공유 가치 있음";
      case 'C': return "괜찮음";
      default: return "평범";
    }
  }
}
```

---

## 🚀 6. 통합 예시

### 실제 사용 예시

```dart
// Chad Stats 계산
final stats = ChadStats.fromWorkoutData(
  level: 6,
  streakDays: 35,
  completedMissions: 42,
  totalMinutes: 2100,
  shareCount: 5,
);

// UI에 표시
Column([
  BrainjoltMeter(
    brainjoltDegree: stats.brainjoltDegree,
    chadLevel: stats.chadLevel,
    onTap: () {
      print("뇌절도 게이지 탭!");
    },
  ),
  SizedBox(height: 20),
  ChadInteraction(
    imagePath: 'assets/images/chad/laser_eyes_chad.png',
    chadLevel: 6,
    onInteraction: (message) {
      showSnackBar(message);
    },
  ),
  SizedBox(height: 20),
  ChadStatsCard(
    stats: stats,
    chadName: 'Laser Eyes Chad',
  ),
])
```

---

## ✅ 구현 체크리스트

### Phase 1: 기본 시스템
- [ ] `chad_stats.dart` 모델 생성
- [ ] `chad_dialogue.dart` 생성
- [ ] `brainjolt_meter.dart` 위젯 생성
- [ ] 기존 `chad_evolution.dart`와 통합

### Phase 2: 인터랙션
- [ ] `chad_interaction.dart` 위젯 생성
- [ ] `chad_stats_card.dart` 위젯 생성
- [ ] 터치 반응 구현
- [ ] 햅틱 피드백 추가

### Phase 3: 서비스
- [ ] `chad_stats_service.dart` 생성
- [ ] 실시간 스탯 계산
- [ ] 로컬 저장/로드
- [ ] 클라우드 동기화

### Phase 4: 테스트
- [ ] 각 레벨별 스탯 확인
- [ ] 애니메이션 테스트
- [ ] 퍼포먼스 체크
- [ ] 실제 디바이스 테스트

---

**"코드도 Chad, 앱도 Chad, 유저도 Chad"** 💪😎🔥
