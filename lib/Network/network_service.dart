import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';

class NetworkService {
  Future<ApiResponseModel> login(
      {required String email, required String password}) async {
    final Dio _dio = Dio();

    try {
      final Response _loginResp = await _dio.post(
        '$baseUrl$loginEndPoint',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (_loginResp.statusCode == 200) {
        return ApiResponseModel(
            statusCode: _loginResp.statusCode!,
            endPoint: loginEndPoint,
            specificMessage: "Login Successful");
      } else {
        return ApiResponseModel(
          statusCode: _loginResp.statusCode ?? 400,
          endPoint: loginEndPoint,
          specificMessage: _loginResp.data.toString(),
        );
      }
    } on DioError catch (e) {
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: loginEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: loginEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> signup(
      {required String name,
      required String email,
      required String password}) async {
    final Dio _dio = Dio();

    try {
      final Response _signupResp = await _dio.post(
        '$baseUrl$signupEndPoint',
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      if (_signupResp.statusCode == 200) {
        return ApiResponseModel(
            statusCode: _signupResp.statusCode!,
            endPoint: loginEndPoint,
            specificMessage: "Signup Successful");
      } else {
        return ApiResponseModel(
          statusCode: _signupResp.statusCode ?? 400,
          endPoint: loginEndPoint,
          specificMessage: _signupResp.data.toString(),
        );
      }
    } on DioError catch (e) {
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: loginEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: loginEndPoint,
        specificMessage: " unknown error",
      );
    }
  }
}
