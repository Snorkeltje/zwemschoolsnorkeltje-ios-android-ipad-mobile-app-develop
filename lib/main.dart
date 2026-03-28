import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait (mobile) - iPad will support landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive for offline storage
  await Hive.initFlutter();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp();

  // TODO: Initialize Supabase
  // await Supabase.initialize(url: '', anonKey: '');

  // TODO: Initialize Stripe
  // Stripe.publishableKey = '';

  runApp(
    const ProviderScope(
      child: SnorkeltjeApp(),
    ),
  );
}
