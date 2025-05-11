import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Create fade-in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Create a slight rotation animation for extra flair
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to Login screen after delay
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeTransition = FadeTransition(
              opacity: animation,
              child: child,
            );
            return fadeTransition;
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with fade, scale and rotation animations
                  Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 15,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 80,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Text with fade and scale animations
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
                        'Listify',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          letterSpacing: 2.5,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.blue.withOpacity(0.3),
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Loading indicator with fade animation
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                      ),
                    ),
                    child: Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Subtitle text with fade animation
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
                      ),
                    ),
                    child: Text(
                      'Organize Your Life',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[700],
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}