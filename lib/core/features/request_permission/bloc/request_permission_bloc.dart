import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

part 'request_permission_event.dart';
part 'request_permission_state.dart';

class RequestPermissionBloc
    extends Bloc<RequestPermissionEvent, RequestPermissionState> {
  RequestPermissionBloc() : super(const RequestPermissionState()) {
    on<CheckPermissionStatus>(_checkPermissionStatus);
    on<RequestPermission>(_requestPermission);
  }

  Future<void> _checkPermissionStatus(
    CheckPermissionStatus event,
    Emitter<RequestPermissionState> emit,
  ) async {
    final audioGranted = await _checkAudioPermission();
    final notifGranted = await Permission.notification.isGranted;

    emit(
      state.copyWith(
        isStorageGranted: audioGranted,
        isNotificationGranted: notifGranted,
        isAudioGranted: audioGranted,
        hasCheckedPermissions: true,
      ),
    );
  }

  Future<void> _requestPermission(
    RequestPermission event,
    Emitter<RequestPermissionState> emit,
  ) async {
    // Request audio/storage permission based on Android version
    final audioStatus = await _requestAudioPermission();

    // Request notification permission
    final notifStatus = await Permission.notification.request();

    log('Audio/Storage Permission: $audioStatus');
    log('Notification Permission: $notifStatus');

    // Check if permissions were permanently denied
    final audioPermanentlyDenied = audioStatus.isPermanentlyDenied;
    final notifPermanentlyDenied = notifStatus.isPermanentlyDenied;

    if (audioPermanentlyDenied || notifPermanentlyDenied) {
      log('Some permissions were permanently denied');
      // User needs to go to settings
    }

    // Update state
    add(CheckPermissionStatus());
  }

  // Helper method to check audio permission based on Android version
  Future<bool> _checkAudioPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+
        return await Permission.audio.isGranted;
      } else {
        // Android 12 and below
        return await Permission.storage.isGranted;
      }
    }
    return false;
  }

  // Helper method to request audio permission based on Android version
  Future<PermissionStatus> _requestAudioPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+
        return await Permission.audio.request();
      } else {
        // Android 12 and below
        return await Permission.storage.request();
      }
    }
    return PermissionStatus.denied;
  }

  // Helper method to get audio permission status
  Future<PermissionStatus> _getAudioPermissionStatus() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return await Permission.audio.status;
      } else {
        return await Permission.storage.status;
      }
    }
    return PermissionStatus.denied;
  }
}
