part of 'request_permission_bloc.dart';

sealed class RequestPermissionEvent extends Equatable {
  const RequestPermissionEvent();
}

class RequestPermission extends RequestPermissionEvent {
  @override
  List<Object> get props => [];
}

class CheckPermissionStatus extends RequestPermissionEvent {
  @override
  List<Object> get props => [];
}

class ResetPermissions extends RequestPermissionEvent {
  @override
  List<Object> get props => [];
}
