import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:learning_app/models/course_info_model.dart';
import 'package:learning_app/pages/course_info_page.dart';
import 'package:learning_app/provider/courses_provider.dart';
import 'package:learning_app/provider/request_provider.dart';
import 'package:learning_app/utils/app_snackbar.dart';
import 'package:learning_app/utils/hive_serivce.dart';
import 'package:learning_app/widgets/course_card_new1.dart';
import 'package:learning_app/widgets/customAppBar.dart';
import 'package:learning_app/widgets/customTextBox.dart';

class CourseSubjectPage extends ConsumerWidget {
  const CourseSubjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesNotifierProvider);
    final user = HiveService.getUser();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: Customappbar(title: user?.username ?? "username"),
      body: coursesAsync.when(
        data: (courses) {
          final width = MediaQuery.of(context).size.width;

          // MOBILE
          if (width < 600) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final courseInfo = _mapToCourseInfo(course);

                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 400),
                    child: FadeInAnimation(
                      child: CourseCardNew1(
                        course: courseInfo,
                        onTap: () =>
                            _handleTap(context, ref, course, courseInfo),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // TABLET / DESKTOP
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width < 1000 ? 2 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final courseInfo = _mapToCourseInfo(course);

                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: width < 1000 ? 2 : 3,
                    child: ScaleAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: FadeInAnimation(
                        child: CourseCardNew1(
                          course: courseInfo,
                          onTap: () =>
                              _handleTap(context, ref, course, courseInfo),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _handleTap(
    BuildContext context,
    WidgetRef ref,
    dynamic course,
    CourseInfoModel courseInfo,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return CourseInfoPage(
            course: courseInfo,
            onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  final codeController = TextEditingController();
                  return SafeArea(
                    bottom: true,
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Enter Batch Code",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Customtextbox(
                            hinttext: "Batch Code",
                            textController: codeController,
                            textFieldIcon: Icons.numbers,
                          ),

                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.secondary,
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              final notifier = ref.read(
                                batchRequestsProvider.notifier,
                              );
                              notifier.setcourseId(course.course_id ?? "");

                              final success = await notifier.submitRequest(
                                code: codeController.text.trim(),
                              );

                              Navigator.pop(context);
                              AppSnackBar.show(
                                context,
                                message: success
                                    ? "Request submitted successfully"
                                    : "Failed to submit request",
                                type: SnackType.success,
                                showAtTop: true,
                              );
                            },
                            child: const Text("Submit"),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Having trouble? Contact +91 73568 47300",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              // keep your bottom sheet logic here (unchanged)
            },
          );
        },
      ),
    );
  }

  CourseInfoModel _mapToCourseInfo(dynamic course) {
    return CourseInfoModel(
      id: course.course_id!,
      title: course.title,
      subtitle: "Full Course",
      languageTag: "ENG",
      categoryTag: "COURSE",
      bannerImageUrl: course.course_image,
      educators: [],
      batchStartDate: DateTime.now(),
      enrollmentEndDate: DateTime.now(),
      about: CourseAbout(description: "", highlights: []),
      stats: CourseStats(liveClasses: 0, teachingLanguages: []),
      pricing: CoursePricing(price: 0, currency: "₹", isFree: true),
      isEnrolled: false,
    );
  }
}

final dummyCourse = CourseInfoModel(
  id: "1",
  title: "Class 9",
  subtitle: "Complete Class 9 Syllabus",
  languageTag: "MAL",
  categoryTag: "FULL SYLLABUS BATCH",
  bannerImageUrl:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDIqG_xMwR4FqQCYDVRkqZ9n4C9kfUNA4_Qg&s",
  educators: [
    CourseEducator(id: "1", name: "Ashiq", imageUrl: ""),
    CourseEducator(id: "2", name: "Vishnu", imageUrl: ""),
    CourseEducator(id: "3", name: "Vaishnav", imageUrl: ""),
  ],
  batchStartDate: DateTime(2024, 7, 4),
  enrollmentEndDate: DateTime.now().add(const Duration(days: 323)),
  about: CourseAbout(
    description:
        "This batch is designed specially for State based class 9. Top educators will teach Linear Algebra, Circle, Rectangle and Square.",
    highlights: [
      "Linear Algebra",
      "Maths",
      "Circle",
      "Trigonometry",
      "Integration",
    ],
  ),
  stats: CourseStats(
    liveClasses: 150,
    teachingLanguages: ["English", "Malayalam"],
  ),
  pricing: CoursePricing(price: 12999, currency: "₹", isFree: false),
  isEnrolled: false,
);
