import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/helpers/date_formatter.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../data/repositories/mock_consultation_repository.dart';
import '../../domain/models/consultation.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../widgets/consultation_actions_bar.dart';
import '../widgets/consultation_patient_card.dart';
import '../widgets/consultation_session_bar.dart';
import '../widgets/doctor_bottom_navigation_bar.dart';
import '../widgets/vitals_entry_section.dart';

/// The doctor's active-visit Consultation screen. The Vitals tab is fully
/// built out (editable, auto-saved, clinically flagged); Diagnosis, Notes
/// and Treatment land as their own tasks later, so they render as light
/// placeholders here rather than guessed-at designs.
class ConsultationScreen extends StatefulWidget {
  final ConsultationRepository repository;

  const ConsultationScreen({
    super.key,
    this.repository = const MockConsultationRepository(),
  });

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  static const _tabs = ['Vitals', 'Diagnosis', 'Notes', 'Treatment'];

  late Future<Consultation> _future;
  Consultation? _consultation;
  int _selectedTab = 0;
  bool _isSaving = false;

  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _bloodGlucoseController = TextEditingController();
  final _pulseRateController = TextEditingController();
  final _weightController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _spo2Controller = TextEditingController();

  final _autosaveDebouncer = Debouncer(duration: const Duration(seconds: 1));
  Timer? _elapsedTicker;

  @override
  void initState() {
    super.initState();
    _future = _load();
    _elapsedTicker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  Future<Consultation> _load() async {
    final consultation = await widget.repository.getActiveConsultation();
    _populateControllers(consultation.vitals);
    _consultation = consultation;
    return consultation;
  }

  void _populateControllers(VitalsReading vitals) {
    _systolicController.text = vitals.systolicBp?.toString() ?? '';
    _diastolicController.text = vitals.diastolicBp?.toString() ?? '';
    _bloodGlucoseController.text = vitals.bloodGlucose?.toString() ?? '';
    _pulseRateController.text = vitals.pulseRate?.toString() ?? '';
    _weightController.text = vitals.weightKg?.toString() ?? '';
    _temperatureController.text = vitals.temperatureC?.toString() ?? '';
    _spo2Controller.text = vitals.spo2?.toString() ?? '';
  }

  VitalsReading _currentVitals() {
    return VitalsReading(
      systolicBp: int.tryParse(_systolicController.text),
      diastolicBp: int.tryParse(_diastolicController.text),
      bloodGlucose: double.tryParse(_bloodGlucoseController.text),
      pulseRate: int.tryParse(_pulseRateController.text),
      weightKg: double.tryParse(_weightController.text),
      temperatureC: double.tryParse(_temperatureController.text),
      spo2: int.tryParse(_spo2Controller.text),
    );
  }

  void _onVitalsFieldChanged() {
    setState(() {});
    _autosaveDebouncer.run(
      () => widget.repository.saveVitalsDraft(_currentVitals()),
    );
  }

  Future<void> _onSaveDraft() async {
    await widget.repository.saveVitalsDraft(_currentVitals());
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Draft saved')));
  }

  Future<void> _onCompleteAndSave() async {
    setState(() => _isSaving = true);
    final updated = await widget.repository.completeConsultation(
      _currentVitals(),
    );
    if (!mounted) return;
    setState(() {
      _consultation = updated;
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consultation saved')),
    );
  }

  void _onRefer() => context.push(AppRoutes.newReferral);

  void _onComingSoon(String feature) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.hammer,
              size: 28,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 10),
            Text(
              '$feature is coming soon',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'This action isn\'t wired up yet.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _elapsedTicker?.cancel();
    _autosaveDebouncer.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _bloodGlucoseController.dispose();
    _pulseRateController.dispose();
    _weightController.dispose();
    _temperatureController.dispose();
    _spo2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: DoctorBottomNavigationBar(
        currentIndex: 1,
        onTap: (_) {},
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<Consultation>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicator(message: 'Loading consultation…');
              }
              if (snapshot.hasError || _consultation == null) {
                return ErrorView(
                  message: 'Could not load the consultation. Please try again.',
                  onRetry: () => setState(() => _future = _load()),
                );
              }

              final consultation = _consultation!;
              final vitals = _currentVitals();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTopBar(
                      onBack: () => Navigator.of(context).maybePop(),
                      contextLabel: 'LIVE',
                      contextColor: AppColors.success,
                      contextDot: true,
                      trailing: const [
                        CircleIconButton(icon: LucideIcons.bell, showDot: true),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ConsultationPatientCard(
                      patient: consultation.patient,
                      dateLabel: 'Today\n${DateFormatter.toDisplayDate(DateTime.now())}',
                    ),
                    const SizedBox(height: 18),
                    ConsultationSessionBar(
                      doctorName: consultation.session.doctorName,
                      visitType: consultation.session.visitType,
                      elapsed: DateTime.now().difference(
                        consultation.session.startedAt,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SegmentedTabs(
                      tabs: _tabs,
                      selectedIndex: _selectedTab,
                      onSelected: (i) => setState(() => _selectedTab = i),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedTab == 0) ...[
                      VitalsEntrySection(
                        vitals: vitals,
                        systolicController: _systolicController,
                        diastolicController: _diastolicController,
                        bloodGlucoseController: _bloodGlucoseController,
                        pulseRateController: _pulseRateController,
                        weightController: _weightController,
                        temperatureController: _temperatureController,
                        spo2Controller: _spo2Controller,
                        onChanged: _onVitalsFieldChanged,
                      ),
                      const SizedBox(height: 16),
                      ConsultationActionsBar(
                        filledCount: vitals.filledCount,
                        totalCount: VitalsReading.fieldCount,
                        isComplete: vitals.isComplete,
                        isSaving: _isSaving,
                        onSaveDraft: _onSaveDraft,
                        onCompleteAndSave: vitals.isComplete
                            ? _onCompleteAndSave
                            : null,
                        onRefer: _onRefer,
                        onOrderLab: () => _onComingSoon('Order Lab'),
                        onFollowUp: () => _onComingSoon('Follow-Up'),
                      ),
                    ] else
                      _ComingSoonTab(tabName: _tabs[_selectedTab]),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  final String tabName;

  const _ComingSoonTab({required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            LucideIcons.construction,
            size: 30,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            '$tabName is on its way',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This tab is tracked as a separate task and will land here once '
            'its design is ready.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
