// lib/core/features/home/bloc/stats_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/listening_stats.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final DatabaseHelper _databaseHelper;

  StatsBloc({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
      super(StatsInitial()) {
    on<LoadStats>(_onLoadStats);
    on<RefreshStats>(_onRefreshStats);
  }

  Future<void> _onLoadStats(LoadStats event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      final stats = await _databaseHelper.getListeningStats();
      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError('Failed to load statistics: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshStats(
    RefreshStats event,
    Emitter<StatsState> emit,
  ) async {
    try {
      final stats = await _databaseHelper.getListeningStats();
      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError('Failed to refresh statistics: ${e.toString()}'));
    }
  }
}
