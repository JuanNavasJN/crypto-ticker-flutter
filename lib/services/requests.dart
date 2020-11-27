import 'package:http/http.dart' as http;
import 'dart:convert';

const cryptocompareKey =
    "993488641014a6c89f2d29d53a5bc0c2ac3eb1308b9575c0eb35be198bd88f73";

Future<double> getRate(String crypto, String fiat) async {
  String url =
      'https://min-api.cryptocompare.com/data/price?fsym=$crypto&tsyms=$fiat';

  http.Response response =
      await http.get(url, headers: {'Apikey': cryptocompareKey});

  var data = jsonDecode(response.body);
  double rate = data['$fiat'];

  // print(data);
  // print(rate);
  if (rate != null) {
    return rate;
  }

  return 0.0;
}
