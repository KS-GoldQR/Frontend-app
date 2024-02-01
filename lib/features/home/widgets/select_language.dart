import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grit_qr_scanner/provider/language_provider.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum Language { english, nepali }

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late Language selectedLanguage;
  bool _isChanging = false;
  final _modalProgressHUDKeyLanguage = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Access the LanguageChangeProvider to get the current app locale
    Locale currentLocale =
        Provider.of<LanguageChangeProvider>(context, listen: false).appLocale ??
            const Locale('ne');

    // Initialize selectedLanguage based on the current locale
    selectedLanguage = currentLocale == const Locale('ne')
        ? Language.nepali
        : Language.english;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      key: _modalProgressHUDKeyLanguage,
      inAsyncCall: _isChanging,
      progressIndicator: const SpinKitChasingDots(color: blueColor),
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: blueColor,
          title: Text(
            AppLocalizations.of(context)!.chooseLanguage,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<LanguageChangeProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.selectALanguage}:',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile(
                    activeColor: blueColor,
                    title: Text(AppLocalizations.of(context)!.english),
                    value: Language.english,
                    groupValue: selectedLanguage,
                    onChanged: (value) async {
                      setState(() {
                        _isChanging = true;
                        selectedLanguage = value!;
                      });
                      provider.changeLangauge(const Locale('en'));
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        _isChanging = false;
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: blueColor,
                    title: Text(AppLocalizations.of(context)!.nepali),
                    value: Language.nepali,
                    groupValue: selectedLanguage,
                    onChanged: (value) async {
                      setState(() {
                        _isChanging = true;
                        selectedLanguage = value!;
                      });
                      provider.changeLangauge(const Locale('ne'));
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        _isChanging = false;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
