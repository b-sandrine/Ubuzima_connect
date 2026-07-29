/// The quick filters above the patient search results.
enum PatientFilter { all, today, critical, followUp }

extension PatientFilterLabel on PatientFilter {
  String get label => switch (this) {
    PatientFilter.all => 'All',
    PatientFilter.today => "Today's Patients",
    PatientFilter.critical => 'Critical',
    PatientFilter.followUp => 'Follow-up',
  };
}
