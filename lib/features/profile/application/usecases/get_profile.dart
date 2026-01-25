import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/base/query.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';
import 'package:starter_app/features/profile/domain/repositories/i_user_profile_repository.dart';

@injectable
final class GetProfile extends QueryNoParams<UserProfile> {
  const GetProfile(this._repository);

  final IUserProfileRepository _repository;

  @override
  FutureResult<UserProfile> call() {
    return _repository.getCurrentProfile();
  }
}
