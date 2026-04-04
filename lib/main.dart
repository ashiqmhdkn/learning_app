import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_app/router/router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_app/state/themeState.dart';
import 'package:learning_app/utils/hive_serivce.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.openAllBoxes();
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
