import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/types/types.dart';

part 'check_user_exists_response_model.freezed.dart';
part 'check_user_exists_response_model.g.dart';

/// Data transfer object for check user exists responses.
@freezed
abstract class CheckUserExistsResponseModel
    with _$CheckUserExistsResponseModel {
  const factory CheckUserExistsResponseModel({
    required bool exists,
  }) = _CheckUserExistsResponseModel;

  /// Creates model from JSON.
  factory CheckUserExistsResponseModel.fromJson(Json json) =>
      _$CheckUserExistsResponseModelFromJson(json);
}
