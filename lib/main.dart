import 'package:flutter/material.dart';

import 'pages/store_home_page.dart';
import 'services/api_client.dart';
import 'state/app_state.dart';

void main() {
  runApp(const MinimarketApp());
}

class MinimarketApp extends StatefulWidget {
  const MinimarketApp({super.key});

  @override
  State<MinimarketApp> createState() => _MinimarketAppState();
}

class _MinimarketAppState extends State<MinimarketApp> {
  final appState = AppState(ApiClient(apiBaseUrl));

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0EA5E9);

    return AppScope(
      state: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MMARK',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF1F5F9),
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary,
            secondary: const Color(0xFF8B5CF6),
            surface: Colors.white,
            error: const Color(0xFFF43F5E),
          ),
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: const Color(0xFF0F172A),
            displayColor: const Color(0xFF0F172A),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF0F172A),
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
        home: const StoreHomePage(),
      ),
    );
  }
}
