import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';
import 'core/services/stripe_service.dart';
import 'core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env (silent fail if not present so app still runs in dev)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  // Initialize backend services
  await SupabaseService.init();
  await FirebaseService.init();
  await StripeService.init();

  // Initialize Dutch locale for date formatting
  await initializeDateFormatting('nl', null);
  await initializeDateFormatting('nl_NL', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: SnorkeltjeApp(),
    ),
  );
}
