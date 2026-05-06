import 'package:flutter/material.dart'; 
import '../services/auth_service.dart'; 

class RegisterPage extends StatefulWidget { 
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController(); 
  final password = TextEditingController(); 
  final npm = TextEditingController();
  bool isLoading = false;

  void register() async { 
    if (_formKey.currentState!.validate()) {
      setState(() { isLoading = true; });
      bool success = await AuthService.register(name.text, email.text, password.text, npm.text); 
      setState(() { isLoading = false; });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Register berhasil. Silakan login.")),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Register gagal. Pastikan email unik.")),
        );
      }
    }
  } 

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: Text("Register")), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column( 
            children: [ 
              TextFormField(
                controller: name, 
                decoration: InputDecoration(labelText: "Name", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ), 
              SizedBox(height: 16),
              TextFormField(
                controller: email, 
                decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email wajib diisi';
                  if (!value.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ), 
              SizedBox(height: 16),
              TextFormField(
                controller: npm, 
                decoration: InputDecoration(labelText: "NPM", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'NPM wajib diisi' : null,
              ), 
              SizedBox(height: 16),
              TextFormField(
                controller: password, 
                decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Password minimal 6 karakter' : null,
              ), 
              SizedBox(height: 24),
              isLoading 
                ? CircularProgressIndicator() 
                : ElevatedButton(
                    onPressed: register, 
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ), 
            ], 
          ),
        ), 
      ), 
    ); 
  } 
}
