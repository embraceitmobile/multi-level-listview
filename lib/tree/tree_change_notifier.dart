import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/node/node.dart';

abstract class TreeChangeNotifier<T> extends ChangeNotifier {
  // final StreamController<NodeAddEvent<T>> _addedItemsController =
  //     StreamController<NodeAddEvent<T>>.broadcast();
  //
  // final StreamController<NodeInsertEvent<T>> _insertedItemsController =
  //     StreamController<NodeInsertEvent<T>>.broadcast();
  //
  // final StreamController<NodeRemoveEvent> _removedItemsController =
  //     StreamController<NodeRemoveEvent>.broadcast();
  //
  // @protected
  // void emitAddItems(Iterable<Node<T>> iterable, {String path}) {
  //   _addedItemsController.sink.add(NodeAddEvent(iterable, path: path));
  // }
  //
  // @protected
  // void emitInsertItems(Iterable<Node<T>> iterable, int index, {String path}) {
  //   _insertedItemsController.sink
  //       .add(NodeInsertEvent(iterable, index, path: path));
  // }
  //
  // @protected
  // void emitRemoveItems(Iterable<String> keys, {String path}) {
  //   _removedItemsController.sink.add(NodeRemoveEvent(keys, path: path));
  // }
  //
  // Stream<NodeAddEvent<T>> get addedItems => _addedItemsController.stream;
  //
  // Stream<NodeInsertEvent<T>> get insertedItems =>
  //     _insertedItemsController.stream;
  //
  // Stream<NodeRemoveEvent> get removedItems => _removedItemsController.stream;

  NodeAddEvent<T> get addedNodes;

  NodeInsertEvent<T> get insertedNodes;

  NodeRemoveEvent get removedNodes;

// void dispose() {
//   _addedItemsController.close();
//   _insertedItemsController.close();
//   _removedItemsController.close();
// }
}

class NodeAddEvent<T> {
  final Iterable<Node<T>> items;
  final String path;

  const NodeAddEvent(this.items, {this.path});
}

class NodeRemoveEvent {
  final Iterable<String> keys;
  final String path;

  const NodeRemoveEvent(this.keys, {this.path});
}

class NodeInsertEvent<T> {
  final Iterable<Node<T>> items;
  final String path;
  final int index;

  const NodeInsertEvent(this.items, this.index, {this.path});
}
