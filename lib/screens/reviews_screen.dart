import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

// Doctor and Case structures matching the React enterprise database
class DoctorOSCEProfile {
  final String id;
  final String doctorNameAr;
  final String doctorNameEn;
  final String deptAr;
  final String deptEn;
  final String hospitalAr;
  final String hospitalEn;
  final String avatarUrl;
  final List<OSCECase> cases;

  DoctorOSCEProfile({
    required this.id,
    required this.doctorNameAr,
    required this.doctorNameEn,
    required this.deptAr,
    required this.deptEn,
    required this.hospitalAr,
    required this.hospitalEn,
    required this.avatarUrl,
    required this.cases,
  });
}

class OSCECase {
  final String id;
  final String titleAr;
  final String titleEn;
  final String typeAr;
  final String typeEn;
  final List<String> questionsAr;
  final List<String> questionsEn;

  OSCECase({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.typeAr,
    required this.typeEn,
    required this.questionsAr,
    required this.questionsEn,
  });
}

class FlutterReviewsScreen extends StatefulWidget {
  final Locale locale;
  const FlutterReviewsScreen({super.key, required this.locale});

  @override
  State<FlutterReviewsScreen> createState() => _FlutterReviewsScreenState();
}

class _FlutterReviewsScreenState extends State<FlutterReviewsScreen> {
  // Switcher: "doctors" (Doctor Cases explorer) / "reviews" (General student advice)
  String _activeTab = 'doctors';
  String _searchQuery = '';
  String _selectedDeptFilter = 'All';

  // Loading and Dynamic data states
  bool _isLoading = false;
  List<DoctorOSCEProfile> _dynamicDoctors = [];
  List<Map<String, dynamic>> _dynamicReviews = [];

