import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ajánlatkérés elküldve!")),
      );

      nameController.clear();
      emailController.clear();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajánlatkérés"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Név"),
                validator: (value) =>
                value!.isEmpty ? "Kötelező mező" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                value!.isEmpty ? "Kötelező mező" : null,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(labelText: "Üzenet"),
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? "Kötelező mező" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Küldés"),
              )
            ],
          ),
        ),
      ),
    );
  }
}