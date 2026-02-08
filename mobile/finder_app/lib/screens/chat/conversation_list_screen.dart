import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Messages')),
      body: Consumer<ChatProvider>(
        builder: (context, chat, _) {
          if (chat.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chat.conversations.isEmpty) {
            return const Center(
              child: Text('No conversations yet.\nStart a chat from an item!',
                  textAlign: TextAlign.center),
            );
          }

          return ListView.separated(
            itemCount: chat.conversations.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final conversation = chat.conversations[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(conversation.otherUsername[0].toUpperCase()),
                ),
                title: Text(conversation.otherUsername),
                subtitle: Text(
                  conversation.lastMessage?.content ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  conversation.itemTitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/chat', arguments: conversation);
                },
              );
            },
          );
        },
      ),
    );
  }
}
