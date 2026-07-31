import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Structured CHW risk assessment produced by the clinical AI.
class GeneratedHealthAssessment {
  final int riskScore;
  final String riskLevel;
  final String summary;
  final String keyRiskFactor;
  final String recommendation;

  const GeneratedHealthAssessment({
    required this.riskScore,
    required this.riskLevel,
    required this.summary,
    required this.keyRiskFactor,
    required this.recommendation,
  });
}

/// Generates clinical narrative from live patient context via Gemini
/// (Firebase AI Logic). Falls back to a deterministic, context-aware
/// assessment when the model is unavailable.
abstract interface class ClinicalAiService {
  Future<String> generateDoctorPanelInsight({required String clinicalContext});

  Future<String> generateFollowUpInsight({required String clinicalContext});

  Future<String> generatePatientClinicalSummary({
    required String clinicalContext,
  });

  Future<String> generatePatientAlert({required String clinicalContext});

  Future<String> generatePatientHealthInsight({
    required String clinicalContext,
  });

  Future<String> generateTimelineAnalysis({required String clinicalContext});

  Future<String> generateMedicationInsight({required String clinicalContext});

  Future<GeneratedHealthAssessment> generateChwAssessment({
    required String clinicalContext,
  });

  /// Short day summary for the CHW home dashboard (caseload briefing).
  Future<String> generateChwDayBriefing({required String clinicalContext});
}

@LazySingleton(as: ClinicalAiService)
class GeminiClinicalAiService implements ClinicalAiService {
  GenerativeModel? _model;
  GenerativeModel? _jsonModel;

  static final _systemInstruction = Content.system(
    'You are a clinical decision-support assistant for Ubuzima Connect, '
    'used by community health workers (CHWs), doctors, and patients in Rwanda. '
    'Give concrete, actionable guidance a CHW can do today in the community '
    'or at a health post (home visit, danger-sign check, referral to sector '
    'health center/hospital, ANC follow-up, medication adherence support). '
    'Never invent lab values, medications, or diagnoses absent from context. '
    'Prefer Rwanda community-care language: health center, CHW visit, '
    'Mutuelle, danger signs. '
    'Do not wrap answers in markdown fences unless asked for JSON. '
    'Avoid saying you are an AI unless the UI label already implies it.',
  );

