import 'dart:convert';

import 'package:check_on/app/modules/home/city_model.dart';
import 'package:check_on/app/modules/home/province_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/home_controller.dart';

class Kota extends GetView<HomeController> {
  const Kota({Key? key, required this.type, required this.idProvince})
      : super(key: key);

  final String type;

  final int idProvince;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          DropdownSearch<City>(
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: type == 'asal'
                    ? 'Kabupaten/Kota Asal'
                    : 'Kabupaten/Kota Tujuan',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                hintText: "Cari Kota/Kabupaten",
              ),
            ),
            clearButtonProps: ClearButtonProps(isVisible: true),
            asyncItems: (String filter) async {
              Uri url = Uri.parse(
                  'https://api.rajaongkir.com/starter/city?province=${idProvince}');
              try {
                final response = await http.get(url,
                    headers: {"key": "a816b9445f295b6395bf332765cae63a"});
                var data = jsonDecode(response.body);
                var listAllProvince = data["rajaongkir"]["results"];
                var models = City.fromJsonList(listAllProvince);
                return models;
              } catch (e) {
                print(e);
                return List<City>.empty();
              }
            },
            onChanged: (Value) {
              if (Value == null) {
                if (type == 'asal') {
                  print('Tidak Memilih Kota / Kabupaten Asal');
                } else {
                  print('Tidak Memilih Kota / Kabupaten Tujuan');
                }
              } else if (Value != null) {
                print(Value.cityName);
                 controller.showButton();
              }
            },
            popupProps: PopupProps.dialog(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)))),
              itemBuilder: (context, item, isSelected) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '${item.type} ${item.cityName}',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
            itemAsString: (City u) => '${u.type!} ${u.cityName!}',
          )
        ],
      ),
    );
  }
}
