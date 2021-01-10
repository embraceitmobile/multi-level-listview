import 'dart:collection';

import 'package:flutter/material.dart';

class ListNode<T> with NodeViewData<T> implements Node<T> {
  final List<Node<T>> children;
  final String key;
  String path;

  @mustCallSuper
  ListNode()
      : children = <Node<T>>[],
        key = UniqueKey().toString();

  factory ListNode.fromMap(Map<String, MapNode<T>> map) {
    return ListNode();
  }

  UnmodifiableListView<Node<T>> toList() => children;
}

class MapNode<T> with NodeViewData<T> implements Node<T> {
  final Map<String, Node<T>> children;
  final String key;
  String path;

  @mustCallSuper
  MapNode()
      : children = <String, Node<T>>{},
        key = UniqueKey().toString();

  factory MapNode.fromList(List<Node<T>> list) {
    return MapNode();
  }

  UnmodifiableListView<Node<T>> toList() => children.values;
}

mixin NodeViewData<T> {
  bool isExpanded = false;

  String get key;

  String path;

  int get level => Node.PATH_SEPARATOR.allMatches(path).length - 1;

  String get childrenPath => "$path${Node.PATH_SEPARATOR}$key";

  UnmodifiableListView<Node<T>> toList();
}

abstract class Node<T> with NodeViewData<T> {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  String get key;

  Object get children;
}
