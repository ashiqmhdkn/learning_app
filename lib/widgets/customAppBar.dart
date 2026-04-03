import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/model_save/user.dart';

class Customappbar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const Customappbar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBox = Hive.box<User>('userBox');
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          onPressed: () async {
            final savedUser = userBox.get('currentUser');
            context.push('/profile/${savedUser?.name}');
          },
          icon: CircleAvatar(
            backgroundImage: AssetImage("lib/assets/image.png"),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
