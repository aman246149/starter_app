// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'auth_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthApiService extends AuthApiService {
  _$AuthApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthApiService;

  @override
  Future<Response<Map<String, dynamic>>> login(
    Map<String, dynamic> credentials,
  ) {
    final Uri $url = Uri.parse('/api/v1/auth/login');
    final $body = credentials;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<void>> logout() {
    final Uri $url = Uri.parse('/api/v1/auth/logout');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<void, void>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> register(
    Map<String, dynamic> userData,
  ) {
    final Uri $url = Uri.parse('/api/v1/auth/register');
    final $body = userData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> refreshToken(
    Map<String, dynamic> refreshData,
  ) {
    final Uri $url = Uri.parse('/api/v1/auth/refresh');
    final $body = refreshData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getCurrentUser() {
    final Uri $url = Uri.parse('/api/v1/auth/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> updateProfile(
    Map<String, dynamic> profileData,
  ) {
    final Uri $url = Uri.parse('/api/v1/auth/me');
    final $body = profileData;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> checkUserExists(
    Map<String, dynamic> userData,
  ) {
    final Uri $url = Uri.parse('/api/v1/auth/check-user-exists');
    final $body = userData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
