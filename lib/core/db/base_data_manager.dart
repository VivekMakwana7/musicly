import 'package:hive_ce/hive.dart';
import 'package:musicly/core/logger.dart';

/// Abstract class [BaseDataManager] provides an interface for interacting with a [Hive] box.
///
/// It offers methods to retrieve, store, and watch for changes in data stored in the box.
/// Subclasses of [BaseDataManager] can implement specific data management logic for different types of data
/// while reusing the basic functionality provided by this class.
abstract class BaseDataManager {
  /// Constructs a [BaseDataManager] with a [Hive] box.
  BaseDataManager(this._box);
  final Box<dynamic> _box;

  /// Retrieves a value from the box associated with the given [key].
  ///
  /// If the key does not exist, returns [defaultValue] if provided, otherwise throws an exception.
  ///
  /// [key] is the key to retrieve the value for.
  /// [defaultValue] (optional) is the default value to return if the key is not found.
  /// Returns the value associated with the key, or the default value.
  /// Throws an [Exception] if an error occurs during retrieval.
  T getValue<T>(String key, {T? defaultValue}) {
    try {
      return _box.get(key, defaultValue: defaultValue) as T;
    } catch (e) {
      'Error in getValue $e'.logE;
      throw Exception('Error in getValue: $e');
    }
  }

  /// Stores a value in the box with the given [key].
  ///
  /// [key] is the key to store the value under.
  /// [value] is the value to be stored.
  /// Returns a [Future] that completes when the value is successfully stored.
  /// Throws an [Exception] if an error occurs during storage.
  Future<void> setValue<T>(String key, T value) async {
    try {
      await _box.put(key, value);
    } catch (e) {
      'Error in setValue $e'.logE;
      throw Exception('Error in setValue: $e');
    }
  }

  /// Returns a stream that emits events whenever the value associated with the given [key] changes in the box.
  ///
  /// [key] is the key to watch for changes.
  /// Returns a [Stream] of [BoxEvent] objects.
  Stream<BoxEvent> getStream(String key) {
    try {
      return _box.watch(key: key).asBroadcastStream();
    } catch (e) {
      'Error in getStream $e'.logE;
      throw Exception('Error in getStream $e');
    }
  }
}
