part of 'folder_selection_bloc.dart';

enum FolderSelectionStatus { initial, loading, success, error }

class FolderSelectionState extends Equatable {
  final List<FolderModel> folders;
  final FolderSelectionStatus status;
  final String? errorMessage;

  const FolderSelectionState({
    this.folders = const [],
    this.status = FolderSelectionStatus.initial,
    this.errorMessage,
  });

  FolderSelectionState copyWith({
    List<FolderModel>? folders,
    FolderSelectionStatus? status,
    String? errorMessage,
  }) {
    return FolderSelectionState(
      folders: folders ?? this.folders,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [folders, status, errorMessage];
}
