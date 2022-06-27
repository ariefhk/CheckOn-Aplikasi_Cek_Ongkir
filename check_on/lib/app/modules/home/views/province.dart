import 'dart:convert';

import 'package:check_on/app/modules/home/city_model.dart';
import 'package:check_on/app/modules/home/province_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/home_controller.dart';

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          DropdownSearch<Province>(
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: type == 'asal' ? 'Provinsi Asal' : 'Provinsi Tujuan',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                hintText: "Cari Provinsi",
              ),
            ),
            clearButtonProps: ClearButtonProps(isVisible: true),
            asyncItems: (String filter) async {
              Uri url =
                  Uri.parse('https://api.rajaongkir.com/starter/province');
              try {
                final response = await http.get(url,
                    headers: {"key": "a816b9445f295b6395bf332765cae63a"});
                var data = jsonDecode(response.body);
                var listAllProvince = data["rajaongkir"]["results"];
                var models = Province.fromJsonList(listAllProvince);
                return models;
              } catch (e) {
                print(e);
                return List<Province>.empty();
              }
            },
            onChanged: (Value) {
              if (Value == null) {
                if (type == 'asal') {
                  controller.hiddenCityAsal.value = true;
                  controller.idProvinceAsal.value = 0;
                } else {
                  controller.hiddenCityTujuan.value = true;
                  controller.idProvinceTujuan.value = 0;
                }
                controller.showButton();
              } else if (Value != null) {
                if (type == 'asal') {
                  controller.hiddenCityAsal.value = false;
                  controller.idProvinceAsal.value =
                      int.parse(Value.provinceId!);
                } else {
                  controller.hiddenCityTujuan.value = false;
                  controller.idProvinceTujuan.value =
                      int.parse(Value.provinceId!);
                }
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
                    '${item.province}',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
            itemAsString: (Province u) => u.province!,
          )
        ],
      ),
    );
  }
}
