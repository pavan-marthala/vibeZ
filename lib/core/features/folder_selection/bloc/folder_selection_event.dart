part of 'folder_selection_bloc.dart';

sealed class FolderSelectionEvent extends Equatable {
  const FolderSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadFolders extends FolderSelectionEvent {}

class AddFolder extends FolderSelectionEvent {}

class RemoveFolder extends FolderSelectionEvent {
  final int folderId;

  const RemoveFolder(this.folderId);

  @override
  List<Object?> get props => [folderId];
}

class ClearAllFolders extends FolderSelectionEvent {}
