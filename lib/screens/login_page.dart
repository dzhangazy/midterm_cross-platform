import 'package:flutter/material.dart';

class Credentials {
  Credentials(this.username, this.password);
  final String username;
  final String password;
}

class LoginPage extends StatefulWidget {
  const LoginPage({required this.onLogIn, required this.onRegister, super.key});
  final Future<void> Function(Credentials) onLogIn;
  final Future<void> Function(Credentials) onRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _handleAction(Credentials creds) async {
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await widget.onLogIn(creds);
      } else {
        await widget.onRegister(creds);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/finance_bg.webp', fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.6))),
          Center(
            child: SingleChildScrollView(
              child: FractionallySizedBox(
                widthFactor: 0.85,
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoginForm(
                          onSubmit: _handleAction,
                          isLogin: _isLogin,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : () => setState(() => _isLogin = !_isLogin),
                          child: Text(_isLogin ? "Need an account? Register" : "Have an account? Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final Future<void> Function(Credentials) onSubmit;
  final bool isLogin;
  final bool isLoading;

  const LoginForm({required this.onSubmit, required this.isLogin, required this.isLoading, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(widget.isLogin ? Icons.lock_outline : Icons.person_add_outlined, 
             size: 64, color: widget.isLogin ? Colors.blue : Colors.green),
        const SizedBox(height: 16),
        Text(widget.isLogin ? 'Login' : 'Register', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          enabled: !widget.isLoading,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passController,
          obscureText: true,
          enabled: !widget.isLoading,
          decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.isLoading 
              ? null 
              : () => widget.onSubmit(Credentials(_emailController.text, _passController.text)),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isLogin ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: widget.isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : Text(widget.isLogin ? 'Login' : 'Create Account'),
          ),
        ),
      ],
    );
  }
}
