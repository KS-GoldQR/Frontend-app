import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/home/screens/change_password_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../models/user_model.dart';
import '../../../provider/user_provider.dart';
import '../../../utils/global_variables.dart';

class UserDetailsScreen extends StatelessWidget {
  static const String routeName = '/user-details-screen';
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: blueColor,
              child: Icon(
                Remix.user_line,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16.0),
            buildUserInfoCard(user, context),
            const Gap(20),
            changePassword(
              context: context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfoCard(User user, BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoRow(AppLocalizations.of(context)!.name, user.name!),
            buildInfoRow(
                AppLocalizations.of(context)!.contactNumber, user.phoneNo!),
            buildInfoRow(AppLocalizations.of(context)!.subscriptionEndsAt,
                DateFormat.yMMMd().format(user.subscriptionEndsAt!)),
            buildInfoRow(
                AppLocalizations.of(context)!.appVersion, user.appVersion!),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 16.0,
                  color: blueColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

Widget changePassword(
    {required VoidCallback onTap, required BuildContext context}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: blueColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.changePassword,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Icon(
            Remix.rotate_lock_line,
            color: Colors.white,
            size: 30.0,
          ),
        ],
      ),
    ),
  );
}
