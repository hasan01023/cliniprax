import 'package:flutter/material.dart';

class FlutterExamGuideScreen extends StatefulWidget {
  final Locale locale;
  const FlutterExamGuideScreen({super.key, required this.locale});

  @override
  State<FlutterExamGuideScreen> createState() => _FlutterExamGuideScreenState();
}

class _FlutterExamGuideScreenState extends State<FlutterExamGuideScreen> {
  // Configured list of systems to align with backend React modules
  int _activeSystemIdx = 0;
  
  final List<Map<String, dynamic>> _systems = [
    {
      'id': 'respiratory',
      'nameAr': 'الفحص التنفسي العام والإصغاء',
      'nameEn': 'Respiratory Examination & Chest Audit',
      'descAr': 'معاينة الصدر، حركات الأضلاع، وجس الرغامي، والقرع والاصغاء الفصيّ المتماثل.',
      'descEn': 'Inspection of chest wall, chest expansion, tracheal localization, and lung percussion.',
      'steps': [
        {
          'titleAr': 'المعاينة والوقوف في نهاية السرير',
          'titleEn': 'Systematic Observation (End of Bed)',
          'descAr': 'ملاحظة سرعة ونمط تنفس المريض، وتناسق تمدد الصدر وتثاقل المجهود وصوت الصرير إن وجد.',
          'descEn': 'Check breathing pattern, chest excursion symmetry, respiratory rate, and respiratory distress tools.',
          'status': 'In Progress',
          'checkouts': [
            {'labelAr': 'معدل ونمط التنفس المستمر', 'labelEn': 'Respiratory rate count', 'checked': false},
            {'labelAr': 'اتساع وانحسار الصدر بالتطابق', 'labelEn': 'Symmetrical rib excursion', 'checked': false},
          ]
        },
        {
          'titleAr': 'الجس السريري وموضع القصبة الهوائية',
          'titleEn': 'Palpating Tracheal Position & Rib Spread',
          'descAr': 'تحديد مسار الرغامي للتأكد من خلو الصدر من الانحراف أو الاسترواح، وقياس تمدد جدار القفص بالأصابع.',
          'descEn': 'Verify trachea central location in suprasternal notch, and check symmetric thumbs movement on chest expansion.',
          'status': 'Locked',
          'checkouts': [
            {'labelAr': 'انحراف موضع القصبة الهوائية', 'labelEn': 'Tracheal deviation check', 'checked': false},
            {'labelAr': 'قياس تمدد الصدر سنتمترياً باليد', 'labelEn': 'Posterior chest expansion metric', 'checked': false},
          ]
        }
      ]
    },
    {
      'id': 'surg_abdominal',
      'nameAr': 'جراحة البطن العامة والتهيج الحاد',
      'nameEn': 'Surgical Abdomen & Rigidity Check',
      'descAr': 'تقييم ألم البطن الحاد والزائدة الدودية وعلامات تهيج البريتوان والمقاومة العضلية.',
      'descEn': 'Assess acute surgical abdomen, peritoneal signs, rigidity, and rebound guarding.',
      'steps': [
        {
          'titleAr': 'المعاينة السريرية وجس المقاومة العضلية',
          'titleEn': 'Surgical Abdomen Inspection & Rigidity',
          'descAr': 'البحث عن التصلب العضلي غير الإرادي ومناطق استيقاظ الألم السطحي.',
          'descEn': 'Inspect scars and check involuntary abdominal guarding and direct rigidity factors.',
          'status': 'In Progress',
          'checkouts': [
            {'labelAr': 'البحث عن علامات وندبات جراحية', 'labelEn': 'Inspect legacy scars', 'checked': false},
            {'labelAr': 'معاينة تمدد البطن السريري', 'labelEn': 'Look for clinical distension', 'checked': false},
          ]
        }
      ]
    }
  ];

  void _onCheckoutToggle(int systemIndex, int stepIndex, int checkoutIndex) {
    setState(() {
      final system = _systems[systemIndex];
      final steps = system['steps'] as List;
      final step = steps[stepIndex];
      final checkouts = step['checkouts'] as List;
      
      checkouts[checkoutIndex]['checked'] = !checkouts[checkoutIndex]['checked'];

      // Check if all are checked to auto mark Step as Completed and unlock next!
      final allChecked = checkouts.every((dynamic c) => c['checked'] == true);
      if (allChecked) {
        step['status'] = 'Completed';
        // Unlock next step in line
        if (stepIndex + 1 < steps.length) {
          if (steps[stepIndex + 1]['status'] == 'Locked') {
            steps[stepIndex + 1]['status'] = 'In Progress';
          }
        }
      } else {
        step['status'] = 'In Progress';
        // Re-lock all next steps as strict prerequisite logic
        for (int i = stepIndex + 1; i < steps.length; i++) {
          steps[i]['status'] = 'Locked';
          final subCheckouts = steps[i]['checkouts'] as List;
          for (var c in subCheckouts) {
            c['checked'] = false;
          }
        }
      }
    });
  }

