import 'package:flutter/material.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';

extension NodeMap<T extends _MapNode<T>> on Map<String, _MapNode<T>> {
  MapNode<T> at(String key) => this[key].populateChildrenPath();
}

mixin MapNode<T extends _MapNode<T>> implements _MapNode<T>, TreeNode {
  Map<String, MapNode<T>> get children;

  /// [key] should be unique, if you are overriding it then make sure that it has a unique value
  final String key = UniqueKey().toString();

  String path = "";

  bool isExpanded = false;

  bool get hasChildren => children.isNotEmpty;

  int get level => TreeNode.PATH_SEPARATOR.allMatches(path).length - 1;

  String get childrenPath => "$path${TreeNode.PATH_SEPARATOR}$key";

  MapNode<T> getNodeAt(String path) {
    assert(key != TreeNode.ROOT_KEY ? !path.contains(TreeNode.ROOT_KEY) : true,
        "Path with ROOT_KEY = ${TreeNode.ROOT_KEY} can only be called from the root node");

    final nodes = MapNode.normalizePath(path).split(TreeNode.PATH_SEPARATOR);

    var currentNode = this;
    for (final node in nodes) {
      if (node.isEmpty) {
        return currentNode;
      } else {
        currentNode = currentNode.children[key];
      }
    }
    return currentNode;
  }

  MapNode<T> populateChildrenPath({bool refresh = false}) {
    if (children.isEmpty) return this;
    if (!refresh && children.values.first.path.isNotEmpty) return this;
    for (final child in children.values) {
      child.path = this.childrenPath;
    }
    return this;
  }

  static String normalizePath(String path) {
    if (path?.isEmpty ?? true) return "";
    var _path = path
        .toString()
        .replaceAll("${TreeNode.PATH_SEPARATOR}${TreeNode.ROOT_KEY}", "")
        .replaceAll(TreeNode.ROOT_KEY, "");

    if (_path.startsWith(TreeNode.PATH_SEPARATOR)) _path = _path.substring(1);
    return _path;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MapNode && key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() {
    return 'Node {key: $key}, path: $path, child_count: ${children.length}';
  }
}

mixin _MapNode<T> implements TreeNode {
  String get key;

  String path;

  Map<String, _MapNode<T>> get children;

  _MapNode<T> populateChildrenPath({bool refresh});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MapNode && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
