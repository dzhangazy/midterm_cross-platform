import 'package:flutter/material.dart';

/// Credential Class
class Credentials {
  Credentials(this.username, this.password);
  final String username;
  final String password;
}

class LoginPage extends StatelessWidget {
  const LoginPage({required this.onLogIn, super.key});

  /// Called when users sign in with [Credentials].
  final ValueChanged<Credentials> onLogIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 700) {
            // Display Desktop View
            return Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/finance_bg.webp',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                      widthFactor: 0.70,
                      child: LoginForm(
                        onLogIn: onLogIn,
                      )),
                ),
              ],
            );
          } else {
            // Display Mobile View
            return Column(
              children: [
                Expanded(
                  child: LoginForm(onLogIn: onLogIn),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({required this.onLogIn, super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueChanged<Credentials> onLogIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/app_logo.png',
            height: 150,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Finance & Trip Tracker',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () async {
              onLogIn(Credentials(_usernameController.value.text,
                  _passwordController.value.text));
            },
          ),
        ],
      ),
    );
  }
}
