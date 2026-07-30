import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../data/repositories/mock_patient_detail_repository.dart';
import '../../domain/models/ai_insight.dart';
import '../../domain/models/allergy.dart';
import '../../domain/models/clinical_note.dart';
import '../../domain/models/clinical_summary_item.dart';
import '../../domain/models/patient_detail.dart';
import '../../domain/models/risk_indicator.dart';
import '../../domain/models/vital_sign.dart';
import '../../domain/repositories/patient_detail_repository.dart';
import '../widgets/ai_clinical_summary_card.dart';
import '../widgets/alert_info_banner.dart';
import '../widgets/ai_insight_banner.dart';
import '../widgets/allergy_chip.dart';
import '../widgets/clinical_note_card.dart';
import '../widgets/clinical_summary_row.dart';
import '../widgets/doctor_bottom_navigation_bar.dart';
import '../widgets/patient_detail_header.dart';
import '../widgets/risk_indicator_bar.dart';
import '../widgets/vital_sign_card.dart';

/// The doctor's Patient Details screen: identity + actions, AI risk
/// scoring, latest vitals, allergies, recent clinical notes, and an
/// AI-generated clinical summary.
///
/// Data comes from a [PatientDetailRepository] — [MockPatientDetailRepository]
/// by default — so swapping in a Firestore-backed implementation later only
/// touches the constructor call, not this screen.
class PatientDetailScreen extends StatefulWidget {
  final PatientDetailRepository repository;

