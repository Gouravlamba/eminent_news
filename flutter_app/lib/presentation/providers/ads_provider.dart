import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ads_model.dart';
import 'providers.dart';

// Ads state
class AdsState {
  final List<AdsModel> ads;
  final bool isLoading;
  final String? error;

  AdsState({
    this.ads = const [],
    this.isLoading = false,
    this.error,
  });

  AdsState copyWith({
    List<AdsModel>? ads,
    bool? isLoading,
    String? error,
  }) {
    return AdsState(
      ads: ads ?? this.ads,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<AdsModel> get bannerAds => ads.where((ad) => ad.isBanner).toList();
  List<AdsModel> get highlightAds => ads.where((ad) => ad.isHighlight).toList();
}

// Ads provider
class AdsNotifier extends StateNotifier<AdsState> {
  final AdsService _adsService;

  AdsNotifier(this._adsService) : super(AdsState());

  Future<void> fetchAds({String? category}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _adsService.fetchAds(category: category);

      if (result['success'] == true) {
        state = state.copyWith(
          ads: result['ads'] as List<AdsModel>,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Failed to fetch ads',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
    }
  }

  Future<bool> deleteAd(String adId) async {
    try {
      final result = await _adsService.deleteAds(adId);
      if (result['success'] == true) {
        // Remove from local state
        state = state.copyWith(
          ads: state.ads.where((ad) => ad.id != adId).toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

final adsProvider = StateNotifierProvider<AdsNotifier, AdsState>((ref) {
  return AdsNotifier(ref.read(adsServiceProvider));
});
