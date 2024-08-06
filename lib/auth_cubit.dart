import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

enum AuthState { authenticated, unauthenticated, loading }

class AuthCubit extends Cubit<AuthState> {
  final RowndPlugin rowndPlugin;
  final GlobalStateNotifier rowndNotifier;

  AuthCubit(this.rowndPlugin, this.rowndNotifier) : super(AuthState.unauthenticated) {
    // Initialize the cubit by setting up a listener to the authentication state
    _initialize();
  }

  void _initialize() {
    rowndNotifier.addListener(() {
      checkAuthentication();
    });
  }

  void checkAuthentication() {
    if (rowndNotifier.state.auth?.isAuthenticated ?? false) {
      emit(AuthState.authenticated);
    } else {
      emit(AuthState.unauthenticated);
    }
  }

   Future<void> signIn() async {
    emit(AuthState.loading);
    RowndSignInOptions signInOpts = RowndSignInOptions();
    rowndPlugin.requestSignIn(signInOpts);
  }

  Future<void> signOut() async {
      rowndPlugin.signOut();
      emit(AuthState.unauthenticated);
  }

  void logout() {
    emit(AuthState.unauthenticated);
  }
}
