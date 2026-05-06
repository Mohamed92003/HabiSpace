import 'package:habispace/features/profile/domain/Repository/Profile_repo.dart';

class ChangePasswordUsecase {
  final ProfileRepo repository;
  ChangePasswordUsecase({required this.repository});

  Future<String> call({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) =>
      repository.changePassword(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
}