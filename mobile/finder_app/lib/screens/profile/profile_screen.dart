import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: user == null
          ? const Center(child: Text('Not logged in'))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    user.username,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: const Text('Reputation Score'),
                    trailing: Text(
                      '${user.reputationScore}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      auth.logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[50]),
                    child: const Text('Logout', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
    );
  }
}
