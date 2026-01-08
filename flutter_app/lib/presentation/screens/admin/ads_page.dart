import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ads_provider.dart';
import '../../widgets/admin/admin_sidebar.dart';
import '../../widgets/common/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdsPage extends ConsumerStatefulWidget {
  const AdsPage({super.key});

  @override
  ConsumerState<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends ConsumerState<AdsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adsProvider.notifier).fetchAds());
  }

  @override
  Widget build(BuildContext context) {
    final adsState = ref.watch(adsProvider);

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Ads Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add new ad
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Ad'),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: adsState.isLoading
                      ? const LoadingWidget()
                      : adsState.ads.isEmpty
                          ? const Center(child: Text('No ads found'))
                          : ListView(
                              padding: const EdgeInsets.all(24),
                              children: [
                                // Banner Ads
                                const Text(
                                  'Banner Ads',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1.5,
                                  ),
                                  itemCount: adsState.getBannerAds().length,
                                  itemBuilder: (context, index) {
                                    final ad = adsState.getBannerAds()[index];
                                    return Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CachedNetworkImage(
                                              imageUrl: ad.images.isNotEmpty
                                                  ? ad.images[0]
                                                  : '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              ad.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 32),

                                // Highlight Ads
                                const Text(
                                  'Highlight Ads',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1.5,
                                  ),
                                  itemCount: adsState.getHighlightAds().length,
                                  itemBuilder: (context, index) {
                                    final ad =
                                        adsState.getHighlightAds()[index];
                                    return Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CachedNetworkImage(
                                              imageUrl: ad.images.isNotEmpty
                                                  ? ad.images[0]
                                                  : '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              ad.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
