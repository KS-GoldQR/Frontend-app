import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/utils/form_validators.dart';
import 'package:loading_btn/loading_btn.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/global_variables.dart';
import '../../home/widgets/qr_button.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserService _userService = UserService();
  final TextEditingController _phoneNo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _phoneNoFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _loginformKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isSecondBoxVisible = false;

  void togglePassowordVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if(mounted) {
        setState(() {
        isSecondBoxVisible = true;
      });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNo.dispose();
    _password.dispose();
    _phoneNoFocus.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.20),
            const Gap(1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 40.0,
                      color: blueColor,
                      fontWeight: FontWeight.bold),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Smart Sunar'),
                    ],
                    isRepeatingAnimation: false,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                  child: Visibility(
                    visible: isSecondBoxVisible,
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Next-Gen Jewellery App',
                            textAlign: TextAlign.center,
                            speed: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        ],
                        repeatForever: false,
                        totalRepeatCount: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(size.height * 0.10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Form(
                key: _loginformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Id:",
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    TextFormField(
                      controller: _phoneNo,
                      focusNode: _phoneNoFocus,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context, _phoneNoFocus, _passwordFocus);
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: formBorderColor,
                      cursorHeight: 25,
                      decoration: userIdDecoration(hintText: "your user id"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateUserId(value!, context),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Password:",
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    TextFormField(
                      controller: _password,
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (value) {
                        _passwordFocus.unfocus();
                      },
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      obscureText: !isVisible,
                      obscuringCharacter: "*",
                      cursorColor: formBorderColor,
                      cursorHeight: 25,
                      decoration: passwordDecoration(onPressed: togglePassowordVisibility, isVisible: isVisible, hintText: "enter your password"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:(value)=> validatePassword(value!,context),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: LoadingBtn(
                          height: 50,
                          borderRadius: 8,
                          animate: true,
                          color: greyColor,
                          width: MediaQuery.of(context).size.width * 0.45,
                          loader: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: SpinKitDoubleBounce(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (btnState == ButtonState.idle) {
                              if (_loginformKey.currentState!.validate()) {
                                startLoading();
                                await _userService.userLogin(
                                    _phoneNo.text.trim(),
                                    _password.text,
                                    context);
                                stopLoading();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFBDBCBC),
              thickness: 1,
              height: 1,
              indent: 50,
              endIndent: 50,
            ),
            QrButton(size: size),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.only(bottom: 20),
        child: const Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'A product of Golden Nepal IT Solution',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
