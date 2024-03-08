import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: const Text('User Details'),
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
