import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/shorts_model.dart';
import 'providers.dart';

// Shorts state
class ShortsState {
  final List<ShortModel> shorts;
  final bool isLoading;
  final String? error;

  ShortsState({
    this.shorts = const [],
    this.isLoading = false,
    this.error,
  });

  ShortsState copyWith({
    List<ShortModel>? shorts,
    bool? isLoading,
    String? error,
  }) {
    return ShortsState(
      shorts: shorts ?? this.shorts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Shorts provider
class ShortsNotifier extends StateNotifier<ShortsState> {
  final ShortsService _shortsService;

  ShortsNotifier(this._shortsService) : super(ShortsState());

  Future<void> fetchShorts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _shortsService.fetchShorts();

      if (result['success'] == true) {
        state = state.copyWith(
          shorts: result['shorts'] as List<ShortModel>,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Failed to fetch shorts',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
    }
  }

  Future<void> fetchMyShorts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _shortsService.fetchMyShorts();

      if (result['success'] == true) {
        state = state.copyWith(
          shorts: result['shorts'] as List<ShortModel>,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Failed to fetch shorts',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
    }
  }

  Future<bool> likeShort(String shortId) async {
    try {
      final result = await _shortsService.likeShort(shortId);
      if (result['success'] == true) {
        // Refresh the shorts list
        await fetchShorts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteShort(String shortId) async {
    try {
      final result = await _shortsService.deleteShort(shortId);
      if (result['success'] == true) {
        // Remove from local state
        state = state.copyWith(
          shorts: state.shorts.where((s) => s.id != shortId).toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

final shortsProvider = StateNotifierProvider<ShortsNotifier, ShortsState>((ref) {
  return ShortsNotifier(ref.read(shortsServiceProvider));
});
