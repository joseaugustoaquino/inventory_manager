import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
import 'screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
        theme: (() {
          final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
          return ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            primaryColor: colorScheme.primary,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              elevation: 2,
              centerTitle: true,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            cardTheme: CardThemeData(
              elevation: 4, 
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          );
        })(),
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
          '/search': (context) => const SearchScreen(),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
  );
  runApp(const MyApp());
}
