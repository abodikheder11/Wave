import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AuthenticationStarted) {
      final bool isAuthenticated = await _isAuthenticated(event.userId);
      if (isAuthenticated) {
        yield* _mapFetchRegisteredUsersToState(event.userId);
      } else {
        yield AuthenticationFailure(error: "Not authenticated");
      }
    } else if (event is AuthenticationLoggedIn) {
      yield AuthenticationSuccess(userId: event.userId);
    } else if (event is AuthenticationLoggedOut) {
      yield AuthenticationInitial();
    }
  }

  Stream<AuthenticationState> _mapFetchRegisteredUsersToState(String userId,) async* {
    try {
      final List<String> registeredUserEmails = await _fetchRegisteredUsers(userId);
      yield RegisteredUsersLoaded(registeredUserEmails);
    } catch (e) {
      yield AuthenticationFailure(error: "Failed to fetch registered users: $e");
    }
  }

  String authenticationUrl = "https://6e52-62-112-9-244.ngrok-free.app/api/endpoint";

    Future<bool> _isAuthenticated(String userId) async {
      try {
        final url = Uri.parse('$authenticationUrl?userId=$userId');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data['isAuthenticated'] as bool;
        } else {
          throw Exception('Failed to authenticate user');
        }
      } catch (e) {
        return false;
      }
    }


  Future<List<String>> _fetchRegisteredUsers(String userId) async {
    try {
      final url = Uri.parse('$authenticationUrl?userId=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> registeredUserNumbers =
        data.map((user) => user['id'].toString()).toList();
        return registeredUserNumbers;
      } else {
        throw Exception('Failed to fetch registered user data');
      }
    } catch (e) {
      throw Exception('Error fetching registered user data: $e');
    }
  }
}
