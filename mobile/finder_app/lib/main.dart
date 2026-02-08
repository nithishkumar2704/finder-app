import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/chat.dart';
import 'models/item.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/items/item_detail_screen.dart';
import 'screens/items/post_item_screen.dart';
import 'screens/chat/conversation_list_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/home/search_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/items/claim_submission_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],

      child: const FinderApp(),
    ),
  );
}

class FinderApp extends StatelessWidget {
  const FinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finder App',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/post-item': (context) => const PostItemScreen(),
        '/conversations': (context) => const ConversationListScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item-detail') {
          final item = settings.arguments as Item;
          return MaterialPageRoute(
            builder: (context) => ItemDetailScreen(item: item),
          );
        }
        if (settings.name == '/chat') {
          final conversation = settings.arguments as Conversation;
          return MaterialPageRoute(
            builder: (context) => ChatScreen(conversation: conversation),
          );
        }
        if (settings.name == '/submit-claim') {
          final item = settings.arguments as Item;
          return MaterialPageRoute(
            builder: (context) => ClaimSubmissionScreen(item: item),
          );
        }
        return null;
      },

    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<void> _authFuture;

  @override
  void initState() {
    super.initState();
    // Only trigger once to avoid infinite loop
    _authFuture = Provider.of<AuthProvider>(context, listen: false)
        .checkAuthStatus()
        .timeout(const Duration(seconds: 15), onTimeout: () {
      debugPrint('Auth check timed out after 15 seconds.');
      throw 'Connection timed out. Please check if your backend is running.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Starting Finder App...'),
                ],
              ),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error initializing app: ${snapshot.error}')),
          );
        }

        return Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
