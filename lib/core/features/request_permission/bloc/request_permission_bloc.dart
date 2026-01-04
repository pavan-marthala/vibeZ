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
    on<ResetPermissions>(_resetPermissions);
  }

  Future<void> _checkPermissionStatus(
    CheckPermissionStatus event,
    Emitter<RequestPermissionState> emit,
  ) async {
    final audioGranted = await _checkAudioPermission();
    final notifGranted = await _checkNotificationPermission();

    log(
      'Checking permissions - Audio: $audioGranted, Notification: $notifGranted',
    );

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
    try {
      PermissionStatus audioStatus;
      PermissionStatus notifStatus;

      if (Platform.isIOS) {
        // For iOS, we need to check if permission was previously denied
        final currentAudioStatus = await Permission.mediaLibrary.status;
        final currentNotifStatus = await Permission.notification.status;

        log(
          'Current iOS statuses - Media: $currentAudioStatus, Notif: $currentNotifStatus',
        );

        // If permanently denied, we can't request again - user must go to settings
        if (currentAudioStatus.isPermanentlyDenied ||
            currentNotifStatus.isPermanentlyDenied) {
          log('Permissions permanently denied - user must enable in Settings');

          emit(
            state.copyWith(
              hasCheckedPermissions: true,
              isStorageGranted: currentAudioStatus.isGranted,
              isNotificationGranted: currentNotifStatus.isGranted,
              isAudioGranted: currentAudioStatus.isGranted,
            ),
          );
          return;
        }

        // Request media library permission
        log('Requesting iOS media library permission');
        audioStatus = await Permission.mediaLibrary.request();
        log('iOS Media Library result: $audioStatus');

        // Request notification permission
        log('Requesting iOS notification permission');
        notifStatus = await Permission.notification.request();
        log('iOS Notification result: $notifStatus');
      } else {
        // Android permissions
        audioStatus = await _requestAudioPermission();
        notifStatus = await _requestNotificationPermission();
      }

      log('Final - Audio: $audioStatus, Notification: $notifStatus');

      // Update state
      add(CheckPermissionStatus());
    } catch (e) {
      log('Error requesting permissions: $e');
      emit(
        state.copyWith(
          hasCheckedPermissions: true,
          isStorageGranted: false,
          isNotificationGranted: false,
          isAudioGranted: false,
        ),
      );
    }
  }

  Future<void> _resetPermissions(
    ResetPermissions event,
    Emitter<RequestPermissionState> emit,
  ) async {
    emit(const RequestPermissionState());
  }

  Future<bool> _checkAudioPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          return await Permission.audio.isGranted;
        } else {
          return await Permission.storage.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.mediaLibrary.status;
        log('iOS Media Library status: $status');

        // On iOS, if status is limited or denied, check if it's first time
        if (status.isDenied) {
          // First time, hasn't been asked yet
          return false;
        }
        return status.isGranted || status.isLimited;
      }
    } catch (e) {
      log('Error checking audio permission: $e');
    }
    return false;
  }

  Future<bool> _checkNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      log('Notification status: $status');

      if (status.isDenied) {
        // First time, hasn't been asked yet
        return false;
      }
      return status.isGranted || status.isProvisional;
    } catch (e) {
      log('Error checking notification permission: $e');
      return false;
    }
  }

  Future<PermissionStatus> _requestAudioPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          log('Requesting Android 13+ audio permission');
          return await Permission.audio.request();
        } else {
          log('Requesting Android storage permission');
          return await Permission.storage.request();
        }
      } else if (Platform.isIOS) {
        log('Requesting iOS media library permission');
        return await Permission.mediaLibrary.request();
      }
    } catch (e) {
      log('Error requesting audio permission: $e');
    }
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> _requestNotificationPermission() async {
    try {
      log('Requesting notification permission');
      return await Permission.notification.request();
    } catch (e) {
      log('Error requesting notification permission: $e');
      return PermissionStatus.denied;
    }
  }
}
