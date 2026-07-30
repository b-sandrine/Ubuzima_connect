import 'package:injectable/injectable.dart';

/// Rwanda's administrative hierarchy for the Household Details cascading
/// pickers (Province → District → Sector). Trimmed to a representative
/// subset of real districts/sectors per province rather than the full
/// national gazetteer — enough to drive the cascading dropdowns without
/// shipping an exhaustive reference dataset.
abstract interface class RwandaLocationsDataSource {
  List<String> provinces();

  List<String> districtsOf(String province);

  List<String> sectorsOf(String province, String district);
}

@LazySingleton(as: RwandaLocationsDataSource)
class RwandaLocationsDataSourceImpl implements RwandaLocationsDataSource {
  static const Map<String, Map<String, List<String>>> _areas = {
    'Kigali City': {
      'Gasabo': ['Remera', 'Kimironko', 'Kacyiru', 'Ndera', 'Jali'],
      'Kicukiro': ['Niboye', 'Kagarama', 'Gahanga', 'Kanombe'],
      'Nyarugenge': ['Nyarugenge', 'Muhima', 'Kimisagara', 'Nyamirambo'],
    },
    'Southern Province': {
      'Huye': ['Ngoma', 'Tumba', 'Mukura'],
      'Nyanza': ['Busasamana', 'Kigoma', 'Mukingo'],
      'Muhanga': ['Nyamabuye', 'Kabgayi'],
    },
    'Northern Province': {
      'Musanze': ['Muhoza', 'Cyuve', 'Kimonyi'],
      'Gicumbi': ['Byumba', 'Kageyo'],
      'Burera': ['Butaro', 'Cyanika'],
    },
    'Eastern Province': {
      'Kayonza': ['Mukarange', 'Rwinkwavu'],
      'Rwamagana': ['Rwamagana', 'Muhazi'],
      'Nyagatare': ['Nyagatare', 'Rukomo'],
    },
    'Western Province': {
      'Rubavu': ['Gisenyi', 'Nyamyumba'],
      'Karongi': ['Rubengera', 'Bwishyura'],
      'Rusizi': ['Kamembe', 'Nkombo'],
    },
  };

  @override
  List<String> provinces() => _areas.keys.toList(growable: false);

  @override
  List<String> districtsOf(String province) =>
      _areas[province]?.keys.toList(growable: false) ?? const [];

  @override
  List<String> sectorsOf(String province, String district) =>
      _areas[province]?[district] ?? const [];
}
