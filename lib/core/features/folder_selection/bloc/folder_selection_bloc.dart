import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/models/folder_model.dart';
import 'package:file_picker/file_picker.dart';
part 'folder_selection_event.dart';
part 'folder_selection_state.dart';

class FolderSelectionBloc
    extends Bloc<FolderSelectionEvent, FolderSelectionState> {
  final DatabaseHelper _databaseHelper;

  FolderSelectionBloc({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
      super(const FolderSelectionState()) {
    on<LoadFolders>(_onLoadFolders);
    on<AddFolder>(_onAddFolder);
    on<RemoveFolder>(_onRemoveFolder);
    on<ClearAllFolders>(_onClearAllFolders);
  }

  Future<void> _onLoadFolders(
    LoadFolders event,
    Emitter<FolderSelectionState> emit,
  ) async {
    emit(state.copyWith(status: FolderSelectionStatus.loading));

    try {
      final folders = await _databaseHelper.getAllFolders();
      emit(
        state.copyWith(folders: folders, status: FolderSelectionStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FolderSelectionStatus.error,
          errorMessage: 'Failed to load folders: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddFolder(
    AddFolder event,
    Emitter<FolderSelectionState> emit,
  ) async {
    try {
      // Open directory picker
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      // Check if folder already exists
      final exists = await _databaseHelper.folderExists(selectedDirectory);
      if (exists) {
        emit(
          state.copyWith(
            status: FolderSelectionStatus.error,
            errorMessage: 'This folder is already added',
          ),
        );
        // Reset error after a delay
        await Future.delayed(const Duration(seconds: 2));
        emit(
          state.copyWith(
            status: FolderSelectionStatus.success,
            errorMessage: null,
          ),
        );
        return;
      }

      // Get folder name from path
      final folderName = selectedDirectory.split('/').last;

      // Create folder model
      final folder = FolderModel(
        path: selectedDirectory,
        name: folderName,
        addedAt: DateTime.now(),
      );

      // Insert into database
      final insertedFolder = await _databaseHelper.insertFolder(folder);

      // Update state with new folder
      final updatedFolders = List<FolderModel>.from(state.folders)
        ..insert(0, insertedFolder);

      emit(
        state.copyWith(
          folders: updatedFolders,
          status: FolderSelectionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FolderSelectionStatus.error,
          errorMessage: 'Failed to add folder: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRemoveFolder(
    RemoveFolder event,
    Emitter<FolderSelectionState> emit,
  ) async {
    try {
      await _databaseHelper.deleteFolder(event.folderId);

      final updatedFolders = state.folders
          .where((folder) => folder.id != event.folderId)
          .toList();

      emit(
        state.copyWith(
          folders: updatedFolders,
          status: FolderSelectionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FolderSelectionStatus.error,
          errorMessage: 'Failed to remove folder: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onClearAllFolders(
    ClearAllFolders event,
    Emitter<FolderSelectionState> emit,
  ) async {
    try {
      await _databaseHelper.deleteAllFolders();
      emit(state.copyWith(folders: [], status: FolderSelectionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: FolderSelectionStatus.error,
          errorMessage: 'Failed to clear folders: ${e.toString()}',
        ),
      );
    }
  }
}
