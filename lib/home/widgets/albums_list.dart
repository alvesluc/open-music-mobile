import 'package:flutter/material.dart';
import 'package:open_music/home/home_controller.dart';
import 'package:open_music/home/models/album_model.dart';
import 'package:open_music/home/widgets/album_tile.dart';
import 'package:provider/provider.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({super.key, required this.albums});

  final List<Album> albums;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Álbuns Encontrados',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                '${albums.length} álbu${albums.length == 1 ? "m" : "ns"}',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: context.read<HomeController>().getAlbums,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: albums.length,
              itemBuilder: (_, i) {
                if (i == albums.length - 1) {
                  return Column(
                    children: [
                      AlbumTile(album: albums[i]),
                      const SizedBox(height: 40),
                    ],
                  );
                }
                return AlbumTile(album: albums[i]);
              },
              separatorBuilder: (_, __) {
                return const SizedBox(height: 20.0);
              },
            ),
          ),
        ),
      ],
    );
  }
}
