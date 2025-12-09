import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/checklist_data.dart';

/// 바디 스캔 가이드 화면
class BodyScanScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback? onCompleted;

  const BodyScanScreen({
    super.key,
    required this.item,
    this.onCompleted,
  });

  @override
  State<BodyScanScreen> createState() => _BodyScanScreenState();
}

class _BodyScanScreenState extends State<BodyScanScreen> {
  int _currentStep = -1; // -1 = 시작 전
  bool _isCompleted = false;
  Timer? _timer;

  final List<_BodyPart> _bodyParts = [
    _BodyPart(
      name: '발',
      instruction: '발끝에 집중하세요.\n발가락, 발바닥, 발등을 느껴보세요.\n긴장이 있다면 숨을 내쉬며 풀어주세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '다리',
      instruction: '종아리와 허벅지에 집중하세요.\n근육의 무게를 느껴보세요.\n긴장을 발견하면 부드럽게 이완하세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '골반과 엉덩이',
      instruction: '골반과 엉덩이 부분에 집중하세요.\n의자나 바닥에 닿는 느낌을 느껴보세요.\n무거움을 내려놓으세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '배와 허리',
      instruction: '호흡과 함께 배가 움직이는 것을 느끼세요.\n허리의 긴장을 찾아보세요.\n숨을 내쉬며 이완하세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '가슴과 등',
      instruction: '가슴이 호흡과 함께 팽창하는 것을 느끼세요.\n등의 긴장을 찾아보세요.\n어깨를 부드럽게 내리세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '어깨와 팔',
      instruction: '어깨의 무게를 느껴보세요.\n팔, 손목, 손가락까지 스캔하세요.\n모든 긴장을 손끝으로 흘려보내세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '목과 얼굴',
      instruction: '목의 긴장을 풀어주세요.\n턱, 입, 눈 주위 근육을 이완하세요.\n이마의 주름도 펴보세요.',
      duration: 15,
    ),
    _BodyPart(
      name: '머리 전체',
      instruction: '머리 전체를 부드럽게 느껴보세요.\n두피의 긴장도 풀어주세요.\n마음이 고요해지는 것을 느끼세요.',
      duration: 15,
    ),
  ];

  int _countdown = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _currentStep = 0;
      _countdown = _bodyParts[0].duration;
    });
    _startStepTimer();
  }

  void _startStepTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _nextStep();
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _bodyParts.length - 1) {
      setState(() {
        _currentStep++;
        _countdown = _bodyParts[_currentStep].duration;
      });
      _startStepTimer();
    } else {
      setState(() => _isCompleted = true);
    }
  }

  void _skipStep() {
    _timer?.cancel();
    _nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nameKo),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _currentStep == -1
            ? _buildIntroView(theme)
            : (_isCompleted ? _buildCompletionView(theme) : _buildScanView(theme)),
      ),
    );
  }

  Widget _buildIntroView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          Icon(Icons.self_improvement, size: 80, color: theme.primaryColor),
          const SizedBox(height: 24),
          Text(
            '바디 스캔',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '바디 스캔은 몸 전체를 천천히 훑으며\n긴장을 찾아 이완하는 명상 기법입니다.\n\n'
                    '편안한 자세로 앉거나 누워주세요.\n눈을 감고 호흡에 집중해보세요.\n\n'
                    '각 부위에 15초씩 집중합니다.\n총 약 2분이 소요됩니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.6, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startScan,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('시작하기', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanView(ThemeData theme) {
    final part = _bodyParts[_currentStep];
    final progress = (_currentStep + 1) / _bodyParts.length;

    return Column(
      children: [
        // 진행 상황
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: Colors.grey[200],
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 단계 표시
                Text(
                  '${_currentStep + 1} / ${_bodyParts.length}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 8),

                // 신체 부위 이름
                Text(
                  part.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 32),

                // 카운트다운
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    border: Border.all(color: theme.primaryColor, width: 4),
                  ),
                  child: Center(
                    child: Text(
                      '$_countdown',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 안내 문구
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    part.instruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 건너뛰기 버튼
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: _skipStep,
            child: Text(
              _currentStep < _bodyParts.length - 1 ? '다음으로' : '완료',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.spa, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            '바디 스캔 완료!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '몸 전체를 스캔하며 긴장을 풀었습니다.\n\n'
            '이제 몸이 더 가볍고 편안하게\n느껴지실 거예요.\n\n'
            '이 평온함을 기억해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onCompleted?.call();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('완료하기', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyPart {
  final String name;
  final String instruction;
  final int duration;

  const _BodyPart({
    required this.name,
    required this.instruction,
    required this.duration,
  });
}
