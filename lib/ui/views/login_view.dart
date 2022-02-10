import 'package:diginote/core/providers/login_provider.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/text_styles.dart';
import 'package:diginote/ui/views/register_view.dart';
import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Global key uniquely identifies the form + allows validation
  // Global key is the recommended way to access a form
  final _formKey = GlobalKey<FormState>();
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
                child: const Text('Login', style: headerStyle),
                alignment: Alignment.topLeft,
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
              Consumer<LoginProvider>(builder: (context, loginProvider, child) {
                return ElevatedButton(
                  onPressed: () => _login(loginProvider),
                  child: const Text('Login'),
                );
              }),
              Footer(
                footerText: "Don't have an account?",
                buttonText: 'Register',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterView()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(LoginProvider loginProvider) async {
    if (_formKey.currentState!.validate()) {
      loginProvider.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ScreensView()),
      // );
    }
  }
}

      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Test',
      //   child: Icon(Icons.ac_unit),
      // ),
