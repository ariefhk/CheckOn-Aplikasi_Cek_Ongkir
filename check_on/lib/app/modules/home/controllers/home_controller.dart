import 'dart:convert';

import 'package:check_on/app/modules/home/kurir_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var hiddenCityAsal = true.obs;
  var idProvinceAsal = 0.obs;
  var hiddenCityTujuan = true.obs;
  var idProvinceTujuan = 0.obs;
  var hiddenButton = true.obs;
  var kurir = "".obs;

  double berat = 0.0;
  String satuan = 'gram';
  late TextEditingController beratC;

  void ongkosKirim() async {
    Uri url = Uri.parse('https://api.rajaongkir.com/starter/cost');
    try {
      final response = await http.post(url, body: {
        "origin": "${idProvinceAsal}",
        "destination": "${idProvinceTujuan}",
        "weight": '${berat}',
        "courier": "${kurir}"
      }, headers: {
        "key": "a816b9445f295b6395bf332765cae63a",
        "content-type": "application/x-www-form-urlencoded"
      });

      var data = json.decode(response.body);
      var result = data['rajaongkir']['results'];
      var listAllKurir = Kurir.fromJsonList(result);
      print(response.body);
      // print(result);
      var kurirr = listAllKurir[0];
      print(result);
      // Get.defaultDialog(
      //     title: kurirr.name!,
      //     content: Column(
      //       children: [
      //         Container(
      //           height: 200,
      //           width: 200,
      //           child: ListView.builder(
      //               itemCount: kurirr.costs!.length,
      //               itemBuilder: (BuildContext context, int index) {
      //                 return ListTile(
      //                   title: Text('${kurirr.costs![0].service}'),
      //                   subtitle: Text('Rp. ${kurirr.costs![0].cost![0].value}'),
      //                   trailing: Text(kurirr.code == 'pos'
      //                       ? '${kurirr.costs![0].cost![0].etd}'
      //                       : '${kurirr.costs![0].cost![0].etd} hari'),
      //                 );
      //               }),
      //         ),
      //       ],
      //       // children: kurirr.costs!.map((e) => ListTile(
      //       //   title: Text('${e.service}'),
      //       //   subtitle: Text('Rp. ${e.cost![0].value}'),
      //       //   trailing: Text(kurirr.code == 'pos' ? '${e.cost![0].etd}' : '${e.cost![0].etd} hari'),
      //       // ))
      //     ));
    } catch (e) {
      print(e);
    }
  }

  void showButton() {
    if (idProvinceAsal != 0 &&
        idProvinceTujuan != 0 &&
        berat > 0 &&
        kurir != "") {
      hiddenButton.value = false;
    } else {
      hiddenButton.value = true;
    }
  }

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    String cekSatuan = satuan;
    switch (cekSatuan) {
      case 'ton':
        berat *= 1000000;
        break;
      case 'kwintal':
        berat *= 100000;
        break;
      case 'ons':
        berat *= 100;
        break;
      case 'lbs':
        berat *= 2204.62;
        break;
      case 'pound':
        berat *= 2204.62;
        break;
      case 'kg':
        berat *= 1000;
        break;
      case 'hg':
        berat *= 100;
        break;
      case 'dag':
        berat *= 10;
        break;
      case 'gram':
        berat = berat;
        break;
      case 'dg':
        berat /= 10;
        break;
      case 'cg':
        berat /= 100;
        break;
      case 'mg':
        berat /= 1000;
        break;
      default:
        berat = berat;
    }
    print('${berat} gram');
    showButton();
  }

  void ubahSatuan(Value) {
    berat = double.tryParse(beratC.text) ?? 0.0;
    switch (Value) {
      case 'ton':
        berat *= 1000000;
        break;
      case 'kwintal':
        berat *= 100000;
        break;
      case 'ons':
        berat *= 100;
        break;
      case 'lbs':
        berat *= 2204.62;
        break;
      case 'pound':
        berat *= 2204.62;
        break;
      case 'kg':
        berat *= 1000;
        break;
      case 'hg':
        berat *= 100;
        break;
      case 'dag':
        berat *= 10;
        break;
      case 'gram':
        berat = berat;
        break;
      case 'dg':
        berat /= 10;
        break;
      case 'cg':
        berat /= 100;
        break;
      case 'mg':
        berat /= 1000;
        break;
      default:
        berat = berat;
    }
    satuan = Value;
    print('${berat} gram');
    showButton();
  }

  @override
  void onInit() {
    beratC = TextEditingController(text: '${berat}');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    beratC.dispose();
    super.onClose();
  }

  // void increment() => count.value++;
}
