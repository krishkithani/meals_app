import 'package:flutter/material.dart';
import 'package:meals_app/Provider/favourite_meals_provider.dart';
import 'package:meals_app/Screens/categories_1st.dart';
import 'package:meals_app/Screens/filters_screen.dart';
import 'package:meals_app/Screens/meals.dart';
import 'package:meals_app/Provider/filters_provider.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabsScreen> {
  int selectedPageIndex = 0;


  void selectPage(index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void setScreen(String identifier) async {
   //Navigator.pop(context);
    if (identifier == 'filters') {
       await Navigator.push<Map<Filter,bool>>(
        context,
        MaterialPageRoute(builder: (ctx) => const FilterScreen()),
      );
    }else{
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (selectedPageIndex == 1) {
      final favouriteMeals = ref.read(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favouriteMeals,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
          onSelectScreen: setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), label: ' Your Favourites')
        ],
      ),
    );
  }
}
