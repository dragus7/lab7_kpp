import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Тестові дані користувача — заміни на реальні або отримуй з бази
    final String name = 'Богдан Білинський';
    final String email = 'BohdanBilynskyi@example.com';
    final String avatarPath = 'assets/images/unnamed.jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(avatarPath),
            ),
            const SizedBox(height: 16),
            Text(name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Редагувати профіль'),
              onTap: () {
                // TODO: реалізувати редагування
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Вийти з акаунта'),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
