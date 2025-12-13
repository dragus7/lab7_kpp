import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'app.dart';

import 'package:provider/provider.dart';
import 'task_state.dart';
import 'repositories/firebase_tasks_repository.dart';

Future<void> main() async {
  await SentryFlutter.init(
        (options) {
      options.dsn = '...';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TaskState(
                FirebaseTasksRepository(firestore, auth),
              )..loadTasks(),
            ),
          ],
          child: const MyApp(),
        ),
      );
    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    Sentry.captureException(
      details.exception,
      stackTrace: details.stack,
    );
  };
}
