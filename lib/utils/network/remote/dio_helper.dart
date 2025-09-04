import 'dart:async';

import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/errors/server_exception.dart';
import 'package:dio/dio.dart';

abstract class DioHelper
{
  Future<dynamic> postMultiPart(String url, {dynamic data, String token});
}

class DioImpl extends DioHelper
{
  final Dio dioCode = Dio(
    BaseOptions(
      baseUrl: Config.get.baseURL,
      receiveDataWhenStatusError: true,
    ),
  );

  @override
  Future postMultiPart(String url, {dynamic data, String? token}) async
  {
    printFullText('req is $url and data is ${data is FormData?data?.fields:data} with token $token');

    dioCode.options.headers =
    {
      'Content-Type':'application/x-www-form-urlencoded',
      'Accept':'application/json',
      if(token != null)
        'Authorization':'Bearer $token'
    };

    if (url.contains('??')) {
      url = url.replaceAll('??', '?');
    }

    return await _request(
          () async => await dioCode.post(url, data: data),
    );
  }
}

extension on DioHelper
{
  Future _request(Future<Response> request()) async
  {
    try
    {
      final r = await request.call();
      return r.data;
    } on DioError catch (e)
    {
      throw ServerException(e.response?.data??'');
    } catch (e)
    {
      throw Exception();
    }
  }
}