  const PatientDetailScreen({
    super.key,
    this.repository = const MockPatientDetailRepository(),
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailData {
  final PatientDetail patient;
  final RiskProfile riskProfile;
  final String aiAlertMessage;
  final List<VitalSign> vitals;
  final String vitalsAsOfLabel;
  final List<Allergy> allergies;
  final String drugInteractionMessage;
  final List<ClinicalNote> clinicalNotes;
  final List<ClinicalSummaryItem> summaryItems;
  final AiInsight aiClinicalSummary;

  const _PatientDetailData({
    required this.patient,
    required this.riskProfile,
    required this.aiAlertMessage,
    required this.vitals,
    required this.vitalsAsOfLabel,
    required this.allergies,
    required this.drugInteractionMessage,
    required this.clinicalNotes,
    required this.summaryItems,
    required this.aiClinicalSummary,
  });
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late Future<_PatientDetailData> _future;
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PatientDetailData> _load() async {
    final results = await Future.wait([
      widget.repository.getPatientDetail(),
      widget.repository.getRiskProfile(),
      widget.repository.getAiAlertMessage(),
      widget.repository.getVitals(),
      widget.repository.getVitalsAsOfLabel(),
      widget.repository.getAllergies(),
      widget.repository.getDrugInteractionMessage(),
      widget.repository.getClinicalNotes(),
      widget.repository.getClinicalSummaryItems(),
      widget.repository.getAiClinicalSummary(),
    ]);

    return _PatientDetailData(
      patient: results[0] as PatientDetail,
      riskProfile: results[1] as RiskProfile,
      aiAlertMessage: results[2] as String,
      vitals: results[3] as List<VitalSign>,
      vitalsAsOfLabel: results[4] as String,
      allergies: results[5] as List<Allergy>,
      drugInteractionMessage: results[6] as String,
      clinicalNotes: results[7] as List<ClinicalNote>,
      summaryItems: results[8] as List<ClinicalSummaryItem>,
      aiClinicalSummary: results[9] as AiInsight,
    );
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  void _printAction(String action) => debugPrint('Tapped: $action');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: _TopBar(
                  onBack: () => context.pop(),
                  onMore: () => _printAction('More options'),
                  onNotifications: () => _printAction('Open notifications'),
                ),
              ),
              Expanded(
                child: FutureBuilder<_PatientDetailData>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LoadingIndicator(
                        message: 'Loading patient record…',
                      );
                    }
                    if (snapshot.hasError) {
                      return ErrorView(
                        message:
                            'Could not load this patient. Please try again.',
                        onRetry: _refresh,
                      );
                    }

                    final data = snapshot.requireData;
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.sm,
                          AppSpacing.md,
                          AppSpacing.xl,
                        ),
                        children: [
                          PatientDetailHeader(
                            patient: data.patient,
                            onConsult: () => _printAction('Consult'),
                            onHistory: () =>
                                context.push(AppRoutes.patientTimeline),
                            onRefer: () => context.push(AppRoutes.newReferral),
                            onLab: () => _printAction('Lab'),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _SectionHeader(
                            title: 'RISK INDICATORS',
                            trailing: Text(
                              data.riskProfile.overallLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: data.riskProfile.overallColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A0F172A),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                for (final indicator
                                    in data.riskProfile.indicators) ...[
                                  RiskIndicatorBar(indicator: indicator),
                                  if (indicator !=
                                      data.riskProfile.indicators.last)
                                    const SizedBox(height: AppSpacing.md),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          AiInsightBanner(
                            message: data.aiAlertMessage,
                            prefixLabel: 'AI Alert: ',
                            showChevron: false,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _SectionHeader(
                            title: 'LATEST VITALS',
                            trailing: Text(
                              data.vitalsAsOfLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          _VitalsGrid(vitals: data.vitals),
                          const SizedBox(height: AppSpacing.lg),
                          _SectionHeader(
                            title: 'ALLERGIES & ALERTS',
                            trailing: Text(
                              '${data.allergies.length} Active',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final allergy in data.allergies)
                                AllergyChip(allergy: allergy),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          AlertInfoBanner(
                            icon: LucideIcons.pill,
                            message: data.drugInteractionMessage,
                            color: AppColors.danger,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _SectionHeader(
                            title: 'RECENT CLINICAL NOTES',
                            trailing: InkWell(
                              onTap: () => _printAction(
                                'Recent Clinical Notes · View All',
                              ),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm + 2),
                          for (
                            var i = 0;
                            i < data.clinicalNotes.length;
                            i++
                          ) ...[
                            ClinicalNoteCard(
                              note: data.clinicalNotes[i],
                              accentColor:
                                  _noteAccentPalette[i %
                                      _noteAccentPalette.length],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                          ],
                          const SizedBox(height: AppSpacing.sm),
                          const _SectionHeader(title: 'CLINICAL SUMMARY CARDS'),
                          const SizedBox(height: AppSpacing.sm + 2),
                          for (final item in data.summaryItems) ...[
                            ClinicalSummaryRow(
                              item: item,
                              onTap: () => _printAction(item.title),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                          ],
                          const SizedBox(height: AppSpacing.sm),
                          AiClinicalSummaryCard(
                            insight: data.aiClinicalSummary,
                            onFullPanel: () => _printAction('Full AI Panel'),
                            onShare: () => _printAction('Share'),
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
      ),
      bottomNavigationBar: DoctorBottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  static const _noteAccentPalette = [
    AppColors.danger,
    AppColors.warning,
    AppColors.secondary,
  ];

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.doctorDashboard);
      case 1:
        context.go(AppRoutes.patientSearch);
      case 3:
        context.go(AppRoutes.doctorNotifications);
      case 4:
        context.go(AppRoutes.doctorSettings);
      default:
        setState(() => _navIndex = index);
    }
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onMore;
  final VoidCallback? onNotifications;

  const _TopBar({this.onBack, this.onMore, this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundIconButton(icon: LucideIcons.arrowLeft, onTap: onBack),
        const SizedBox(width: 10),
        const Expanded(child: UbuzimaWordmark(compact: true)),
        const SizedBox(width: 8),
        _RoundIconButton(icon: LucideIcons.ellipsis, onTap: onMore),
        const SizedBox(width: 8),
        _RoundIconButton(icon: LucideIcons.bell, onTap: onNotifications),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 19, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Two vitals per row, each sized to its own content — avoids guessing a
/// fixed aspect ratio for cards whose content length varies (some carry a
/// status pill + trend row, some don't).
class _VitalsGrid extends StatelessWidget {
  final List<VitalSign> vitals;

  const _VitalsGrid({required this.vitals});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < vitals.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: VitalSignCard(vital: vitals[i])),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: i + 1 < vitals.length
                    ? VitalSignCard(vital: vitals[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (i + 2 < vitals.length) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
