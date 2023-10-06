import 'package:flutter/material.dart';
import 'package:open_music/album_details/album_details_controller.dart';
import 'package:open_music/home/home_controller.dart';
import 'package:open_music/home/models/album_model.dart';
import 'package:open_music/shared/form_validators.dart';
import 'package:open_music/shared/widgets/custom_flight_shuttle_builder.dart';
import 'package:open_music/shared/widgets/custom_form_field.dart';
import 'package:provider/provider.dart';

class AlbumDetailsPage extends StatefulWidget {
  const AlbumDetailsPage({
    super.key,
    required this.album,
    required this.categories,
  });

  final Album album;
  final List<String> categories;

  @override
  State<AlbumDetailsPage> createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  late final AlbumDetailsController controller;
  final formKey = GlobalKey<FormState>();
  var formValidationMode = AutovalidateMode.disabled;

  void toggleFormValidationModeOnUserInteraction() {
    setState(() {
      formValidationMode = AutovalidateMode.onUserInteraction;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AlbumDetailsController(
      album: widget.album,
      categories: widget.categories,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.title),
        actions: [
          IconButton(
            onPressed: handleDeleteAlbum,
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      body: Form(
        key: formKey,
        autovalidateMode: formValidationMode,
        child: ListView(
          children: [
            Stack(
              children: [
                Hero(
                  tag: "album_image${widget.album.id}",
                  flightShuttleBuilder: customFlightShuttleBuilder,
                  child: Image.network(
                    widget.album.img,
                    height: 240,
                    width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 240,
                        color: theme.disabledColor,
                        width: double.maxFinite,
                        child: const Center(
                            child: Text("Não foi possível carregar a imagem.")),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    height: 48,
                    width: double.maxFinite,
                    color: theme.scaffoldBackgroundColor.withOpacity(.4),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 20,
                  child: Text(
                    "${widget.album.title} - ${widget.album.year}",
                    style: theme.textTheme.headlineSmall,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                initialValue: widget.album.img,
                label: "URL da imagem",
                onChanged: controller.setImg,
                validator: controller.validateValidImgURL,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                initialValue: widget.album.band,
                label: "Banda",
                onChanged: controller.setBand,
                validator: FormValidators.validateNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                initialValue: widget.album.title,
                label: "Título",
                onChanged: controller.setTitle,
                validator: FormValidators.validateNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                initialValue: "${widget.album.year}",
                label: "Ano",
                onChanged: controller.setYear,
                keyboardType: TextInputType.number,
                validator: controller.validateYear,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownButtonFormField(
                items: controller.categories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    enabled: value != "Todos",
                    child: value == "Todos"
                        ? Text(
                            value,
                            style: TextStyle(color: theme.disabledColor),
                          )
                        : Text(value),
                  );
                }).toList(),
                value: controller.categories[controller.category],
                onChanged: controller.setCategory,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                initialValue: widget.album.price.toStringAsFixed(2),
                label: "Preço",
                onChanged: controller.setPrice,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: controller.validatePrice,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ValueListenableBuilder(
                valueListenable: controller.updateState,
                builder: (_, updateState, __) {
                  return FilledButton(
                    onPressed: updateState == UpdateState.loading
                        ? null
                        : handleUpdateAlbum,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Center(
                        child: updateState == UpdateState.loading
                            ? LinearProgressIndicator(
                                backgroundColor: theme.hintColor,
                              )
                            : const Text("Confirmar edição"),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> handleDeleteAlbum() async {
    await controller.deleteAlbum();

    if (!mounted) return;

    if (controller.deleteState.value == DeleteState.failure) {
      showErrorMessageOnSnackBar(
        message: 'Erro ao atualizar informações do álbum.',
      );
      return;
    }

    if (controller.deleteState.value == DeleteState.success) {
      return reloadHome();
    }
  }

  Future<void> handleUpdateAlbum() async {
    toggleFormValidationModeOnUserInteraction();
    if (!formKey.currentState!.validate()) return;

    await controller.updateAlbum();

    if (!mounted) return;

    if (controller.updateState.value == UpdateState.failure) {
      showErrorMessageOnSnackBar(
        message: 'Erro ao atualizar informações do álbum.',
      );
      return;
    }

    if (controller.updateState.value == UpdateState.success) {
      return reloadHome();
    }
  }

  void showErrorMessageOnSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void reloadHome() {
    Navigator.pop(context);
    context.read<HomeController>().getAlbums();
  }
}
