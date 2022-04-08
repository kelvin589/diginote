import 'package:diginote/core/providers/firebase_login_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:diginote/ui/shared/styling_constants.dart';
import 'package:diginote/ui/views/home_view.dart';
import 'package:diginote/ui/views/register_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key, required this.applicationLoginState})
      : super(key: key);

  static const String route = '/login';

  final ApplicationLoginState applicationLoginState;

  @override
  Widget build(BuildContext context) {
    switch (applicationLoginState) {
      case ApplicationLoginState.loggedIn:
        return const HomeView();
      case ApplicationLoginState.loggedOut:
        return const LoginForm();
      default:
        return const Text("Unknown error occured");
    }
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Global key uniquely identifies the form + allows validation
  // Global key is the recommended way to access a form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: contentHorizontalPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Header(),
                  Container(
                    child: const Text('Login', style: headerStyle),
                    alignment: Alignment.topLeft,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: Validator.isValidEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: Validator.isValidPassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  Consumer<FirebaseLoginProvider>(
                      builder: (context, loginProvider, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        await _login(loginProvider);
                      },
                      child: const Text('Login'),
                    );
                  }),
                  Footer(
                    footerText: "Don't have an account?",
                    buttonText: 'Register',
                    onPressed: () async {
                      await Navigator.pushReplacementNamed(
                          context, RegisterView.route);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(FirebaseLoginProvider loginProvider) async {
    if (_formKey.currentState!.validate()) {
      await loginProvider.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        (exception) =>
            DialogueHelper.showErrorDialogue(context, 'Login Error', exception),
      );
    }
  }
}
