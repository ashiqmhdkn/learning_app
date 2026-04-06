import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learning_app/pages/videoPlayBack.dart';
import 'package:learning_app/pages/videoSelectionCard.dart';
import 'package:learning_app/provider/videoupload_provider.dart';

class Subjectwisevideos extends ConsumerStatefulWidget {
  final String unitName;
  final String unitId;

  const Subjectwisevideos({
    super.key,
    required this.unitName,
    required this.unitId,
  });

  @override
  ConsumerState<Subjectwisevideos> createState() => _SubjectwisevideosState();
}

class _SubjectwisevideosState extends ConsumerState<Subjectwisevideos> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(videosNotifierProvider.notifier).setUnitId(widget.unitId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('videos');
print("HIVE DATA: ${box.toMap()}");
    final videoProvider = ref.watch(videosNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimationLimiter(
          child: videoProvider.when(
            data: (videos) {
              if (videos.isEmpty) {
                return const Center(child: Text('No Videos available'));
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  print(video.thumbnail_url);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: FadeInAnimation(
                        child: Videoselectioncard(
                          title: video.title,
                          subtitle: video.description,
                          imagelocation: video.thumbnail_url,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    Videoplayback(url: video.video_url,title: video.title,description: video.description,),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },

            loading: () => const Center(child: CircularProgressIndicator()),

            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }
}
