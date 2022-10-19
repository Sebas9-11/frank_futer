// ignore_for_file: unused_import
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frank_futer/models/model.dart';
import 'package:intl/intl.dart';

class FrankFurterProvider {
  final baseUrl = 'api.frankfurter.app';

  Future<List<ModelRates>> getRates({divisa}) async {
    final url = Uri.https(
      baseUrl,
      '/latest',
      {'base': divisa},
    );
    final response = await http.get(url);
    final List<ModelRates> modelRates = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var result = jsonDecode(body);

      for (var item in result['rates'].keys) {
        modelRates.add(
          ModelRates(
            amount: double.parse(result['rates'][item].toString()),
            base: item,
            //date: DateTime.parse(result['date']),
            //obtener fecga actual sin l hora
            date: DateTime.now(),
            rates: Map.from(result['rates'])
                .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
          ),
        );
      }
      return modelRates;
    } else {
      throw Exception('Failed to load rates');
    }
  }

  Future<List<String>> getCurencies() async {
    final url = Uri.https(baseUrl, '/currencies');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      String body = utf8.decode(res.bodyBytes);
      var result = jsonDecode(body);
      return result.keys.toList();
    } else {
      throw Exception("Failed to load data");
    }
  }
}
