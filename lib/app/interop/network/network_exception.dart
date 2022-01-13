import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';

part 'network_exception.freezed.dart';

@freezed
class NetworkException with ErrorHandler, _$NetworkException {
  const NetworkException._();
  const factory NetworkException.badRequest() = BadRequest;
  const factory NetworkException.conflict() = Conflict;
  const factory NetworkException.created() = Created;
  const factory NetworkException.defaultError(String error) = DefaultError;
  const factory NetworkException.formatException() = NetworkFormatException;
  const factory NetworkException.gatewayTimeout() = GatewayTimeout;
  const factory NetworkException.internalServerError() = InternalServerError;
  const factory NetworkException.methodNotAllowed() = MethodNotAllowed;
  const factory NetworkException.noInternetConnection() = NoInternetConnection;
  const factory NetworkException.notAcceptable() = NotAcceptable;
  const factory NetworkException.notFound(String reason) = NotFound;
  const factory NetworkException.notImplemented() = NotImplemented;
  const factory NetworkException.ok() = Ok;
  const factory NetworkException.requestCancelled() = RequestCancelled;
  const factory NetworkException.requestTimeout() = RequestTimeout;
  const factory NetworkException.sendTimeout() = SendTimeout;
  const factory NetworkException.serviceUnavailable() = ServiceUnavailable;
  const factory NetworkException.tooManyRequests() = TooManyRequests;
  const factory NetworkException.unableToProcess() = UnableToProcess;
  const factory NetworkException.unauthenticated() = Unauthenticated;
  const factory NetworkException.unauthorizedRequest() = UnauthorizedRequest;
  const factory NetworkException.unexpectedError() = UnexpectedError;
  static NetworkException handleResponse(int? statusCode) {
    switch (statusCode) {
      case 200:
        return NetworkException.ok();
      case 201:
        return NetworkException.created();
      case 400:
        return NetworkException.badRequest();
      case 401:
        return NetworkException.unauthenticated();
      case 403:
        return NetworkException.unauthorizedRequest();
      case 404:
        return NetworkException.notFound('Not found');
      case 408:
        return NetworkException.requestTimeout();
      case 409:
        return NetworkException.conflict();
      case 429:
        return NetworkException.tooManyRequests();
      case 500:
        return NetworkException.internalServerError();
      case 501:
        return NetworkException.notImplemented();
      case 503:
        return NetworkException.serviceUnavailable();
      case 504:
        return NetworkException.gatewayTimeout();
      default:
        var responseCode = statusCode;
        return NetworkException.defaultError(
          'Received invalid status code: $responseCode',
        );
    }
  }

  static NetworkException getDioException(error) {
    if (error is Exception) {
      try {
        NetworkException networkException;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkException = NetworkException.requestCancelled();
              break;
            case DioErrorType.connectTimeout:
              networkException = NetworkException.requestTimeout();
              break;
            case DioErrorType.other:
              networkException = NetworkException.noInternetConnection();
              break;
            case DioErrorType.receiveTimeout:
              networkException = NetworkException.sendTimeout();
              break;
            case DioErrorType.response:
              networkException =
                  NetworkException.handleResponse(error.response?.statusCode);
              break;
            case DioErrorType.sendTimeout:
              networkException = NetworkException.sendTimeout();
              break;
          }
        } else if (error is SocketException) {
          networkException = NetworkException.noInternetConnection();
        } else {
          networkException = NetworkException.unexpectedError();
        }
        return networkException;
      } on FormatException catch (_) {
        return NetworkException.formatException();
      } catch (_) {
        return NetworkException.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return NetworkException.unableToProcess();
      } else {
        return NetworkException.unexpectedError();
      }
    }
  }

  @override
  String getErrorMessage(BuildContext context, ErrorHandler networkException) {
    final localizations = AppLocalizations.of(context)!;

    var errorMessage = '';
    if (networkException is NetworkException) {
      networkException.when(notImplemented: () {
        errorMessage = localizations.networkErrorNotImplemented;
      }, requestCancelled: () {
        errorMessage = localizations.networkErrorRequestCancelled;
      }, internalServerError: () {
        errorMessage = localizations.networkErrorInternalServerError;
      }, notFound: (String reason) {
        errorMessage = reason;
      }, serviceUnavailable: () {
        errorMessage = localizations.networkErrorServiceUnavailable;
      }, methodNotAllowed: () {
        errorMessage = localizations.networkErrorMethodNotAllowed;
      }, badRequest: () {
        errorMessage = localizations.networkErrorBadRequest;
      }, unauthorizedRequest: () {
        errorMessage = localizations.networkErrorUnauthorizedRequest;
      }, unexpectedError: () {
        errorMessage = localizations.networkErrorUnexpectedError;
      }, requestTimeout: () {
        errorMessage = localizations.networkErrorRequestTimeout;
      }, noInternetConnection: () {
        errorMessage = localizations.networkErrorNoInternetConnection;
      }, conflict: () {
        errorMessage = localizations.networkErrorConflict;
      }, sendTimeout: () {
        errorMessage = localizations.networkErrorSendTimeout;
      }, unableToProcess: () {
        errorMessage = localizations.networkErrorUnableToProcess;
      }, defaultError: (String error) {
        errorMessage = error;
      }, formatException: () {
        errorMessage = localizations.networkErrorUnexpectedError;
      }, notAcceptable: () {
        errorMessage = localizations.networkErrorNotAcceptable;
      }, created: () {
        errorMessage = localizations.networkErrorCreated;
      }, gatewayTimeout: () {
        errorMessage = localizations.networkErrorGatewayTimeout;
      }, ok: () {
        errorMessage = localizations.networkErrorOk;
      }, tooManyRequests: () {
        errorMessage = localizations.networkErrorTooManyRequests;
      }, unauthenticated: () {
        errorMessage = localizations.networkErrorUnauthenticated;
      });
    }
    return errorMessage;
  }

  @override
  void displayError(
      BuildContext context, ErrorHandler error, Color errorColor) {
    if (error is NetworkException) {
      var errorMessage = getErrorMessage(context, error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: errorColor,
        content: Text(errorMessage),
      ));
    }
  }
}
