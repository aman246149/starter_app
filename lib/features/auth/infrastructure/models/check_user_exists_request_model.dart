import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/types/types.dart';

part 'check_user_exists_request_model.freezed.dart';
part 'check_user_exists_request_model.g.dart';

/// Data transfer object for check user exists requests.
@freezed
abstract class CheckUserExistsRequestModel with _$CheckUserExistsRequestModel {
  const factory CheckUserExistsRequestModel({
    required String email,
  }) = _CheckUserExistsRequestModel;

  const CheckUserExistsRequestModel._();

  /// Creates model from JSON (rarely used).
  factory CheckUserExistsRequestModel.fromJson(Json json) =>
      _$CheckUserExistsRequestModelFromJson(json);

  /// Creates model from domain email.
  factory CheckUserExistsRequestModel.fromDomain(EmailAddress email) {
    return CheckUserExistsRequestModel(
      email: email.getOrCrash(),
    );
  }
}
