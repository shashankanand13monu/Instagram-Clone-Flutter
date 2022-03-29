import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_responsive.dart';
import 'package:instagram_flutter/responsive/responsive_screen.dart';
import 'package:instagram_flutter/responsive/webscreen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/text_field.dart';

import '../utils/utils.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String defaultImg =
      'https://www.pinkvilla.com/imageresize/decoding_nfts_what_are_nfts_and_how_do_they_work_all_you_need_to_know.jpg?width=752&format=webp&t=pvorg';
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    print('email: ${_emailController.text}');
    print('password: ${_passwordController.text}');
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 20),
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(
                //   child: Container(),
                //   flex: 2,
                // ),

                //text for mail
                //text for pass
                //login
                const SizedBox(height: 40),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 60,
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 50),

                Stack(
                  children: [
                    _image != null
                        ? Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_image!),
                            ),
                          )
                        : Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(defaultImg),
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 210,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.pink,
                        ),
                        onPressed: selectImage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingcontroller: _usernameController,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingcontroller: _emailController,
                ),

                const SizedBox(height: 20),

                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingcontroller: _passwordController,
                  isPass: true,
                ),
                const SizedBox(height: 20),

                TextFieldInput(
                  hintText: 'Enter your Bio',
                  textInputType: TextInputType.text,
                  textEditingcontroller: _bioController,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: signUpUser,

                  // print('email: ${_emailController.text}');
                  // print('password: ${_passwordController.text}');
                  // String res = await AuthMethods().signUpUser(
                  //   email: _emailController.text,
                  //   password: _passwordController.text,
                  //   username: _usernameController.text,
                  //   bio: _bioController.text,
                  //   file: _image!,
                  // );
                  // print(res);

                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                  ),
                ),

                const SizedBox(height: 20),
                // Flexible(child: Container(), flex: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Already have an account? "),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
