import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/admin/admin_sidebar.dart';
import '../../widgets/common/loading_widget.dart';

class ShortsManager extends ConsumerStatefulWidget {
  const ShortsManager({super.key});

  @override
  ConsumerState<ShortsManager> createState() => _ShortsManagerState();
}

class _ShortsManagerState extends ConsumerState<ShortsManager> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(shortsProvider.notifier).fetchShorts());
  }

  @override
  Widget build(BuildContext context) {
    final shortsState = ref.watch(shortsProvider);

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
                        'Shorts Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO:  Add new short
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Short'),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: shortsState.isLoading
                      ? const LoadingWidget()
                      : shortsState.shorts.isEmpty
                          ? const Center(child: Text('No shorts found'))
                          : GridView.builder(
                              padding: const EdgeInsets.all(24),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.6,
                              ),
                              itemCount: shortsState.shorts.length,
                              itemBuilder: (context, index) {
                                final short = shortsState.shorts[index];
                                return Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.play_circle,
                                              size: 48),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              short.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'By ${short.editorName}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
