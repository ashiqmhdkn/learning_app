import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:learning_app/models/course_info_model.dart';
import 'package:learning_app/pages/course_info_page.dart';
import 'package:learning_app/pages/subjectsPage.dart';
import 'package:learning_app/provider/courses_provider.dart';
import 'package:learning_app/widgets/course_card_new1.dart';
import 'package:learning_app/widgets/customAppBar.dart';

class CourseSubjectPage extends ConsumerWidget {
  const CourseSubjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: Customappbar(title: "Username"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: coursesAsync.when(
          data: (courses) {
            if (courses.isEmpty) {
              return const Center(child: Text("No Courses Available"));
            }

            return AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];

                  final courseInfo = CourseInfoModel(
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
                    pricing: CoursePricing(
                      price: 0,
                      currency: "₹",
                      isFree: true,
                    ),
                    isEnrolled: false,
                  );

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: FadeInAnimation(
                        child: CourseCardNew1(
                          course: courseInfo,

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseInfoPage(
                                  course: courseInfo,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Subjectspage(
                                          courseName: course.title,
                                          courseId: course.course_id as String,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
      ),
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
