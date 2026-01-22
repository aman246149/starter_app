import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Module for storage-related dependencies.
///
/// Provides:
/// - **HydratedBloc storage**: For automatic state persistence (Cubits/Blocs)
/// - **SharedPreferences**: For simple key-value storage (settings, cache)
/// - **FlutterSecureStorage**: For secure storage of sensitive data (tokens)
///
/// All dependencies are async-initialized with @preResolve to ensure
/// they're ready before app startup completes.
@module
abstract class StorageModule {
  /// Provides HydratedBloc storage for state persistence.
  ///
  /// Uses @preResolve because storage initialization is asynchronous.
  /// This ensures storage is ready before any HydratedBloc is created.
  ///
  /// Storage location:
  /// - **Mobile/Desktop**: Temporary directory (fast, auto-managed)
  /// - **Web**: Browser storage
  ///
  /// Used by: ThemeCubit and other HydratedCubits for automatic
  /// state persistence across app restarts.
  @preResolve
  @singleton
  Future<HydratedStorage> provideHydratedStorage() async {
    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
    return storage;
  }

  /// Provides SharedPreferences for simple key-value storage.
  ///
  /// Uses @preResolve because SharedPreferences initialization is async.
  /// Available as a lazySingleton - initialized on first use but reusable.
  ///
  /// Use cases:
  /// - User preferences and settings
  /// - Simple cache data
  /// - Feature flags
  /// - Onboarding state
  ///
  /// For complex state management, prefer HydratedBloc instead.
  @preResolve
  @lazySingleton
  Future<SharedPreferences> provideSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  /// Provides FlutterSecureStorage for secure storage of sensitive data.
  ///
  /// Uses platform-specific secure storage:
  /// - **iOS**: Keychain
  /// - **Android**: EncryptedSharedPreferences (AES)
  /// - **Web**: Web Cryptography API
  /// - **Desktop**: Encrypted storage
  ///
  /// Use cases:
  /// - Authentication tokens (access/refresh tokens)
  /// - API keys
  /// - User credentials (if stored)
  /// - Encryption keys
  ///
  /// DO NOT use for:
  /// - Large data (use SharedPreferences or database)
  /// - Non-sensitive data (use SharedPreferences)
  @lazySingleton
  FlutterSecureStorage provideFlutterSecureStorage() {
    return const FlutterSecureStorage(
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }
}
