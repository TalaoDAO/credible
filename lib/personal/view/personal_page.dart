import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';
import 'package:talao/drawer/profile/models/profile.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/personal/cubit/personal_page_cubit.dart';
import 'package:talao/self_issued_credential/sef_issued_credential.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

import '../cubit/personal_page_state.dart';

class PersonalPage extends StatefulWidget {
  final ProfileModel profileModel;
  final bool isFromOnBoarding;

  const PersonalPage({
    Key? key,
    required this.profileModel,
    required this.isFromOnBoarding,
  }) : super(key: key);

  static Route route({required profileModel, required isFromOnBoarding}) =>
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => PersonalPgeCubit()),
            BlocProvider(
                create: (_) => SelfIssuedCredentialCubit(
                    walletCubit: context.read<WalletCubit>(),
                    secureStorageProvider: SecureStorageProvider.instance,
                    didKitProvider: DIDKitProvider.instance,
                    didCubit: context.read<DIDCubit>())),
          ],
          child: PersonalPage(
            profileModel: profileModel,
            isFromOnBoarding: isFromOnBoarding ?? false,
          ),
        ),
        settings: RouteSettings(name: '/personalPage'),
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
  late TextEditingController companyNameController;
  late TextEditingController companyWebsiteController;
  late TextEditingController jobTitleController;

  //
  late final l10n = context.l10n;
  late final personalPageCubit = context.read<PersonalPgeCubit>();
  late final isEnterprise = widget.profileModel.isEnterprise;
  late final enterpriseFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(text: widget.profileModel.firstName);
    lastNameController =
        TextEditingController(text: widget.profileModel.lastName);
    phoneController = TextEditingController(text: widget.profileModel.phone);
    locationController =
        TextEditingController(text: widget.profileModel.location);
    emailController = TextEditingController(text: widget.profileModel.email);
    //enterprise
    companyNameController =
        TextEditingController(text: widget.profileModel.companyName);
    companyWebsiteController =
        TextEditingController(text: widget.profileModel.companyWebsite);
    jobTitleController =
        TextEditingController(text: widget.profileModel.jobTitle);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!widget.isFromOnBoarding) {
          Navigator.pop(context);
        }
        return false;
      },
      child: BasePage(
        title: l10n.personalTitle,
        titleLeading: widget.isFromOnBoarding ? null : BackLeadingButton(),
        floatingActionButton: widget.isFromOnBoarding
            ? null
            : SelfIssuedCredentialButton(
                selfIssuedCredentialButtonClick: _getSelfIssuedCredential,
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        titleTrailing: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () async {
            if (isEnterprise) {
              if (!enterpriseFormKey.currentState!.validate()) {
                return;
              }
            }
            var model = widget.profileModel.copyWith(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                phone: phoneController.text,
                location: locationController.text,
                email: emailController.text,
                companyName: companyNameController.text,
                companyWebsite: companyWebsiteController.text,
                jobTitle: jobTitleController.text,
                issuerVerificationSetting:
                    widget.profileModel.issuerVerificationSetting);

            await context.read<ProfileCubit>().update(model);
            if (widget.isFromOnBoarding) {
              ///save selfIssued credential when user press save button during onboarding
              await context
                  .read<SelfIssuedCredentialCubit>()
                  .createSelfIssuedCredential(
                      selfIssuedCredentialDataModel:
                          _getSelfIssuedCredential());
              await Navigator.of(context)
                  .pushReplacement(CredentialsListPage.route());
            } else {
              Navigator.of(context).pop();

              /// Another pop to close the drawer
              Navigator.of(context).pop();
            }
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
        body: BlocBuilder<PersonalPgeCubit, PersonalPageState>(
            builder: (context, state) {
          return Form(
            key: enterpriseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    l10n.personalSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.subtitle1),
                  ),
                ),
                const SizedBox(height: 32.0),
                BaseTextField(
                  label: l10n.personalFirstName,
                  controller: firstNameController,
                  icon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  validator: !isEnterprise
                      ? null
                      : (value) {
                          if (value?.isEmpty ?? true) {
                            return l10n.thisFieldIsRequired;
                          } else {
                            return null;
                          }
                        },
                  prefixIcon: Checkbox(
                    value: state.isFirstName,
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondaryContainer),
                    onChanged: personalPageCubit.firstNameCheckBoxChange,
                  ),
                ),
                _textFieldSpace(),
                BaseTextField(
                  label: l10n.personalLastName,
                  controller: lastNameController,
                  icon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  validator: !isEnterprise
                      ? null
                      : (value) {
                          if (value?.isEmpty ?? true) {
                            return l10n.thisFieldIsRequired;
                          } else {
                            return null;
                          }
                        },
                  prefixIcon: Checkbox(
                    value: state.isLastName,
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondaryContainer),
                    onChanged: personalPageCubit.lastNameCheckBoxChange,
                  ),
                ),
                _textFieldSpace(),
                BaseTextField(
                  label: l10n.personalPhone,
                  controller: phoneController,
                  icon: Icons.phone,
                  type: TextInputType.phone,
                  validator: !isEnterprise
                      ? null
                      : (value) {
                          if (value?.isEmpty ?? true) {
                            return l10n.thisFieldIsRequired;
                          } else {
                            return null;
                          }
                        },
                  prefixIcon: Checkbox(
                    value: state.isPhone,
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondaryContainer),
                    onChanged: personalPageCubit.phoneCheckBoxChange,
                  ),
                ),
                _textFieldSpace(),
                BaseTextField(
                  label: l10n.personalLocation,
                  controller: locationController,
                  icon: Icons.location_pin,
                  textCapitalization: TextCapitalization.words,
                  validator: !isEnterprise
                      ? null
                      : (value) {
                          if (value?.isEmpty ?? true) {
                            return l10n.thisFieldIsRequired;
                          } else {
                            return null;
                          }
                        },
                  prefixIcon: Checkbox(
                    value: state.isLocation,
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondaryContainer),
                    onChanged: personalPageCubit.locationCheckBoxChange,
                  ),
                ),
                _textFieldSpace(),
                BaseTextField(
                  label: l10n.personalMail,
                  controller: emailController,
                  icon: Icons.email,
                  type: TextInputType.emailAddress,
                  validator: !isEnterprise
                      ? null
                      : (value) {
                          if (value?.isEmpty ?? true) {
                            return l10n.thisFieldIsRequired;
                          } else {
                            return null;
                          }
                        },
                  prefixIcon: Checkbox(
                    value: state.isEmail,
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondaryContainer),
                    onChanged: personalPageCubit.emailCheckBoxChange,
                  ),
                ),
                if (isEnterprise) _buildEnterpriseTextFields(state)
              ],
            ),
          );
        }),
        navigation: !widget.isFromOnBoarding || isEnterprise
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BaseButton.primary(
                        context: context,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(CredentialsListPage.route());
                        },
                        child: Text(l10n.personalSkip),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  SelfIssuedCredentialDataModel _getSelfIssuedCredential() {
    final selfIssuedCredentialDataModel = SelfIssuedCredentialDataModel(
      givenName: personalPageCubit.state.isFirstName
          ? firstNameController.text.isNotEmpty
              ? firstNameController.text
              : null
          : null,
      familyName: personalPageCubit.state.isLastName
          ? lastNameController.text.isNotEmpty
              ? lastNameController.text
              : null
          : null,
      telephone: personalPageCubit.state.isPhone
          ? phoneController.text.isNotEmpty
              ? phoneController.text
              : null
          : null,
      address:
          personalPageCubit.state.isLocation ? locationController.text : null,
      email: personalPageCubit.state.isEmail ? emailController.text : null,
      companyName: personalPageCubit.state.isCompanyName
          ? companyNameController.text
          : null,
      companyWebsite: personalPageCubit.state.isCompanyWebsite
          ? companyWebsiteController.text
          : null,
      jobTitle:
          personalPageCubit.state.isJobTitle ? jobTitleController.text : null,
    );

    return selfIssuedCredentialDataModel;
  }

  Widget _textFieldSpace() {
    return const SizedBox(height: 16.0);
  }

  Widget _buildEnterpriseTextFields(PersonalPageState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _textFieldSpace(),
        BaseTextField(
          label: l10n.companyName,
          controller: companyNameController,
          icon: Icons.apartment,
          type: TextInputType.text,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.thisFieldIsRequired;
            } else {
              return null;
            }
          },
          prefixIcon: Checkbox(
            value: state.isCompanyName,
            fillColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondaryContainer),
            onChanged: personalPageCubit.companyNameCheckBoxChange,
          ),
        ),
        _textFieldSpace(),
        BaseTextField(
          label: l10n.companyWebsite,
          controller: companyWebsiteController,
          icon: Icons.web_outlined,
          type: TextInputType.url,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.thisFieldIsRequired;
            } else {
              return null;
            }
          },
          prefixIcon: Checkbox(
            value: state.isCompanyWebsite,
            fillColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondaryContainer),
            onChanged: personalPageCubit.companyWebsiteCheckBoxChange,
          ),
        ),
        _textFieldSpace(),
        BaseTextField(
          label: l10n.jobTitle,
          controller: jobTitleController,
          icon: Icons.work_outlined,
          type: TextInputType.text,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return l10n.thisFieldIsRequired;
            } else {
              return null;
            }
          },
          prefixIcon: Checkbox(
            value: state.isJobTitle,
            fillColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondaryContainer),
            onChanged: personalPageCubit.jobTitleCheckBoxChange,
          ),
        ),
        _textFieldSpace()
      ],
    );
  }
}
