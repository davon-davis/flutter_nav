import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

enum AuthState { authenticated, unauthenticated, loading }

class AuthCubit extends Cubit<AuthState> {
  final RowndPlugin rowndPlugin;

  AuthCubit(this.rowndPlugin) : super(AuthState.unauthenticated);

  void initialize(GlobalStateNotifier rownd) {
    // Add a listener to the GlobalStateNotifier to check authentication on changes
    rownd.addListener(() {
      checkAuthentication(rownd);
    });
  }

  void checkAuthentication(GlobalStateNotifier rownd) {
    if (rownd.state.auth?.isAuthenticated ?? false) {
      emit(AuthState.authenticated);
    } else {
      emit(AuthState.unauthenticated);
    }
  }

  Future<void> signInOrOut(
      BuildContext context, GlobalStateNotifier rownd) async {
    if (rownd.state.auth?.isAuthenticated ?? false) {
      rowndPlugin.signOut();
      emit(AuthState.unauthenticated);
    } else {
      emit(AuthState.loading);
      RowndSignInOptions signInOpts = RowndSignInOptions();
      rowndPlugin.requestSignIn(signInOpts);
    }
  }

  

  void logout() {
    emit(AuthState.unauthenticated);
  }
}
