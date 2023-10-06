import 'package:flutter/material.dart';
import 'package:open_music/album_details/album_details_page.dart';
import 'package:open_music/home/home_controller.dart';
import 'package:open_music/home/models/album_model.dart';
import 'package:provider/provider.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeController = context.read<HomeController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: "album_image${album.id}",
                child: Image.network(
                  album.img,
                  height: 120,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 120,
                      color: theme.disabledColor,
                      width: double.maxFinite,
                      child: const Center(
                        child: Text("Não foi possível carregar a imagem."),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: FloatingActionButton(
                  heroTag: "edit_fab${album.id}",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AlbumDetailsPage(
                          album: album,
                          categories: context.read<HomeController>().categories,
                        ),
                      ),
                    );
                  },
                  elevation: 0,
                  backgroundColor:
                      theme.floatingActionButtonTheme.backgroundColor,
                  mini: true,
                  child: const Icon(Icons.edit),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: homeController.isFavoriteEnabled,
                builder: (_, isFavoriteEnabled, __) {
                  return Visibility(
                    visible: isFavoriteEnabled,
                    child: Positioned(
                      top: 4,
                      left: 4,
                      child: FloatingActionButton(
                        heroTag: "favorite_fab${album.id}",
                        onPressed: () => homeController
                            .toggleFavorite(album.id)
                            .then((_) => homeController.getAlbums()),
                        elevation: 0,
                        backgroundColor:
                            theme.floatingActionButtonTheme.backgroundColor,
                        mini: true,
                        child: Icon(
                          album.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).hoverColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${album.band} - ${album.year}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  album.title,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${album.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const SizedBox(
                    width: double.maxFinite,
                    child: Center(child: Text('Comprar')),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
