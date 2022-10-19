import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frank_futer/models/model.dart';
import 'package:frank_futer/provider/second_provider.dart';
import 'package:card_swiper/card_swiper.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  late Future<List<ModelRates>> _modelRates;
  late FrankFurterProvider _frankFurterProvider;
  late Future<List<String>> currencies;
  late String _selectedCurrency = 'AUD';

  final flags2 = {
    "AUD": 'AUS',
    "BGN": 'BGR',
    "BRL": 'BRA',
    "HRK": 'HRV',
    "ISK": 'ISL',
    "TRY": 'TR',
    "USD": 'US',
    "ZAR": 'ZAF',
    'EUR': 'EUR',
    'GBP': 'GBR',
    'CAD': 'CAN',
    'CHF': 'CHE',
    'CNY': 'CHN',
    'CZK': 'CZE',
    'DKK': 'DNK',
    'HKD': 'HKG',
    'HUF': 'HUN',
    'IDR': 'IDN',
    'ILS': 'ISR',
    'INR': 'IND',
    'JPY': 'JPN',
    'KRW': 'KOR',
    'MXN': 'MEX',
    'MYR': 'MYS',
    'NOK': 'NOR',
    'NZD': 'NZL',
    'PHP': 'PHL',
    'PLN': 'POL',
    'RON': 'ROU',
    'RUB': 'RUS',
    'SEK': 'SWE',
    'SGD': 'SGP',
    'THB': 'THA',
  };

  @override
  void initState() {
    super.initState();
    _frankFurterProvider = FrankFurterProvider();
    currencies = _frankFurterProvider.getCurencies();
    _modelRates = _frankFurterProvider.getRates(divisa: _selectedCurrency);
    _frankFurterProvider = FrankFurterProvider();
    _selectedCurrency;
  }

  //generar colores aleatorios una sola vez
  final _random = Random();
  Color _getRandomColor() => Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //selector para divisas y recargar la pagina
            FutureBuilder<List<String>>(
              future: currencies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(255, 127, 80, 1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 127, 80, 1),
                          ),
                        ),
                        labelText: 'Divisa',
                      ),
                      alignment: Alignment.center,
                      value: _selectedCurrency,
                      items: snapshot.data!
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                //mostrar texto e imagen de la divisa
                                child: Row(
                                  children: <Widget>[
                                    Image.network(
                                      'https://countryflagsapi.com/png/${flags2[value]}',
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(value),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCurrency = value!;
                          _modelRates =
                              _frankFurterProvider.getRates(divisa: value);
                        });
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            FutureBuilder(
                future: _modelRates,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      key: UniqueKey(),
                      child: Swiper(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var flags = snapshot.data![index].base;
                          var amount = snapshot.data![index].amount;
                          var base = snapshot.data![index].base;
                          var date = snapshot.data![index].date.toString();
                          var money = _selectedCurrency;
                          return Card(
                            color: _getRandomColor(),
                            child: Column(
                              children: <Widget>[
                                //imagen de la divisa
                                Expanded(
                                  flex: 2,
                                  child: Image.network(
                                    'https://countryflagsapi.com/png/${flags2[flags]}',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                //nombre de la divisa
                                Expanded(
                                  flex: 1,
                                  child: titles(title: '$money ➡️ $base'),
                                ),
                                spaces(),
                                //valor de la divisa
                                Expanded(
                                  flex: 1,
                                  child: titles(
                                      title: '1.0 $money = $amount $base'),
                                ),
                                spaces(),
                                //fecha de consulta
                                Expanded(
                                  flex: 1,
                                  child: titles(title: date),
                                ),
                              ],
                            ),
                          );
                        },
                        //efecto de la tarjeta
                        layout: SwiperLayout.TINDER,
                        itemWidth: MediaQuery.of(context).size.width * 0.9,
                        itemHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      // child: ListView(
                      //   children: _moneys(snapshot.data),
                      // ),
                    );
                  } else if (snapshot.hasError) {
                    (snapshot.error);
                    return const Text('No funciona');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget spaces({height}) {
    return const SizedBox(
      height: 10,
    );
  }

  Widget titles({title}) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    );
  }
}
