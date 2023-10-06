import 'package:flutter/material.dart';
import 'package:open_music/home/home_controller.dart';
import 'package:open_music/home/widgets/albums_list.dart';
import 'package:open_music/home/widgets/categories_list.dart';
import 'package:open_music/home/widgets/price_slider.dart';
import 'package:open_music/new_album/new_album_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();

    controller.getCategories();
    controller.getAlbums();
    controller.checkEnableFavoriteFeatureFlag();

    return Scaffold(
      appBar: AppBar(title: const Text("Open Music")),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: controller.categoriesState,
            builder: (_, categoriesState, __) {
              if (categoriesState == CategoriesState.loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (categoriesState == CategoriesState.error) {
                return const Center(child: Text('Erro ao carregar categorias'));
              }

              if (categoriesState == CategoriesState.success) {
                if (controller.categories.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma categoria disponível'),
                  );
                }

                return ValueListenableBuilder(
                  valueListenable: controller.selectedCategory,
                  builder: (_, selectedCategory, __) {
                    return CategoriesList(
                      categories: controller.categories,
                      selectedCategory: selectedCategory,
                      setSelectedCategory: controller.setSelectedCategory,
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          ),
          const SizedBox(height: 24),
          PriceSlider(
            sliderValue: controller.sliderValue,
            onChanged: controller.setSliderValue,
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: controller.albumsState,
            builder: (_, albumsState, __) {
              if (albumsState == AlbumsState.loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (albumsState == AlbumsState.error) {
                return const Center(child: Text('Erro ao carregar albums'));
              }

              if (albumsState == AlbumsState.success) {
                if (controller.albums.isEmpty) {
                  return const Center(
                    child: Text('Nenhum album foi encontrado'),
                  );
                }

                return Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: controller.filteredAlbums,
                    builder: (_, filteredAlbums, __) {
                      return AlbumsList(
                        albums:
                            controller.filteredAlbums.value.reversed.toList(),
                      );
                    },
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewAlbumPage(
                categories: controller.categories,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
