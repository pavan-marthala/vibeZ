import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_permission_event.dart';
part 'request_permission_state.dart';

class RequestPermissionBloc extends Bloc<RequestPermissionEvent, RequestPermissionState> {
  RequestPermissionBloc() : super(RequestPermissionInitial()) {
    on<RequestPermissionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
