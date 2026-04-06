import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/utils/hive_serivce.dart';

class Customappbar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const Customappbar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = HiveService.getUser();
    print(user);
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          onPressed: () async {
            context.push('/profile/${user?.username}');
          },
          icon: CircleAvatar(
  radius: 70,
  backgroundColor: Colors.grey.shade200,
  backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
      ? NetworkImage(user.image!)
      : null,
  child: (user?.image == null || user!.image!.isEmpty)
      ?Image.asset('lib/assets/image.png')
      : null,
),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
