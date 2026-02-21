import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const DailyHelperToolkitApp());
}

class DailyHelperToolkitApp extends StatefulWidget {
  const DailyHelperToolkitApp({super.key});

  @override
  State<DailyHelperToolkitApp> createState() => _DailyHelperToolkitAppState();
}

class _DailyHelperToolkitAppState extends State<DailyHelperToolkitApp> {
  String _displayName = 'Learner';
  MaterialColor _themeColor = Colors.indigo;
  int _currentIndex = 0;

  late final List<ToolModule> modules = [
    BmiModule(),
    StudyTimerModule(),
    ExpenseSplitterModule(),
  ];

  void _openPersonalizationSheet() {
    final TextEditingController nameController = TextEditingController(
      text: _displayName,
    );
    MaterialColor selectedColor = _themeColor;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Personalize App'),
          content: StatefulBuilder(
            builder: (context, setInnerState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Display name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Theme color'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _ColorOption(
                        label: 'Blue',
                        color: Colors.blue,
                        selected: selectedColor == Colors.blue,
                        onTap: () {
                          setInnerState(() {
                            selectedColor = Colors.blue;
                          });
                        },
                      ),
                      _ColorOption(
                        label: 'Green',
                        color: Colors.green,
                        selected: selectedColor == Colors.green,
                        onTap: () {
                          setInnerState(() {
                            selectedColor = Colors.green;
                          });
                        },
                      ),
                      _ColorOption(
                        label: 'Purple',
                        color: Colors.purple,
                        selected: selectedColor == Colors.purple,
                        onTap: () {
                          setInnerState(() {
                            selectedColor = Colors.purple;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String newName = nameController.text.trim();
                setState(() {
                  _displayName = newName.isEmpty ? 'Learner' : newName;
                  _themeColor = selectedColor;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('Saved! Hi, $_displayName'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Helper Toolkit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _themeColor,
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          final ToolModule currentModule = modules[_currentIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text('Hi, $_displayName'),
              actions: [
                IconButton(
                  tooltip: 'Personalize',
                  onPressed: _openPersonalizationSheet,
                  icon: const Icon(Icons.tune),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(44),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Icon(currentModule.icon),
                      const SizedBox(width: 8),
                      Text(
                        currentModule.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: modules
                  .map((module) => module.buildBody(context))
                  .toList(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: modules
                  .map(
                    (module) => BottomNavigationBarItem(
                      icon: Icon(module.icon),
                      label: module.title,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selectedColor: color.withValues(alpha: 0.25),
      selected: selected,
      avatar: CircleAvatar(backgroundColor: color),
      onSelected: (_) => onTap(),
    );
  }
}

abstract class ToolModule {
  String get title;

  IconData get icon;

  Widget buildBody(BuildContext context);
}

class BmiModule extends ToolModule {
  final Widget _body = const _BmiModuleBody();

  @override
  String get title => 'BMI Checker';

  @override
  IconData get icon => Icons.monitor_weight_outlined;

  @override
  Widget buildBody(BuildContext context) => _body;
}

class _BmiModuleBody extends StatefulWidget {
  const _BmiModuleBody();

  @override
  State<_BmiModuleBody> createState() => _BmiModuleBodyState();
}

class _BmiModuleBodyState extends State<_BmiModuleBody> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _heightCm;
  double? _weightKg;
  double? _bmiResult;
  String _category = '-';

  void compute() {
    final double? height = double.tryParse(_heightController.text.trim());
    final double? weight = double.tryParse(_weightController.text.trim());

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid positive numbers.')),
      );
      return;
    }

    final double meters = height / 100;
    final double bmi = weight / (meters * meters);

    setState(() {
      _heightCm = height;
      _weightKg = weight;
      _bmiResult = bmi;
      if (bmi < 18.5) {
        _category = 'Underweight';
      } else if (bmi < 25) {
        _category = 'Normal';
      } else if (bmi < 30) {
        _category = 'Overweight';
      } else {
        _category = 'Obese';
      }
    });
  }

  void reset() {
    setState(() {
      _heightCm = null;
      _weightKg = null;
      _bmiResult = null;
      _category = '-';
      _heightController.clear();
      _weightController.clear();
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Check your BMI quickly'),
          const SizedBox(height: 12),
          TextField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              hintText: 'e.g., 170',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'e.g., 65',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: compute,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Compute'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Result'),
                  const SizedBox(height: 8),
                  Text('BMI: ${_bmiResult?.toStringAsFixed(2) ?? '-'}'),
                  Text('Category: $_category'),
                ],
              ),
            ),
          ),
          if (_heightCm != null && _weightKg != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Text('Input used: ${_heightCm!.toStringAsFixed(1)} cm, '
                  '${_weightKg!.toStringAsFixed(1)} kg'),
            ),
          ],
        ],
      ),
    );
  }
}

class StudyTimerModule extends ToolModule {
  final Widget _body = const _StudyTimerModuleBody();

  @override
  String get title => 'Study Timer';

  @override
  IconData get icon => Icons.timer_outlined;

  @override
  Widget buildBody(BuildContext context) => _body;
}

class _StudyTimerModuleBody extends StatefulWidget {
  const _StudyTimerModuleBody();

  @override
  State<_StudyTimerModuleBody> createState() => _StudyTimerModuleBodyState();
}

class _StudyTimerModuleBodyState extends State<_StudyTimerModuleBody> {
  final TextEditingController _minutesController = TextEditingController();
  final List<String> _sessionLog = [];

  Timer? _timer;
  int _secondsLeft = 0;
  bool _running = false;

  void startTimer() {
    final int? minutes = int.tryParse(_minutesController.text.trim());
    if (minutes == null || minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid minutes greater than zero.')),
      );
      return;
    }

    _timer?.cancel();
    setState(() {
      _secondsLeft = minutes * 60;
      _running = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsLeft <= 1) {
        timer.cancel();
        _logSession(minutes);
        setState(() {
          _secondsLeft = 0;
          _running = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session completed! Nice work.')),
        );
      } else {
        setState(() {
          _secondsLeft -= 1;
        });
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _running = false;
    });
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _secondsLeft = 0;
      _minutesController.clear();
    });
  }

  void _logSession(int minutes) {
    final DateTime now = DateTime.now();
    setState(() {
      _sessionLog.insert(
        0,
        '${minutes}m at '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}',
      );
    });
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Session minutes',
              hintText: 'e.g., 25',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Column(
              children: [
                const Text('Countdown'),
                const SizedBox(height: 6),
                Text(
                  _formatTime(_secondsLeft),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _running ? null : startTimer,
                  child: const Text('Start'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _running ? stopTimer : null,
                  child: const Text('Stop'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: reset,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 8),
              Text('Completed Sessions'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _sessionLog.isEmpty
                ? const Center(child: Text('No sessions yet.'))
                : ListView.builder(
                    itemCount: _sessionLog.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text(_sessionLog[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ExpenseSplitterModule extends ToolModule {
  final Widget _body = const _ExpenseSplitterModuleBody();

  @override
  String get title => 'Expense Splitter';

  @override
  IconData get icon => Icons.receipt_long_outlined;

  @override
  Widget buildBody(BuildContext context) => _body;
}

class _ExpenseSplitterModuleBody extends StatefulWidget {
  const _ExpenseSplitterModuleBody();

  @override
  State<_ExpenseSplitterModuleBody> createState() =>
      _ExpenseSplitterModuleBodyState();
}

class _ExpenseSplitterModuleBodyState extends State<_ExpenseSplitterModuleBody> {
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _paxController = TextEditingController();

  double _tipPercent = 10;
  double? _total;
  int? _pax;
  double? _perPerson;
  double? _tipAmount;

  void compute() {
    final double? total = double.tryParse(_totalController.text.trim());
    final int? pax = int.tryParse(_paxController.text.trim());

    if (total == null || total <= 0 || pax == null || pax <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid total and pax greater than zero.'),
        ),
      );
      return;
    }

    final double tipAmount = total * (_tipPercent / 100);
    final double finalTotal = total + tipAmount;
    final double personShare = finalTotal / pax;

    setState(() {
      _total = total;
      _pax = pax;
      _tipAmount = tipAmount;
      _perPerson = personShare;
    });
  }

  void reset() {
    setState(() {
      _tipPercent = 10;
      _total = null;
      _pax = null;
      _tipAmount = null;
      _perPerson = null;
      _totalController.clear();
      _paxController.clear();
    });
  }

  @override
  void dispose() {
    _totalController.dispose();
    _paxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _totalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Total bill',
              hintText: 'e.g., 1200',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _paxController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of people (pax)',
              hintText: 'e.g., 4',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text('Tip: ${_tipPercent.toStringAsFixed(0)}%'),
          Slider(
            value: _tipPercent,
            min: 0,
            max: 30,
            divisions: 30,
            label: '${_tipPercent.toStringAsFixed(0)}%',
            onChanged: (value) {
              setState(() {
                _tipPercent = value;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: compute,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Split'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.clear),
                  label: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Per person: ${_perPerson?.toStringAsFixed(2) ?? '-'}'),
                  const SizedBox(height: 8),
                  const Text('Breakdown'),
                  const SizedBox(height: 6),
                  Text('Bill: ${_total?.toStringAsFixed(2) ?? '-'}'),
                  Text('Tip: ${_tipAmount?.toStringAsFixed(2) ?? '-'}'),
                  Text('Pax: ${_pax?.toString() ?? '-'}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
