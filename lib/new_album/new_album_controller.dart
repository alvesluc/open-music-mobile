import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_music/utils/constants.dart';

enum CreateState { initial, loading, success, failure }

class NewAlbumController {
  final List<String> categories;
  final title = ValueNotifier("");
  final img = ValueNotifier("");
  final year = ValueNotifier(0);
  int category = 0;
  double price = 0;
  String band = "";

  NewAlbumController({required this.categories});

  final createState = ValueNotifier(CreateState.initial);

  void setCreateState(CreateState state) => createState.value = state;

  void setImg(String text) => img.value = text;

  void setBand(String text) => band = text;

  void setTitle(String text) => title.value = text;

  void setYear(String text) => year.value = int.tryParse(text) ?? 0;

  void setCategory(String? text) {
    if (text == null) return;

    category = categories.indexWhere((e) => e == text);
  }

  void setPrice(String text) => price = double.tryParse(text) ?? 0;

  String? validateValidImgURL(String? _) {
    String urlPattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    final urlRegex = RegExp(urlPattern);

    if (img.value.isEmpty || !urlRegex.hasMatch(img.value)) {
      return "A URL da imagem é inválida.";
    }
    return null;
  }

  String? validatePrice(String? _) {
    if (price > 100.0) {
      return 'O preço tem que ser entre R\$ 0.00 e R\$ 100.00';
    }
    return null;
  }

  String? validateYear(String? _) {
    if (year.value == 0) {
      return "O ano é inválido.";
    }
    return null;
  }

  Future<void> createAlbum() async {
    try {
      setCreateState(CreateState.loading);

      final url = Uri.parse('$baseURL/products');

      final response = await http.post(
        url,
        headers: {"content-type": "application/json"},
        body: jsonEncode(newAlbumMap),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        return setCreateState(CreateState.failure);
      }

      return setCreateState(CreateState.success);
    } catch (e) {
      return setCreateState(CreateState.failure);
    }
  }

  Map<String, dynamic> get newAlbumMap {
    return {
      "title": title.value,
      "category": category,
      "price": price,
      "img": img.value,
      "band": band,
      "year": year.value
    };
  }
}
