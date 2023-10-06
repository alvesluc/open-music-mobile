import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.setSelectedCategory,
  });

  final List<String> categories;
  final int selectedCategory;
  final void Function(int) setSelectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Gênero Musical',
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final buttonText = Text(categories[i]);

              if (i == 0) {
                return Row(
                  children: [
                    const SizedBox(width: 20),
                    selectedCategory == i
                        ? FilledButton(
                            onPressed: () => setSelectedCategory(i),
                            child: buttonText,
                          )
                        : OutlinedButton(
                            onPressed: () => setSelectedCategory(i),
                            child: buttonText,
                          ),
                  ],
                );
              }
              if (i == categories.length - 1) {
                return Row(
                  children: [
                    selectedCategory == i
                        ? FilledButton(
                            onPressed: () => setSelectedCategory(i),
                            child: buttonText,
                          )
                        : OutlinedButton(
                            onPressed: () => setSelectedCategory(i),
                            child: buttonText,
                          ),
                    const SizedBox(width: 20),
                  ],
                );
              }
              return selectedCategory == i
                  ? FilledButton(
                      onPressed: () => setSelectedCategory(i),
                      child: buttonText,
                    )
                  : OutlinedButton(
                      onPressed: () => setSelectedCategory(i),
                      child: buttonText,
                    );
            },
            separatorBuilder: (_, __) {
              return const SizedBox(width: 8);
            },
          ),
        ),
      ],
    );
  }
}
