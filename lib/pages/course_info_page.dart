import 'package:flutter/material.dart';
import 'package:learning_app/models/course_info_model.dart';
import 'package:learning_app/widgets/customBoldText.dart';
import 'package:learning_app/widgets/customButtonOne.dart';
import 'package:learning_app/widgets/customPrimaryText.dart';

class CourseInfoPage extends StatelessWidget {
  final CourseInfoModel course;
  final VoidCallback onTap;
  const CourseInfoPage({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderSection(
                        imageUrl: course.bannerImageUrl,
                        heroTag: course.id,
                      ),

                      _TitleSection(course: course),
                      _EnrollmentSection(course: course),
                      const _TabSection(),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            _AboutTab(course: course),
                            const Center(child: Text("Schedule")),
                            const Center(child: Text("Educators")),
                            const Center(child: Text("Testimonials")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _BottomCTA(course: course, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const _HeaderSection({required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Hero(
            tag: heroTag,
            child: Image.network(imageUrl, fit: BoxFit.fill),
          ),
        ),
        Container(
          height: 240,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent, Colors.black45],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  final CourseInfoModel course;

  const _TitleSection({required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: course.languageTag),
              const SizedBox(width: 8),
              _Tag(label: course.categoryTag),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            course.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Educators : ${course.educators.map((e) => e.name).join(", ")}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _EnrollmentSection extends StatelessWidget {
  final CourseInfoModel course;

  const _EnrollmentSection({required this.course});

  @override
  Widget build(BuildContext context) {
    final daysLeft = course.enrollmentEndDate.difference(DateTime.now()).inDays;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enrollment ends in $daysLeft days",
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 4),
                Text(
                  "Batch started on ${course.batchStartDate.day}/${course.batchStartDate.month}/${course.batchStartDate.year}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSection extends StatelessWidget {
  const _TabSection();

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      isScrollable: true,
      tabs: [
        Tab(text: "About"),
        Tab(text: "Schedule"),
        Tab(text: "Educators"),
        Tab(text: "Testimonials"),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  final CourseInfoModel course;

  const _AboutTab({required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatCard(
                title: course.stats.liveClasses.toString(),
                subtitle: "Live Classes",
              ),
              const SizedBox(width: 16),
              _StatCard(
                title: course.stats.teachingLanguages.join(" & "),
                subtitle: "Language",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(course.about.description),
        ],
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  final CourseInfoModel course;
  final VoidCallback onTap;
  const _BottomCTA({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1)),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Customprimarytext(text: "Price", fontValue: 14),
                Customboldtext(
                  text: course.pricing.isFree
                      ? "Free"
                      : "${course.pricing.currency} ${course.pricing.price}",
                  fontValue: 18,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Custombuttonone(
                text: course.isEnrolled ? "Already Enrolled" : "Join Batch",
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          children: [
            Customboldtext(text: title, fontValue: 15),
            const SizedBox(height: 4),
            Customprimarytext(text: subtitle, fontValue: 14),
          ],
        ),
      ),
    );
  }
}
