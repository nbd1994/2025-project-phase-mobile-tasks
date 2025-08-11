import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/bloc/button/button_state.dart';
import '../../../../core/common/bloc/button/button_state_cubit.dart';
import '../../../../core/common/widgets/button/basic_app_button.dart';
import '../../../../injection_container.dart';
import '../../data/models/signin_request_model.dart';
import '../../domain/usecases/signin_usecase.dart';
import 'signup.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonStateCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          final snackBar = const SnackBar(
            content: Text('Successfully Logged In'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacementNamed(context, '/');
        } else if (state is ButtonFailureState) {
          final snackBar = SnackBar(content: Text(state.errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: BlocBuilder<ButtonStateCubit, ButtonState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              minimum: const EdgeInsets.only(top: 100, right: 16, left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _signin(),
                  const SizedBox(height: 50),
                  _emailField(),
                  const SizedBox(height: 20),
                  _password(),
                  const SizedBox(height: 60),
                  _createAccountButton(context),
                  const SizedBox(height: 20),
                  _signupText(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _signin() {
    return const Text(
      'Sign In',
      style: TextStyle(
        color: Color(0xff2A4ECA),
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
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
          onPressed: () {
            context.read<ButtonStateCubit>().execute(
              useCase: sl<SigninUsecase>(),
              params: SigninRequestModel(
                email: _emailCon.text,
                password: _passwordCon.text,
              ),
            );
          },
          title: 'Login',
        );
      },
    );
  }

  Widget _signupText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "Don't you have account?",
            style: TextStyle(
              color: Color(0xff3B4054),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' Sign Up',
            style: const TextStyle(
              color: Color(0xff3461FD),
              fontWeight: FontWeight.w500,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/signup');
                  },
          ),
        ],
      ),
    );
  }
}
