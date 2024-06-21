import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:weight_app/components/my_text_field.dart';
import 'package:weight_app/screens/auth/blocs/register_bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool registerRequested = false;
  String? _successMsg;
  String? _errorMsg;
  Map<String, String>? _fieldErrors;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        log(state.toString());
        if (state is RegisterSuccess) {
          setState(() {
            registerRequested = false;
            nameController.text = '';
            emailController.text = '';
            passwordController.text = '';
            _successMsg = AppLocalizations.of(context)!.registerSuccessful;
          });
        } else if (state is RegisterLoading) {
          setState(() {
            registerRequested = true;
          });
        } else if (state is RegisterGenericFailure) {
          setState(() {
            _errorMsg = AppLocalizations.of(context)!.requestFailed;
            _fieldErrors = null;
          });
        } else if (state is RegisterRequestRejected) {
          setState(() {
            registerRequested = false;
            _errorMsg = state.message;
            _fieldErrors =
                state.errors.map((key, value) => MapEntry(key, value.first));
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (_successMsg != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    _successMsg!,
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
              ],
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
                    controller: nameController,
                    hintText: AppLocalizations.of(context)!.name,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    errorMsg: _fieldErrors?['name'],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseFillField;
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 10),
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
                    }),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              !registerRequested
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                context.read<RegisterBloc>().add(
                                    RegisterRequested(
                                        AppLocalizations.of(context)!
                                            .localeName,
                                        nameController.text,
                                        emailController.text,
                                        passwordController.text));
                              });
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
                              AppLocalizations.of(context)!.register,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  : const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
