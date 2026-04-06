import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/models/streak_modal.dart';
import 'package:learning_app/utils/hive_serivce.dart';
import 'package:learning_app/widgets/customPrimaryText.dart';
import 'package:learning_app/widgets/darkOrLight.dart';
import 'package:learning_app/widgets/streak_widget.dart';

class DummyStreakData {
  static List<StreakDay> generate() {
    final today = DateTime.now();
    return [
      StreakDay(
        date: today.subtract(const Duration(days: 6)),
        minutesStudied: 15,
      ),
      StreakDay(
        date: today.subtract(const Duration(days: 5)),
        minutesStudied: 12,
      ),
      StreakDay(
        date: today.subtract(const Duration(days: 4)),
        minutesStudied: 0,
      ),
      StreakDay(
        date: today.subtract(const Duration(days: 3)),
        minutesStudied: 20,
      ),
      StreakDay(
        date: today.subtract(const Duration(days: 2)),
        minutesStudied: 5,
      ),

      StreakDay(date: today, minutesStudied: 25),
    ];
  }
}

class Profilepage extends ConsumerWidget {
  final String username;
  const Profilepage({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dummyData = DummyStreakData.generate();
    final user = HiveService.getUser();
    print(user?.username);


    return Scaffold(
      appBar: AppBar(actions: [Darkorlight()], scrolledUnderElevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
  radius: 70,
  backgroundColor: Colors.grey.shade200,
  backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
      ? NetworkImage(user.image!)
      : null,
  child: (user?.image == null || user!.image!.isEmpty)
      ?Image.asset('lib/assets/image.png')
      : null,
),
                const SizedBox(width: 60),
                Flexible(
                  child: Column(
                    children: [
                      Customprimarytext(text: username, fontValue: 25),
                      Customprimarytext(text: user?.email??" ", fontValue: 15),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 30,
                        width: 90,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          onPressed: () async {
                            GoRouter.of(
                              context,
                            ).push('/editProfile',);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              Text(
                                "Edit",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreakWidget(streakData: dummyData),
              ),
              const SizedBox(height: 20),
              _settingsSectionTitle("Feedback"),
              _SettingsTile(
                icon: Icons.star_border,
                title: "Rate the app",
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.flag_outlined,
                title: "Report a problem",
                onTap: () {},
              ),

              const SizedBox(height: 20),
              _settingsSectionTitle("Crescent "),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: "Terms and conditions",
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: "Privacy policy",
                onTap: () {},
              ),

              const SizedBox(height: 20),
              _SettingsTile(
                icon: Icons.logout,
                title: "Sign out",
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  HiveService.clearAll();
                  GoRouter.of(context).go('/login');
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
    );
  }
}

Widget _settingsSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.9),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
