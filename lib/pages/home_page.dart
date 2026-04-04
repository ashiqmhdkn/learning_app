import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/pages/coursePage.dart';
import 'package:learning_app/provider/subject_provider.dart';
import 'package:learning_app/utils/hive_serivce.dart';
import 'package:learning_app/widgets/practiceTIle2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomePage> {
  final courses = HiveService.getCourses();
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    _loadSelectedCourse();
  }

  Future<void> _loadSelectedCourse() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedCourse = prefs.getString('selected_course');

    String? courseToUse;
    if (savedCourse != null && courses.any((c) => c.course_id == savedCourse)) {
      courseToUse = savedCourse;
    } else if (courses.isNotEmpty) {
      courseToUse = courses[0].course_id;
      await prefs.setString('selected_course', courseToUse!);
    }

    if (courseToUse != null) {
      setState(() {
        selectedCourse = courseToUse;
      });

      // ✅ Safe to call AFTER build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(subjectsNotifierProvider.notifier)
            .setcourse_id(courseToUse!);
      });
    }
  }

  Future<void> _saveSelectedCourse(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_course', value);
  }

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return CourseSubjectPage();
    }
final user = HiveService.getUser();
    return Scaffold(
      appBar: AppBar(
        actions: [ 
          IconButton(
          onPressed: () async {
            context.push('/profile/${user?.username}');
          },
          icon: CircleAvatar(
            backgroundImage:NetworkImage(user?.image ??""),
          ),
        ),],
        title: DropdownMenu<String>(
          initialSelection: selectedCourse,
          dropdownMenuEntries: courses
              .map((course) => DropdownMenuEntry<String>(
                    value: course.course_id!,
                    label: course.title,
                  ))
              .toList(),
          onSelected: (value) async {
            if (value == null) return;

            setState(() {
              selectedCourse = value;
            });

            await _saveSelectedCourse(value);

            // ✅ Safe — called from a user interaction, not during build
            ref
                .read(subjectsNotifierProvider.notifier)
                .setcourse_id(value);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (selectedCourse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Only watch — no side effects here
    final subjectsState = ref.watch(subjectsNotifierProvider);

    return subjectsState.when(
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
    );
  }
}


























































      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(20, 3, 8, 3),
      //       child: Text(
      //         "Ready To learn?",
      //         style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(20, 3, 8, 18),
      //       child: Text(
      //         "Continue where you left of ",
      //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      //       ),
      //     ),

      //     SizedBox(
      //       height: 180,
      //       child: ListView(
      //         physics: BouncingScrollPhysics(),
      //         scrollDirection: Axis.horizontal,
      //         padding: const EdgeInsets.symmetric(horizontal: 12),
      //         children: [
      //           Previouslearned(
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (ctx) {
      //                     return Videoplayback(url: "widget.url,",title: "",description: "",);
      //                   },
      //                 ),
      //               );
      //             },
      //             title: "Maths",
      //             subtitle: "Subtitle1",
      //             progress: 0.9,
      //             color: Colors.purple,
      //             icon: Icons.numbers,
      //           ),
      //           Previouslearned(
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (ctx) {
      //                     return Videoplayback(url: "widget.url,",title: "",description: "",);
      //                   },
      //                 ),
      //               );
      //             },
      //             title: "English",
      //             subtitle: "Subtitle",
      //             progress: 0.6,
      //             color: Colors.blue,
      //             icon: Icons.language,
      //           ),
      //           Previouslearned(
      //             onTap: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (ctx) {
      //                     return Videoplayback(url: "widget.url,",title: "",description: "",);
      //                   },
      //                 ),
      //               );
      //             },
      //             title: "Computer",
      //             subtitle: "Data Structure",
      //             progress: 0.4,
      //             color: Colors.orange,
      //             icon: Icons.computer,
      //           ),
      //         ],
      //       ),
      //     ),
      //     SizedBox(height: 20),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(20, 0, 8, 3),
      //       child: Text(
      //         "Practice",
      //         style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      //       ),
      //     ),
      //     SizedBox(height: 15),
      //     Expanded(
      //       child: ListView(
      //         padding: const EdgeInsets.symmetric(horizontal: 10),
      //         physics: const BouncingScrollPhysics(
      //           parent: AlwaysScrollableScrollPhysics(),
      //         ),
      //         children: [
      //           PracticeTile2(
      //             onTap: () {
      //               context.push('/chapters/Maths');
      //             },
      //             title: "Maths",
      //             backGroundImage: 'https://imagedelivery.net/qbIY5PxQGCt4my9mH271vg/7c9a98e1-fffd-4859-83a8-37be105bfc00/public',
      //           ),
      //           PracticeTile2(
      //             onTap: () {
      //               context.push('/chapters/Physics');
      //             },
      //             title: "physics",
      //             backGroundImage: 'https://imagedelivery.net/qbIY5PxQGCt4my9mH271vg/7c9a98e1-fffd-4859-83a8-37be105bfc00/public',
      //           ),
      //           PracticeTile2(
      //             onTap: () {
      //               context.push('/chapters/Biology');
      //             },
      //             title: "Biology",
      //             backGroundImage: 'https://imagedelivery.net/qbIY5PxQGCt4my9mH271vg/7c9a98e1-fffd-4859-83a8-37be105bfc00/public',
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
//     );
//   }
// }
