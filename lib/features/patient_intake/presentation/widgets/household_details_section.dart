import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/local/rwanda_locations_data_source.dart';
import '../../domain/entities/patient_intake_draft.dart';
import 'intake_inputs.dart';

/// Step 1 — Household Details: the Province → District → Sector cascade,
/// optional cell/village, household size, head of household, and the
/// Ubudehe category used for health-insurance eligibility.
class HouseholdDetailsSection extends StatelessWidget {
  final PatientIntakeDraft draft;
  final ValueChanged<PatientIntakeDraft> onChanged;

  const HouseholdDetailsSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  static const List<String> _ubudeheCategories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
  ];

  @override
  Widget build(BuildContext context) {
    final locations = getIt<RwandaLocationsDataSource>();
    final districts = draft.province.isEmpty
        ? const <String>[]
        : locations.districtsOf(draft.province);
    final sectors = draft.district.isEmpty
        ? const <String>[]
        : locations.sectorsOf(draft.province, draft.district);

    return IntakeSectionCard(
      icon: LucideIcons.house,
      title: 'Household Details',
      tint: AppColors.rolePatientTint,
      iconColor: AppColors.rolePatient,
      children: [
        IntakeDropdownField(
          label: 'Province',
          hint: 'Select province...',
          required: true,
          value: draft.province.isEmpty ? null : draft.province,
          items: locations.provinces(),
          onChanged: (v) => onChanged(
            draft.copyWith(province: v ?? '', district: '', sector: ''),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: IntakeDropdownField(
                label: 'District',
                hint: 'District...',
                required: true,
                value: draft.district.isEmpty ? null : draft.district,
                items: districts,
                onChanged: (v) =>
                    onChanged(draft.copyWith(district: v ?? '', sector: '')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: IntakeDropdownField(
                label: 'Sector',
                hint: 'Sector...',
                required: true,
                value: draft.sector.isEmpty ? null : draft.sector,
                items: sectors,
                onChanged: (v) => onChanged(draft.copyWith(sector: v ?? '')),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: IntakeTextField(
                label: 'Cell',
                hint: 'Cell name...',
                value: draft.cell,
                onChanged: (v) => onChanged(draft.copyWith(cell: v)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: IntakeTextField(
                label: 'Village',
                hint: 'Village name...',
                value: draft.village,
                onChanged: (v) => onChanged(draft.copyWith(village: v)),
              ),
            ),
          ],
        ),
        IntakeCounterField(
          label: 'Household Size',
          value: draft.householdSize,
          onChanged: (v) => onChanged(draft.copyWith(householdSize: v)),
        ),
        IntakeTextField(
          label: 'Head of Household',
          hint: 'Name of household head...',
          value: draft.headOfHousehold,
          onChanged: (v) => onChanged(draft.copyWith(headOfHousehold: v)),
        ),
        IntakeDropdownField(
          label: 'Ubudehe Category',
          hint: 'Select category...',
          value: draft.ubudeheCategory.isEmpty ? null : draft.ubudeheCategory,
          items: _ubudeheCategories,
          onChanged: (v) => onChanged(draft.copyWith(ubudeheCategory: v ?? '')),
        ),
        const Text(
          'Used for health insurance eligibility',
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}
