class ModelRates {
  ModelRates({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  double amount;
  String base;
  DateTime date;
  Map<String, double> rates;

  factory ModelRates.fromJson(Map<String, dynamic> json) => ModelRates(
        amount: json["amount"],
        base: json["base"],
        date: DateTime.parse(json["date"]),
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "base": base,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
