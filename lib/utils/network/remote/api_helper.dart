import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/errors/server_exception.dart';
import 'package:cargo/utils/runtime_printer.dart';
import 'package:http/http.dart';

abstract class ApiHelper {
  Future<String> getData(
    String baseUrl,
    String url, {
    String? token,
    String queries,
    bool typeJSON = false,
  });

  Future<String> deleteData(
    String baseUrl,
    String url, {
    String token,
  });

  Future<dynamic> postData(
    String baseUrl,
    String url, {
    String? token,
    String? authToken,
    Map<String, dynamic> data,
    Map<String, dynamic> headers,
    bool typeJSON = false,
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

class ApiImpl extends ApiHelper {
  // Client client = HttpClientWithInterceptor.build(interceptors: [
  //   LoggingInterceptor(),
  // ]);

  Client client = Client();

  @override
  Future<String> getData(
    String baseUrl,
    String url, {
    String? token,
    String queries = '',
    bool typeJSON = false,
  }) async {
    return await _request(() async {
      String req = '$baseUrl$url$queries';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      printFullText('req is $req');
      printFullText('token is $token');
      final rp = RunTimePrinter()..init();
      final r = await client.get(Uri.parse(req), headers: {
        if (token != null && token.isNotEmpty) 'token': '$token',
        if (typeJSON) HttpHeaders.contentTypeHeader: 'application/json',
      });
      rp.printTime(req);
      final request = r.request;
      log('REQUEST:\n'
          'METHOD: ${request?.method}\n'
          'URL: ${request?.url}\n'
          'QUERIES: $queries\n'
          'HEADERS: {${request?.headers.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          ''
          'RESPONSE:\n'
          'STATUS_CODE: ${r.statusCode}\n'
          'HEADERS: {${r.headers.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          'BODY: ${r.body}\n'
          '');
      return r;
    }, () {
      String req = '$baseUrl$url$queries';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      return req;
    }());
  }

  @override
  Future<String> deleteData(
    String baseUrl,
    String url, {
    String? token,
  }) async {
    return await _request(() async {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      printFullText('req is $req');
      final rp = RunTimePrinter()..init();
      final r = await client.delete(Uri.parse(req), headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      });
      rp.printTime(req);
      final request = r.request;
      log('REQUEST:\n'
          'METHOD: ${request?.method}\n'
          'URL: ${request?.url}\n'
          'HEADERS: {${request?.headers.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          ''
          'RESPONSE:\n'
          'STATUS_CODE: ${r.statusCode}\n'
          'HEADERS: {${r.headers.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          'BODY: ${r.body}\n'
          '');
      return r;
    }, () {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      return req;
    }());
  }

  @override
  Future<dynamic> postData(
    String baseUrl,
    String url, {
    String? token,
    String? authToken,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> headers = const {},
    bool typeJSON = false,
  }) async {
    return await _request(() async {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      printFullText('req is $req and data : $data');
      final rp = RunTimePrinter()..init();
      final r = await client.post(
        Uri.parse(req),
        headers: {
          ...headers,
          if (token != null && token.isNotEmpty) 'token': '$token',
          if (authToken != null && authToken.isNotEmpty) 'token': '$authToken',
          if (typeJSON) HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: data,
      );
      rp.printTime(req);
      final request = r.request;
      log('REQUEST:\n'
          'METHOD: ${request?.method}\n'
          'URL: ${request?.url}\n'
          'DATA: {${data.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          'HEADERS: {${request?.headers.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          ''
          'RESPONSE:\n'
          'STATUS_CODE: ${r.statusCode}\n'
          'HEADERS: {${r.headers.entries.map((e) => '${e.key}:${e.value}').join(',')}}\n'
          'BODY: ${r.body}\n'
          '');
      return r;
    }, () {
      String req = '$baseUrl$url';
      if (req.contains('??')) {
        req = req.replaceAll('??', '?');
      }
      return '$req and data : $data';
    }());
  }
}

extension on ApiHelper {
  Future _request(Future<Response> request(), String url) async {
    try {
      var r = await request.call();
      return r.body;
    } catch (e,s) {
      print('eorroroorro : ${e.toString()} in $url');
      print(s);
      throw ServerException('server exception');
    }
  }
}

// class LoggingInterceptor implements InterceptorContract {
//   @override
//   Future<RequestData> interceptRequest({RequestData data}) async {
//     printFullText('Call Headers => ${data.headers}');
//     print('Call Params => ${data.params}');
//     print('Call Base Url => ${data.baseUrl}');
//     print('Call Full Url => ${data.toHttpRequest().url}');
//     return data;
//   }
//
//   @override
//   Future<ResponseData> interceptResponse({ResponseData data}) async {
//     print('Response URL => ${data.url}');
//     print('Response Method => ${data.method}');
//     print('Response Code => ${data.statusCode}');
//     print('Response Headers => ${data.headers}');
//     // printFullText('Response Body => ${jsonDecode(data.body)}');
//     return data;
//   }
// }
