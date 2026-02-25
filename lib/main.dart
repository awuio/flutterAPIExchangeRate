import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab12/ExchangeRate.dart';
import 'package:lab12/MoneyBox.dart';

void main() {
  runApp(MyApp());
}

// stl
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      home: MyHomePage(),
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.red)),
    );
  }
}

// stf
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ExchangeRate _dataFromAPI;
  @override
  void initState() {
    super.initState();
  }

  Future<ExchangeRate> getExchangeRate() async {
    var url = "https://open.er-api.com/v6/latest/THB";
    var response = await http.get(Uri.parse(url));

    _dataFromAPI = exchangeRateFromJson(response.body);
    return _dataFromAPI;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exchange Rate")),
      body: FutureBuilder(
        future: getExchangeRate(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //ตรวจสอบสถานะ กรณีดึงข้อมูลสำเร็จ
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            double money = 4;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Moneybox("THB", money, Colors.green, 150),
                  SizedBox(height: 5),
                  Moneybox("USD", money * result.rates["USD"], Colors.red, 100),
                  SizedBox(height: 5),
                  Moneybox(
                    "JPY",
                    money * result.rates["JPY"],
                    Colors.orange,
                    100,
                  ),
                ],
              ),
            );
          }
          //กรณีอยู่ระหว่างดึงข้อมูลให้แสดง progress bar
          return LinearProgressIndicator();
        },
      ),
    );
  }
}
