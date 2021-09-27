import 'package:dio/dio.dart';

var options = BaseOptions(
  baseUrl: 'http://d.store.deepinos.org.cn',
  connectTimeout: 5000,
  receiveTimeout: 3000,
  sendTimeout: 3000,
  headers: {
    "User-Agent":
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:92.0) Gecko/20100101 Firefox/92.0",
  },
);

Dio dio = Dio(options)
  ..interceptors.add(
    LogInterceptor(),
  );
// ..httpClientAdapter = Http2Adapter(
//   ConnectionManager(
//     idleTimeout: 10000,
//     // Ignore bad certificate
//     onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
//   ),
// );
