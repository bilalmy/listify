import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/screen/Signup_screen.dart';
import 'package:listify/screen/home_screen.dart';

import '../UserAuth/UserAuthentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final UserAuthentication _auth=UserAuthentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.withOpacity(0.1), Colors.white],
              stops: const [0.0, 0.4],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Hero(
                                tag: 'app_logo',
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.check_circle_outline, size: 60, color: Colors.blue[700]),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text('Welcome to Listify',
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text('Login to continue',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              _buildTextField(
                                controller: _emailController,
                                labelText: 'Email',
                                prefixIcon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                prefixIcon: Icons.lock,
                                obscureText: _obscureText,
                                validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                                  onPressed: () => setState(() => _obscureText = !_obscureText),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text('Forgot Password?', style: TextStyle(color: Colors.blue[700])),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildLoginButton(),
                              const SizedBox(height: 20),
                              Row(children: [
                                Expanded(child: Divider(color: Colors.grey[300])),
                                const SizedBox(width: 10),
                                const Text('OR'),
                                const SizedBox(width: 10),
                                Expanded(child: Divider(color: Colors.grey[300])),
                              ]),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(color: Colors.grey[700]),
                                    children: [
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.blue[700]),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          LoginMe();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Log In', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  void LoginMe() async
  {
    User? user = await _auth.SignInWithEmailAndPassword(_emailController.text,_passwordController.text);
    if(user!=null)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
    }
    else
    {
      print('User NOT Found');
    }
  }
}