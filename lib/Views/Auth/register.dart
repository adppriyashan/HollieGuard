import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:hollieguard/Controllers/AuthController.dart';
import 'package:hollieguard/Models/Strings/main_screen.dart';
import 'package:hollieguard/Models/Utils/Common.dart';
import 'package:hollieguard/Models/Utils/Utils.dart';
import 'package:hollieguard/Views/Widgets/custom_button.dart';
import 'package:hollieguard/Views/Widgets/custom_dropdown.dart';
import 'package:hollieguard/Views/Widgets/custom_text_area.dart';
import 'package:hollieguard/Views/Widgets/custom_text_date_chooser.dart';
import 'package:hollieguard/Views/Widgets/custom_text_form_field.dart';

import '../../Models/Strings/register_screen.dart';
import '../../Models/Utils/Colors.dart';
import '../../Models/Utils/Routes.dart';
import '../Widgets/custom_back_button.dart';

class BusinessRegister extends StatefulWidget {
  BusinessRegister({Key? key}) : super(key: key);

  @override
  State<BusinessRegister> createState() => _BusinessRegisterState();
}

class _BusinessRegisterState extends State<BusinessRegister> {
  bool termsAndConditionCheck = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm_password = TextEditingController();

  List<String> provinceList=[
      'Western',
      'Uva',
      'Southern',
      'Sabaragamuwa',
      'North Western',
      'Northern',
      'North Central',
      'Eastern',
      'Central'
    ];

  String? province;

  List<DropdownMenuItem<String>> _provinceList = [];

  final _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  @override
  void initState() {
    _name.text = "User";
    _email.text = "user@gmail.com";
    _contact.text = "0779778269";
    _address.text = "Colombo";
    _birthday.text = CustomUtils.formatDate(DateTime.now());
    _password.text = "User@123";
    _confirm_password.text = "User@123";

    enrollPrivinceData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color6,
      body: SafeArea(
          child: SizedBox(
              height: displaySize.height,
              width: displaySize.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CustomCustomBackButton(onclickFunction: () {
                            Routes(context: context).back();
                          })),
                      const Center(
                        child: Text(
                          Signup_title,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _name,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Full Name',
                                      icon: Icons.person_outline,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );
                                        return validator.validate(
                                          label:
                                              register_validation_invalid_name,
                                          value: value,
                                        );
                                      },
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _email,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Email',
                                      icon: Icons.email_outlined,
                                      textInputType: TextInputType.emailAddress,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );
                                        return validator.validate(
                                          label:
                                              register_validation_invalid_email,
                                          value: value,
                                        );
                                      },
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _contact,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Mobile Number',
                                      icon: Icons.phone,
                                      textInputType: TextInputType.emailAddress,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );
                                        return validator.validate(
                                          label:
                                              register_validation_invalid_mobile_number,
                                          value: value,
                                        );
                                      },
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextDateChooser(
                                      height: 5.0,
                                      controller: _birthday,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Birthdate',
                                      icon: Icons.calendar_month,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );
                                        return validator.validate(
                                          label:
                                              register_validation_invalid_birthdate,
                                          value: value,
                                        );
                                      },
                                      obscureText: false),
                                ),
                                (_provinceList.isNotEmpty)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 5.0),
                                        child: CustomDropDown(
                                            dropdown_value: province ??
                                                (_provinceList.first.value ??
                                                    'Western'),
                                            action_icon_color: colorPrimary,
                                            text_color: colorPrimary,
                                            background_color: color7,
                                            underline_color: color6,
                                            leading_icon: Icons.maps_home_work_outlined ,
                                            leading_icon_color: colorPrimary,
                                            function: (value) {
                                              setState(() {
                                                province = value;
                                              });
                                            },
                                            items: _provinceList),
                                      )
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextAreaFormField(
                                      height: 5.0,
                                      controller: _address,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Address',
                                      icon: Icons.map_outlined,
                                      textInputType: TextInputType.multiline,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );
                                        return validator.validate(
                                          label:
                                              register_validation_invalid_mobile_number,
                                          value: value,
                                        );
                                      },
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _password,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Password',
                                      icon: Icons.lock_open,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );
                                        return validator.validate(
                                          label:
                                              register_validation_invalid_password,
                                          value: value,
                                        );
                                      },
                                      obscureText: true),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      height: 5.0,
                                      controller: _confirm_password,
                                      backgroundColor: color7,
                                      iconColor: colorPrimary,
                                      isIconAvailable: true,
                                      hint: 'Confirm Password',
                                      icon: Icons.lock_open,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        final validator = Validator(
                                          validators: [
                                            const RequiredValidator()
                                          ],
                                        );

                                        if (value != _password.text) {
                                          return register_validation_passwords_does_not_match;
                                        }

                                        return validator.validate(
                                          label:
                                              register_validation_invalid_retype_password,
                                          value: value,
                                        );
                                      },
                                      obscureText: true),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Checkbox(
                                          checkColor: colorPrimary,
                                          fillColor:
                                              MaterialStateProperty.all(color7),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          value: termsAndConditionCheck,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              termsAndConditionCheck = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: SizedBox(
                                          width: displaySize.width * 0.65,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                termsAndConditionCheck =
                                                    !termsAndConditionCheck;
                                              });
                                            },
                                            child: Text(
                                              Signup_Checkbox_termsAndConditions_lbl,
                                              style: TextStyle(
                                                  color: color8,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45.0, vertical: 20.0),
                                  child: CustomButton(
                                      buttonText: SignUp_title,
                                      textColor: color6,
                                      backgroundColor: colorPrimary,
                                      isBorder: false,
                                      borderColor: color6,
                                      onclickFunction: () async {
                                        FocusScope.of(context).unfocus();
                                        if (termsAndConditionCheck == true) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            CustomUtils.showLoader(context);
                                            FocusScope.of(context).unfocus();
                                            await _authController
                                                .doRegistration({
                                              'name': _name.text.toString(),
                                              'age': CustomUtils
                                                  .getAgeUsingBirthdate(
                                                      _birthday.text),
                                              'mobile':
                                                  _contact.text.toString(),
                                              'address':
                                                  _address.text.toString(),
                                              'email': _email.text.toString(),
                                              'type': 2,
                                              'password':
                                                  _password.text.toString(),
                                              'province':
                                                  province ?? 'Western',
                                            }).then((value) =>
                                                    CustomUtils.hideLoader(
                                                        context));

                                            _formKey.currentState!.reset();

                                            _birthday.text = '';
                                            _name.text = '';
                                            _contact.text = '';
                                            _address.text = '';
                                            _email.text = '';
                                            _password.text = '';
                                            _confirm_password.text = '';
                                          }
                                        } else {
                                          CustomUtils.showSnackBar(
                                              context,
                                              register_setect_terms_and_conditions,
                                              CustomUtils.ERROR_SNACKBAR);
                                        }
                                      }),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }

  void enrollPrivinceData() {
    for (var element in provinceList) {
      _provinceList.add(DropdownMenuItem(
          value: element,
          alignment: Alignment.centerLeft,
          enabled: true,
          child: Text("$element Province", style: TextStyle(color: colorPrimary, fontSize: 15.0) )));
    }
  }
}
