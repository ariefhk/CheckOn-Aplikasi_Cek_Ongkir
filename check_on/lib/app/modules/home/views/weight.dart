import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class Berat extends GetView<HomeController> {
  const Berat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.beratC,
            autocorrect: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Berat Barang',
                hintText: 'Berat Barang',
                border: OutlineInputBorder()),
            onChanged: (Value) => controller.ubahBerat(Value),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 150,
          // color: Colors.red,
          child: DropdownSearch<String>(
            popupProps: PopupProps.bottomSheet(
              showSelectedItems: true,
              showSearchBox: true
            ),
            items: ['ton', 'kwintal', 'ons', 'lbs','pound','kg','hg','dag','gram', 'dg','cg', 'mg'],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "cari satuan berat...",
              ),
            ),
            selectedItem: "gram",
            onChanged: (Value)=> controller.ubahSatuan(Value),
          ),
        )
      ],
    );
  }
}
