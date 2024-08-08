import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:path_provider/path_provider.dart';

class HttpService {
  static late Dio dio;

  static initialize() async {
    BaseOptions baseOptions = BaseOptions(
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      connectTimeout: const Duration(seconds: 5),
    );
    dio = Dio(baseOptions);
    Directory? appDocDir = await getDownloadsDirectory();
    String appDocPath = appDocDir!.path;
    // Use PersistCookieJar to save/load cookies
    PersistCookieJar cookieJar = PersistCookieJar(storage: FileStorage("$appDocPath/cookies"));
    // Add CookieManager to Dio
    dio.interceptors.add(CookieManager(cookieJar));
    // Add an interceptor to modify the response headers if needed
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (response.headers.value('content-type') == 'text/html;UTF-8;charset=utf-8') {
          // Correct the content-type header
          response.headers.set('content-type', 'text/html;charset=UTF-8');
        }
        handler.next(response); // Continue
      },
    ));
    try {
      await dio.get(Constants.apiUrl);
      // Get cookies for the site
      List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(Constants.apiUrl));
      for (var cookie in cookies) {
        print('Cookie from ${Constants.apiUrl}: $cookie');
      }
    } on DioException catch (e) {
      print('Request to ${Constants.apiUrl} failed with status: ${e.response?.statusCode}');
    }
  }

  static Future<Map<String, String>> getHeaders() async {
    return {HttpHeaders.acceptHeader: "application/json"};
  }

  static Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeHeaders = true,
  }) async {
    final mOptions = !includeHeaders ? null : Options(headers: await getHeaders());
    queryParameters!.addAll({
      "ctime": Constants.ctime,
      "version": Constants.zingMP3Version,
      "apiKey": Constants.apiKey,
    });
    Response response;
    try {
      response = await dio.get(url, options: mOptions, queryParameters: queryParameters);
    } on DioException catch (error) {
      response = formatDioExecption(error);
    } catch (error) {
      throw "$error";
    }
    return response;
  }

  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders ? null : Options(headers: await getHeaders());
    return dio.post(url, data: body, options: mOptions);
  }

  Future<Response> postWithFiles(
    String url,
    body, {
    FormData? formData,
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders ? null : Options(headers: await getHeaders());
    Response response;
    try {
      response = await dio.post(
        url,
        data: formData ?? FormData.fromMap(body),
        options: mOptions,
      );
    } on DioException catch (error) {
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
    final mOptions = !includeHeaders ? null : Options(headers: await getHeaders());
    Response response;
    try {
      response = await dio.post(
        url,
        data: formData ?? FormData.fromMap(body),
        options: mOptions,
      );
    } on DioException catch (error) {
      response = formatDioExecption(error);
    }
    return response;
  }

  Future<Response> patch(String url, Map<String, dynamic> body) async {
    return dio.patch(
      url,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

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

  static Response formatDioExecption(DioException ex) {
    Response response = Response(requestOptions: ex.requestOptions);
    response.statusCode = 400;
    try {
      if (ex.type == DioExceptionType.connectionTimeout) {
        response.data = {"msg": "Please check your internet connection and try again"};
      } else {
        response.data = {"msg": ex.error.toString()};
      }
    } catch (error) {
      response.statusCode = 400;
      response.data = {"msg": "Please check your internet connection and try again"};
    }
    return response;
  }
}
