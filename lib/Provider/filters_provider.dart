import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/Provider/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void setFilters(Map<Filter , bool> chosenFilters){
    state=chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref){
  final meals = ref.watch(mealsProvider);
  final availableFilters=ref.watch(filtersProvider);
  return meals.where((meal){
    if(availableFilters[Filter.glutenFree]! && !meal.isGlutenFree){
      return false;
    }
    if(availableFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
      return false;
    }
    if(availableFilters[Filter.vegetarian]! && !meal.isVegetarian){
      return false;
    }
    if(availableFilters[Filter.vegan]! && !meal.isVegan){
      return false;
    }
    return true;
  }).toList();

});

