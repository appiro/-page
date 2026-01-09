import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signInWithGoogle();

    if (mounted) {
      setState(() {
        _isSigningIn = false;
      });

      if (!success && authProvider.errorMessage != null) {
        _showErrorDialog(authProvider.errorMessage!);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon
                Icon(
                  Icons.fitness_center,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                
                // App Name
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                
                // Tagline
                Text(
                  'Track your workouts, achieve your goals',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                
                // Sign In Button
                _isSigningIn
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _handleGoogleSignIn,
                        icon: const Icon(Icons.login, size: 24),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, AppConstants.minTapTargetSize),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),
                
                // Info Text
                Text(
                  'Sign in to sync your data across devices',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
