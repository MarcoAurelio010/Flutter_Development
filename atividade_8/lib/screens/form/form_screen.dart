import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _countryController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    try {
      await _firestoreService.saveFormData(
        name: _nameController.text,
        email: _emailController.text,
        age: _ageController.text,
        country: _countryController.text,
      );

      _nameController.clear();
      _emailController.clear();
      _ageController.clear();
      _countryController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulário enviado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar formulário: $e'),
          backgroundColor: Colors.red,
        ),
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
      appBar: AppBar(
        title: const Text('Enviar Meus Dados'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Por favor, insira seu nome' : null,
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Por favor, insira seu email';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Insira a idade' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? 'Insira o país' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('SUBMIT'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}