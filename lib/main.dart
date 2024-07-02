import 'package:expense_tracker_app/app_view.dart';
import 'package:expense_tracker_app/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:expense_tracker_app/firebase_options.dart';
import 'package:expense_tracker_app/notification_services.dart';
import 'package:expense_tracker_app/repoitories/auth_repository.dart';
import 'package:expense_tracker_app/repoitories/firebase_expense_repo.dart';
import 'package:expense_tracker_app/screens/authentications/data/providers/authentication_firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'screens/authentications/data/providers/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationServices notificationServices = NotificationServices();
  await notificationServices.showNotification(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
              authenticationRepository: AuthenticationRepository(
                  authenticationFirebaseProvider:
                      AuthenticationFirebaseProvider(
                          firebaseAuth: FirebaseAuth.instance),
                  googleSignInProvider:
                      GoogleSignInProvider(googleSignIn: GoogleSignIn()),
                  firebaseExpenseRepo: FirebaseExpenseRepo())),
        ),
        // BlocProvider<GetExpensesBloc>(
        //   create: (context) =>
        //       GetExpensesBloc(FirebaseExpenseRepo())..add(GetExpenses()),
        // ),
        // BlocProvider<GetIncomeBloc>(
        //   create: (context) =>
        //       GetIncomeBloc(FirebaseExpenseRepo())..add(GetIncome()),
        // ),
      ],
      child: const MyAppView(),
    );
  }
}
