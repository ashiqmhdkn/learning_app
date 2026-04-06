import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:learning_app/pages/student_exams.dart';
import 'package:learning_app/pages/subjectWiseVideos.dart';
import 'package:learning_app/pages/subject_wise_notes.dart';

class Unitspage extends StatefulWidget {
  final String unitName;
  final String unitId;

  const Unitspage({super.key, required this.unitName, required this.unitId});

  @override
  State<Unitspage> createState() => _UnitspageState();
}

class _UnitspageState extends State<Unitspage> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            widget.unitName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomSlidingSegmentedControl<int>(
                initialValue: _selectedIndex,
                children: const {
                  0: Text("Classes"),
                  1: Text("Exam"),
                  2: Text("Notes"),
                },
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: colorScheme.tertiary),
                ),
                thumbDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                onValueChanged: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });

                  _pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            Subjectwisevideos(unitName: widget.unitName, unitId: widget.unitId),
            StudentExams(unitId: widget.unitId),
            SubjectWiseNotes(unitName: widget.unitName, unitId: widget.unitId),
          ],
        ),
      ),
    );
  }
}
