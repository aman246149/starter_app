// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'profile_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProfileApiService extends ProfileApiService {
  _$ProfileApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProfileApiService;

  @override
  Future<Response<Map<String, dynamic>>> getMyProfile() {
    final Uri $url = Uri.parse('/api/v1/profiles/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
