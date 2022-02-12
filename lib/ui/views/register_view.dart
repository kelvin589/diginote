import 'package:diginote/core/providers/firebase_register_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:diginote/ui/shared/text_styles.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key, required this.applicationRegisterState}) : super(key: key);

  static const String route = '/register';

  final ApplicationRegisterState applicationRegisterState;

  @override
  Widget build(BuildContext context) {
    switch (applicationRegisterState) {
      case ApplicationRegisterState.registered:
        return const Text("Registered");
      case ApplicationRegisterState.registering:
        return const RegisterForm();
      default:
        return const Text("Unknown error occured");
    }
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
              Consumer<FirebaseRegisterProvider>(
                  builder: (context, registerProvider, child) {
                return ElevatedButton(
                  onPressed: () => _register(registerProvider),
                  child: const Text('Register'),
                );
              }),
              Footer(
                footerText: "Already have an account?",
                buttonText: 'Login',
                onPressed: () => Navigator.pushReplacementNamed(context, LoginView.route),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register(FirebaseRegisterProvider registerProvider) async {
    if (_formKey.currentState!.validate()) {
      await registerProvider.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
          (exception) => DialogueHelper.showErrorDialogue(context, 'Registration Error', exception),
      );
    }
  }
}
