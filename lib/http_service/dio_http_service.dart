import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

_HttpService httpService = _HttpService();

class _HttpService {
  Dio? _dio;

  _HttpService() {
    _dio = Dio(BaseOptions(
      // Todo base Url Here
      baseUrl: "",
      connectTimeout: 5000,
      receiveTimeout: 3000,
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
        return _errorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage);
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
        return _errorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage);
      } else {
        throw Exception(e);
      }
    }
  }

  // Patch Request

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
        return _errorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage);
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
        return _errorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage);
      } else {
        throw Exception(e);
      }
    }
  }

  // Patch Request

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
        return _errorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage);
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
        return _errorResponse(
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage);
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
          // String? token = Constant.pref?.getString("token");

          // if (token != null) {
          //   requestOptions.headers["Authorization"] = token;
          // }

          //>
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
          log("on Error Response ${err.response}");

          return handler.next(err);
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
    // Constant.pref?.clear();
    return Response(
        statusCode: 403,
        statusMessage: "Somthing wrong in API 403",
        requestOptions: RequestOptions(path: ""));

    // showToastMsg(response.data["message"].toString(),
    //     color: Colors.black, gravity: ToastGravity.BOTTOM);

  } else if (response.data["code"] == 404) {
    return Response(
        statusCode: 404,
        statusMessage: "Somthing wrong in API 404",
        requestOptions: RequestOptions(path: ""));
    // showToastMsg(response.data["message"].toString(),
    //     color: Colors.black, gravity: ToastGravity.BOTTOM);
  }
  // user is not authenticated

  else if (response.statusCode == 409) {
    // showToastMsg(response.data['message'],
    //     color: Colors.black, gravity: ToastGravity.BOTTOM);
    // Future.delayed(const Duration(seconds: 1), () async {
    //   Constant.pref?.clear();
    //   Getx.Get.offAll(() => const LoginScreen());
    // });

    return Response(
        statusCode: 409,
        statusMessage: "Somthing wrong in API 409",
        requestOptions: RequestOptions(path: ""));
  } else if (response.statusCode == 400) {
    return Response(
        statusCode: 400,
        statusMessage: "Bad Request 400",
        requestOptions: RequestOptions(path: ""));
  } else {
    return Response(
        statusCode: 400,
        statusMessage: "Bad Request 400",
        requestOptions: RequestOptions(path: ""));
    // showToastMsg(response.data['message'] ?? "Something Went Wrong",
    //     color: Colors.black, gravity: ToastGravity.BOTTOM);
  }
}

Response _errorResponse({int? statusCode, String? statusMessage}) {
  return Response(
      statusCode: statusCode ?? 400,
      statusMessage: statusMessage ?? "Somthing wrong in API",
      requestOptions: RequestOptions(path: ""));
}
