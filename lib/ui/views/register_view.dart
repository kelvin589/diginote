import 'package:diginote/core/providers/register_provider.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/text_styles.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RegisterForm();
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Header(),
              Container(
                child: const Text('Register', style: headerStyle),
                alignment: Alignment.topLeft,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'Username'),
                validator: isEmptyValidator,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
                validator: isEmptyValidator,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                validator: isEmptyValidator,
              ),
              Consumer<RegisterProvider>(
                  builder: (context, registerProvider, child) {
                return ElevatedButton(
                  onPressed: () => _register(registerProvider),
                  child: const Text('Register'),
                );
              }),
              Footer(
                footerText: "Already have an account?",
                buttonText: 'Login',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register(RegisterProvider registerProvider) async {
    if (_formKey.currentState!.validate()) {
      await registerProvider.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _usernameController.text);
    }
  }
}
