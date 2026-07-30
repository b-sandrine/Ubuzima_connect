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
/// (Firebase AI Logic). Falls back to a deterministic summary when the
/// model is unavailable so screens never depend on hardcoded marketing copy.
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
}

@LazySingleton(as: ClinicalAiService)
class GeminiClinicalAiService implements ClinicalAiService {
  GenerativeModel? _model;

  static final _systemInstruction = Content.system(
    'You are a clinical decision-support assistant for Ubuzima Connect, '
    'a healthcare platform used by doctors, community health workers, and '
    'patients in Rwanda. '
    'Be concise, actionable, and evidence-oriented. '
    'Never invent lab values, medications, or diagnoses that are not in the '
    'provided context. '
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
        temperature: 0.4,
        maxOutputTokens: 512,
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
  Future<GeneratedHealthAssessment> generateChwAssessment({
    required String clinicalContext,
  }) async {
    const fallback = GeneratedHealthAssessment(
      riskScore: 55,
      riskLevel: 'moderate',
      summary:
          'Based on the recorded symptoms and status, schedule a timely '
          'follow-up and continue community monitoring.',
      keyRiskFactor: 'Symptom cluster',
      recommendation: 'Follow-up in 3 days',
    );

    try {
      final raw = await _generate(
        'Return ONLY valid JSON (no markdown) with keys: '
        'riskScore (0-100 int), riskLevel (low|moderate|high|critical), '
        'summary (2 sentences), keyRiskFactor (short), recommendation '
        '(short action with timing).\n\n$clinicalContext',
      );
      if (raw == null || raw.trim().isEmpty) return fallback;

      final decoded = jsonDecode(_extractJson(raw)) as Map<String, dynamic>;
      final level = (decoded['riskLevel'] as String? ?? 'moderate')
          .toLowerCase()
          .trim();
      final allowed = {'low', 'moderate', 'high', 'critical'};

      return GeneratedHealthAssessment(
        riskScore: ((decoded['riskScore'] as num?)?.toInt() ?? 55).clamp(
          0,
          100,
        ),
        riskLevel: allowed.contains(level) ? level : 'moderate',
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
