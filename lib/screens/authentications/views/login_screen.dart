import 'package:expense_tracker_app/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:expense_tracker_app/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return BlocConsumer<AuthenticationBloc, AuthBlocState>(
              listener: (context, state) {
                if (state is AuthBlocSuccess) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                } else if (state is AuthBlocFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              buildWhen: (current, next) {
                if (next is AuthBlocSuccess) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is AuthBlocInitial || state is AuthBlocFailure) {
                  return Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          color: Theme.of(context).colorScheme.primary,
                          'assets/top_right.png',
                          width: 190,
                          height: 210,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          color: Theme.of(context).colorScheme.primary,
                          'assets/bottom_left_1.png',
                          width: 240,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          color: Theme.of(context).colorScheme.primary,
                          'assets/bottom_left_2.png',
                          width: 150,
                          height: 220,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () =>
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                AuthenticationGoogleStarted(),
                              ),
                              child: Text(
                                'Login with Google',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            // OutlinedButton(
                            //   onPressed: () {
                            //     Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => BlocProvider(
                            //                 create: (context) => PhoneAuthBloc(
                            //                   phoneAuthRepository:
                            //                       PhoneAuthRepository(
                            //                     phoneAuthFirebaseProvider:
                            //                         PhoneAuthFirebaseProvider(
                            //                             firebaseAuth:
                            //                                 FirebaseAuth.instance),
                            //                   ),
                            //                 ),
                            //                 child: LoginPhoneNumberView(),
                            //               )),
                            //     );
                            //   },
                            //   child: Text('Login with Phone Number'),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is AuthBlocLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Center(child: Text('Error'));
              },
            );
          },
        ),
      ),
    );
  }
}