  // Seed Doctor OSCE Data representing the React database (fallback)
  final List<DoctorOSCEProfile> _doctorsList = [
    DoctorOSCEProfile(
      id: "dr_tahani",
      doctorNameAr: "د. تهاني",
      doctorNameEn: "Dr. Tahani",
      deptAr: "الجراحة العامة",
      deptEn: "General Surgery",
      hospitalAr: "مستشفى الثورة",
      hospitalEn: "Thora Hospital",
      avatarUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCoT9c6fe8u7Oj1eeqYIJM7EZ6WIXsCyC9HoUxC4bWJmCXmxQ9meoMF7VNkXplfsKU6EFYTPxWXej73eWtPbem_NznKC1RJ6uTOH129CEgUjuVQ_ot0CAuko6fB4y2Z6nRn0I90qZbXM3zASysPkeuIZSKCQrXYCkvXS93uyqcnn2LzVPh1MMoOg47RdD4xgmaanWLrpEPxhsqqtgkVWB4hCuiOdHe891wdE_1Ck6lr0dehuBMh8C3TyeqxN__o_rYLyfOqCcjJWYs",
      cases: [
        OSCECase(
          id: "tahani_c1",
          titleAr: "مريض يعاني من جرح طعن في الجزء الخلفي من الصدر الأيمن (حالة طويلة)",
          titleEn: "Male patient with a stab wound to the back of the right chest (Long case)",
          typeAr: "حالة جراحية طويلة",
          typeEn: "Long Case",
          questionsAr: [
            "تحديد وفحص الأنبوب الصدري (لون وحجم السائل المصرف، هل يعمل أم لا، انتفاخ غازات تحت الجلد Subcutaneous Emphysema، التأكد من عدم وجود التواء أو انسداد).",
            "متى يجب إزالة الأنبوب الصدري؟",
            "كيف يتم إزالة الأنبوب الصدري خطوة بخطوة سريرياً؟"
          ],
          questionsEn: [
            "Identify and assess a chest tube (drained fluid color and volume, working or not, subcutaneous emphysema, no kinking or obstruction).",
            "When is it indicated to remove a chest tube?",
            "How is a chest tube removed step-by-step?"
          ],
        ),
      ],
    ),
    DoctorOSCEProfile(
      id: "dr_fares_hajjami",
      doctorNameAr: "د. فارس الحجامي",
      doctorNameEn: "Dr. Fares Al-Hajjami",
      deptAr: "الجراحة العامة وطب الطوارئ",
      deptEn: "General Surgery & Emergency Medicine",
      hospitalAr: "مستشفى الجمهوري والكويت",
      hospitalEn: "Al-Gomhori & Kuwait Hospital",
      avatarUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDUBDgDkiBV194Oxf8zlAVQcltFXm0waVP6pyNr0goZmtJlh6wO6sBezGh8nW_9nFw0KwAdxZHrdav7NnEgpJp5aPUy3WUAoksab5GjED3_RFNhYer6XSon7FgBkOkHciHpJstC-D1MM8plsE-brgSAO5437m6UCI8hIL9acVYkBGcOXD2NxfNFFHiO0lyBJ1AbfizXd5qtYtGwF7Or6hXoAAzmO1BsqI0_6shdN2JPnViMiwL7GBWdwaZxYWOfOwg9nXk5VPKYaIo",
      cases: [
        OSCECase(
          id: "fares_c1",
          titleAr: "مريض ذكر بقسطرة وريد مركزي في الوريد الوداجي الداخلي وأنبوب صدري",
          titleEn: "Male patient with central venous catheter (CVC) in the internal jugular vein and a chest tube",
          typeAr: "فحص ومهارات عملية",
          typeEn: "Bedside Skills Case",
          questionsAr: [
            "كيف تجري الانطباع العام الأولي للمريض (General Impression)؟",
            "ما هي المواقع البديلة التي قد تجد فيها قسطرة وريد مركزي (CVC)؟",
            "قارن بين مميزات قسطرة الوريد الوداجي الداخلي وقسطرة وريد تحت الترقوة.",
            "أيهما يرتبط بخطر أعلى للإصابة باسترواح الصدر (Pneumothorax)؟",
            "لماذا لا يفضل استخدام القسطرة المركزية عبر الوريد الفخذي (Femoral CVC)؟",
            "كيف يتم تقييم وضمان عمل الأنبوب الصدري؟",
            "ما هي أسباب تصريف سائل مصلي (Serous fluid) من الأنبوب الصدري المصاحب؟",
            "افحص النبض كمهارة عملية تفصيلية.",
          ],
          questionsEn: [
            "Perform general impression on the patient.",
            "In what anatomical sites may you find a central venous catheter (CVC)?",
            "Compare clinical aspects of internal jugular vein and subclavian vein catheters.",
            "Which CVC placement site is associated with a higher risk of pneumothorax?",
            "Why is a femoral central venous catheter not preferred for routine use?",
            "How do you clinically assess and troubleshoot a chest tube?",
            "What are the main causes of serous drained fluid in the chest tube?",
            "Perform a practical clinical pulse examination.",
          ],
        ),
        OSCECase(
          id: "fares_c2",
          titleAr: "اليرقان الانسدادي (حالة طويلة جراحية)",
          titleEn: "Obstructive jaundice (Long case)",
          typeAr: "حالة جراحية طويلة",
          typeEn: "Long Case",
          questionsAr: [
            "ما هي الفيسيولوجيا المرضية وأسباب اليرقان الانسدادي (Obstructive Jaundice)؟",
            "ما هي الأنواع الرئيسية الثلاثة لليرقان (Jaundice)؟",
            "ضع تصنيفاً للتشخيص التفريقي (Differential Diagnosis) لمريض يعاني من اصفرار العينين والبول.",
            "ما هي الاستقصاءات والفحوصات (Investigations) المخبرية والشعاعية لتشخيص حصوات المجرى الصفراوي؟",
            "ما هي السبل العلاجية والجراحية المتاحة؟",
            "ما هي وظائف أملاح الصفراء (Bile Salts) فسيولوجياً؟",
            "ما هي الأنواع المختلفة لحصوات المرارة (Gallstones)؟"
          ],
          questionsEn: [
            "What are the main causes and obstructive signs of jaundice?",
            "Detail the types of jaundice (Pre-hepatic, Intra-hepatic, Post-hepatic).",
            "Provide a structured differential diagnosis for Post-hepatic jaundice.",
            "What laboratory and radiological investigations are prioritized for CBD stones?",
            "Discuss the chemical and physical treatment lines of biliary stones.",
            "What is the function of bile salts in digestion and absorption?",
            "Enumerate the classifications of gallstones (Cholesterol, Pigment, Mixed)."
          ],
        )
      ],
    ),
    DoctorOSCEProfile(
      id: "dr_ali_sabahi",
      doctorNameAr: "د. علي الصبحي",
      doctorNameEn: "Dr. Ali Al-Sabahi",
      deptAr: "الجراحة العامة ورعاية الطوارئ",
      deptEn: "General Surgery & Critical Care",
      hospitalAr: "مستشفى الكويت",
      hospitalEn: "Kuwait Hospital",
      avatarUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCoT9c6fe8u7Oj1eeqYIJM7EZ6WIXsCyC9HoUxC4bWJmCXmxQ9meoMF7VNkXplfsKU6EFYTPxWXej73eWtPbem_NznKC1RJ6uTOH129CEgUjuVQ_ot0CAuko6fB4y2Z6nRn0I90qZbXM3zASysPkeuIZSKCQrXYCkvXS93uyqcnn2LzVPh1MMoOg47RdD4xgmaanWLrpEPxhsqqtgkVWB4hCuiOdHe891wdE_1Ck6lr0dehuBMh8C3TyeqxN__o_rYLyfOqCcjJWYs",
      cases: [
        OSCECase(
          id: "sabahi_c1",
          titleAr: "الفحص العام وقثطرة فولي والأنبوب الرغامي ومحلول رينجر وتدبير الصدمة في الطوارئ",
          titleEn: "General exam, Foley's catheter, Endotracheal tube, Ringer lactate, and Shock",
          typeAr: "حالة مهارات سريرية قصيرة لطوارئ الجراحة",
          typeEn: "Short & Emergency Case",
          questionsAr: [
            "ما هي الأنواع المختلفة لقثطرة فولي البولية (Foley's catheter) وبم تقاس مقاساتها؟",
            "ما هي استطبابات ومعايير غسيل المثانة المستمر (Bladder Irrigation) وما شيوعها بعد عمليات تجريف البروستات عياناً (TURP)؟",
            "ما هي دواعي تشبيب (ETT) ووضع الأنبوب الرغامي للمريض؟",
            "ماذا سيحدث في الحال إذا تم تسييل الأنبوب الرغامي في المريء عن طريق الخطأ (Esophageal Intubation)؟ (نقص أكسجين الدماغ الحاد المؤدي للوفاة وفقدان الوعي).",
            "ما هي استطبابات ومعايير تزويد المريض بمحلول رينجر لاكتات (Ringer Lactate Indications)؟",
            "كيف يتم بدقة قياس وحساب محلول صيانة السوائل اليومية (Maintenance Therapy Calculations)؟",
            "عرف سريرياً مفهوم الصدمة (Shock Definitive Types).",
            "ما هي الأعضاء الحيوية الأساسية الستة (Vital Organs) التي يتوجب حمايتها في حالات الصدمة النزفية؟"
          ],
          questionsEn: [
            "List the types and sizes of Foley's catheters.",
            "What are the clinical indications of bladder irrigation (most commonly post-TURP)?",
            "Specify the clinical indications for endo-tracheal tube (ETT) placement.",
            "What will resolve if the ETT is falsely positioned in the esophagus? (Hypoxia -> rapid brain injury -> death).",
            "Detail the physiological indications of Ringer's lactate fluid solution.",
            "How do you mathematically calculate maintenance fluid therapy requirements for a 24-hour cycle?",
            "What is the precise definition of circulatory and clinical shock?",
            "What are the key vital organs that must be preserved during hemodynamic monitoring?"
          ],
        )
      ],
    ),
  ];

