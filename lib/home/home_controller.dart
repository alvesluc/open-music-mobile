import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_music/home/models/album_model.dart';
import 'package:open_music/utils/constants.dart';

enum CategoriesState { initial, loading, success, error }

enum AlbumsState { initial, loading, success, error }

enum ToggleFavoriteState { initial, loading, success, error }

class HomeController {
  final categoriesState = ValueNotifier(CategoriesState.initial);
  List<String> categories = [];

  void setCategoriesState(CategoriesState state) {
    categoriesState.value = state;
  }

  final selectedCategory = ValueNotifier(0);

  void setSelectedCategory(int categoryIndex) {
    selectedCategory.value = categoryIndex;
    filterAlbums();
  }

  Future<void> getCategories() async {
    categories.clear();
    try {
      setCategoriesState(CategoriesState.loading);

      final url = Uri.parse('$baseURL/categories');
      final response = await http.get(url);

      final jsonList = jsonDecode(response.body) as List;
      categories = jsonList.map((e) => e as String).toList();

      return setCategoriesState(CategoriesState.success);
    } catch (e) {
      return setCategoriesState(CategoriesState.error);
    }
  }

  final sliderValue = ValueNotifier(100.0);

  void setSliderValue(double inputValue) {
    sliderValue.value = inputValue;
    filterAlbums();
  }

  final albumsState = ValueNotifier(AlbumsState.initial);
  List<Album> albums = [];
  final filteredAlbums = ValueNotifier<List<Album>>([]);

  void setAlbumsState(AlbumsState state) {
    albumsState.value = state;
  }

  Future<void> getAlbums() async {
    albums.clear();
    try {
      setAlbumsState(AlbumsState.loading);

      final url = Uri.parse('$baseURL/products');
      final response = await http.get(url);

      final jsonList = jsonDecode(response.body) as List;
      albums = jsonList.map((e) => Album.fromMap(e)).toList();
      filteredAlbums.value = albums;
      filterAlbums();

      setAlbumsState(AlbumsState.success);
    } catch (e) {
      setAlbumsState(AlbumsState.error);
    }
  }

  void filterAlbums() {
    if (selectedCategory.value == 0) {
      filteredAlbums.value =
          albums.where((e) => e.price <= sliderValue.value).toList();
    } else {
      filteredAlbums.value = albums.where((e) {
        return e.price <= sliderValue.value &&
            e.category == selectedCategory.value;
      }).toList();
    }
  }

  final isFavoriteEnabled = ValueNotifier(false);
  void setIsFavoriteEnabled(bool value) {
    isFavoriteEnabled.value = value;
  }

  Future<void> checkEnableFavoriteFeatureFlag() async {
    try {
      final url = Uri.parse('$baseURL/enable-favorites');
      final response = await http.get(url);

      if (response.body == "true") setIsFavoriteEnabled(true);
    } catch (_) {}
  }

  final toggleFavoriteState = ValueNotifier(ToggleFavoriteState.initial);
  void setToggleFavoriteState(ToggleFavoriteState state) {
    toggleFavoriteState.value = state;
  }

  Future<void> toggleFavorite(int id) async {
    try {
      setToggleFavoriteState(ToggleFavoriteState.loading);

      final url = Uri.parse('$baseURL/products/toggle-favorite/$id');
      final response = await http.put(url);

      if (response.statusCode != 200) {
        return setToggleFavoriteState(ToggleFavoriteState.error);
      }

      return setToggleFavoriteState(ToggleFavoriteState.success);
    } catch (e) {
      return setToggleFavoriteState(ToggleFavoriteState.error);
    }
  }
}
