import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/custom_decorators.dart';
import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../services/user_service.dart';

enum PasswordType {
  newPassword,
  confirmNewPassword,
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _changePasswordFormKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();
  final FocusNode _currentPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmNewPasswordFocus = FocusNode();
  bool isNewPasswordVisible = false;
  bool isConfirmNewPasswordVisible = false;
  bool _isSubmitting = false;

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void togglePassowordVisibility(PasswordType type) {
    setState(() {
      if (type == PasswordType.newPassword) {
        isNewPasswordVisible = !isNewPasswordVisible;
      } else if (type == PasswordType.confirmNewPassword) {
        isConfirmNewPasswordVisible = !isConfirmNewPasswordVisible;
      }
    });
  }

  void _validateConfirmPassword() {
    if (_newPassword.text.isNotEmpty && _confirmNewPassword.text.isNotEmpty) {
      if (_newPassword.text == _confirmNewPassword.text) {
        _confirmNewPasswordFocus.unfocus();
      } else {
        _changePasswordFormKey.currentState?.validate();
      }
    }
  }

  void changePasswordSubmit() async {
    setState(() {
      _isSubmitting = true;
    });
    bool isPasswordChanged = await _userService.changePassword(
        context: context,
        currentPassword: _currentPassword.text.trim(),
        newPassword: _newPassword.text.trim());

    if (isPasswordChanged) {
      navigatorKey.currentState!.pop();
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    super.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmNewPasswordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isSubmitting,
      progressIndicator: const SpinKitDoubleBounce(color: blueColor),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              AppLocalizations.of(context)!.changePassword,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _changePasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentPassword,
                    style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  TextFormField(
                    controller: _currentPassword,
                    focusNode: _currentPasswordFocus,
                    onFieldSubmitted: (value) {
                      _fieldFocusChange(
                          context, _currentPasswordFocus, _newPasswordFocus);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: formBorderColor,
                    cursorHeight: 25,
                    decoration: userIdDecoration(
                        hintText:
                            AppLocalizations.of(context)!.yourCurrentPassword),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => validatePassword(value!, context),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.newPassword,
                    style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  TextFormField(
                    controller: _newPassword,
                    focusNode: _newPasswordFocus,
                    onFieldSubmitted: (value) {
                      _fieldFocusChange(
                          context, _newPasswordFocus, _confirmNewPasswordFocus);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscureText: !isNewPasswordVisible,
                    obscuringCharacter: "*",
                    cursorColor: formBorderColor,
                    cursorHeight: 25,
                    decoration: passwordDecoration(
                        onPressed: () =>
                            togglePassowordVisibility(PasswordType.newPassword),
                        isVisible: isNewPasswordVisible,
                        hintText:
                            AppLocalizations.of(context)!.yourNewPassword),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => validatePassword(value!, context),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.confirmNewPassword,
                    style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  TextFormField(
                    controller: _confirmNewPassword,
                    focusNode: _confirmNewPasswordFocus,
                    onFieldSubmitted: (value) {
                      _confirmNewPasswordFocus.unfocus();
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: !isConfirmNewPasswordVisible,
                    obscuringCharacter: "*",
                    cursorColor: formBorderColor,
                    cursorHeight: 25,
                    decoration: passwordDecoration(
                        onPressed: () => togglePassowordVisibility(
                            PasswordType.confirmNewPassword),
                        isVisible: isConfirmNewPasswordVisible,
                        hintText:
                            AppLocalizations.of(context)!.confirmNewPassword),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => validateConfirmPassword(
                        value!, _newPassword.text, context),
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    onPressed: () {
                      if (_changePasswordFormKey.currentState!.validate()) {
                        changePasswordSubmit();
                      }
                    },
                    text: AppLocalizations.of(context)!.changePassword,
                    textColor: Colors.white,
                    backgroundColor: blueColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
