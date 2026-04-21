import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends StatefulWidget {
  final User user;
  final LogoutCallback onLogOut;

  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.user,
  });

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            buildProfile(),
            Expanded(
              child: buildMenu(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Travel Support'),
          onTap: () async {
            await launchUrl(Uri.parse('https://jangazy-portfolio.netlify.app/'));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Finance Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {
            widget.onLogOut(true);
          },
        )
      ],
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 60.0,
          child: Icon(Icons.person, size: 60),
        ),
        const SizedBox(height: 16.0),
        Text(
          widget.user.firstName,
          style: const TextStyle(
            fontSize: 21,
          ),
        ),
        Text(widget.user.role),
        const Text(
          '1,200 Miles Earned',
        ),
      ],
    );
  }
}
