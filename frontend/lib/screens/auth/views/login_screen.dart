// reference: https://github.com/romain-girou/pizza_app

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weight_app/blocs/auth_bloc/auth_bloc.dart';

import 'package:weight_app/components/my_text_field.dart';
import 'package:weight_app/screens/auth/blocs/login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loginRequested = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;
  Map<String, String>? _fieldErrors;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AuthBloc>().add(AuthUserChanged(state.authUser));
          setState(() {
            loginRequested = false;
            _errorMsg = null;
            _fieldErrors = null;
          });
        } else if (state is LoginLoading) {
          setState(() {
            loginRequested = true;
          });
        } else if (state is LoginGenericFailure) {
          setState(() {
            loginRequested = false;
            _errorMsg = AppLocalizations.of(context)!.requestFailed;
            _fieldErrors = null;
          });
        } else if (state is LoginRequestRejected) {
          setState(() {
            loginRequested = false;
            _errorMsg = state.message;
            _fieldErrors =
                state.errors.map((key, value) => MapEntry(key, value.first));
          });
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (_errorMsg != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  errorMsg: _fieldErrors?['email'],
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseFillField;
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return AppLocalizations.of(context)!
                          .pleaseEnterValidEmail;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _fieldErrors?['password'],
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseFillField;
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              !loginRequested
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(LoginRequested(
                                  AppLocalizations.of(context)!.localeName,
                                  emailController.text,
                                  passwordController.text));
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  : const CircularProgressIndicator(),
            ],
          )),
    );
  }
}
