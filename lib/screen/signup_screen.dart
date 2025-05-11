import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/screen/login_screen.dart';
import 'package:listify/screen/home_screen.dart';
import 'package:listify/UserAuth/UserAuthentication.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final UserAuthentication _auth=UserAuthentication();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
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
                          Text(
                            'Create Account',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign up to get started',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          _buildTextField(_usernameController, 'Username', Icons.person, false, (value) {
                            if (value == null || value.isEmpty) return 'Enter username';
                            return null;
                          }),
                          const SizedBox(height: 16),
                          _buildTextField(_emailController, 'Email', Icons.email, false, (value) {
                            if (value == null || value.isEmpty) return 'Enter email';
                            return null;
                          }),
                          const SizedBox(height: 16),
                          _buildTextField(
                            _passwordController,
                            'Password',
                            Icons.lock,
                            _obscureText,
                                (value) => value == null || value.isEmpty ? 'Enter password' : null,
                            suffix: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => _obscureText = !_obscureText);
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                                SignUpMe();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.blue[700],
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(thickness: 0.5, color: Colors.grey),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                                child: const Text('Login', style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      bool obscure,
      String? Function(String?) validator, {
        Widget? suffix,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: label == 'Email' ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[100]!)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2)),
      ),
    );
  }

  void SignUpMe() async
      {
        User? user = await _auth.SignUpwithEmailAndPassword(_emailController.text, _passwordController.text);

        if(user!=null)
          {
            print('Signup Success!');
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
          }
        else
          {
            print('User Already Exists');
          }
      }

}
