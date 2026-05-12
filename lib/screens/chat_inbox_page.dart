import 'package:flutter/material.dart';
import '../models/models.dart';
import 'chat_page.dart';

class ChatInboxPage extends StatelessWidget {
  const ChatInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Используем список постов из модели для формирования списка контактов
    final uniqueContacts = <String, Post>{};
    for (var post in posts) {
      if (!uniqueContacts.containsKey(post.authorEmail)) {
        uniqueContacts[post.authorEmail] = post;
      }
    }
    
    final contactList = uniqueContacts.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Community'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: contactList.length,
        separatorBuilder: (context, index) => const Divider(indent: 80),
        itemBuilder: (context, index) {
          final post = contactList[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(post.author[0], 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, 
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )),
            ),
            title: Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(post.comment, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${post.timestamp}m', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    recipientName: post.author,
                    recipientEmail: post.authorEmail,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
