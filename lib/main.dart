import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Screens/Details/venue_detail_screen.dart';
import 'Screens/splash.dart';
import 'Services/supabase_keys.dart';
import 'Services/venue_model.dart';
import 'Widgets/custom_navigator.dart';
import 'routes/app_routes.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseKeys.supabaseUrl,
    anonKey: SupabaseKeys.supabaseAnonKey,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(1.0)),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nearby Venues',
            initialRoute: AppRoutes.splash,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case AppRoutes.splash:
                  return NavigationUtils.slideTransition(const SplashScreen());
                case AppRoutes.home:
                  return NavigationUtils.slideTransition(const HomeScreen());
                case AppRoutes.venueDetails:
                  final venue = settings.arguments as VenueModel;
                  return NavigationUtils.slideTransition(VenueDetailScreen(venue: venue));
                default:
                  return MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  );
              }
            },
          ),

        );
      },
    );
  }
}