  GenerativeModel get _gemini {
    return _model ??= FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
      auth: FirebaseAuth.instance,
    ).generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: _systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.35,
        maxOutputTokens: 512,
      ),
    );
  }

  GenerativeModel get _geminiJson {
    return _jsonModel ??= FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
      auth: FirebaseAuth.instance,
    ).generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: _systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.2,
        maxOutputTokens: 640,
        responseMimeType: 'application/json',
      ),
    );
  }

  @override
  Future<String> generateDoctorPanelInsight({
    required String clinicalContext,
  }) {
    return _text(
      prompt:
          'Write a 2–3 sentence doctor dashboard clinical insight for this '
          'panel. Call out the highest-priority follow-up gaps or risks and '
          'name specific patients when present.\n\n$clinicalContext',
      fallback: _fallbackPanel(clinicalContext),
    );
  }

  @override
  Future<String> generateFollowUpInsight({required String clinicalContext}) {
    return _text(
      prompt:
          'Write one short AI alert sentence for a doctor patient-search '
          'screen about overdue follow-ups. Keep it under 35 words.\n\n'
          '$clinicalContext',
      fallback: _fallbackFollowUp(clinicalContext),
    );
  }

  @override
  Future<String> generatePatientClinicalSummary({
    required String clinicalContext,
  }) {
    return _text(
      prompt:
          'Write a 3–5 sentence AI clinical summary for a doctor viewing one '
          'patient chart. Prioritize uncontrolled conditions, complications, '
          'and the next clinical actions.\n\n$clinicalContext',
      fallback: _fallbackClinicalSummary(clinicalContext),
    );
  }

  @override
  Future<String> generatePatientAlert({required String clinicalContext}) {
    return _text(
      prompt:
          'Write one urgent clinical alert sentence for a doctor patient '
          'detail banner. Under 30 words.\n\n$clinicalContext',
      fallback: _fallbackAlert(clinicalContext),
    );
  }

  @override
  Future<String> generatePatientHealthInsight({
    required String clinicalContext,
  }) {
    return _text(
      prompt:
          'Write a patient-friendly health insight (2 sentences). Be '
          'encouraging but clear about what the patient should do. No '
          'medical jargon.\n\n$clinicalContext',
      fallback: _fallbackPatientInsight(clinicalContext),
    );
  }

  @override
  Future<String> generateTimelineAnalysis({required String clinicalContext}) {
    return _text(
      prompt:
          'Write a 3–4 sentence longitudinal AI timeline analysis for a '
          'doctor. Describe disease progression patterns and recommend a '
          'management focus.\n\n$clinicalContext',
      fallback: _fallbackTimeline(clinicalContext),
    );
  }

  @override
  Future<String> generateMedicationInsight({required String clinicalContext}) {
    return _text(
      prompt:
          'Write a 2-sentence patient-facing medication insight about '
          'adherence and one practical tip tied to the listed medicines.\n\n'
          '$clinicalContext',
      fallback: _fallbackMedication(clinicalContext),
    );
  }

  @override
  Future<String> generateChwDayBriefing({required String clinicalContext}) {
    return _text(
      prompt:
          'Write a 2–3 sentence CHW day briefing for a community health '
          'worker starting their rounds in Rwanda. Prioritize emergency '
          'flags and high-risk patients by name when present, then mention '
          'upcoming visits. Be concrete about what to do today '
          '(home visit, danger-sign check, refer to health center).\n\n'
          '$clinicalContext',
      fallback: _fallbackChwDayBriefing(clinicalContext),
    );
  }

  @override
  Future<GeneratedHealthAssessment> generateChwAssessment({
    required String clinicalContext,
  }) async {
    final fallback = _fallbackChwAssessment(clinicalContext);

    try {
      final response = await _geminiJson.generateContent([
        Content.text(
          'You are advising a Rwanda community health worker (CHW).\n'
          'Return ONLY a JSON object with keys:\n'
          '- riskScore: integer 0-100 reflecting urgency for CHW action\n'
          '- riskLevel: one of low|moderate|high|critical\n'
          '- summary: exactly 2 sentences naming the patient risks from '
          'the context (symptoms, pregnancy, chronic conditions, emergency '
          'flags) and what to watch for\n'
          '- keyRiskFactor: short phrase (<= 6 words) naming the dominant '
          'risk from context\n'
          '- recommendation: one concrete CHW action with timing, e.g. '
          '"Home visit today — check fever & breathing", '
          '"Refer to sector health center within 24h", '
          '"ANC follow-up in 3 days", '
          '"Monitor BP at home this week".\n'
          'Rules: use only facts in the context; if emergency flags exist, '
          'riskLevel must be high or critical and recommendation must be '
          'same-day referral or urgent visit; if pregnant + concerning '
          'symptoms, recommend ANC/danger-sign check; if chronic disease '
          'only, recommend adherence support + scheduled check.\n\n'
          'Patient context:\n$clinicalContext',
        ),
      ]);
      final raw = response.text;
      if (raw == null || raw.trim().isEmpty) return fallback;

      final decoded = jsonDecode(_extractJson(raw)) as Map<String, dynamic>;
      final level = (decoded['riskLevel'] as String? ?? fallback.riskLevel)
          .toLowerCase()
          .trim();
      const allowed = {'low', 'moderate', 'high', 'critical'};

      return GeneratedHealthAssessment(
        riskScore: ((decoded['riskScore'] as num?)?.toInt() ??
                fallback.riskScore)
            .clamp(0, 100),
        riskLevel: allowed.contains(level) ? level : fallback.riskLevel,
        summary: (decoded['summary'] as String?)?.trim().isNotEmpty == true
            ? (decoded['summary'] as String).trim()
            : fallback.summary,
        keyRiskFactor:
            (decoded['keyRiskFactor'] as String?)?.trim().isNotEmpty == true
            ? (decoded['keyRiskFactor'] as String).trim()
            : fallback.keyRiskFactor,
        recommendation:
            (decoded['recommendation'] as String?)?.trim().isNotEmpty == true
            ? (decoded['recommendation'] as String).trim()
            : fallback.recommendation,
      );
    } catch (e, st) {
      debugPrint('ClinicalAiService.generateChwAssessment failed: $e\n$st');
      return fallback;
    }
  }

  /// Deterministic CHW assessment from recorded context when Gemini is down.
  static GeneratedHealthAssessment _fallbackChwAssessment(String ctx) {
    final lower = ctx.toLowerCase();
    final pregnant =
        lower.contains('pregnan') && !lower.contains('not pregnant');
    final emergency =
        lower.contains('emergency') ||
        lower.contains('unconscious') ||
        lower.contains('convulsion') ||
        lower.contains('severe bleeding') ||
        lower.contains('severe breathing') ||
        lower.contains('high fever') ||
        lower.contains('pregnancy emergency');

    final symptoms = <String>[];
    for (final s in const [
      'fever',
      'cough',
      'fatigue',
      'headache',
      'nausea',
      'diarrhea',
      'chest pain',
      'breathless',
      'swelling',
      'rash',
      'vomiting',
    ]) {
      if (lower.contains(s)) symptoms.add(s);
    }

    final chronic = <String>[];
    for (final c in const [
      'diabetes',
      'hypertension',
      'asthma',
      'hiv',
      'tb',
    ]) {
      if (lower.contains(c)) chronic.add(c);
    }

    final scoreMatch = RegExp(
      r'intake risk score:\s*(\d+)',
      caseSensitive: false,
    ).firstMatch(ctx);
    var score = int.tryParse(scoreMatch?.group(1) ?? '') ?? 40;
    var level = 'moderate';
    var factor = 'Community monitoring';
    var recommendation = 'Home check-in within 7 days';
    var summary =
        'No urgent flags in the recorded chart. Continue routine community '
        'monitoring and encourage the household to report new danger signs.';

    if (emergency) {
      score = score < 85 ? 90 : score;
      level = 'critical';
      factor = 'Emergency danger signs';
      recommendation = 'Urgent referral to health center today';
      summary =
          'Emergency screening flags are present on this record. Arrange '
          'same-day transport/referral to the sector health center and stay '
          'with the patient until handover.';
    } else if (pregnant &&
        (symptoms.contains('swelling') ||
            symptoms.contains('fever') ||
            symptoms.contains('headache') ||
            symptoms.contains('breathless') ||
            symptoms.contains('vomiting') ||
            symptoms.contains('nausea'))) {
      score = score < 70 ? 75 : score;
      level = 'high';
      factor = 'Pregnancy + ${symptoms.first}';
      recommendation = 'ANC danger-sign visit within 24 hours';
      summary =
          'Pregnant patient with concerning symptoms (${symptoms.take(3).join(', ')}). '
          'Check danger signs at home today and escalate to ANC/health center '
          'if headache, swelling, fever, bleeding, or reduced fetal movement.';
    } else if (pregnant) {
      score = score < 55 ? 58 : score;
      level = 'moderate';
      factor = 'Pregnancy follow-up';
      recommendation = 'ANC follow-up in 3 days';
      summary =
          'Pregnancy is recorded without emergency flags. Confirm ANC '
          'attendance, iron/folate adherence, and counsel on danger signs '
          'before the next scheduled visit.';
    } else if (symptoms.contains('breathless') ||
        symptoms.contains('chest pain') ||
        (symptoms.contains('fever') && symptoms.contains('cough'))) {
      score = score < 72 ? 78 : score;
      level = 'high';
      factor = symptoms.contains('chest pain')
          ? 'Chest pain'
          : 'Respiratory symptoms';
      recommendation = 'Clinical assessment at health post today';
      summary =
          'Acute symptoms (${symptoms.take(3).join(', ')}) need prompt review. '
          'Do a home visit, check breathing/temperature, and refer if '
          'worsening or danger signs appear.';
    } else if (chronic.isNotEmpty) {
      score = score < 50 ? 60 : score;
      level = score >= 70 ? 'high' : 'moderate';
      factor = '${_title(chronic.first)} follow-up';
      recommendation = chronic.contains('hypertension')
          ? 'Home BP check within 3 days'
          : 'Adherence visit within 5 days';
      summary =
          'Chronic condition(s) on file: ${chronic.map(_title).join(', ')}. '
          'Support medication adherence, check for new symptoms, and confirm '
          'the next facility appointment.';
    } else if (symptoms.isNotEmpty) {
      score = score < 45 ? 52 : score;
      level = 'moderate';
      factor = _title(symptoms.first);
      recommendation = 'Follow-up home visit in 3 days';
      summary =
          'Reported symptoms: ${symptoms.map(_title).join(', ')}. Monitor '
          'progression, advise fluids/rest as appropriate, and return sooner '
          'if fever, breathing difficulty, or inability to drink develops.';
    }

    if (score >= 85) {
      level = 'critical';
    } else if (score >= 70) {
      level = level == 'critical' ? level : 'high';
    } else if (score >= 45) {
      level = (level == 'high' || level == 'critical') ? level : 'moderate';
    } else {
      level = 'low';
    }

    return GeneratedHealthAssessment(
      riskScore: score.clamp(0, 100),
      riskLevel: level,
      summary: summary,
      keyRiskFactor: factor,
      recommendation: recommendation,
    );
  }

  static String _title(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  Future<String> _text({
    required String prompt,
    required String fallback,
  }) async {
    try {
      final raw = await _generate(prompt);
      final cleaned = raw?.trim();
      if (cleaned == null || cleaned.isEmpty) return fallback;
      return cleaned;
    } catch (e, st) {
      debugPrint('ClinicalAiService generation failed: $e\n$st');
      return fallback;
    }
  }

  Future<String?> _generate(String prompt) async {
    final response = await _gemini.generateContent([Content.text(prompt)]);
    return response.text;
  }

  static String _extractJson(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('{')) return trimmed;
    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return trimmed.substring(start, end + 1);
    }
    return trimmed;
  }

  static String _fallbackPanel(String ctx) {
    final names = RegExp(r'[A-Z][a-z]+ [A-Z]\.').allMatches(ctx).map((m) {
      return m.group(0)!;
    }).toList();
    if (names.isNotEmpty) {
      return 'Priority follow-up needed for ${names.take(3).join(', ')}. '
          'Review overdue chronic-care visits and schedule check-ins today.';
    }
    return 'Several panel patients need timely chronic-care follow-up. '
        'Review overdue hypertension and diabetes visits first.';
  }

  static String _fallbackChwDayBriefing(String ctx) {
    final lower = ctx.toLowerCase();
    final hasEmergency =
        lower.contains('emergency patients:') &&
        !lower.contains('emergency patients:\n- none');
    final hasHighRisk = lower.contains('high/critical risk') &&
        !lower.contains('high/critical risk patients:\n- none');
    if (hasEmergency) {
      return 'Start with emergency-flagged households today — check danger '
          'signs and refer to the sector health center if needed. Then '
          'complete scheduled visits and reassess high-risk patients.';
    }
    if (hasHighRisk) {
      return 'Prioritize high-risk follow-ups this morning, confirm '
          'medications and danger signs, and finish your scheduled community '
          'visits before evening.';
    }
    return 'Caseload looks stable. Complete today’s household visits, keep '
        'screening for danger signs, and log any new concerns in patient '
        'records.';
  }

  static String _fallbackFollowUp(String ctx) {
    if (ctx.toLowerCase().contains('hypertension') ||
        ctx.toLowerCase().contains('htn')) {
      return 'AI Alert: Hypertension patients with overdue follow-up need '
          'scheduling before complications escalate.';
    }
    return 'AI Alert: Review patients with overdue follow-ups and prioritize '
        'high-risk cases today.';
  }

  static String _fallbackClinicalSummary(String ctx) {
    return 'Patient chart review suggests active chronic disease management '
        'is needed. Prioritize blood-pressure and metabolic control, confirm '
        'medications are renal-safe, and schedule specialty follow-up where '
        'indicated. Reassess within 2–4 weeks.\n\nContext used: '
        '${ctx.length > 120 ? '${ctx.substring(0, 120)}…' : ctx}';
  }

  static String _fallbackAlert(String ctx) {
    if (ctx.toLowerCase().contains('bp') ||
        ctx.toLowerCase().contains('hypertension')) {
      return 'Elevated blood pressure readings require urgent clinical review.';
    }
    return 'Clinical risk flags detected — review vitals and recent notes now.';
  }

  static String _fallbackPatientInsight(String ctx) {
    if (ctx.toLowerCase().contains('blood pressure') ||
        ctx.toLowerCase().contains('bp')) {
      return 'Your recent blood pressure readings look higher than usual. '
          'Drink more water, cut back on salt, and tell your care team if '
          'headaches or chest discomfort appear.';
    }
    return 'Your health data shows a few areas to watch. Keep taking your '
        'medicines as prescribed and share any new symptoms with your CHW '
        'or doctor.';
  }

  static String _fallbackTimeline(String ctx) {
    return 'Longitudinal review shows progressive chronic disease burden. '
        'Focus on tighter blood-pressure and glucose control with structured '
        'monthly monitoring and earlier specialty referral when renal markers '
        'worsen.\n\nContext length: ${ctx.length} chars.';
  }

  static String _fallbackMedication(String ctx) {
    final adherence = RegExp(r'(\d+)%').firstMatch(ctx)?.group(1);
    if (adherence != null) {
      return 'You are at $adherence% adherence — keep this streak going. '
          'Taking doses with meals can reduce stomach upset and improve '
          'day-to-day control.';
    }
    return 'Consistent dosing improves long-term control. Take each medicine '
        'with the meal or water instruction shown on your schedule.';
  }
}
