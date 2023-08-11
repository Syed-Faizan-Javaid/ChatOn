import 'package:chat_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../common_widgets/generic_dialogue.dart';
import '../../constants/color.dart';
import '../../repositories/user_repository.dart';
import '../../utils/loading.dart';
import '../cubit/login_cubit.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  late LoginCubit _loginCubit;
  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  @override
  void initState() {
    _loginCubit = LoginCubit(userRepository: context.read<UserRepository>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _loginCubit,
        child: BlocListener<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (context, state) {
            if (state is LoginLoading) {
              _loadingOverlay.show(context);
            } else {
              _loadingOverlay.hide();
            }
            if (state is LoginSuccessful) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }
            if (state is ErrorInAuthentication) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctx) => GenericDialogue(
                        content: "Server Error. Something went wrong.Try Again Later.!!",
                      ));
            }
          },
          child: Scaffold(
              body: SafeArea(
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: ClipPath(
                    clipper: WaveClipper(), //set our custom wave clipper
                    child: Container(
                      color: Colors.indigoAccent,
                      height: 300,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(), //set our custom wave clipper.
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    color: primaryColor,
                    height: 280,
                    alignment: Alignment.center,
                    child: Text(
                      'LOGIN',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _loginCubit.signUpWithGoogle();
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          elevation: 1.2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/google.svg',
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Login with Google',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "By continuing, you are agree to our Terms of Service and Privacy Notice Understood and agree to our",
                          style: Theme.of(context).textTheme.bodySmall,
                          children: const [
                            TextSpan(text: ' Terms of Service', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                            TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy and Policy', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //   ],
                // ),
                // )
              ],
            ),
          )),
        ));
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
