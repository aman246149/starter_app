import 'package:injectable/injectable.dart';
import 'package:starter_app/core/api/extensions/response_extensions.dart';
import 'package:starter_app/core/infrastructure/base_remote_data_source.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/profile_api_service.dart';
import 'package:starter_app/features/profile/infrastructure/models/user_profile_model.dart';

/// Remote data source for user profiles.
abstract interface class IUserProfileRemoteDataSource {
  Future<UserProfileModel> getMyProfile();
}

/// Implementation using [ProfileApiService].
@LazySingleton(as: IUserProfileRemoteDataSource)
class UserProfileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements IUserProfileRemoteDataSource {
  UserProfileRemoteDataSourceImpl(this._apiService);

  final ProfileApiService _apiService;

  @override
  Future<UserProfileModel> getMyProfile() => execute(
    () async {
      final response = await _apiService.getMyProfile();
      return UserProfileModel.fromJson(response.requireBody);
    },
  );
}
