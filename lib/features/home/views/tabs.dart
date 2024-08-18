import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prideofknowledge/constants/colors.dart';
import 'package:prideofknowledge/constants/image_strings.dart';
import 'package:prideofknowledge/constants/navigation_consts.dart';
import 'package:prideofknowledge/data/cloud/cloud_constants.dart';
import 'package:prideofknowledge/data/models/category.dart';
import 'package:prideofknowledge/data/models/creator.dart';
import 'package:prideofknowledge/features/home/services/providers/all_courses_provider.dart';
import 'package:prideofknowledge/features/home/services/providers/data_provider.dart';
import 'package:prideofknowledge/features/home/services/providers/data_state.dart';
import 'package:prideofknowledge/features/home/views/categories_view.dart';
import 'package:prideofknowledge/features/home/views/courses_view.dart';
import 'package:prideofknowledge/features/home/views/favorites_view.dart';
import 'package:prideofknowledge/features/home/views/home_view.dart';
import 'package:prideofknowledge/features/home/services/providers/nav_provider.dart';
import 'package:prideofknowledge/features/home/views/profile_view.dart';
import 'package:prideofknowledge/features/home/views/widgets/bottom_nav_bar.dart';
import 'package:prideofknowledge/utilities/dialogs/show_error_dialog.dart';
import 'package:prideofknowledge/utilities/helper/loading/loading.dart';

class TabsView extends ConsumerWidget {
  const TabsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Firestore data retrieval
    final data = ref.watch(dataProvider);
    final List<Category> categories = data[categoriesCollection];
    final List<Creator> creators = data[creatorsCollection];
    final courses = ref.watch(allCoursesProvider);

    //Data State provider
    final dataState = ref.watch(dataStateProvider);

    // Navigation providers
    final navIndex = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    if (dataState.isLoading) {
      LoadingScreen().show(context: context, text: 'Loading...');
    } else {
      LoadingScreen().hide();
    }

    if (dataState.isFailed) {
      showErrorDialog(context, 'Unable to retreive data');
    }

    Widget activeScreen = HomeView(
      creators: creators,
      courses: courses,
      categories: categories,
    );
    //TODO Say Welcome UserName
    String activeScreenTitle = 'Welcome Bob';
    Widget? leading;
    Widget? bottomNavigationBar =
        ABottomNavigationBar(index: navNotifier.navState);

    List<Widget>? actions = [
      IconButton(
        iconSize: 25,
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart_outlined),
      ),
      IconButton(
        iconSize: 20,
        onPressed: () {},
        icon: const Icon(Icons.account_balance_wallet_outlined),
      ),
      InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          ref
              .read(navigationProvider.notifier)
              .setPageScreen(ANavigationIndex.profileViewIndex);
        },
        child: const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(AImages.profileImage),
          foregroundColor: AColors.black,
        ),
      ),
    ];

    if (navIndex != ANavigationIndex.homeViewIndex) {
      switch (navIndex) {
        case ANavigationIndex.courseViewIndex:
          activeScreen = const CoursesView();
          activeScreenTitle = 'My Courses';
          bottomNavigationBar = ABottomNavigationBar(index: navIndex);
          break;
        case ANavigationIndex.categoriesViewIndex:
          activeScreen = CategoriesView(
            categories: categories,
          );
          activeScreenTitle = 'Categories';
          bottomNavigationBar = ABottomNavigationBar(index: navIndex);
          break;
        case ANavigationIndex.favoritesViewIndex:
          activeScreen = const FavoritesView();
          activeScreenTitle = 'Favorites';
          bottomNavigationBar = ABottomNavigationBar(index: navIndex);
          break;
        case ANavigationIndex.profileViewIndex:
          activeScreen = const ProfileView();
          activeScreenTitle = 'Profile Settings';
          bottomNavigationBar = null;
          actions = null;
          leading = IconButton(
            onPressed: () {
              ref
                  .read(navigationProvider.notifier)
                  .setNavScreen(navNotifier.navState);
            },
            icon: const Icon(Icons.keyboard_arrow_left),
          );

        default:
          const CircularProgressIndicator();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AColors.white,
        title: Text(activeScreenTitle),
        actions: actions,
        leading: leading,
      ),
      body: activeScreen,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
