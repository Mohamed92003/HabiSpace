part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLogOut extends ProfileState {}

final class ProfileDeleted extends ProfileState {}

/// Emitted during updateProfile — keeps the existing profile data visible
/// so the profile page doesn't flash the loading skeleton.
final class ProfileUpdating extends ProfileState {
  final List<ProfileEntity> profile;
  final int imageVersion;
  ProfileUpdating(this.profile, {this.imageVersion = 0});
}

final class ProfileLoaded extends ProfileState {
  final List<ProfileEntity> profile;
  final int imageVersion;
  ProfileLoaded(this.profile, {this.imageVersion = 0});
}

final class ProfilePasswordChanged extends ProfileState {
  final String message;
  ProfilePasswordChanged(this.message);
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
