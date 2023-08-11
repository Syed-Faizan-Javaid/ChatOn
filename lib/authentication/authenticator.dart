import 'package:chat_app/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/ui/phone_login_ui.dart';
import 'cubit/authentication_cubit.dart';

class Authenticator extends StatefulWidget {
  const Authenticator({super.key});

  @override
  State<Authenticator> createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  late AuthenticationCubit authenticationCubit;
  @override
  void initState() {
    authenticationCubit = context.read<AuthenticationCubit>();
    authenticationCubit.authenticateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: authenticationCubit,
      listener: (context, state) {
        if (state is Authenticated) {
          if (kDebugMode) {
            print("Authenticated");
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else if (state is Unauthenticated) {
          if (kDebugMode) {
            print("unAuthenticated");
          }

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PhoneLoginScreen()));
        }
      },
      child: const SizedBox(
        height: 50,
        width: 50,
        child: null,
      ),
    );
  }
}
