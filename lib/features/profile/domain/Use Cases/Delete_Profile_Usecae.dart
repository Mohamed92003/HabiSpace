import 'package:habispace/features/profile/domain/Repository/Profile_repo.dart';

class DeleteProfileUsecae {
  final ProfileRepo repo;

  DeleteProfileUsecae(this.repo);
  Future<void>execute ()async{
    await repo.deleteAccount();
  }
}