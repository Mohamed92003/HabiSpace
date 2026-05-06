part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
final class ProfileLogOut extends ProfileState {}
final class ProfileDeleted extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final List<ProfileEntity> profile;
  ProfileLoaded(this.profile);
}

final class ProfilePasswordChanged extends ProfileState {
  final String message;
  ProfilePasswordChanged(this.message);
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
