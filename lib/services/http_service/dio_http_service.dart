import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fluttermvvm/core/utils/constants/endpoints_rest_api.dart';

var httpService = _HttpService();

class _HttpService {
  Dio? _dio;

  _HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppUrls.base,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    _initInterceptors();
  }

  // GET Request

  Future<Response> get({
    String? baseUrl,
    String? endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      if (baseUrl != null) {
        _dio?.options.baseUrl = baseUrl;
      }
      Response? res = await _dio?.get(endPoint ?? "",
          queryParameters: queryParameters, options: options);

      return res!;
    } catch (e) {
      if (e is DioError) {
        return e.response!;
      } else {
        throw Exception(e);
      }
    }
  }

  // POST Request

  Future<Response> post(
      {String? baseUrl,
      String? endPoint,
      dynamic data,
      Options? options,
      void Function(int, int)? onSendProgress}) async {
    try {
      if (baseUrl != null) {
        _dio?.options.baseUrl = baseUrl;
      }

      Response? res = await _dio?.post(
        endPoint ?? "",
        data: data,
        options: options,
        onSendProgress: onSendProgress,
      );

      return res!;
    } catch (e) {
      if (e is DioError) {
        return e.response!;
      } else {
        throw Exception(e);
      }
    }
  }

  // Put Request

  Future<Response> put({
    String? baseUrl,
    String? endPoint,
    dynamic data,
    Options? options,
  }) async {
    try {
      if (baseUrl != null) {
        _dio?.options.baseUrl = baseUrl;
      }
      Response? res =
          await _dio?.put(endPoint ?? "", data: data, options: options);

      return res!;
    } catch (e) {
      if (e is DioError) {
        return e.response!;
      } else {
        throw Exception(e);
      }
    }
  }

  // Patch Request

  Future<Response> patch({
    String? baseUrl,
    String? endPoint,
    dynamic data,
    Options? options,
  }) async {
    try {
      if (baseUrl != null) {
        _dio?.options.baseUrl = baseUrl;
      }
      Response? res =
          await _dio?.patch(endPoint ?? "", data: data, options: options);

      return res!;
    } catch (e) {
      if (e is DioError) {
        return e.response!;
      } else {
        throw Exception(e);
      }
    }
  }

  // delete Request

  Future<Response> delete({
    String? baseUrl,
    String? endPoint,
    dynamic data,
    Options? options,
  }) async {
    try {
      if (baseUrl != null) {
        _dio?.options.baseUrl = baseUrl;
      }
      Response? res =
          await _dio?.delete(endPoint ?? "", data: data, options: options);

      return res!;
    } catch (e) {
      if (e is DioError) {
        return e.response!;
      } else {
        throw Exception(e);
      }
    }
  }

  // Download reqest

  Future<Response> download({
    required String urlPath,
    dynamic savePath,
    void Function(int, int)? onReceiveProgress,
    dynamic data,
    Options? options,
  }) async {
    try {
      Response? res = await _dio?.download(urlPath, savePath,
          data: data, onReceiveProgress: onReceiveProgress, options: options);

      return res!;
    } catch (e) {
      if (e is DioError) {
        return e.response!;
      } else {
        throw Exception(e);
      }
    }
  }

  void _initInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          // << handling token
          // String? token =
          //     SharedPrefs.pref?.getString(SharedPrefs.keys.authToken);

          // if ("$token" != "null") {
          //   requestOptions.headers["Authorization"] = "Bearer $token";
          // }

          // >
          log("Method : ${requestOptions.method}");
          log("Url : ${requestOptions.uri}");
          log("Header : ${requestOptions.headers}");
          log("Body : ${requestOptions.data}");
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          var data = json.encode(response.data);
          log("Response $data");
          var res = _responseHendle(response);
          return handler.next(res);
          // return handler.next(response);
        },
        onError: (err, handler) {
          _responseHendle(err.response!);
          log("on Error Response  ${err.response}");
          DioError errorData = DioError(
              requestOptions: RequestOptions(path: ""),
              response: _responseHendle(err.response!));

          return handler.next(errorData);
        },
      ),
    );
  }
}

Response<dynamic> _responseHendle(Response<dynamic> response) {
  if (response.statusCode == 200) {
    return response;
  } else if (response.statusCode == 201) {
    return response;
  } else if (response.statusCode == 403) {
    // SharedPreferenceStorage.clearData();

    return Response(
        statusCode: 403,
        data: response.data ?? {},
        statusMessage: "Somthing wrong in API 403",
        requestOptions: RequestOptions(path: ""));
  } else if (response.statusCode == 404) {
    return Response(
        statusCode: 404,
        data: response.data ?? {},
        statusMessage: "Somthing wrong in API 404",
        requestOptions: RequestOptions(path: ""));
  }
  // user is not authenticated

  else if (response.statusCode == 409) {
    return Response(
        statusCode: 409,
        data: response.data ?? {},
        statusMessage: "Somthing wrong in API 409",
        requestOptions: RequestOptions(path: ""));
  } else if (response.statusCode == 400) {
    return Response(
        statusCode: 400,
        data: response.data ?? {},
        statusMessage: "Bad Request 400",
        requestOptions: RequestOptions(path: ""));
  } else {
    return Response(
        statusCode: 400,
        data: response.data ?? {},
        statusMessage: "Bad Request 400",
        requestOptions: RequestOptions(path: ""));
  }
}
