import 'package:flutter/material.dart';
import 'socrates_screen.dart';
import 'exam_screen.dart';
import 'reviews_screen.dart';

class HomeScreen extends StatefulWidget {
  final Locale locale;
  final VoidCallback onToggleLanguage;

  const HomeScreen({
    super.key,
    required this.locale,
    required this.onToggleLanguage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedDept;
  int _activeBottomNavIdx = 0;
  String _searchQuery = '';
  String? _selectedCategory;

  // Department definitions
  final List<Map<String, dynamic>> _departments = [
    {
      'id': 'internal',
      'nameAr': 'الطب الباطني',
      'nameEn': 'Internal Medicine',
      'descAr': 'استقصاء الحالات القلبية، التنفسية والهضمية الشائعة عبر بروتوكولات المتابعة الطبية.',
      'descEn': 'Investigate cardiac, respiratory, and GI conditions with structured history taking.',
      'color': const Color(0xFF10B981),
      'icon': Icons.favorite,
    },
    {
      'id': 'surgery',
      'nameAr': 'الجراحة العامة',
      'nameEn': 'General Surgery',
      'descAr': 'تقييم البطن الجراحي الحاد، الفتوق، وحالات قصور التروية الشريانية الطرفية.',
      'descEn': 'Assess acute surgical abdomen, hernias, and lower limb peripheral ischemia cases.',
      'color': const Color(0xFFF59E0B),
      'icon': Icons.shield,
    },
    {
      'id': 'pediatrics',
      'nameAr': 'طب الأطفال',
      'nameEn': 'Pediatrics',
      'descAr': 'تشخيص اليرقان الوليدي، صعوبات التغذية، وميكانيكية التنفس عند الرضع والأطفال.',
      'descEn': 'Navigate neonatal jaundice diagnostics, poor infant feeding, and pediatric respiratory rate checkups.',
      'color': const Color(0xFF6366F1),
      'icon': Icons.child_care,
    },
    {
      'id': 'obgyn',
      'nameAr': 'أمراض النساء والولادة',
      'nameEn': 'Obstetrics & Gynecology',
      'descAr': 'إدارة حالات النزيف التوليدي، ما قبل الارتعاج، والنزيف المهبلي غير المنتظم.',
      'descEn': 'Manage antepartum hemorrhage risks, pre-eclampsia warnings, and abnormal uterine bleeding.',
      'color': const Color(0xFFEC4899),
      'icon': Icons.cloud,
    }
  ];

  // Symptoms data map representing the identical logic of React site
  final Map<String, Map<String, List<Map<String, String>>>> _symptomsData = {
    'internal': {
      'Cardiology': [
        {
          'titleAr': 'ألم الصدر قيد الاستقصاء',
          'titleEn': 'Chest Pain (R/O ACS)',
          'descAr': 'تقييم الألم الإكليلي، خصائصه الإقفارية، والانتشار للكتف الأيسر والفك السفلي.',
          'descEn': 'Assess coronary blood flow risks, ischemic duration, jaw/shoulder radiation and risk factors.',
        }
      ],
      'Pulmonology': [
        {
          'titleAr': 'ضيق التنفس الحاد وذات الرئة',
          'titleEn': 'Acute Dyspnea & Pneumonia',
          'descAr': 'البحث في المسببات من وذمة رئة، التهاب قصبات حاد، أو انصمام رئوي صاعق.',
          'descEn': 'Investigate sudden onset dyspnea, sputum cough quality, and pleuritic chest discomfort.',
        }
      ],
      'Gastroenterology': [
        {
          'titleAr': 'ألم البطن الحاد والقولون',
          'titleEn': 'Acute Abdominal Pain & GI',
          'descAr': 'تحري العوامل المفاجئة لألم المعدة، التهاب البنكرياس، والمرارة.',
          'descEn': 'Analyze acute upper abdominal colic, biliary spasms, or generalized IBS triggers.',
        }
      ]
    },
    'surgery': {
      'Surgical Abdomen': [
        {
          'titleAr': 'ألم الزائدة الدودية والبطن الحاد',
          'titleEn': 'Appendicitis & Surgical Abdomen',
          'descAr': 'علامات تهيج البريتوان والمقاومة العضلية ونقاط ألم الماكبورني.',
          'descEn': 'Assess migrating pain, rebound tenderness, rigidity, and lower right quadrant guarding.',
        },
        {
          'titleAr': 'انسداد الأمعاء الدقيقة والغليظة',
          'titleEn': 'Intestinal Obstruction Diagnosis',
          'descAr': 'تفحص علامات التمدد المعوي والتقيؤ الصفراوي والإمساك المطلق السريري.',
          'descEn': 'Differentiate mechanical bowel distension, bilious emesis, and absolute constipation rules.',
        }
      ],
      'Hernias & Swellings': [
        {
          'titleAr': 'الفتوق والتورمات الإربية',
          'titleEn': 'Inguinal Hernias & Groin Swellings',
          'descAr': 'فحص دفع السعال وتفريق الفصول القابلة للاختزال عن الفتوق المختنقة.',
          'descEn': 'Examine reducible vs strangulated/incarcerated groin hernias and impulse on coughing.',
        }
      ],
      'Vascular Cases': [
        {
          'titleAr': 'العرج المتقطع ونقص تروية الأطراف',
          'titleEn': 'Claudication & Limb Ischemia',
          'descAr': 'تفقد نبض الشраيين الطرفية ووقت إعادة الامتلاء الشعري والحرارة.',
          'descEn': 'Assess lower limb pulses, capillary refill time, sensory losses, and chronic ischemic signs.',
        }
      ]
    },
    'pediatrics': {
      'Neonatology': [
        {
          'titleAr': 'اليرقان الوليدي وتحت السريري',
          'titleEn': 'Neonatal Jaundice',
          'descAr': 'اليرقان الفسيولوجي مقابل المرضي وأعلام الخطر ومستوى البيليروبين.',
          'descEn': 'Distinguish physiologic from pathologic jaundice, active feeding response, and scleral state.',
        },
        {
          'titleAr': 'صعوبة التغذية والوهن عند الرضع',
          'titleEn': 'Poor Feeding & Floppy Infant',
          'descAr': 'ملاحظة منعكس المص وتقييم مرونة العضلات وعلامات الجفاف كالغاف الغائر.',
          'descEn': 'Check fontanelle depth, poor feeding habits, weak sucking reflex, and infant muscle tone.',
        }
      ],
      'Respiratory & Infections': [
        {
          'titleAr': 'الصفير والتنفس السريع للأطفال',
          'titleEn': 'Pediatric Wheeze & Tachypnea',
          'descAr': 'دراسة التهاب القصيبات الهوائية ومعدلات التنفس والانسحابات التنفسية حسب العمر.',
          'descEn': 'Count respiratory rates by age group, subcostal retractions, and childhood wheeze characteristics.',
        }
      ]
    },
    'obgyn': {
      'Obstetrics': [
        {
          'titleAr': 'نزيف ما قبل الولادة والحمل المبكر',
          'titleEn': 'Antepartum & Early Pregnancy Bleeding',
          'descAr': 'الاشتباه بالإجهاض المنذر، الحمل الهاجر والنزيف التوليدي لسرير آمن.',
          'descEn': 'Assess early pregnancy bleeding, ectopic rupture risk, and late third-trimester bleeding causes.',
        },
        {
          'titleAr': 'أعراض ما قبل الارتعاج وتسمم الحمل',
          'titleEn': 'Pre-eclampsia Warning Signs',
          'descAr': 'الصداع البصري، تشوش الرؤية، الألم الشرسوفي والمنعكسات العضلية الزائدة.',
          'descEn': 'Screen for visual disturbances, epigastric pain, hyperreflexia, and sudden edema.',
        }
      ],
      'Gynecology': [
        {
          'titleAr': 'نزيف الرحم غير الطبيعي وضوابطه',
          'titleEn': 'Abnormal Uterine Bleeding',
          'descAr': 'تصنيف PALM-COEIN السريري لأسباب النزيف والحديث عن انقطاع الطمث.',
          'descEn': 'Investigate polyps, adenomyosis, hormonal dysregulations using PALM-COEIN classifications.',
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final isAr = widget.locale.languageCode == 'ar';

    if (_selectedDept == null) {
      return _buildLandingPage(isAr);
    } else {
      return _buildDepartmentPortal(isAr);
    }
  }

  // Welcome / Rotations Selection Landing layout
  Widget _buildLandingPage(bool isAr) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isAr ? 'منصة كلينيبراكس السريرية' : 'Cliniprax OSCE Hub',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF006774)),
            ),
            Text(
              isAr ? 'محاكاة السيرة المرضية والفحص السريري' : 'OSCE History & Physical Exam Simulator',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton.icon(
            onPressed: widget.onToggleLanguage,
            icon: const Icon(Icons.language, size: 16, color: Color(0xFF006774)),
            label: Text(
              isAr ? 'English' : 'العربية',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006774)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Banner matching the React styling cues
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF006774), Color(0xFF004D56)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF006774).withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isAr ? 'بوابة الطبيب المساعد المتكاملة' : 'Integrated Smart OSCE Suite',
                        style: const TextStyle(color: Color(0xFF69E8FE), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isAr ? 'اختر التخصص السريري للتدريب' : 'Select Rotation Department',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.extrabold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isAr 
                        ? 'محاكاة كاملة لطرق أخذ التاريخ المرضي والفحص السريري العيني للأجنحة لكل مستويات طلبة الطب بجودة عالية.' 
                        : 'Full simulator tracking medical history procedures and standard OSCE checkup sheets for clinical rotation stages.',
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, height: 1.4),
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title Header
              Text(
                isAr ? 'الأقسام والتدويرات السريرية المعتمدة' : 'Accredited Faculty Rotations',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.extrabold, color: Color(0xFF006774)),
                textAlign: isAr ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 14),

              // Grid / List of Departments
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _departments.length,
                itemBuilder: (context, idx) {
                  final dept = _departments[idx];
                  final name = isAr ? dept['nameAr'] : dept['nameEn'];
                  final desc = isAr ? dept['descAr'] : dept['descEn'];
                  final color = dept['color'] as Color;
                  final icon = dept['icon'] as IconData;

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDept = dept['id'];
                          _activeBottomNavIdx = 0;
                          _selectedCategory = null;
                          _searchQuery = '';
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(icon, color: color, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF006774)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    desc,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isAr ? Icons.chevron_left : Icons.chevron_right,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Interactive About Box matching Cliniprax details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.slate.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.flash_on, color: Color(0xFF69E8FE), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          isAr ? 'عن مبادرة الطبيب المتدرب' : 'Under Graduate Doctor Lead',
                          style: const TextStyle(color: Color(0xFF69E8FE), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isAr
                        ? 'تطبيق سريري متكامل صُمّم لدعم أطباء الامتياز في اجتياز الامتحانات العملية OSCE. إشراف الطبيب المطور: سعيد مروان الشيباني.'
                        : 'Integrated clinical toolset targeting medical final OSCE exams success. Designed under guidance for medical students.',
                      style: TextStyle(color: Colors.slate.shade300, fontSize: 11, height: 1.4),
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Active department portal matching tab transitions in React component
  Widget _buildDepartmentPortal(bool isAr) {
    final deptData = _departments.firstWhere((d) => d['id'] == _selectedDept);
    final deptName = isAr ? deptData['nameAr'] : deptData['nameEn'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedDept = null;
            });
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deptName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF006774)),
            ),
            Text(
              isAr ? 'مجموعة الفحوص السريرية النشطة' : 'Active OSCE Clinical Suite',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton.icon(
            onPressed: widget.onToggleLanguage,
            icon: const Icon(Icons.language, size: 14, color: Color(0xFF006774)),
            label: Text(
              isAr ? 'EN' : 'AR',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006774)),
            ),
          ),
        ],
      ),
      body: _buildSelectedTabBody(isAr),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeBottomNavIdx,
        onTap: (index) {
          setState(() {
            _activeBottomNavIdx = index;
          });
        },
        selectedItemColor: const Color(0xFF006774),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_edu),
            label: isAr ? 'السيرة SOCRATES' : 'SOCRATES History',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_box),
            label: isAr ? 'قوائم OSCE' : 'OSCE Sheets',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.comment),
            label: isAr ? 'تجارب الأجنحة' : 'Student Advice',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabBody(bool isAr) {
    switch (_activeBottomNavIdx) {
      case 0:
        return _buildSocratesSymptomsTab(isAr);
      case 1:
        return FlutterExamGuideScreen(locale: widget.locale);
      case 2:
        return FlutterReviewsScreen(locale: widget.locale);
      default:
        return _buildSocratesSymptomsTab(isAr);
    }
  }

  // Symptoms Selection Sub-Page under Department context
  Widget _buildSocratesSymptomsTab(bool isAr) {
    final deptSymptoms = _symptomsData[_selectedDept] ?? {};
    final categories = deptSymptoms.keys.toList();
    
    // Filter symptoms by search query if applicable
    Map<String, List<Map<String, String>>> filteredSymptoms = {};
    for (var cat in categories) {
      final list = deptSymptoms[cat] ?? [];
      final filteredList = list.where((sym) {
        final title = isAr ? sym['titleAr']! : sym['titleEn']!;
        return title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      if (filteredList.isNotEmpty) {
        filteredSymptoms[cat] = filteredList;
      }
    }

    final displayCategories = _selectedCategory == null 
        ? filteredSymptoms.keys.toList() 
        : [ _selectedCategory! ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Field
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            enableInteractiveSelection: false,
            decoration: InputDecoration(
              hintText: isAr ? 'البحث عن عرض أو سيرة مرضية...' : 'Search clinical symptoms / complaints...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF006774)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF006774), width: 1.5),
              ),
              isDense: true,
              fillColor: Colors.white,
              filled: true,
            ),
            style: const TextStyle(fontSize: 13),
            textAlign: isAr ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 16),

          // Horizontal Category Chip filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(isAr ? 'الكل' : 'All'),
                    selected: _selectedCategory == null,
                    selectedColor: const Color(0xFF006774).withOpacity(0.12),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: _selectedCategory == null ? const Color(0xFF006774) : Colors.black87,
                      fontWeight: _selectedCategory == null ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                ),
                ...categories.map((cat) {
                  final active = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: active,
                      selectedColor: const Color(0xFF006774).withOpacity(0.12),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: active ? const Color(0xFF006774) : Colors.black87,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                    ),
                  );
                }).toList()
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Symptom Complaint items list
          Expanded(
            child: displayCategories.isEmpty
                ? Center(
                    child: Text(
                      isAr ? 'لم نجد أي أعراض تطابق البحث.' : 'No diagnostic complaints found.',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: displayCategories.length,
                    itemBuilder: (context, catIdx) {
                      final category = displayCategories[catIdx];
                      final syms = filteredSymptoms[category] ?? [];

                      return Column(
                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006774),
                              ),
                            ),
                          ),
                          ...syms.map((s) {
                            final symptomTitle = isAr ? s['titleAr']! : s['titleEn']!;
                            final symptomDesc = isAr ? s['descAr']! : s['descEn']!;

                            return Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      symptomTitle,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      symptomDesc,
                                      style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SocratesSimulatorScreen(
                                                locale: widget.locale,
                                                activeSymptom: symptomTitle,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.flash_on, size: 14, color: Colors.white),
                                        label: Text(
                                          isAr ? 'بدء سيرة SOCRATES' : 'Start SOCRATES Interview',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF006774),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, py: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
