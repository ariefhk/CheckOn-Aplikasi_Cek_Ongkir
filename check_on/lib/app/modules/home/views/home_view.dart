import 'dart:convert';
import 'package:check_on/app/modules/home/city_model.dart';
import 'package:check_on/app/modules/home/province_model.dart';
import 'package:check_on/app/modules/home/views/weight.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'province.dart';
import 'city.dart';
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
            Provinsi(
              type: 'asal',
            ),
            Obx(() => controller.hiddenCityAsal.isTrue
                ? SizedBox()
                : Kota(
                    type: 'asal',
                    idProvince: controller.idProvinceAsal.value,
                  )),
            Provinsi(
              type: 'tujuan',
            ),
            Obx(() => controller.hiddenCityTujuan.isTrue
                ? SizedBox()
                : Kota(
                    type: 'asal',
                    idProvince: controller.idProvinceTujuan.value,
                  )),
            Berat(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: DropdownSearch<Map<String, dynamic>>(
                popupProps: PopupProps.menu(
                  // showSelectedItems: true,
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        '${item['name']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
                clearButtonProps: ClearButtonProps(isVisible: true),
                items: [
                  {'code': 'jne', 'name': 'Jalur Nugraha Ekakurir (JNE)'},
                  {'code': 'tiki', 'name': 'Titipan Kilat (TIKI)'},
                  {'code': 'pos', 'name': 'Perusahaan Opsional Surat (POS)'},
                ],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Tipe Kuris",
                    hintText: "Pilih tipe kurirr..",
                  ),
                ),
                onChanged: (Value) {
                  if (Value != null) {
                    if (controller.idProvinceAsal != 0 &&
                        controller.idProvinceTujuan != 0 &&
                        controller.berat > 0) {
                      controller.hiddenButton.value = false;
                    } else {
                      controller.hiddenButton.value = true;
                    }
                    controller.kurir.value = Value['code'];
                  } else {
                    controller.hiddenButton.value = true;
                  }
                },
                itemAsString: (Value) => Value['name'],
              ),
            ),
            Obx(
              () => controller.hiddenButton.isTrue
                  ? SizedBox()
                  : ElevatedButton(
                      onPressed: () {
                        controller.ongkosKirim();
                      },
                      child: Text('CEK ONGKOS KIRIM'),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          primary: Colors.red[900]),
                    ),
            )
          ],
        ));
  }
}
