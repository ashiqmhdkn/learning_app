import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/router/router.dart';
import 'package:learning_app/state/themeState.dart';
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
        final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'learning app',
      theme:theme,
      routerConfig:router,
    );
  }
}
