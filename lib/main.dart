import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/create_ad_screen.dart';
import 'screens/ads_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Inventory Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 2,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return authProvider.isAuthenticated 
                      ? const HomeScreen() 
                      : const LoginScreen();
                },
              ),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/home': (context) => const HomeScreen(),
          '/about': (context) => const AboutScreen(),
          '/create-ad': (context) => const CreateAdScreen(),
          '/ads-list': (context) => const AdsListScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/statistics': (context) => const StatisticsScreen(),
        },
        onGenerateRoute: (settings) {
          // Rota para telas que precisam de parâmetros
          if (settings.name == '/ad-detail') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => AboutScreen(),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
