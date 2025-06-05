import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = AuthLoginRequested;
  
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
  
  const factory AuthEvent.checkAuthStatus() = AuthCheckStatus;
}