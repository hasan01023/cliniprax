import 'package:flutter/material.dart';

class SocratesSimulatorScreen extends StatefulWidget {
  final Locale locale;
  final String activeSymptom;

  const SocratesSimulatorScreen({
    super.key,
    required this.locale,
    required this.activeSymptom,
  });

  @override
  State<SocratesSimulatorScreen> createState() => _SocratesSimulatorScreenState();
}

class _SocratesSimulatorScreenState extends State<SocratesSimulatorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // SOCRATES Controller States
  final _siteController = TextEditingController();
  final _onsetController = TextEditingController();
  final _characterController = TextEditingController();
  final _radiationController = TextEditingController();
  final _assocController = TextEditingController();
  final _timingController = TextEditingController();
  final _exacController = TextEditingController();
  double _severity = 5.0;

  bool _isReportGenerated = false;
  String _generatedReport = '';

  @override
  void dispose() {
    _siteController.dispose();
    _onsetController.dispose();
    _characterController.dispose();
    _radiationController.dispose();
    _assocController.dispose();
    _timingController.dispose();
    _exacController.dispose();
    super.dispose();
  }

  void _generateClinicalSummary() {
    final isAr = widget.locale.languageCode == 'ar';
    setState(() {
      if (isAr) {
        _generatedReport = """
=== تقرير السيرة المرضية السريري المتكامل (SOCRATES Summary) ===
العرض الرئيسي النشط: ${widget.activeSymptom}
١. الموقع الدقيق لقرارة الألم: ${_siteController.text.isNotEmpty ? _siteController.text : 'لم يذكر'}
٢. نمط آلية وبداية العارض (Onset): ${_onsetController.text.isNotEmpty ? _onsetController.text : 'لم يذكر'}
٣. خصائص ملمس وطبيعة الألم (Character): ${_characterController.text.isNotEmpty ? _characterController.text : 'لم يذكر'}
٤. مدى انتشار الوجع المحيطي (Radiation): ${_radiationController.text.isNotEmpty ? _radiationController.text : 'لا ينتشر'}
٥. الأعراض والعلامات الطبية المصاحبة: ${_assocController.text.isNotEmpty ? _assocController.text : 'لا يوجد أعراض أخرى تفاعلية'}
٦. النبرة الزمنية والتكامل الدوري (Timing): ${_timingController.text.isNotEmpty ? _timingController.text : 'مستمر'}
٧. العوامل المسببة للمفاقمة أو تلطيف الحدة: ${_exacController.text.isNotEmpty ? _exacController.text : 'الراحة التامة تخفف العرض'}
٨. تقييم شدة ودرجة الألم الموضعية: ${_severity.toInt()}/10

* الخاتمة والتوجه التشريحي: المظاهر السريرية السابقة تتطلب متابعة الفحوصات والنبض والتحقق الاستقصائي OSCE.
""";
      } else {
        _generatedReport = """
=== INTEGRATED CLINICAL HISTORY REPORT (SOCRATES) ===
Active Chief Complaint: ${widget.activeSymptom}
1. Site: ${_siteController.text.isNotEmpty ? _siteController.text : 'Not specified'}
2. Onset: ${_onsetController.text.isNotEmpty ? _onsetController.text : 'Not specified'}
3. Character of Pain: ${_characterController.text.isNotEmpty ? _characterController.text : 'Not specified'}
4. Radiation: ${_radiationController.text.isNotEmpty ? _radiationController.text : 'Does not radiate'}
5. Associated Symptoms: ${_assocController.text.isNotEmpty ? _assocController.text : 'None reported'}
6. Timing & Pattern: ${_timingController.text.isNotEmpty ? _timingController.text : 'Constant'}
7. Exacerbating & Relieving Factors: ${_exacController.text.isNotEmpty ? _exacController.text : 'Relieved by complete rest'}
8. Pain Severity evaluation score: ${_severity.toInt()}/10

* OSCE Form Matrix: Align diagnostic history with differential rules to construct final physical checkup metrics.
""";
      }
      _isReportGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.locale.languageCode == 'ar';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'محاكي الفحص SOCRATES' : 'SOCRATES Simulator',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF006774).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF006774).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology, color: Color(0xFF006774)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'العرض المسجل للتفعيل' : 'Active Diagnosis Symptom',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Text(
                            widget.activeSymptom,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.extrabold, color: Color(0xFF006774)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Inputs list cards
              _buildFormSection(
                label: isAr ? 'الموقع الجغرافي للألم (Site)' : 'Site of Pain',
                hint: isAr ? 'أين يتركز الألم تحديداً؟ (مثل: شرسوفي، الربع السفلي الأيمن)' : 'Where exactly is the pain?',
                controller: _siteController,
                icon: Icons.location_on,
              ),
              _buildFormSection(
                label: isAr ? 'بداية الألم وإيقاعه (Onset)' : 'Onset of Symptom',
                hint: isAr ? 'متى وكيف بدأ هذا الألم؟ هل كان فجائياً أم متدرج السلم؟' : 'When and how did it start? Sudden vs gradual?',
                controller: _onsetController,
                icon: Icons.play_arrow,
              ),
              _buildFormSection(
                label: isAr ? 'طبيعة الألم وملمسه (Character)' : 'Character of Pain',
                hint: isAr ? 'صف ملمس الألم (ضاغط، حاد كالسكين، حارق حامضي)' : 'Describe pain nature (crushing, stabbing, burning, aching)',
                controller: _characterController,
                icon: Icons.grain,
              ),
              _buildFormSection(
                label: isAr ? 'الانتشار المحيطي للوجع (Radiation)' : 'Radiation Path',
                hint: isAr ? 'هل ينتقل الألم لمكان أخر كبين الكتفين أو الكتف الأيسر؟' : 'Does the pain travel? (e.g., Left arm, back blade)',
                controller: _radiationController,
                icon: Icons.keyboard_double_arrow_right,
              ),
              _buildFormSection(
                label: isAr ? 'الأعراض المرافقة ومظاهرها (Associations)' : 'Associated Symptoms',
                hint: isAr ? 'هل تشكو من غثيان، تعرق غزير، ضيق بالشهيق والزفير؟' : 'Nausea, pallor, sweating, or dyspnea noted?',
                controller: _assocController,
                icon: Icons.add_circle_outline,
              ),
              _buildFormSection(
                label: isAr ? 'التوقيت الزمني والدوري (Timing)' : 'Timing & Pattern',
                hint: isAr ? 'هل الألم مستمر أم متقطع؟ كم يدوم في المرة الواحدة؟' : 'Is it constant or intermittent? Duration per episode?',
                controller: _timingController,
                icon: Icons.access_time,
              ),
              _buildFormSection(
                label: isAr ? 'العوامل المهيجة والمخففة (Exacerbating)' : 'Exacerbating & Relieving Factors',
                hint: isAr ? 'ما الذي يزيد العارض حدة أو يريحه بشكل ملموس؟' : 'What makes it worse or better?',
                controller: _exacController,
                icon: Icons.tune,
              ),

              // Severity Form Item
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'شدة الألم ودرجته: ${_severity.toInt()}/10' : 'Severity Level: ${_severity.toInt()}/10',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Slider(
                        value: _severity,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        activeColor: const Color(0xFF006774),
                        onChanged: (val) {
                          setState(() {
                            _severity = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _generateClinicalSummary,
                icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
                label: Text(
                  isAr ? 'توليد تقرير الحالة السريرية' : 'Generate Clinical Summary',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006774),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              if (_isReportGenerated) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF006774), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Text(
                            isAr ? 'ملخص الفحص الطبي المتكامل' : 'Clinical Summary Output',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006774)),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        _generatedReport,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: controller,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon, color: const Color(0xFF006774)),
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
