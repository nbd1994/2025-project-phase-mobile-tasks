import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/bloc/button/button_state.dart';
import '../../../../core/common/bloc/button/button_state_cubit.dart';
import '../../../../injection_container.dart';
import '../../data/models/signup_request_model.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../../../core/common/widgets/button/basic_app_button.dart';
import 'signin.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _usernameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            final snackBar = const SnackBar(
              content: Text('Successfully Registered'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushReplacementNamed(context, '/signin');
          } else if (state is ButtonFailureState) {
            final snackBar = SnackBar(content: Text(state.errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<ButtonStateCubit, ButtonState>(
          builder: (context, state) {
            return SafeArea(
              minimum: const EdgeInsets.only(top: 100, right: 16, left: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _signup(),
                    const SizedBox(height: 50),
                    _userNameField(),
                    const SizedBox(height: 20),
                    _emailField(),
                    const SizedBox(height: 20),
                    _password(),
                    const SizedBox(height: 60),
                    _createAccountButton(context),
                    const SizedBox(height: 20),
                    _signinText(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _signup() {
    return const Text(
      'Sign Up',
      style: TextStyle(
        color: Color(0xff2A4ECA),
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
    );
  }

  Widget _userNameField() {
    return TextField(
      controller: _usernameCon,
      decoration: const InputDecoration(hintText: 'Username'),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Email'),
    );
  }

  Widget _password() {
    return TextField(
      controller: _passwordCon,
      decoration: const InputDecoration(hintText: 'Password'),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicAppButton(
          onPressed: () async {
            final useCase = sl<SignupUsecase>();
            final request = SignupRequestModel(
              name: _usernameCon.text,
              email: _emailCon.text,
              password: _passwordCon.text,
            );
            context.read<ButtonStateCubit>().execute(
              useCase: useCase,
              params: request,
            );
          },
          title: 'Create Account',
        );
      },
    );
  }

  Widget _signinText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Do you have account?',
            style: TextStyle(
              color: Color(0xff3B4054),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' Sign In',
            style: const TextStyle(
              color: Color(0xff3461FD),
              fontWeight: FontWeight.w500,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(
                      context,
                      '/signin'
                    );
                  },
          ),
        ],
      ),
    );
  }
}
