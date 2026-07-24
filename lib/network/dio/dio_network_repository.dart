import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../domain/repositories/database/local_database_repository.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../api_status.dart';
import '../file_field.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/organization_interceptor.dart';
import '../network_repository.dart';

class DioNetworkRepository implements NetworkRepository {
  final SecureStorageService _secureStorageService;
  final LocalDatabaseRepository _localDatabaseRepository;
  final Future<void> Function()? _onSessionExpired;

  DioNetworkRepository(
    this._secureStorageService,
    this._localDatabaseRepository, {
    this._onSessionExpired,
  }) {
    _initialize();
  }

  var dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3000",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  void _initialize() {
    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(
      AuthInterceptor(
        _secureStorageService,
        dio,
        onSessionExpired: _onSessionExpired,
      ),
    );
    dio.interceptors.add(OrganizationInterceptor(_localDatabaseRepository));
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        maxWidth: 90,
      ),
    );
  }

  @override
  Future<dynamic> sendRequest(
    final String endpoint, {
    final NetworkRequestMode mode = NetworkRequestMode.get,
    final Map<String, dynamic> parameters = const {},
    final Map<String, dynamic> headers = const {},
    final dynamic body,
    final bool isFormData = false,
    final bool returnFullResponse = false,
    final List<FileField>? fileFields,
  }) async {
    try {
      // Validate body type
      if (body != null && body is! Map<String, dynamic> && body is! List) {
        throw ArgumentError('Body must be either Map<String, dynamic> or List');
      }

      // Prepare headers
      final defaultHeaders = isFormData
          ? {'Content-Type': 'multipart/form-data'}
          : {'Content-Type': 'application/json', 'Accept': 'application/json'};
      final requestHeaders = {...defaultHeaders, ...headers};

      // Convert method enum to string
      final method = _getMethodString(mode);

      // Handle file uploads if present
      dynamic requestData;
      if (fileFields != null && fileFields.isNotEmpty) {
        if (isFormData) {
          final formData = FormData();

          // Add regular form fields
          if (body is Map) {
            body.forEach((key, value) {
              if (value != null) {
                formData.fields.add(MapEntry(key, value.toString()));
              }
            });
          }

          // Add files
          final fileMap = await _getFileFields(fileFields);
          fileMap.forEach((key, file) {
            formData.files.add(MapEntry(key, file));
          });

          requestData = formData;
        } else {
          throw ArgumentError('File uploads require isFormData=true');
        }
      } else {
        requestData = body;
      }

      // Make the request
      final response = await dio.request(
        '${dio.options.baseUrl}$endpoint',
        queryParameters: _removeNullAndEmptyValues(parameters),
        options: Options(method: method, headers: requestHeaders),
        data: isFormData && requestData is! FormData
            ? FormData.fromMap(requestData as Map<String, dynamic>)
            : requestData,
      );

      return returnFullResponse ? response.data : response.data['data'];
    } on DioException catch (e) {
      _handleException(e);
    } catch (e) {
      throw FormatException(e.toString());
    }
  }

  String _getMethodString(NetworkRequestMode mode) {
    switch (mode) {
      case NetworkRequestMode.post:
        return 'POST';
      case NetworkRequestMode.get:
        return 'GET';
      case NetworkRequestMode.put:
        return 'PUT';
      case NetworkRequestMode.delete:
        return 'DELETE';
      case NetworkRequestMode.patch:
        return 'PATCH';
      default:
        throw Exception('Unsupported HTTP method: $mode');
    }
  }

  Future<Map<String, MultipartFile>> _getFileFields(
    List<FileField> fileFields,
  ) async {
    final Map<String, MultipartFile> mediaFields = {};

    for (var fileField in fileFields) {
      if (fileField.files.isNotEmpty) {
        final httpFile = fileField.files.first;
        log("FILE NAME: ${httpFile.path.split('/').last}");

        final mimeType =
            lookupMimeType(httpFile.path) ?? 'application/octet-stream';
        mediaFields[fileField.fieldName] = await MultipartFile.fromFile(
          httpFile.path,
          filename: httpFile.path.split('/').last,
          contentType: MediaType.parse(mimeType),
        );
      }
    }
    return mediaFields;
  }

  Never _handleException(DioException exception) {
    debugPrint("status code : ${exception.response?.statusCode}");
    if (exception.type == DioExceptionType.connectionError) {
      throw ApiStatuses.INTERNET_CONNECTION_PROBLEM;
    }
    final responseData = exception.response?.data;
    if (responseData is Map<String, dynamic>) {
      throw responseData['message'] ?? exception.message;
    }
    throw exception.message ?? 'The request could not be completed.';
  }

  Map<String, dynamic> _removeNullAndEmptyValues(
    Map<String, dynamic> inputMap,
  ) {
    return Map.from(inputMap)..removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );
  }
}
