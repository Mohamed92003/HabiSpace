import '../Repository/Profile_repo.dart';

class DeleteProfileUseCase {
  final ProfileRepo repo;
  DeleteProfileUseCase({required this.repo});

  Future<void> execute() => repo.deleteAccount();
}