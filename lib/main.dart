import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/home/home_page.dart';
import 'shared/theme/app_theme.dart';

import 'data/datasources/db_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDb();
  await initializeDateFormatting('tr_TR', null);
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deprem Takip',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
