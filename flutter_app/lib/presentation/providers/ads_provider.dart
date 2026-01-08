import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ads_model.dart';
import '../../data/services/ads_service.dart';

// Ads State
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
      error: error,
    );
  }

  // Filter ads by category
  List<AdsModel> getBannerAds() {
    return ads.where((ad) => ad.category == 'Banner').toList();
  }

  List<AdsModel> getHighlightAds() {
    return ads.where((ad) => ad.category == 'Highlights').toList();
  }
}

// Ads Notifier
class AdsNotifier extends StateNotifier<AdsState> {
  final AdsService _adsService;

  AdsNotifier(this._adsService) : super(AdsState());

  // Fetch all ads
  Future<void> fetchAds() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ads = await _adsService.fetchAds();
      state = state.copyWith(ads: ads, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

// Providers
final adsProvider = StateNotifierProvider<AdsNotifier, AdsState>((ref) {
  final adsService = ref.watch(adsServiceProvider);
  return AdsNotifier(adsService);
});
