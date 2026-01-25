import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/profile_endpoints.dart';

part 'profile_api_service.chopper.dart';

@lazySingleton
@ChopperApi(baseUrl: ProfileEndpoints.profileBasePath)
abstract class ProfileApiService extends ChopperService {
  @factoryMethod
  static ProfileApiService create(ChopperClient client) =>
      _$ProfileApiService(client);

  @POST(path: ProfileEndpoints.profiles)
  Future<Response<Map<String, dynamic>>> createProfile(
    @Body() Map<String, dynamic> body,
  );


  @GET(path: ProfileEndpoints.me)
  Future<Response<Map<String, dynamic>>> getMyProfile();
}
