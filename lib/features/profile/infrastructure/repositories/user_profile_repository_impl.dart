import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/infrastructure/base_repository.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';
import 'package:starter_app/features/profile/domain/repositories/i_user_profile_repository.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/user_profile_remote_data_source.dart';

@LazySingleton(as: IUserProfileRepository)
class UserProfileRepositoryImpl extends BaseRepository
    implements IUserProfileRepository {
  UserProfileRepositoryImpl(
    this._remoteDataSource,
    ExceptionHandler exceptionHandler,
  ) : super(exceptionHandler);

  final IUserProfileRemoteDataSource _remoteDataSource;


  @override
  FutureResult<UserProfile> getCurrentProfile() => execute(
    () async {
      final result = await _remoteDataSource.getMyProfile();
      return result.toDomain();
    },
  );
}
