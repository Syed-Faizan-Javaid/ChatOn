import 'package:chat_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authenticator.dart';
import 'authentication/cubit/authentication_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserRepository _userRepository;

  late AuthenticationCubit _authenticationCubit;

  @override
  void initState() {
    _userRepository = UserRepository();
    _authenticationCubit = AuthenticationCubit(_userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => _userRepository),
      ],
      child: BlocProvider(
        create: (context) => _authenticationCubit,
        child: const MaterialApp(
          home: Authenticator(),
          title: "ChatOn",
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
