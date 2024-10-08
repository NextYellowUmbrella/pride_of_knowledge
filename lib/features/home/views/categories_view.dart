import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prideofknowledge/constants/colors.dart';
import 'package:prideofknowledge/utilities/dialogs/show_error_dialog.dart';

import 'package:prideofknowledge/utilities/theme/widget_themes/text_theme.dart';

class CategoriesView extends StatelessWidget {
  final AsyncValue categories;

  const CategoriesView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return categories.when(
      data: (categories) {
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 2.7),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  Image.network(categories[index].image),
                  Text(
                    categories[index].name,
                    style: ATextTheme.mediumSubHeading
                        .copyWith(color: AColors.primary),
                  )
                ],
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        showErrorDialog(context, 'Error Retrieving Categories');
        return Container();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
