import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/text_styles.dart';
import 'package:diginote/ui/views/register_view.dart';
import 'package:diginote/ui/views/screens_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';

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
                decoration: const InputDecoration(hintText: 'Email'),
                validator: isEmptyValidator,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                validator: isEmptyValidator,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScreensView()),
                    );
                  }
                },
                child: const Text('Login'),
              ),
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
}

      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Test',
      //   child: Icon(Icons.ac_unit),
      // ),
