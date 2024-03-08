import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grit_qr_scanner/features/home/screens/change_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../provider/user_provider.dart';
import '../../../utils/global_variables.dart';
import '../screens/user_details_screen.dart';
import 'select_language.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '${AppLocalizations.of(context)!.goodMorning}!';
    } else if (hour < 18) {
      return '${AppLocalizations.of(context)!.goodAfternoon}!';
    } else {
      return '${AppLocalizations.of(context)!.goodEvening}!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final greeting = _getGreeting(context);

    return Drawer(
      child: Column(
        children: [
          // User Details Section
          GestureDetector(
            onTap: () {
              navigatorKey.currentState!.pushNamed(UserDetailsScreen.routeName);
              scaffoldKey.currentState?.closeDrawer();
            },
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: blueColor),
              accountName: Text(greeting),
              accountEmail: null,
              currentAccountPicture: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Remix.user_line,
                  size: 40,
                ),
              ),
            ),
          ),
          // Navigation Tiles
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageSelectionScreen()));
              scaffoldKey.currentState?.closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(
              Remix.rotate_lock_line,
            ),
            title: Text(AppLocalizations.of(context)!.changePassword),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()));
              scaffoldKey.currentState?.closeDrawer();
            },
          ),
          //add more list tile if needed
        ],
      ),
    );
  }
}
