import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/saved/models/saved_calculation.dart';

class StorageService {
  static const String _savedCalcsBox = 'saved_calculations';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box<SavedCalculation> _savedBox;

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(SavedCalculationAdapter().typeId)) {
      Hive.registerAdapter(SavedCalculationAdapter());
    }
    _savedBox = await Hive.openBox<SavedCalculation>(_savedCalcsBox);
  }

  // ── CRUD ──────────────────────────────────────────────

  Future<void> saveCalculation(SavedCalculation calc) async {
    await _savedBox.put(calc.id, calc);
  }

  List<SavedCalculation> getAllSaved() {
    final items = _savedBox.values.toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  Future<void> deleteCalculation(String id) async {
    await _savedBox.delete(id);
  }

  Future<void> renameCalculation(String id, String newName) async {
    final calc = _savedBox.get(id);
    if (calc != null) {
      calc.name = newName;
      await calc.save();
    }
  }

  // ── Onboarding ────────────────────────────────────────

  Future<bool> isOnboardingComplete() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('onboarding_done') ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('onboarding_done', true);
  }
}
