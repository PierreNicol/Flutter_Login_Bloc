import 'dart:async';

import 'package:flutter_login_bloc/authentication_event.dart';
import 'package:flutter_login_bloc/authentication_state.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  void onAppStart() {
    dispatch(AppStarted());
  }

  void onLogin({@required String token}){
    dispatch(LoggedIn(token: token));
  }

  void onLogout(){
    dispatch(LoggedOut());
  }

  @override
  AuthenticationState get initialState => AuthenticationState.initializing();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState state, AuthenticationEvent event) async* {
    if (event is AppStarted){
      final bool hasToken = await _hasToken();

      if (hasToken){
        yield AuthenticationState.authenticated();
      } else {
        yield AuthenticationState.unauthenticated();
      }
    }

    if (event is LoggedIn){
      yield state.copyWith(isLoading: true);

      await _persistToken(event.token);

      yield AuthenticationState.authenticated();

    }

    if (event is LoggedOut) {
      yield state.copyWith(isLoading: true);

      await _deleteToken();
      yield AuthenticationState.unauthenticated();
    }


  }

  _deleteToken() {}
  }

  _hasToken() {}

  _persistToken(String token) {}
}
