import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_music/home/models/album_model.dart';
import 'package:open_music/utils/constants.dart';

enum DeleteState { initial, loading, success, failure }

enum UpdateState { initial, loading, success, failure }

class AlbumDetailsController {
  final Album album;
  final List<String> categories;
  late String title;
  late int category;
  late double price;
  late String img;
  late String band;
  late int year;

  AlbumDetailsController({required this.album, required this.categories}) {
    title = album.title;
    category = album.category;
    price = album.price;
    img = album.img;
    band = album.band;
    year = album.year;
  }

  final updateState = ValueNotifier(UpdateState.initial);

  void setUpdateState(UpdateState state) => updateState.value = state;

  void setImg(String text) => img = text;

  void setBand(String text) => band = text;

  void setTitle(String text) => title = text;

  void setYear(String text) => year = int.tryParse(text) ?? 0;

  void setCategory(String? text) {
    if (text == null) return;

    category = categories.indexWhere((e) => e == text);
  }

  void setPrice(String text) => price = double.tryParse(text) ?? 0;

  String? validateValidImgURL(String? _) {
    String urlPattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    final urlRegex = RegExp(urlPattern);

    if (img.isEmpty || !urlRegex.hasMatch(img)) {
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
    if (year == 0) {
      return "O ano é inválido.";
    }
    return null;
  }

  Future<void> updateAlbum() async {
    try {
      setUpdateState(UpdateState.loading);

      final url = Uri.parse('$baseURL/products/${album.id}');
      final response = await http.put(
        url,
        headers: {"content-type": "application/json"},
        body: jsonEncode(updatedAlbumMap),
      );

      if (response.statusCode != 200) {
        return setUpdateState(UpdateState.failure);
      }

      return setUpdateState(UpdateState.success);
    } catch (e) {
      return setUpdateState(UpdateState.failure);
    }
  }

  Map<String, dynamic> get updatedAlbumMap {
    return {
      "title": title,
      "category": category,
      "price": price,
      "img": img,
      "band": band,
      "year": year
    };
  }

  final deleteState = ValueNotifier(DeleteState.initial);

  void setDeleteState(DeleteState state) => deleteState.value = state;

  Future<void> deleteAlbum() async {
    try {
      setDeleteState(DeleteState.loading);

      final url = Uri.parse('$baseURL/products/${album.id}');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        return setDeleteState(DeleteState.failure);
      }

      return setDeleteState(DeleteState.success);
    } catch (e) {
      return setDeleteState(DeleteState.failure);
    }
  }
}
