import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/node/node.dart';

abstract class TreeUpdateNotifier<T> {
  Stream<NodeAddEvent<T>> get addedNodes;

  Stream<NodeInsertEvent<T>> get insertedNodes;

  Stream<NodeRemoveEvent> get removedNodes;

  void dispose();
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
