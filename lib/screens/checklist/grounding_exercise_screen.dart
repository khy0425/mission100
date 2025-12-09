import 'package:flutter/material.dart';
import '../../utils/checklist_data.dart';

/// 5-4-3-2-1 그라운딩 운동 화면
class GroundingExerciseScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback? onCompleted;

  const GroundingExerciseScreen({
    super.key,
    required this.item,
    this.onCompleted,
  });

  @override
  State<GroundingExerciseScreen> createState() => _GroundingExerciseScreenState();
}

class _GroundingExerciseScreenState extends State<GroundingExerciseScreen> {
  int _currentStep = 0;
  final List<List<String>> _userInputs = [[], [], [], [], []];

  final List<_GroundingStep> _steps = [
    _GroundingStep(
      number: 5,
      sense: '시각',
      icon: Icons.visibility,
      color: Colors.blue,
      instruction: '주변에서 보이는 것 5가지를 찾아보세요',
      hint: '예: 창문, 책상, 시계, 식물, 컵...',
    ),
    _GroundingStep(
      number: 4,
      sense: '촉각',
      icon: Icons.touch_app,
      color: Colors.green,
      instruction: '만질 수 있는 것 4가지를 느껴보세요',
      hint: '예: 부드러운 옷, 딱딱한 책상, 차가운 물병...',
    ),
    _GroundingStep(
      number: 3,
      sense: '청각',
      icon: Icons.hearing,
      color: Colors.orange,
      instruction: '지금 들리는 소리 3가지에 집중하세요',
      hint: '예: 시계 소리, 바람 소리, 에어컨 소리...',
    ),
    _GroundingStep(
      number: 2,
      sense: '후각',
      icon: Icons.air,
      color: Colors.purple,
      instruction: '냄새를 맡을 수 있는 것 2가지를 찾으세요',
      hint: '예: 커피 향, 비누 향, 신선한 공기...',
    ),
    _GroundingStep(
      number: 1,
      sense: '미각',
      icon: Icons.restaurant,
      color: Colors.red,
      instruction: '맛볼 수 있는 것 1가지를 느껴보세요',
      hint: '예: 물 한 모금, 사탕, 입 안의 맛...',
    ),
  ];

  bool get _isCompleted => _currentStep >= _steps.length;

  void _addInput(String input) {
    if (input.trim().isEmpty) return;
    final step = _steps[_currentStep];
    if (_userInputs[_currentStep].length < step.number) {
      setState(() {
        _userInputs[_currentStep].add(input.trim());
      });
    }
  }

  void _removeInput(int index) {
    setState(() {
      _userInputs[_currentStep].removeAt(index);
    });
  }

  void _nextStep() {
    if (_userInputs[_currentStep].length >= _steps[_currentStep].number) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
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
        child: _isCompleted ? _buildCompletionView(theme) : _buildStepView(theme),
      ),
    );
  }

  Widget _buildStepView(ThemeData theme) {
    final step = _steps[_currentStep];
    final inputController = TextEditingController();

    return Column(
      children: [
        // 진행 상황
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: List.generate(_steps.length, (index) {
              final isComplete = index < _currentStep;
              final isCurrent = index == _currentStep;
              final stepInfo = _steps[index];
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: isComplete
                        ? stepInfo.color
                        : (isCurrent ? stepInfo.color.withValues(alpha: 0.5) : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),

        // 현재 단계
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 단계 헤더
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: step.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: step.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${step.number}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(step.icon, color: step.color, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    step.sense,
                                    style: TextStyle(
                                      color: step.color,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${step.number}가지 찾기',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        step.instruction,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.hint,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 입력된 항목들
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._userInputs[_currentStep].asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        backgroundColor: step.color.withValues(alpha: 0.1),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeInput(entry.key),
                      );
                    }),
                    // 남은 슬롯 표시
                    ...List.generate(
                      step.number - _userInputs[_currentStep].length,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+ 추가',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 입력 필드
                if (_userInputs[_currentStep].length < step.number)
                  TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      hintText: '여기에 입력하세요',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle, color: step.color),
                        onPressed: () {
                          _addInput(inputController.text);
                          inputController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (value) {
                      _addInput(value);
                      inputController.clear();
                    },
                  ),
              ],
            ),
          ),
        ),

        // 하단 버튼
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    child: const Text('이전'),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _userInputs[_currentStep].length >= step.number
                      ? _nextStep
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: step.color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _currentStep < _steps.length - 1 ? '다음' : '완료',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            '그라운딩 완료!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '5-4-3-2-1 기법으로 현재에 집중했습니다.\n마음이 한결 차분해졌을 거예요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),

          // 요약
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘 발견한 것들',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_steps.length, (index) {
                    final step = _steps[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(step.icon, size: 18, color: step.color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _userInputs[index].join(', '),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
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

class _GroundingStep {
  final int number;
  final String sense;
  final IconData icon;
  final Color color;
  final String instruction;
  final String hint;

  const _GroundingStep({
    required this.number,
    required this.sense,
    required this.icon,
    required this.color,
    required this.instruction,
    required this.hint,
  });
}
