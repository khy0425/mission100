import 'package:flutter/material.dart';
import '../../utils/checklist_data.dart';

/// 감사 3가지 입력 화면
class GratitudeScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback? onCompleted;

  const GratitudeScreen({
    super.key,
    required this.item,
    this.onCompleted,
  });

  @override
  State<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends State<GratitudeScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<String> _prompts = [
    '오늘 감사한 일이 있다면 무엇인가요?',
    '당연하게 여겼지만 감사한 것은요?',
    '작지만 기쁨을 준 순간은요?',
  ];

  final List<String> _hints = [
    '예: 맛있는 점심을 먹었어요',
    '예: 건강하게 일어날 수 있어서',
    '예: 따뜻한 햇살을 느꼈어요',
  ];

  bool get _isAllFilled => _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 40,
                        color: Colors.amber[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '오늘 감사한 일 3가지',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '작은 것이라도 괜찮아요.\n감사함을 느끼는 것 자체가 소중해요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 감사 입력 필드들
              ...List.generate(3, (index) => _buildGratitudeField(index, theme)),

              const SizedBox(height: 24),

              // 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAllFilled
                      ? () => _showCompletionDialog(context, theme)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('감사 기록하기', style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 16),

              // 안내 카드
              Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '감사 일기의 효과',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 긍정적인 감정이 증가합니다\n'
                        '• 스트레스가 줄어듭니다\n'
                        '• 수면의 질이 좋아집니다\n'
                        '• 전반적인 행복감이 높아집니다',
                        style: TextStyle(
                          color: Colors.amber[900],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGratitudeField(int index, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _prompts[index],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controllers[index],
            decoration: InputDecoration(
              hintText: _hints[index],
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.amber[700]!, width: 2),
              ),
            ),
            maxLines: 2,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 40, color: Colors.green[600]),
            ),
            const SizedBox(height: 20),
            const Text(
              '감사 기록 완료!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '오늘도 감사함을 느끼셨네요.\n이 마음을 기억해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 감사',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.favorite, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _controllers[index].text,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.onCompleted?.call();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('완료'),
            ),
          ),
        ],
      ),
    );
  }
}
