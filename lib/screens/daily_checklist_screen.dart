import 'package:flutter/material.dart';
import '../utils/checklist_data.dart';
import '../generated/l10n/app_localizations.dart';

/// Daily Checklist Screen
/// Shows all checklist items grouped by priority
class DailyChecklistScreen extends StatefulWidget {
  const DailyChecklistScreen({super.key});

  @override
  State<DailyChecklistScreen> createState() => _DailyChecklistScreenState();
}

class _DailyChecklistScreenState extends State<DailyChecklistScreen> {
  // Track completion state for each item
  Map<String, bool> completionState = {};
  Map<String, int> counterState = {}; // For items with countRequired

  @override
  void initState() {
    super.initState();
    // Initialize all items as incomplete
    for (final item in ChecklistData.dailyChecklist) {
      completionState[item.id] = false;
      if (item.countRequired != null) {
        counterState[item.id] = 0;
      }
    }
  }

  double get completionRate {
    int completed = 0;
    int total = 0;

    for (final item in ChecklistData.dailyChecklist) {
      if (item.optional) continue; // Skip optional items

      total++;

      if (item.countRequired != null) {
        // Counter items: check if target reached
        if ((counterState[item.id] ?? 0) >= item.countRequired!) {
          completed++;
        }
      } else {
        // Regular checkbox items
        if (completionState[item.id] == true) {
          completed++;
        }
      }
    }

    return total > 0 ? completed / total : 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyChecklistAppBar),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${(completionRate * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: completionRate,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(completionRate * 100).toInt()}% ${l10n.dailyChecklistComplete}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Priority 1 Section
          if (ChecklistData.priority1Items.isNotEmpty) ...[
            _buildSectionHeader(l10n.dailyChecklistPriority1, Colors.red[100]!),
            ...ChecklistData.priority1Items.map((item) =>
              _buildChecklistItem(item)
            ),
            const SizedBox(height: 16),
          ],

          // Priority 2 Section
          if (ChecklistData.priority2Items.isNotEmpty) ...[
            _buildSectionHeader(l10n.dailyChecklistPriority2, Colors.orange[100]!),
            ...ChecklistData.priority2Items.map((item) =>
              _buildChecklistItem(item)
            ),
            const SizedBox(height: 16),
          ],

          // Regular Section
          if (ChecklistData.regularItems.isNotEmpty) ...[
            _buildSectionHeader(l10n.dailyChecklistRegular, Colors.blue[50]!),
            ...ChecklistData.regularItems.map((item) =>
              _buildChecklistItem(item)
            ),
            const SizedBox(height: 16),
          ],

          // Optional Section
          if (ChecklistData.optionalItems.isNotEmpty) ...[
            _buildSectionHeader(l10n.dailyChecklistOptional, Colors.grey[200]!),
            ...ChecklistData.optionalItems.map((item) =>
              _buildChecklistItem(item, isOptional: true)
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item, {bool isOptional = false}) {
    if (item.countRequired != null) {
      // Counter item (e.g., Reality Check)
      return _buildCounterItem(item, isOptional);
    } else {
      // Regular checkbox item
      return _buildCheckboxItem(item, isOptional);
    }
  }

  Widget _buildCheckboxItem(ChecklistItem item, bool isOptional) {
    return Opacity(
      opacity: isOptional ? 0.7 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: CheckboxListTile(
        value: completionState[item.id] ?? false,
        onChanged: (value) {
          setState(() {
            completionState[item.id] = value ?? false;
          });
        },
        title: Row(
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.nameKo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.description),
            if (item.researchNote != null) ...[
              const SizedBox(height: 4),
              Text(
                '📊 ${item.researchNote}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (item.defaultTime != null) ...[
              const SizedBox(height: 4),
              Text(
                '⏰ ${item.defaultTime}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
        isThreeLine: true,
        ),
      ),
    );
  }

  Widget _buildCounterItem(ChecklistItem item, bool isOptional) {
    final l10n = AppLocalizations.of(context);
    final int currentCount = counterState[item.id] ?? 0;
    final int targetCount = item.countRequired ?? 0;
    final double progress = targetCount > 0 ? currentCount / targetCount : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(item.icon, style: const TextStyle(fontSize: 32)),
        title: Text(
          item.nameKo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.description),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyChecklistCounterProgress(currentCount, targetCount),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 40),
                  color: currentCount < targetCount
                      ? Colors.blue
                      : Colors.grey,
                  onPressed: currentCount < targetCount
                      ? () {
                          setState(() {
                            counterState[item.id] = currentCount + 1;
                          });

                          // Show completion dialog when target reached
                          if (currentCount + 1 == targetCount) {
                            _showCompletionDialog(item);
                          }
                        }
                      : null,
                ),
              ],
            ),
            if (item.intervalMinutes != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.dailyChecklistPracticeInterval(item.intervalMinutes!),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _showCompletionDialog(ChecklistItem item) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dailyChecklistCompletionDialogTitle(item.icon)),
        content: Text(l10n.dailyChecklistCompletionDialogContent(item.nameKo)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.dailyChecklistConfirmButton),
          ),
        ],
      ),
    );
  }
}
