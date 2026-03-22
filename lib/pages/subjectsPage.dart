import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/provider/subject_provider.dart';
import 'package:learning_app/widgets/customAppBar.dart';
import 'package:learning_app/widgets/practiceTIle2.dart';

class Subjectspage extends ConsumerStatefulWidget {
  final String courseName;
  final String courseId;

  const Subjectspage({
    super.key,
    required this.courseName,
    required this.courseId,
  });

  @override
  ConsumerState<Subjectspage> createState() => _SubjectspageState();
}

class _SubjectspageState extends ConsumerState<Subjectspage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(subjectsNotifierProvider.notifier).setcourse_id(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectsState = ref.watch(subjectsNotifierProvider);

    return Scaffold(
      appBar: Customappbar(title: widget.courseName),

      body: subjectsState.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return const Center(child: Text("No Subjects Available"));
          }

          return AnimationLimiter(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 400),
                    child: FadeInAnimation(
                      child: PracticeTile2(
                        title: subject.title,
                        backGroundImage: subject.subject_image,
                        onTap: () {
                          context.push(
                            '/chapters/${subject.title}',
                            extra: subject.subject_id,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
