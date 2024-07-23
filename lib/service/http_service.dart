import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:flutter_music_app/common/constants.dart';

class HttpService {
  String host = Constants.apiUrl;
  late BaseOptions baseOptions;
  late Dio dio;
  // late SharedPreferences prefs;

  Future<Map<String, String>> getHeaders() async {
    // final userToken = await AuthServices.getAuthBearerToken();
    return {
      HttpHeaders.acceptHeader: "application/json",
      // HttpHeaders.authorizationHeader: "Bearer $userToken",
      // "lang": translator.activeLocale.languageCode,
    };
  }

  HttpService() {
    // LocalStorageService.getPrefs();
    baseOptions = BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = Dio(baseOptions);
    dio.interceptors.add(getCacheManager().interceptor);
    // customization
    // dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: false,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90,
    //   ),
    // );
  }

  DioCacheManager getCacheManager() {
    return DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: const Duration(hours: 1),
      ),
    );
  }

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.get(
      url,
      options: mOptions,
      queryParameters: queryParameters,
    );
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.post(
      url,
      data: body,
      options: mOptions,
    );
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    FormData? formData,
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio.post(
        url,
        data: formData ?? FormData.fromMap(body),
        options: mOptions,
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    } catch (error) {
      throw "$error";
    }

    return response;
  }

  Future<Response> postCustomFiles(
    String url,
    body, {
    FormData? formData,
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio.post(
        url,
        data: formData ?? FormData.fromMap(body),
        options: mOptions,
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    return dio.patch(
      url,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    return dio.delete(
      url,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  Response formatDioExecption(DioError ex) {
    Response response = Response(requestOptions: ex.requestOptions);
    response.statusCode = 400;
    try {
      if (ex.type == DioErrorType.connectTimeout) {
        response.data = {
          "message": "Connection timeout. Please check your internet connection and try again",
        };
      } else {
        response.data = {
          "message": "Please check your internet connection and try again",
        };
      }
    } catch (error) {
      response.statusCode = 400;
      response.data = {
        "message": "Please check your internet connection and try again",
      };
    }

    return response;
  }
}
