import 'package:go_router/go_router.dart';
import 'package:learning_app/login/new_login_page.dart';
import 'package:learning_app/login/new_register_page.dart';
import 'package:learning_app/models/user_model.dart';
import 'package:learning_app/pages/chatpers_units.dart';
import 'package:learning_app/pages/profilePage.dart';
import 'package:learning_app/pages/splash.dart';
import 'package:learning_app/pages/unitsPage.dart';
import 'package:learning_app/pages/updateprofile_page.dart';
import 'package:learning_app/widgets/student_navbar.dart';

final router = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/', builder: (context, state) => const StudentNavbar()),
    GoRoute(path: "/login", builder: (context, state) => const NewLoginPage()),
    GoRoute(
      path: "/register",
      builder: (context, state) => const NewRegisterPage(),
    ),
    GoRoute(
      path: "/profile/:username",
      builder: (context, state) {
        final username = state.pathParameters['username']!;
        return Profilepage(username: username);
      },
    ),
    GoRoute(
      path: "/units/:unitname",
      builder: (context, state) {
        final unitname = state.pathParameters['unitname']!;
        final unitId = state.extra as String;
        return Unitspage(unitName: unitname, unitId: unitId);
      },
    ),
    GoRoute(
      path: "/editProfile",
      builder: (context, state) {
        final user = state.extra as User;
        return UpdateProfilePage(user: user);
      },
    ),
    GoRoute(
      path: "/chapters/:name",
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        final subjectId = state.extra as String;
        return ChatpersUnits(name: name, subjectId: subjectId);
      },
    ),
  ],
);
