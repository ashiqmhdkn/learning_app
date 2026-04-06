import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:learning_app/pages/student_exams.dart';
import 'package:learning_app/provider/unit_provider.dart';
import 'package:learning_app/widgets/unit_card.dart';

class ChatpersUnits extends ConsumerStatefulWidget {
  final String name;
  final String subjectId;

  const ChatpersUnits({super.key, required this.name, required this.subjectId});

  @override
  ConsumerState<ChatpersUnits> createState() => _ChatpersUnitsState();
}

class _ChatpersUnitsState extends ConsumerState<ChatpersUnits> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    // same as admin — load units based on subject
    Future.microtask(() {
      ref.read(unitsNotifierProvider.notifier).setsubject_id(widget.subjectId);
    });
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
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomSlidingSegmentedControl<int>(
                initialValue: _selectedIndex,
                children: const {0: Text("Units"), 1: Text("Exams")},
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
                  setState(() => _selectedIndex = value);
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
            setState(() => _selectedIndex = index);
          },
          children: [
            _unitsGrid(context),
            const StudentExams(unitId: ''),
          ],
        ),
      ),
    );
  }

  Widget _unitsGrid(BuildContext context) {
    final unitsAsync = ref.watch(unitsNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: unitsAsync.when(
        data: (units) {
          if (units.isEmpty) {
            return const Center(child: Text('No units available'));
          }

          return AnimationLimiter(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];

                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: LessonCard(
                        lesson: Lesson(
                          title: unit.title,
                          part: '',
                          thumbnail: unit.unit_image,
                        ),
                        onTap: () {
                          context.push(
                            '/units/${unit.title}',
                            extra: unit.unit_id,
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

        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(unitsNotifierProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
