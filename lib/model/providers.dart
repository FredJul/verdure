import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';

import 'food.dart';
import 'food_repository.dart';

final scannedFoodsBoxProvider = FutureProvider.autoDispose<Box<Food>>((ref) async {
  final box = await _safeOpenBox<Food>('scanned_foods');

  ref.onDispose(() => box.close()); // this will close the box automatically when the provider is no longer used
  return box;
});

final favFoodsBoxProvider = FutureProvider.autoDispose<Box<Food>>((ref) async {
  final box = await _safeOpenBox<Food>('fav_foods');

  ref.onDispose(() => box.close()); // this will close the box automatically when the provider is no longer used
  return box;
});

final foodRepositoryProvider = FutureProvider.autoDispose<FoodRepository>((ref) async {
  final scannedFoodsBox = await ref.watch(scannedFoodsBoxProvider.future);
  final favFoodsBox = await ref.watch(favFoodsBoxProvider.future);

  return FoodRepository(scannedFoodsBox, favFoodsBox);
});

final scannedFoodsProvider = StreamProvider.autoDispose((ref) async* {
  final box = await ref.watch(scannedFoodsBoxProvider.future);

  yield* Stream.value(box.values);
  yield* box.watch().map((boxEvent) {
    return boxEvent.value == null ? List<Food>.empty() : boxEvent.value as Iterable<Food>;
  });
});

final favFoodsProvider = StreamProvider.autoDispose((ref) async* {
  final box = await ref.watch(favFoodsBoxProvider.future);

  yield* Stream.value(box.values);
  yield* box.watch().map((boxEvent) {
    return boxEvent.value == null ? List<Food>.empty() : boxEvent.value as Iterable<Food>;
  });
});

Future<Box<T>> _safeOpenBox<T>(String boxName) async {
  Box<T> box;
  try {
    box = await Hive.openBox(boxName);
  } catch (_) {
    // In case of migration issue, we simply erase everything :)
    await Hive.deleteBoxFromDisk(boxName);
    box = await Hive.openBox(boxName);
  }

  return box;
}
