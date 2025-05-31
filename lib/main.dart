// Code quality isn't the best and could be improved to be more readable and maintainable
// But as this is only a prototype, it is acceptable for now
// The codebase is still modular but methods could be better organized and shared across widgets
// For ease of understanding, comments has been added to components to clearly explain their purpose

import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/main_view.dart';
import 'package:imat_app/pages/order_history_view.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/user_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImatDataHandler()),
        ChangeNotifierProvider(create: (_) => UserManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMat',
      theme: ThemeData(colorScheme: AppTheme.colorScheme),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainView(),
        '/orderHistory': (context) => const OrderHistoryView(),
      },
    );
  }
}
