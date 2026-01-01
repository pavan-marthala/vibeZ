part of 'request_permission_bloc.dart';

class RequestPermissionState extends Equatable {
  final bool isStorageGranted;
  final bool isNotificationGranted;
  final bool isAudioGranted;
  final bool hasCheckedPermissions;

  const RequestPermissionState({
    this.isStorageGranted = false,
    this.isNotificationGranted = false,
    this.isAudioGranted = false,
    this.hasCheckedPermissions = false,
  });

  bool get allGranted => isAudioGranted && isNotificationGranted;

  RequestPermissionState copyWith({
    bool? isStorageGranted,
    bool? isNotificationGranted,
    bool? isAudioGranted,
    bool? hasCheckedPermissions,
  }) {
    return RequestPermissionState(
      isStorageGranted: isStorageGranted ?? this.isStorageGranted,
      isNotificationGranted:
          isNotificationGranted ?? this.isNotificationGranted,
      isAudioGranted: isAudioGranted ?? this.isAudioGranted,
      hasCheckedPermissions:
          hasCheckedPermissions ?? this.hasCheckedPermissions,
    );
  }

  @override
  List<Object?> get props => [
    isStorageGranted,
    isNotificationGranted,
    isAudioGranted,
    hasCheckedPermissions,
  ];
}
