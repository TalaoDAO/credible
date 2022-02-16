import 'package:provider/src/provider.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:flutter/material.dart';
import 'package:talao/profile/profile.dart';

class PersonalPage extends StatefulWidget {
  final ProfileModel profile;

  const PersonalPage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  static Route route(profile) => MaterialPageRoute(
        builder: (context) => PersonalPage(profile: profile),
        settings: RouteSettings(
          name: '/personalPage',
        ),
      );

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.profile.firstName);
    lastNameController = TextEditingController(text: widget.profile.lastName);
    phoneController = TextEditingController(text: widget.profile.phone);
    locationController = TextEditingController(text: widget.profile.location);
    emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.personalTitle,
      titleLeading: BackLeadingButton(),
      titleTrailing: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          context.read<ProfileBloc>().add(ProfileEventUpdate(ProfileModel(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              phone: phoneController.text,
              location: locationController.text,
              email: emailController.text,
              issuerVerificationSetting:
                  widget.profile.issuerVerificationSetting)));
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Text(
            l10n.personalSave,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              l10n.personalSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Theme.of(context).colorScheme.subtitle1),
            ),
          ),
          // Center(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.2,
          //     height: MediaQuery.of(context).size.width * 0.2,
          //     decoration: BoxDecoration(
          //       color: Colors.pink,
          //       borderRadius: BorderRadius.circular(16.0),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 32.0),
          BaseTextField(
            label: l10n.personalFirstName,
            controller: firstNameController,
            icon: Icons.person,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: l10n.personalLastName,
            controller: lastNameController,
            icon: Icons.person,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: l10n.personalPhone,
            controller: phoneController,
            icon: Icons.phone,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: l10n.personalLocation,
            controller: locationController,
            icon: Icons.location_pin,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: l10n.personalMail,
            controller: emailController,
            icon: Icons.email,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
