import 'dart:convert';

import 'package:check_on/app/modules/home/city_model.dart';
import 'package:check_on/app/modules/home/province_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CheckOn-Apps'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Provinsi(),
            Obx(() => controller.hiddenCity.isTrue
                ? SizedBox()
                : Kota(
                    idProvince: controller.idProvince.value,
                  ))
          ],
        ));
  }
}

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          DropdownSearch<Province>(
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Provinsi',
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
                controller.hiddenCity.value = true;
                controller.idProvince.value = 0;
              } else if (Value != null) {
                controller.hiddenCity.value = false;
                controller.idProvince.value = int.parse(Value.provinceId!);
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

class Kota extends StatelessWidget {
  const Kota({Key? key, required this.idProvince}) : super(key: key);

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
                labelText: 'Kabupaten/Kota',
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
                print('Tidak Memilih Kota / Kabupaten');
              } else if (Value != null) {
                print(Value.cityName);
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
