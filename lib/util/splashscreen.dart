import 'package:anonymity/csidebar/image_upload.dart';
import 'package:anonymity/screen/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:themed/themed.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Define the animation
    _animation = Tween<double>(
      begin: 0,
      end: -100,
    ).animate(_animationController);

    // Start the animation
    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Wrap your logo in a Transform widget to animate its position
            Transform.translate(
              offset: Offset(0, _animation.value),
              child: ChangeColors(
                  hue: 0.55,
                  brightness: 0.2,
                  saturation: 0.1,
                  child: Image.asset("assets/logo.png",
                      width: 300,
                      height: 300)
              ),
            ),
            Text("ANONYMITY 2.1",
                style: TextStyle(
                    fontSize: 20,
                    color: mainTextColor,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
