import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/news_service.dart';
import '../../data/services/shorts_service.dart';
import '../../data/services/ads_service.dart';

// API Service - Single source of truth
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Service providers
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(apiServiceProvider)),
);

final newsServiceProvider = Provider<NewsService>(
  (ref) => NewsService(ref.read(apiServiceProvider)),
);

final shortsServiceProvider = Provider<ShortsService>(
  (ref) => ShortsService(ref.read(apiServiceProvider)),
);

final adsServiceProvider = Provider<AdsService>(
  (ref) => AdsService(ref.read(apiServiceProvider)),
);
