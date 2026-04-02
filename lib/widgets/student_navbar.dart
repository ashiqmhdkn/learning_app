import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:learning_app/models/course_info_model.dart';
import 'package:learning_app/pages/coursePage.dart';
import 'package:learning_app/pages/home_page.dart';
import 'package:learning_app/pages/student_notifications.dart';

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

class StudentNavbar extends StatefulWidget {
  const StudentNavbar({super.key});

  @override
  State<StudentNavbar> createState() => _StudentNavbarState();
}

class _StudentNavbarState extends State<StudentNavbar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  // OLD CODE - COMMENTED OUT:
  // final _pages = const [
  //   HomePage(),
  //   CourseSubjectPage(),
  //   AdminDashboard(),
  //   StudentsMarks(),
  // ];

  // NEW CODE:
  final _pages = [
    HomePage(),
    CourseSubjectPage(),
    StudentNotifications(),
    StudentNotifications(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = const AlwaysStoppedAnimation(Offset.zero);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabChange(int newIndex) {
    if (newIndex == _currentIndex) return;

    _previousIndex = _currentIndex;
    _currentIndex = newIndex;

    final isForward = _currentIndex > _previousIndex;

    _slideAnimation = Tween<Offset>(
      begin: isForward ? const Offset(1, 0) : const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(from: 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _pages[_previousIndex],
            SlideTransition(
              position: _slideAnimation,
              child: _pages[_currentIndex],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: _onTabChange,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tabBorderRadius: 16,
            activeColor: colorScheme.onPrimary,
            tabBackgroundColor: colorScheme.primary,
            color: colorScheme.secondary,
            tabs: const [
              GButton(icon: Icons.menu_book, text: 'Learn'),
              GButton(icon: Icons.explore, text: 'Explore'),
              GButton(icon: Icons.notifications, text: 'Messages'), // NEW CODE
              GButton(icon: Icons.grade_outlined, text: 'Marks'),
            ],
          ),
        ),
      ),
    );
  }
}
