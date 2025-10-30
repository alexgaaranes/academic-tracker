import 'package:academic_tracker/models/grade.dart';
import 'package:flutter/material.dart';

class GradeCalculator extends StatefulWidget {
  const GradeCalculator({super.key});

  @override
  State<GradeCalculator> createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  final List<GradeComponent> _components = [];
  final _componentNameController = TextEditingController();
  final _componentWeightController = TextEditingController();

  void _addComponent() {
    final name = _componentNameController.text.trim();
    final weight = double.tryParse(_componentWeightController.text.trim()) ?? 0;

    if (name.isEmpty || weight <= 0 || weight > 100) return;

    setState(() {
      _components.add(
        GradeComponent(name: name, weight: weight / 100, entries: []),
      );
    });

    _componentNameController.clear();
    _componentWeightController.clear();
  }

  void _addGradeEntry(int componentIndex, double score, double total) {
    final component = _components[componentIndex];
    final updatedEntries = [
      ...component.entries,
      GradeEntry(earned: score, total: total),
    ];

    setState(() {
      _components[componentIndex] = GradeComponent(
        name: component.name,
        weight: component.weight,
        entries: updatedEntries,
      );
    });
  }

  GradeEntry parseScore(String input) {
    double earned = 0;
    double total = 0;

    if (input.contains('/')) {
      final parts = input.split('/');
      if (parts.length == 2) {
        earned = double.tryParse(parts[0].trim()) ?? 0;
        total = double.tryParse(parts[1].trim()) ?? 1;
      }
    } else {
      earned = double.tryParse(input) ?? 0;
      total = earned; // if no total, treat earned as full points
    }

    return GradeEntry(earned: earned, total: total);
  }

  void _showAddEntryDialog(int componentIndex) {
    final scoreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Grade Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: scoreController,
              decoration: InputDecoration(
                labelText: 'Score',
                hintText: 'e.g. 12/20 or 85',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final input = scoreController.text.trim();
              final entry = parseScore(input);
              _addGradeEntry(componentIndex, entry.earned, entry.total);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grade Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // input for new component
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _componentNameController,
                    decoration: const InputDecoration(
                      labelText: 'Component Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _componentWeightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (%)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addComponent,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // list of components
            Expanded(
              child: ListView.builder(
                itemCount: _components.length,
                itemBuilder: (context, index) {
                  final component = _components[index];
                  return Card(
                    child: ExpansionTile(
                      title: Text(
                        '${component.name} (${component.weight * 100}%)',
                      ),
                      children: [
                        ...component.entries.map(
                          (e) => ListTile(
                            title: Text(
                              '${e.earned.toStringAsFixed(1)}/${e.total.toStringAsFixed(1)}',
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddEntryDialog(index),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Entry'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
