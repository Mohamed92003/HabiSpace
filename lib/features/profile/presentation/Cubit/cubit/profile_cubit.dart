import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:habispace/core/error/app_exception.dart';
import 'package:habispace/core/services/local_image_storage.dart';
import 'package:habispace/features/profile/domain/Use%20Cases/Delete_Profile_Usecae.dart';
import 'package:habispace/features/profile/domain/Use%20Cases/Get_Profile_Usecase.dart';
import 'package:habispace/features/profile/domain/Use%20Cases/updata_profile_usecase.dart';
import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';
import 'package:meta/meta.dart';

import '../../../domain/Use Cases/change_password_usecase.dart';

import '../../../domain/Use Cases/delete_account_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final LogOutProfileUseCase logOut;
  final UpdateProfileUsecase updateProfileUsecase;
  final DeleteProfileUseCase deleteProfileUsecase;

  final ChangePasswordUsecase changePasswordUsecase;

  ProfileCubit({
    required this.logOut,
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
    required this.deleteProfileUsecase,
    required this.changePasswordUsecase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUsecase.call();
      // Check if there's a locally saved image and apply it
      final localPath = await LocalImageStorage.getImagePath();
      if (localPath != null && localPath.isNotEmpty) {
        final withLocal = _ProfileEntityWithLocalImage(profile, localPath);
        emit(ProfileLoaded([withLocal]));
      } else {
        emit(ProfileLoaded([profile]));
      }
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

  Future<void> logOutProfile() async {
    emit(ProfileLoading());
    try {
      await logOut.execute();
      emit(ProfileLogOut());
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

  Future<void> deleteProfile() async {
    emit(ProfileLoading());
    try {
      await deleteProfileUsecase.execute();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String location,
    String? imagePath,
  }) async {
    // Use ProfileUpdating instead of ProfileLoading so the profile page
    // doesn't show the full skeleton while saving
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(
        ProfileUpdating(
          currentState.profile,
          imageVersion: currentState.imageVersion,
        ),
      );
    } else {
      emit(ProfileLoading());
    }
    try {
      final updated = await updateProfileUsecase.call(
        name: name,
        phone: phone,
        location: location,
        imagePath: imagePath,
      );
      final prevVersion = currentState is ProfileLoaded
          ? currentState.imageVersion
          : 0;
      // Re-apply local image after API update so it isn't lost
      final localPath = await LocalImageStorage.getImagePath();
      final entity = localPath != null
          ? _ProfileEntityWithLocalImage(updated, localPath)
          : updated;
      emit(ProfileLoaded([entity], imageVersion: prevVersion + 1));
    } catch (e) {
      // Restore previous loaded state so the profile page stays visible,
      // then show the error message
      if (currentState is ProfileLoaded) {
        emit(currentState);
      }
      // Show error as a separate emission after restoring state
      Future.microtask(() {
        if (!isClosed) emit(ProfileError(handleException(e).message));
      });
    }
  }

  /// Called when the user saves a local image — updates the in-memory
  /// profile so the profile page and bottom nav avatar reflect it immediately.
  void onLocalImageSaved(String localPath) {
    final currentState = state;
    if (currentState is! ProfileLoaded || currentState.profile.isEmpty) return;
    final user = currentState.profile.first;
    // Create a copy of the entity with the local path as the image
    final updated = _ProfileEntityWithLocalImage(user, localPath);
    emit(ProfileLoaded([updated], imageVersion: currentState.imageVersion + 1));
  }

  /// Does not emit loading/error states so the UI is not disrupted.
  /// Requires the profile to already be loaded.
  Future<void> updateLocationSilently(String location) async {
    final currentState = state;
    if (currentState is! ProfileLoaded || currentState.profile.isEmpty) return;

    final user = currentState.profile.first;
    // Skip if location hasn't changed
    if (user.location == location) return;

    try {
      final updated = await updateProfileUsecase.call(
        name: user.name,
        phone: user.phone,
        location: location,
        imagePath: null,
      );
      // Re-apply local image so it isn't lost after location sync
      final localPath = await LocalImageStorage.getImagePath();
      final entity = localPath != null
          ? _ProfileEntityWithLocalImage(updated, localPath)
          : updated;
      emit(ProfileLoaded([entity], imageVersion: currentState.imageVersion));
    } catch (_) {
      // Silent — location sync failure should not surface to the user
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ProfileLoading());
    try {
      final message = await changePasswordUsecase.call(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(ProfilePasswordChanged(message));
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }
}

/// Wraps an existing [ProfileEntity] but overrides [image] with a local
/// file path so the avatar shows the locally-saved image everywhere.
class _ProfileEntityWithLocalImage extends ProfileEntity {
  _ProfileEntityWithLocalImage(ProfileEntity base, String localPath)
    : super(
        id: base.id,
        name: base.name,
        email: base.email,
        phone: base.phone,
        location: base.location,
        image: localPath, // local file path instead of remote URL
        role: base.role,
        createdAt: base.createdAt,
      );
}