  // General Reviews List Data
  final List<Map<String, dynamic>> _reviews = [
    {
      'doctor': 'د. سليم عبدالمجيد',
      'hospital': 'مستشفى الملك فهد الجامعي',
      'dept': 'Surgery',
      'textAr': 'فحص البطن الحاد OSCE يركز بشدة على كشف علامة روفسينج وعلامة مورفي، فاحرص على لمس البطن بيد دافئة.',
      'textEn': 'Surgical abdomen checks under King Fahad ward emphasize Murphy/Rovsing signs. Keep hands warm.',
      'student': 'عبدالرحمن الشهري • سنة رابعة',
      'rating': 5,
    },
    {
      'doctor': 'د. مريم الطرابلسي',
      'hospital': 'المستشفى العسكري بجدة',
      'dept': 'Pediatrics',
      'textAr': 'في فحص الأطفال، تذكر دائماً غسل اليدين وحساب سرعة التنفس الحقيقية دقيقة كاملة قبل الاقتراب بأي سماعة.',
      'textEn': 'When entering pediatrics rotation, wash your hands and count the respiratory rate for a full minute first.',
      'student': 'رنا العيسى • سنة خامسة',
      'rating': 4,
    }
  ];

  // Track checked questions to preserve study progress state locally
  final Set<String> _checkedQuestions = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Populate dynamic lists with static fallback data initially
    setState(() {
      _dynamicDoctors = List.from(_doctorsList);
      _dynamicReviews = List.from(_reviews);
    });

