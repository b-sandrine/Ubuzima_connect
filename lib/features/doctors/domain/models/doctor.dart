/// The signed-in doctor shown in the dashboard header.
///
/// Plain, unannotated model (no Freezed/json_serializable) — the dashboard
/// is mock-data only for now. A Firestore-backed repository can map
/// `DocumentSnapshot.data()` straight into this shape without the UI
/// changing.
class Doctor {
  final String id;
  final String fullName;
  final String hospital;
  final bool onDuty;
  final String? photoUrl;

  const Doctor({
    required this.id,
    required this.fullName,
    required this.hospital,
    required this.onDuty,
    this.photoUrl,
  });
}
