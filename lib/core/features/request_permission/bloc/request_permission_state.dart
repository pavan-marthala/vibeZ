part of 'request_permission_bloc.dart';

sealed class RequestPermissionState extends Equatable {
  const RequestPermissionState();
}

final class RequestPermissionInitial extends RequestPermissionState {
  @override
  List<Object> get props => [];
}