  // Calculate dynamic metrics
  double _getSystemProgress(int systemIdx) {
    final system = _systems[systemIdx];
    final steps = system['steps'] as List;
    int completed = steps.where((dynamic s) => s['status'] == 'Completed').length;
    return completed / steps.length;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.locale.languageCode == 'ar';
    final activeSystem = _systems[_activeSystemIdx];
    final List stepsList = activeSystem['steps'];
    final progress = _getSystemProgress(_activeSystemIdx);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Left structural menu selector (Responsive split screen mimic)
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
              child: ListView.builder(
                itemCount: _systems.length,
                itemBuilder: (context, idx) {
                  final sys = _systems[idx];
                  final sysName = isAr ? sys['nameAr'] : sys['nameEn'];
                  final sysDesc = isAr ? sys['descAr'] : sys['descEn'];
                  final isActive = idx == _activeSystemIdx;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _activeSystemIdx = idx;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF006774).withOpacity(0.05) : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: isActive ? const Color(0xFF006774) : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sysName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isActive ? const Color(0xFF006774) : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sysDesc,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _getSystemProgress(idx),
                              backgroundColor: Colors.grey.shade200,
                              color: const Color(0xFF006774),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Right main checklists detail stream
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Circular Progress summary header card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 6,
                                  backgroundColor: Colors.grey.shade100,
                                  color: const Color(0xFF006774),
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAr ? activeSystem['nameAr'] : activeSystem['nameEn'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Text(
                                  isAr ? 'حالة إكمال المتطلبات السريرية' : 'Module completion metrics tracker',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Steps ListView
                  ...List.generate(stepsList.length, (stepIdx) {
                    final step = stepsList[stepIdx];
                    final stepTitle = isAr ? step['titleAr'] : step['titleEn'];
                    final stepDesc = isAr ? step['descAr'] : step['descEn'];
                    final String status = step['status'];
                    final bool isLocked = status == 'Locked';
                    final bool isCompleted = status == 'Completed';

                    return Card(
                      elevation: 0,
                      color: isLocked ? Colors.grey.shade50 : Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isLocked ? Colors.grey.shade100 : Colors.grey.shade200,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Expanded(
                                  child: Text(
                                    '0${stepIdx + 1}. $stepTitle',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isLocked ? Colors.grey : Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? Colors.emerald.shade50
                                        : (isLocked ? Colors.grey.shade100 : const Color(0xFF006774).withOpacity(0.08)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isCompleted
                                        ? (isAr ? 'مكتمل' : 'Completed')
                                        : (isLocked ? (isAr ? 'مغلق' : 'Locked') : (isAr ? 'جاري' : 'In Progress')),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted
                                          ? Colors.emerald.shade700
                                          : (isLocked ? Colors.grey : const Color(0xFF006774)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              stepDesc,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: isLocked ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                            if (!isLocked) ...[
                              const Divider(height: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: List.generate((step['checkouts'] as List).length, (chkIdx) {
                                  final chk = step['checkouts'][chkIdx];
                                  final label = isAr ? chk['labelAr'] : chk['labelEn'];
                                  final bool val = chk['checked'];

                                  return InputChip(
                                    label: Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: val ? FontWeight.bold : FontWeight.normal,
                                        color: val ? const Color(0xFF006774) : Colors.black87,
                                      ),
                                    ),
                                    selected: val,
                                    selectedColor: const Color(0xFF006774).withOpacity(0.1),
                                    checkmarkColor: const Color(0xFF006774),
                                    onSelected: (selected) {
                                      _onCheckoutToggle(_activeSystemIdx, stepIdx, chkIdx);
                                    },
                                  );
                                }),
                              ),
                            ],
                            if (isLocked) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock, size: 12, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    isAr ? 'أكمل المتطلبات في الأعلى لفتح الفحص' : 'Complete previous steps to unlock',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      );
                    });
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
