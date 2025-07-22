
import 'package:flutter/material.dart';
import 'package:venues_locater/Routes/app_routes.dart';
import 'package:venues_locater/Utils/sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Center(
        child: Text(
          'Nearby Venues',
          style: TextStyle(
            fontSize: SizeConfig.setWidth(24),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
