import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:learning_app/provider/notes_provider.dart';
import 'package:learning_app/utils/securePdfViewer.dart';
import 'package:learning_app/widgets/notes_card.dart';

class SubjectWiseNotes extends ConsumerStatefulWidget {
  final String unitName;
  final String unitId;
  const SubjectWiseNotes({
    super.key,
    required this.unitName,
    required this.unitId,
  });
  ConsumerState<SubjectWiseNotes> createState() => _notesState();
}
class _notesState extends ConsumerState<SubjectWiseNotes> {

@override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notesNotifierProvider.notifier).setunit_id(widget.unitId);
      print("working notes fetch request");
    });
  }


  @override
   Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimationLimiter(
          child: notesAsync.when(
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
                      ref.invalidate(notesNotifierProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),

            data: (notes) {
              if (notes.isEmpty) {
                return const Center(child: Text("No Notes availale"));
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: FadeInAnimation(
                        child: NotesCard(
                          title: note.title,
                          subtitle: "Description",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SecurePdfViewer(
                                  noteurl: note.filePath!,
                                  name: note.title,
                                ),
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
          ),
        ),
      ),
    );
  }
}
