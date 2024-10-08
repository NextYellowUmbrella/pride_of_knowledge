import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prideofknowledge/features/authentication/services/bloc/auth_bloc.dart';
import 'package:prideofknowledge/features/authentication/services/bloc/auth_event.dart';
import 'package:prideofknowledge/features/authentication/services/bloc/auth_state.dart';
import 'package:prideofknowledge/features/authentication/views/login_view.dart';
import 'package:prideofknowledge/features/authentication/views/onboarding_view.dart';
import 'package:prideofknowledge/features/authentication/views/register_view.dart';
import 'package:prideofknowledge/features/authentication/views/verify_email_view.dart';

import 'package:prideofknowledge/features/home/views/tabs.dart';
import 'package:prideofknowledge/utilities/helper/loading/loading.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.read<AuthBloc>().add(AuthEventInitialize(ref));
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: 'Loading...');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const TabsView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateOnboarding) {
          return const OnboardingView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
