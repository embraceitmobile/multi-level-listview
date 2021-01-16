import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/node/node.dart';

abstract class TreeChangeNotifier<T> {
  final StreamController<NodeEvent<T>> _addedItemsController =
      StreamController<NodeEvent<T>>.broadcast();

  final StreamController<NodeEvent<T>> _insertedItemsController =
      StreamController<NodeEvent<T>>.broadcast();

  final StreamController<NodeEvent<T>> _removedItemsController =
      StreamController<NodeEvent<T>>.broadcast();

  @protected
  void emitAddItems(Iterable<Node<T>> iterable, {String path}) {
    _addedItemsController.sink.add(NodeEvent(iterable, path: path));
  }

  @protected
  void emitInsertItems(Iterable<Node<T>> iterable, int index, {String path}) {
    _insertedItemsController.sink
        .add(NodeEvent(iterable, index: index, path: path));
  }

  @protected
  void emitRemoveItems(Iterable<Node<T>> iterable, {String path}) {
    _removedItemsController.sink.add(NodeEvent(iterable, path: path));
  }

  Stream<NodeEvent<T>> get addedItems => _addedItemsController.stream;

  Stream<NodeEvent<T>> get insertedItems => _insertedItemsController.stream;

  Stream<NodeEvent<T>> get removedItems => _removedItemsController.stream;

  void dispose() {
    _addedItemsController.close();
    _insertedItemsController.close();
    _removedItemsController.close();
  }
}

class NodeEvent<T> {
  final Iterable<Node<T>> items;
  final int index;
  final String path;

  const NodeEvent(this.items, {this.index, this.path});
}
