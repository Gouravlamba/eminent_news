import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/shorts_model.dart';
import '../../data/services/shorts_service.dart';

// Shorts State
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
      error: error,
    );
  }
}

// Shorts Notifier
class ShortsNotifier extends StateNotifier<ShortsState> {
  final ShortsService _shortsService;

  ShortsNotifier(this._shortsService) : super(ShortsState());

  // Fetch all shorts
  Future<void> fetchShorts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final shorts = await _shortsService.fetchShorts();
      state = state.copyWith(shorts: shorts, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Like short
  Future<void> likeShort(String shortId) async {
    try {
      await _shortsService.likeShort(shortId);
    } catch (e) {
      // Handle error silently or show toast
    }
  }
}

// Providers
final shortsProvider = StateNotifierProvider<ShortsNotifier, ShortsState>(
  (ref) {
    final shortsService = ref.watch(shortsServiceProvider);
    return ShortsNotifier(shortsService);
  },
);
