import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/storage_service.dart';
import '../models/saved_calculation.dart';
import 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(const SavedState()) {
    load();
  }

  final _storage = StorageService();

  void load() {
    emit(state.copyWith(loans: _storage.getAllSaved(), isLoading: false));
  }

  Future<void> save(SavedCalculation calc) async {
    await _storage.saveCalculation(calc);
    load();
  }

  Future<void> delete(String id) async {
    await _storage.deleteCalculation(id);
    load();
  }

  Future<void> rename(String id, String newName) async {
    await _storage.renameCalculation(id, newName);
    load();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
