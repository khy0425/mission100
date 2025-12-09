import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/checklist_data.dart';

/// 걱정 시간 - 걱정 비우기 화면
class WorryTimeScreen extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback? onCompleted;

  const WorryTimeScreen({
    super.key,
    required this.item,
    this.onCompleted,
  });

  @override
  State<WorryTimeScreen> createState() => _WorryTimeScreenState();
}

class _WorryTimeScreenState extends State<WorryTimeScreen> {
  final TextEditingController _worryController = TextEditingController();
  final List<String> _worries = [];
  bool _isTimerRunning = false;
  bool _isCompleted = false;
  int _remainingSeconds = 10 * 60; // 10분
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _worryController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isTimerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isCompleted = true);
      }
    });
  }

  void _addWorry() {
    final worry = _worryController.text.trim();
    if (worry.isNotEmpty) {
      setState(() {
        _worries.add(worry);
        _worryController.clear();
      });
    }
  }

  void _removeWorry(int index) {
    setState(() => _worries.removeAt(index));
  }

  void _skipTimer() {
    _timer?.cancel();
    setState(() => _isCompleted = true);
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nameKo),
        centerTitle: true,
        actions: [
          if (_isTimerRunning && !_isCompleted)
            TextButton(
              onPressed: _skipTimer,
              child: const Text('건너뛰기'),
            ),
        ],
      ),
      body: SafeArea(
        child: _isCompleted ? _buildCompletionView(theme) : _buildMainView(theme),
      ),
    );
  }

  Widget _buildMainView(ThemeData theme) {
    return Column(
      children: [
        // 타이머
        Container(
          padding: const EdgeInsets.all(20),
          color: theme.primaryColor.withValues(alpha: 0.1),
          child: Column(
            children: [
              Text(
                _isTimerRunning ? '걱정 비우는 중...' : '걱정 시간 시작하기',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              if (!_isTimerRunning) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('시작하기'),
                ),
              ],
            ],
          ),
        ),

        // 설명
        if (!_isTimerRunning)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: theme.primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          '걱정 시간이란?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '하루 중 정해진 시간에 걱정을 모아서 처리하는 기법입니다.\n\n'
                      '1. 10분 동안 모든 걱정을 적어보세요\n'
                      '2. 적고 나면 마음이 가벼워집니다\n'
                      '3. 이 시간 외에는 걱정을 미뤄두세요\n\n'
                      '걱정은 적으면 작아집니다.',
                      style: TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // 걱정 입력 영역
        if (_isTimerRunning)
          Expanded(
            child: Column(
              children: [
                // 입력 필드
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _worryController,
                          decoration: InputDecoration(
                            hintText: '걱정거리를 적어보세요...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => _addWorry(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _addWorry,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                // 걱정 목록
                Expanded(
                  child: _worries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note, size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text(
                                '걱정을 적어보세요',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _worries.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  Icons.cloud_outlined,
                                  color: Colors.grey[400],
                                ),
                                title: Text(_worries[index]),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
                                  onPressed: () => _removeWorry(index),
                                ),
                              ),
                            );
                          },
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
          Icon(Icons.cloud_done, size: 80, color: Colors.teal),
          const SizedBox(height: 24),
          Text(
            '걱정 비우기 완료!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _worries.isEmpty
                ? '오늘은 걱정이 없었네요. 좋은 하루예요!'
                : '${_worries.length}개의 걱정을 비웠습니다.\n이제 마음이 한결 가벼워졌을 거예요.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),

          // 걱정 요약
          if (_worries.isNotEmpty)
            Card(
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud_outlined, size: 20, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          '오늘 비운 걱정들',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._worries.map((worry) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: TextStyle(color: Colors.teal[300])),
                              Expanded(
                                child: Text(
                                  worry,
                                  style: TextStyle(
                                    color: Colors.teal[700],
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.teal[300],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          const Spacer(),

          const Text(
            '이 걱정들은 지금 여기에 두고 가세요.\n필요하면 내일 다시 생각해도 됩니다.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onCompleted?.call();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
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