    if (!SupabaseConfig.isConfigured) {
      debugPrint('Supabase is not configured. Running Flutter app in offline mode.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      // 1. Fetch doctors with cases and questions
      final doctorsResponse = await supabase
          .from('doctors')
          .select('*, cases(*, questions(*))');

      if (doctorsResponse != null) {
        final List<DoctorOSCEProfile> fetchedDoctors = [];
        for (var doc in doctorsResponse) {
          final List<OSCECase> fetchedCases = [];
          for (var c in (doc['cases'] as List? ?? [])) {
            final List<String> qsAr = [];
            final List<String> qsEn = [];
            final questionsList = c['questions'] as List? ?? [];
            // Sort questions by sort_order
            questionsList.sort((a, b) => (a['sort_order'] as int).compareTo(b['sort_order'] as int));
            for (var q in questionsList) {
              qsAr.add(q['question_ar']?.toString() ?? '');
              qsEn.add(q['question_en']?.toString() ?? '');
            }

            fetchedCases.add(OSCECase(
              id: c['id']?.toString() ?? '',
              titleAr: c['title_ar']?.toString() ?? '',
              titleEn: c['title_en']?.toString() ?? '',
              typeAr: c['type_ar']?.toString() ?? '',
              typeEn: c['type_en']?.toString() ?? '',
              questionsAr: qsAr,
              questionsEn: qsEn,
            ));
          }

          fetchedDoctors.add(DoctorOSCEProfile(
            id: doc['id']?.toString() ?? '',
            doctorNameAr: doc['doctor_name_ar']?.toString() ?? '',
            doctorNameEn: doc['doctor_name_en']?.toString() ?? '',
            deptAr: doc['dept_ar']?.toString() ?? '',
            deptEn: doc['dept_en']?.toString() ?? '',
            hospitalAr: doc['hospital_ar']?.toString() ?? '',
            hospitalEn: doc['hospital_en']?.toString() ?? '',
            avatarUrl: doc['avatar_url']?.toString() ?? '',
            cases: fetchedCases,
          ));
        }

        if (fetchedDoctors.isNotEmpty) {
          setState(() {
            _dynamicDoctors = fetchedDoctors;
          });
        }
      }

      // 2. Fetch reviews ordered by creation date
      final reviewsResponse = await supabase
          .from('reviews')
          .select()
          .order('created_at', ascending: false);

      if (reviewsResponse != null) {
        final List<Map<String, dynamic>> fetchedReviews = [];
        for (var r in reviewsResponse) {
          fetchedReviews.add({
            'id': r['id']?.toString() ?? '',
            'doctor': r['doctor_name_ar']?.toString() ?? r['doctor_name_en']?.toString() ?? '',
            'doctorNameEn': r['doctor_name_en']?.toString() ?? '',
            'hospital': r['hospital_ar']?.toString() ?? r['hospital_en']?.toString() ?? '',
            'dept': r['dept_en']?.toString() ?? '',
            'deptAr': r['dept_ar']?.toString() ?? '',
            'deptEn': r['dept_en']?.toString() ?? '',
            'textAr': r['review_ar']?.toString() ?? '',
            'textEn': r['review_en']?.toString() ?? '',
            'student': r['student_name_ar']?.toString() ?? r['student_name_en']?.toString() ?? '',
            'studentNameEn': r['student_name_en']?.toString() ?? '',
            'studentInitials': r['student_initials']?.toString() ?? 'MD',
            'rating': (r['rating'] as num?)?.toInt() ?? 5,
            'likes': (r['likes'] as num?)?.toInt() ?? 0,
            'avatarUrl': r['avatar_url']?.toString() ?? '',
          });
        }

        if (fetchedReviews.isNotEmpty) {
          setState(() {
            _dynamicReviews = fetchedReviews;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading from Supabase: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showNewReviewSheet() {
    final isAr = widget.locale.languageCode == 'ar';
    final nameController = TextEditingController();
    final hspController = TextEditingController();
    final bodyController = TextEditingController();
    int chosenRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isAr ? 'كتابة تجربة سريرية جديدة' : 'Write Clinical Experience',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF006774)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      labelText: isAr ? 'اسم الدكتور الموجه' : 'Mentor Doctor Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: hspController,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      labelText: isAr ? 'اسم المستشفى أو الجناح' : 'Hospital or Ward Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: bodyController,
                    maxLines: 3,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      labelText: isAr ? 'النصيحة والتجربة بالتفصيل' : 'Detailed OSCE advice/experience',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isAr ? 'التقييم المستحق' : 'Experience Rating'),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              Icons.star,
                              color: index < chosenRating ? Colors.amber : Colors.grey.shade300,
                            ),
                            onPressed: () {
                              setSheetState(() {
                                chosenRating = index + 1;
                              });
                            },
                          );
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty && bodyController.text.isNotEmpty) {
                        final newId = 'rev_${DateTime.now().millisecondsSinceEpoch}';
                        final newReview = {
                          'id': newId,
                          'doctor': 'د. ' + nameController.text,
                          'doctorNameEn': 'Dr. ' + nameController.text,
                          'hospital': hspController.text,
                          'dept': 'Surgery',
                          'deptAr': 'قسم الجراحة العامة • ${hspController.text}',
                          'deptEn': 'Surgery • ${hspController.text}',
                          'textAr': bodyController.text,
                          'textEn': bodyController.text,
                          'student': isAr ? 'طبيب امتياز مشارك' : 'Affiliate Intern',
                          'studentNameEn': 'Affiliate Intern',
                          'studentInitials': 'MD',
                          'rating': chosenRating,
                          'likes': 0,
                          'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZK-wCYl_eI0sGIn1v4ygUXxy19c29MHpAGyjFZFhn76sDxnlDq-qa3MJWjugJ6TVLUNOaZ8x8011odLA_cAcVuPoDIcV-2WL84j6hjvkUKym2bojxq4XwIFeC0tsL6GwRUpNp4Q0bMMozTpj-onfzouCa8gg8CKtML5S5ei9TBy5bEWPiVOUxWCCwTrrb1skGLYOi88aSoqn0MRPjQPWZYuZKKVoHHsmzBUKPcpQT0dyqIoI5GVJP8VRgerS_a1Di3JIabUr6VRs',
                        };

                        if (SupabaseConfig.isConfigured) {
                          try {
                            final supabase = Supabase.instance.client;
                            await supabase.from('reviews').insert({
                              'id': newId,
                              'doctor_name_ar': 'د. ' + nameController.text,
                              'doctor_name_en': 'Dr. ' + nameController.text,
                              'dept_ar': 'قسم الجراحة العامة • ${hspController.text}',
                              'dept_en': 'Surgery • ${hspController.text}',
                              'hospital_ar': hspController.text,
                              'hospital_en': hspController.text,
                              'rating': chosenRating.toDouble(),
                              'review_ar': bodyController.text,
                              'review_en': bodyController.text,
                              'student_initials': 'MD',
                              'student_name_ar': isAr ? 'طبيب امتياز مشارك' : 'Affiliate Intern',
                              'student_name_en': 'Affiliate Intern',
                              'likes': 0,
                              'avatar_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZK-wCYl_eI0sGIn1v4ygUXxy19c29MHpAGyjFZFhn76sDxnlDq-qa3MJWjugJ6TVLUNOaZ8x8011odLA_cAcVuPoDIcV-2WL84j6hjvkUKym2bojxq4XwIFeC0tsL6GwRUpNp4Q0bMMozTpj-onfzouCa8gg8CKtML5S5ei9TBy5bEWPiVOUxWCCwTrrb1skGLYOi88aSoqn0MRPjQPWZYuZKKVoHHsmzBUKPcpQT0dyqIoI5GVJP8VRgerS_a1Di3JIabUr6VRs',
                            });
                          } catch (e) {
                            debugPrint('Error inserting review to Supabase: $e');
                          }
                        }

                        setState(() {
                          _dynamicReviews.insert(0, newReview);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isAr ? 'تم حفظ وإرسال المراجعة السريرية!' : 'Review posted successfully!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006774),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isAr ? 'إرسال المراجعة الآن' : 'Publish Review',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.locale.languageCode == 'ar';
    final categories = ['All', 'Surgery', 'Pediatrics', 'Internal'];

    // Filter Doctor OSCE List
    final filteredDoctors = _dynamicDoctors.where((doc) {
      final docName = isAr ? doc.doctorNameAr : doc.doctorNameEn;
      final hospName = isAr ? doc.hospitalAr : doc.hospitalEn;
      final matchesSearch = docName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hospName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_selectedDeptFilter == 'All') return matchesSearch;
      if (_selectedDeptFilter == 'Surgery') {
        return matchesSearch && (doc.deptEn.contains('Surgery') || doc.deptAr.contains('جراحة'));
      }
      if (_selectedDeptFilter == 'Pediatrics') {
        return matchesSearch && (doc.deptEn.contains('Pediatrics') || doc.deptAr.contains('أطفال'));
      }
      if (_selectedDeptFilter == 'Internal') {
        return matchesSearch && (doc.deptEn.contains('Medicine') || doc.deptAr.contains('باطني') || doc.deptAr.contains('القلب'));
      }
      return matchesSearch;
    }).toList();

    // Filter Student Reviews List
    final filteredReviews = _dynamicReviews.where((r) {
      final matchSearch = r['doctor'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r['hospital'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedDeptFilter == 'All') return matchSearch;
      return matchSearch && r['dept'].toString().toLowerCase() == _selectedDeptFilter.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: _activeTab == 'reviews'
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF006774),
              onPressed: _showNewReviewSheet,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                isAr ? 'أضف تجربة' : 'Post Advice',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Segment Switcher: Doctors vs Reviews
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeTab = 'doctors';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _activeTab == 'doctors' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _activeTab == 'doctors'
                              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            isAr ? 'دليل الأطباء والحالات (OSCE)' : 'Doctors & OSCE Cases',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _activeTab == 'doctors' ? const Color(0xFF006774) : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeTab = 'reviews';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _activeTab == 'reviews' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _activeTab == 'reviews'
                              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            isAr ? 'تقييمات وتجارب الطلاب' : 'General Reviews',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _activeTab == 'reviews' ? const Color(0xFF006774) : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: _activeTab == 'doctors'
                    ? (isAr ? 'ابحث باسم الدكتور، المستشفى أو موضوع الحالة...' : 'Search doctor, hospital, or case...')
                    : (isAr ? 'ابحث باسم الدكتور أو الكلمة المفتاحية...' : 'Search clinical evaluations...'),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF006774)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF006774), width: 1.5),
                ),
                isDense: true,
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(fontSize: 12),
              textAlign: isAr ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 12),

            // Department filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((cat) {
                  final active = cat == _selectedDeptFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        cat == 'All' ? (isAr ? 'كافة التخصصات' : 'All') : cat,
                        style: TextStyle(fontSize: 11, color: active ? const Color(0xFF006774) : Colors.black87),
                      ),
                      selected: active,
                      selectedColor: const Color(0xFF006774).withOpacity(0.15),
                      onSelected: (sel) {
                        if (sel) {
                          setState(() {
                            _selectedDeptFilter = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Main List Switch View
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006774)),
                      ),
                    )
                  : _activeTab == 'doctors'
                      ? _buildDoctorsOSCETab(isAr, filteredDoctors)
                      : _buildGeneralReviewsTab(isAr, filteredReviews),
            ),
          ],
        ),
      ),
    );
  }

  // Doctors OSCE tab
  Widget _buildDoctorsOSCETab(bool isAr, List<DoctorOSCEProfile> docs) {
    if (docs.isEmpty) {
      return Center(
        child: Text(
          isAr ? 'لم نجد أطباء يطابقون تصفيتك الحالية.' : 'No clinical mentors found.',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, idx) {
        final doc = docs[idx];
        final name = isAr ? doc.doctorNameAr : doc.doctorNameEn;
        final deptText = isAr ? doc.deptAr : doc.deptEn;
        final hospitalText = isAr ? doc.hospitalAr : doc.hospitalEn;

        // Calculate progress percentage
        int totalQs = 0;
        int completedQs = 0;
        for (var c in doc.cases) {
          for (int i = 0; i < c.questionsAr.length; i++) {
            totalQs++;
            if (_checkedQuestions.contains('${doc.id}_${c.id}_$i')) {
              completedQs++;
            }
          }
        }
        final double progressValue = totalQs > 0 ? (completedQs / totalQs) : 0.0;

        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              // Direct navigation to Doctor detail (الدخول لصفحة الطبيب)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailScreen(
                    doctor: doc,
                    locale: widget.locale,
                    checkedQuestions: _checkedQuestions,
                    onToggle: (qId) {
                      setState(() {
                        if (_checkedQuestions.contains(qId)) {
                          _checkedQuestions.remove(qId);
                        } else {
                          _checkedQuestions.add(qId);
                        }
                      });
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF006774).withOpacity(0.1),
                    backgroundImage: NetworkImage(doc.avatarUrl),
                    onBackgroundImageError: (obj, stack) {
                      // Fallback nicely if custom network avatar offline
                    },
                    child: Text(
                      name.substring(name.startsWith('د.') ? 3 : 0, (name.startsWith('د.') ? 3 : 0) + 1),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006774)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF006774)),
                        ),
                        Text(
                          deptText,
                          style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            const Icon(Icons.apartment, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hospitalText,
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        if (totalQs > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: Colors.grey.shade100,
                                    color: Colors.emerald,
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(progressValue * 100).toInt()}%',
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ]
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
    );
  }

  // Student reviews list
  Widget _buildGeneralReviewsTab(bool isAr, List<Map<String, dynamic>> revs) {
    if (revs.isEmpty) {
      return Center(
        child: Text(
          isAr ? 'لم نجد تقييمات للطلاب حالياً.' : 'No reviews recorded yet.',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      itemCount: revs.length,
      itemBuilder: (context, idx) {
        final r = revs[idx];
        final textDesc = isAr ? r['textAr'] : r['textEn'];

        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Column(
                      crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['doctor'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF006774)),
                        ),
                        Text(
                          r['hospital'],
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(r['rating'], (index) {
                        return const Icon(Icons.star, color: Colors.amber, size: 14);
                      }),
                    )
                  ],
                ),
                const Divider(height: 18),
                Text(
                  textDesc,
                  style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Text(
                      r['student'],
                      style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, py: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        r['dept'],
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// Full interactive subscreen that hosts doctor tested patient cases & exact questions asked (الدخول لصفحة الدكتور)
class DoctorDetailScreen extends StatefulWidget {
  final DoctorOSCEProfile doctor;
  final Locale locale;
  final Set<String> checkedQuestions;
  final Function(String) onToggle;

  const DoctorDetailScreen({
    super.key,
    required this.doctor,
    required this.locale,
    required this.checkedQuestions,
    required this.onToggle,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isAr = widget.locale.languageCode == 'ar';
    final name = isAr ? widget.doctor.doctorNameAr : widget.doctor.doctorNameEn;
    final dept = isAr ? widget.doctor.deptAr : widget.doctor.deptEn;
    final hospital = isAr ? widget.doctor.hospitalAr : widget.doctor.hospitalEn;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isAr ? 'صفحة الدكتور والأسئلة' : 'Doctor OSCE Cases',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF006774)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Doctor Profile card
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFF006774).withOpacity(0.1),
                      backgroundImage: NetworkImage(widget.doctor.avatarUrl),
                      child: Text(
                        name.substring(name.startsWith('د.') ? 3 : 0, (name.startsWith('د.') ? 3 : 0) + 1),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF006774)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006774)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dept,
                      style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          hospital,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cases header
            Text(
              isAr ? 'الحالات والأسئلة الشفوية المطروحة للطلاب' : 'Tested OSCE Cases & Questions Asked',
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF006774)),
              textAlign: isAr ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 10),

            // List of cases assigned to this doctor (تظهر الحالة)
            ...widget.doctor.cases.map((cs) {
              final caseTitle = isAr ? cs.titleAr : cs.titleEn;
              final caseType = isAr ? cs.typeAr : cs.typeEn;

              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Accent category label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, py: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF006774).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          caseType,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF006774)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Case description (تظهر الحالة)
                      Text(
                        caseTitle,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, height: 1.4, color: Colors.black87),
                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                      ),
                      const Divider(height: 24),

                      // List of examiner tested questions (والأسئلة التي سألها)
                      Text(
                        isAr ? 'الأسئلة الشفوية المطروحة بالتفصيل:' : 'Specific questions asked:',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                      ),
                      const SizedBox(height: 8),

                      ...List.generate(cs.questionsAr.length, (qIdx) {
                        final questionAr = cs.questionsAr[qIdx];
                        final questionEn = cs.questionsEn[qIdx];
                        final questionText = isAr ? questionAr : questionEn;
                        final qId = '${widget.doctor.id}_${cs.id}_$qIdx';
                        final isChecked = widget.checkedQuestions.contains(qId);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isChecked ? Colors.emerald.withOpacity(0.04) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isChecked ? Colors.emerald.withOpacity(0.2) : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Checkbox(
                                value: isChecked,
                                activeColor: Colors.emerald,
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (val) {
                                  widget.onToggle(qId);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  questionText,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.4,
                                    color: isChecked ? Colors.grey : Colors.black87,
                                    decoration: isChecked ? TextDecoration.lineThrough : null,
                                  ),
                                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
