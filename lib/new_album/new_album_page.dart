import 'package:flutter/material.dart';
import 'package:open_music/home/home_controller.dart';
import 'package:open_music/new_album/new_album_controller.dart';
import 'package:open_music/shared/form_validators.dart';
import 'package:open_music/shared/widgets/custom_form_field.dart';
import 'package:provider/provider.dart';

class NewAlbumPage extends StatefulWidget {
  const NewAlbumPage({super.key, required this.categories});

  final List<String> categories;

  @override
  State<NewAlbumPage> createState() => _NewAlbumPageState();
}

class _NewAlbumPageState extends State<NewAlbumPage> {
  late final NewAlbumController controller;
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
    controller = NewAlbumController(
      categories: widget.categories,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Novo álbum")),
      body: Form(
        key: formKey,
        autovalidateMode: formValidationMode,
        child: ListView(
          children: [
            Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: controller.img,
                  builder: (_, img, __) {
                    return Image.network(
                      img,
                      height: 240,
                      width: double.maxFinite,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          height: 240,
                          color: theme.disabledColor,
                          width: double.maxFinite,
                          child: const Center(
                            child: Text(
                              "A imagem carregará com uma URL válida.",
                            ),
                          ),
                        );
                      },
                    );
                  },
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
                ValueListenableBuilder(
                  valueListenable: controller.title,
                  builder: (_, title, __) {
                    return ValueListenableBuilder(
                      valueListenable: controller.year,
                      builder: (_, year, __) {
                        return Positioned(
                          bottom: 8,
                          left: 20,
                          child: Text(
                            "$title - ${year == 0 ? "" : year}",
                            style: theme.textTheme.headlineSmall,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                label: "URL da imagem",
                onChanged: controller.setImg,
                validator: controller.validateValidImgURL,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                label: "Banda",
                onChanged: controller.setBand,
                validator: FormValidators.validateNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
                label: "Título",
                onChanged: controller.setTitle,
                validator: FormValidators.validateNotEmpty,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomFormField(
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
                            "Selecione um gênero",
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
                valueListenable: controller.createState,
                builder: (_, createState, __) {
                  return FilledButton(
                    onPressed: createState == CreateState.loading
                        ? null
                        : handleUpdateAlbum,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Center(
                        child: createState == CreateState.loading
                            ? LinearProgressIndicator(
                                backgroundColor: theme.hintColor,
                              )
                            : const Text("Adicionar álbum"),
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

  Future<void> handleUpdateAlbum() async {
    toggleFormValidationModeOnUserInteraction();
    if (!formKey.currentState!.validate()) return;

    await controller.createAlbum();

    if (!mounted) return;

    if (controller.createState.value == CreateState.failure) {
      showErrorMessageOnSnackBar(
        message: 'Erro ao criar álbum.',
      );
      return;
    }

    if (controller.createState.value == CreateState.success) {
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
