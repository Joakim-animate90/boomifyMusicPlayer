import 'dart:io';
import 'dart:typed_data';
import 'package:boomify_app/service_authentication/sign_up/sign_up_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helpers/helper.dart';
import '../../ui/home_screen/home_screen.dart';
import '../../utils/constants.dart';
import '../Authentication_Bloc/authentication_bloc.dart';
import '../utils/loading_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  Uint8List? _imageData;
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  String? firstName, lastName, email, password, confirmPassword;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  bool acceptEULA = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          if (!kIsWeb && Platform.isAndroid) {
            context.read<SignUpBloc>().add(const RetrieveLostDataEvent());
          }
          return MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  context.read<LoadingCubit>().hideLoading();
                  if (state is AuthenticationAuthenticated) {
                    pushAndRemoveUntil(
                        context, HomeScreen(user: state.user!,), false);
                  } else {
                    if (state is AuthenticationError){
                      print(state.message);


                      showSnackBar(
                          context,
                          state.message ?? 'Couldn\'t sign up, Please try again.');
                    }
                };
                },
              ),
              BlocListener<SignUpBloc, SignUpState>(
                listener: (context, state) async {
                  if (state is ValidFields) {

                    //if (!mounted) return;

                    context.read<AuthenticationBloc>().add(
                        SignUpWithEmailAndPasswordEvent(
                            email: email ?? '',
                            password: password ?? '',
                            imageData: _imageData ?? Uint8List(0),
                            lastName: lastName ?? '',
                            firstName: firstName ?? ''));
                  } else if (state is SignUpError) {
                    showSnackBar(context, state.errorMessage);
                  }
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
              ),
              body: SingleChildScrollView(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                child: BlocBuilder<SignUpBloc, SignUpState>(
                  buildWhen: (old, current) =>
                  current is SignUpError && old != current,
                  builder: (context, state) {
                    if (state is SignUpError) {
                      _validate = AutovalidateMode.onUserInteraction;
                    }
                    return Form(
                      key: _key,
                      autovalidateMode: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Create new account',
                              style: TextStyle(
                                  color: Color(colorPrimary),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 32, right: 8, bottom: 8),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                BlocBuilder<SignUpBloc, SignUpState>(
                                  buildWhen: (old, current) =>
                                  current is SignUpImageSelected &&
                                      old != current,
                                  builder: (context, state) {
                                    if (state is SignUpImageSelected) {
                                      _imageData = state.imageData;
                                    }
                                    return state is SignUpImageSelected
                                        ? SizedBox(
                                      height: 130,
                                      width: 130,
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(65),
                                          child: state.imageData == null
                                              ? Image.asset(
                                            'assets/images/placeholder.webp',
                                            fit: BoxFit.cover,
                                          )
                                              : Image.memory(
                                            state.imageData!,
                                            fit: BoxFit.cover,
                                          )),
                                    )
                                        : SizedBox(
                                      height: 130,
                                      width: 130,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(65),
                                        child: Image.asset(
                                          'assets/images/placeholder.webp',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  right: 0,
                                  child: FloatingActionButton(
                                    backgroundColor: const Color(colorPrimary),
                                    mini: true,
                                    onPressed: () => _onCameraClick(context),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: isDarkMode(context)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, right: 8.0, left: 8.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              validator: validateName,
                              onSaved: (String? val) {
                                firstName = val;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: getInputDecoration(
                                  hint: 'First Name',
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).errorColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, right: 8.0, left: 8.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              validator: validateName,
                              onSaved: (String? val) {
                                lastName = val;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: getInputDecoration(
                                  hint: 'Last Name',
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).errorColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, right: 8.0, left: 8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: validateEmail,
                              onSaved: (String? val) {
                                print("onSaved email: $val");
                                print(val);
                                email = val;
                              },
                              decoration: getInputDecoration(
                                  hint: 'Email',
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).errorColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, right: 8.0, left: 8.0),
                            child: TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              controller: _passwordController,
                              validator: validatePassword,
                              onSaved: (String? val) {
                                print("onSaved password: $val");
                                password = val;
                              },
                              style:
                              const TextStyle(height: 0.8, fontSize: 18.0),
                              cursorColor: const Color(colorPrimary),
                              decoration: getInputDecoration(
                                  hint: 'Password',
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).errorColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, right: 8.0, left: 8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  context.read<SignUpBloc>().add(
                                    ValidateFieldsEvent(_key,
                                        acceptEula: acceptEULA),
                                  ),
                              obscureText: true,
                              validator: (val) => validateConfirmPassword(
                                  _passwordController.text, val),
                              onSaved: (String? val) {
                                confirmPassword = val;
                              },
                              style:
                              const TextStyle(height: 0.8, fontSize: 18.0),
                              cursorColor: const Color(colorPrimary),
                              decoration: getInputDecoration(
                                  hint: 'Confirm Password',
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).errorColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 40.0, left: 40.0, top: 40.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromWidth(
                                    MediaQuery.of(context).size.width / 1.5),
                                backgroundColor: const Color(colorPrimary),
                                padding:
                                const EdgeInsets.only(top: 16, bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: const BorderSide(
                                    color: Color(colorPrimary),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () => context.read<SignUpBloc>().add(
                                ValidateFieldsEvent(_key,
                                    acceptEula: acceptEULA),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ListTile(
                            trailing: BlocBuilder<SignUpBloc, SignUpState>(
                              buildWhen: (old, current) =>
                              current is EulaToggleState && old != current,
                              builder: (context, state) {
                                if (state is EulaToggleState) {
                                  acceptEULA = state.eulaAccepted;
                                }
                                return Checkbox(
                                  onChanged: (value) =>
                                      context.read<SignUpBloc>().add(
                                        ToggleEulaCheckboxEvent(
                                          eulaAccepted: value!,
                                        ),
                                      ),
                                  activeColor: const Color(colorPrimary),
                                  value: acceptEULA,
                                );
                              },
                            ),
                            title: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text:
                                    'By creating an account you agree to our ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                    text: 'Terms of Use',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                print("Coming Soon");
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },

    );
  }

  _onCameraClick(BuildContext context) {
    if (kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      context.read<SignUpBloc>().add(const ChooseImageFromGalleryEvent());
    } else {
      final action = CupertinoActionSheet(
        title: const Text(
          'Add Profile Picture',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () async {
              Navigator.pop(context);
              context.read<SignUpBloc>().add(ChooseImageFromGalleryEvent());
            },
            child: const Text('Choose from gallery'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: false,
            onPressed: () async {
              Navigator.pop(context);
              context.read<SignUpBloc>().add(const CaptureImageByCameraEvent());
            },
            child: const Text('Take a picture'),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
      );
      showCupertinoModalPopup(context: context, builder: (context) => action);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _imageData = null;
    super.dispose();
  }
}