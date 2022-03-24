import 'package:diginote/core/providers/firebase_register_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/shared/state_enums.dart';
import 'package:diginote/ui/shared/styling_constants.dart';
import 'package:diginote/ui/views/login_view.dart';
import 'package:diginote/ui/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key, required this.applicationRegisterState})
      : super(key: key);

  static const String route = '/register';

  final ApplicationRegisterState applicationRegisterState;

  @override
  Widget build(BuildContext context) {
    switch (applicationRegisterState) {
      case ApplicationRegisterState.registered:
        Future.delayed(
            Duration.zero,
            () => DialogueHelper.showSuccessDialogue(
                context,
                'Successful Registration',
                'Successfully created an account. You can login.'));
        return const RegisterForm();
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
                    child: const Text('Register', style: headerStyle),
                    alignment: Alignment.topLeft,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(hintText: 'Username'),
                    validator: Validator.isValidUsername,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  Consumer<FirebaseRegisterProvider>(
                      builder: (context, registerProvider, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        await _register(registerProvider);
                      },
                      child: const Text('Register'),
                    );
                  }),
                  Footer(
                    footerText: "Already have an account?",
                    buttonText: 'Login',
                    onPressed: () async {
                      Provider.of<FirebaseRegisterProvider>(context, listen: false).resetState();
                      Navigator.pushReplacementNamed(context, LoginView.route);
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

  Future<void> _register(FirebaseRegisterProvider registerProvider) async {
    if (_formKey.currentState!.validate()) {
      await registerProvider.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
        (exception) => DialogueHelper.showErrorDialogue(
            context, 'Registration Error', exception),
      );
    }
  }
}
