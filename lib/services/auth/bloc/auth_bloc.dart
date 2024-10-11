import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exeption: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          currentUser: user,
          isLoading: false,
        ));
      }
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistring(exeption: e, isLoading: false));
      }
    });
    on<AuthEventShouldRegister>((event, emit) {
      emit(AuthStateRegistring(
        exeption: null,
        isLoading: false,
      ));
    });
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoggedOut(
          exeption: null,
          isLoading: true,
          loadingText: 'Please wait while I log you in',
        ));
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedOut(
          exeption: null,
          isLoading: false,
        ));
        if (!user.isEmailVerified) {
          emit(AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(
            currentUser: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exeption: e,
          isLoading: false,
        ));
      }
    });
    on<AuthEventSendEmailVerficaion>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        isLoading: false,
        exeption: null,
        hasSendEmail: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(
        isLoading: true,
        exeption: null,
        hasSendEmail: false,
      ));
      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordResetEmail(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        isLoading: false,
        exeption: exception,
        hasSendEmail: didSendEmail,
      ));
    });
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(
          exeption: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exeption: e,
          isLoading: false,
        ));
      }
    });
  }
}
