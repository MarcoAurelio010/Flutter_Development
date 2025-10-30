import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:atividade_8/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // intância para o serviço de identificação
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _handleLogin() async {
    if (!mounted) return;

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha e-mail e senha.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Inicia o indicador de progresso
    });

    try {
      await _authService.signInWithEmailAndPassword(email, password);
    
    } on FirebaseAuthException catch (e) {
      String message;
      switch(e.code) {
        case 'user-not-found':
          message = 'Nenhum usuário encontrado para este e-mail.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta. Tente novamente.';
          break;
        case 'invalid-email':
          message = 'O formato do e-mail é inválido.';
          break;
        default:
          message = 'Ocorreu um erro. Tente novamente mais tarde.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro inesperado: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // fundo cinza claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey[800],
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Campo Usuário
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Usuário",
                ),
              ),
              const SizedBox(height: 16),

              // Campo Senha
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Senha",
                ),
              ),
              const SizedBox(height: 24),

              // Botão Entrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}