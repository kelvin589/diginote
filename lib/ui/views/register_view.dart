import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/text_styles.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  @override
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
                decoration: const InputDecoration(hintText: 'Username'),
                validator: isEmptyValidator,
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
                  }
                },
                child: const Text('Register'),
              ),
              Footer(
                footerText: "Already have an account?",
                buttonText: 'Login',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginView(title: 'Login')),
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
