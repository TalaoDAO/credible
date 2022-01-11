import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions
    with ErrorHandler
    implements _$NetworkExceptions {
  const factory NetworkExceptions.badRequest() = BadRequest;
  const factory NetworkExceptions.conflict() = Conflict;
  const factory NetworkExceptions.created() = Created;
  const factory NetworkExceptions.defaultError(String error) = DefaultError;
  const factory NetworkExceptions.formatException() = NetworkFormatException;
  const factory NetworkExceptions.gatewayTimeout() = GatewayTimeout;
  const factory NetworkExceptions.internalServerError() = InternalServerError;
  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;
  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;
  const factory NetworkExceptions.notAcceptable() = NotAcceptable;
  const factory NetworkExceptions.notFound(String reason) = NotFound;
  const factory NetworkExceptions.notImplemented() = NotImplemented;
  const factory NetworkExceptions.ok() = Ok;
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;
  const factory NetworkExceptions.requestTimeout() = RequestTimeout;
  const factory NetworkExceptions.sendTimeout() = SendTimeout;
  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;
  const factory NetworkExceptions.tooManyRequests() = TooManyRequests;
  const factory NetworkExceptions.unableToProcess() = UnableToProcess;
  const factory NetworkExceptions.unauthenticated() = Unauthenticated;
  const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;
  const factory NetworkExceptions.unexpectedError() = UnexpectedError;
  static NetworkExceptions handleResponse(int? statusCode) {
    switch (statusCode) {
      case 200:
        return NetworkExceptions.ok();
      case 201:
        return NetworkExceptions.created();
      case 400:
        return NetworkExceptions.badRequest();

      case 401:
        return NetworkExceptions.unauthenticated();
      case 403:
        return NetworkExceptions.unauthorizedRequest();
      case 404:
        return NetworkExceptions.notFound('Not found');
      case 408:
        return NetworkExceptions.requestTimeout();
      case 409:
        return NetworkExceptions.conflict();
      case 429:
        return NetworkExceptions.tooManyRequests();
      case 500:
        return NetworkExceptions.internalServerError();
      case 501:
        return NetworkExceptions.notImplemented();
      case 503:
        return NetworkExceptions.serviceUnavailable();
      case 504:
        return NetworkExceptions.gatewayTimeout();
      default:
        var responseCode = statusCode;
        return NetworkExceptions.defaultError(
          'Received invalid status code: $responseCode',
        );
    }
  }

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkExceptions = NetworkExceptions.requestCancelled();
              break;
            case DioErrorType.connectTimeout:
              networkExceptions = NetworkExceptions.requestTimeout();
              break;
            case DioErrorType.other:
              networkExceptions = NetworkExceptions.noInternetConnection();
              break;
            case DioErrorType.receiveTimeout:
              networkExceptions = NetworkExceptions.sendTimeout();
              break;
            case DioErrorType.response:
              networkExceptions =
                  NetworkExceptions.handleResponse(error.response?.statusCode);
              break;
            case DioErrorType.sendTimeout:
              networkExceptions = NetworkExceptions.sendTimeout();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return NetworkExceptions.formatException();
      } catch (_) {
        return NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return NetworkExceptions.unableToProcess();
      } else {
        return NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(
      BuildContext context, NetworkExceptions networkExceptions) {
    final localizations = AppLocalizations.of(context)!;

    var errorMessage = '';
    networkExceptions.when(notImplemented: () {
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
    return errorMessage;
  }

  static void displayError(
      BuildContext context, ErrorHandler error, Color errorColor) {
    if (error is NetworkExceptions) {
      var errorMessage = getErrorMessage(context, error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: errorColor,
        content: Text(errorMessage),
      ));
    }
  }
}
