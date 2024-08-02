import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tukar_barang/services/auth_service.dart';
import 'package:tukar_barang/services/item_list_screen.dart';
import 'package:tukar_barang/services/item_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ItemService>(create: (_) => ItemService()),
      ],
      child: MaterialApp(
        title: 'Tukar Barang',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<bool>(
          future: AuthService().isLoggedIn(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return snapshot.data! ? ItemListScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await Provider.of<AuthService>(context, listen: false).signIn(
                  _emailController.text,
                  _passwordController.text,
                );
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ItemListScreen()),
                  );
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () async {
                bool success = await Provider.of<AuthService>(context, listen: false).register(
                  _emailController.text,
                  _passwordController.text,
                );
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered successfully')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
