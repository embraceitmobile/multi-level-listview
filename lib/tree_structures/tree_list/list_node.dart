import 'package:flutter/material.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';

extension NodeList<T extends TreeNode> on List<TreeNode> {
  ListNode<T> get firstNode => this.first.populateChildrenPath();

  ListNode<T> get lastNode => this.last.populateChildrenPath();

  ListNode<T> at(int index) => this[index].populateChildrenPath();

  //TODO: optimize this method, it is simply getting the first element in a loop
  ListNode<T> firstNodeWhere(bool test(T element), {T orElse()}) =>
      this.firstWhere((e) => test(e), orElse: orElse).populateChildrenPath();

  //TODO: optimize this method, it is simply getting the last element in a loop
  ListNode<T> lastNodeWhere(bool Function(T element) test,
          {T Function() orElse}) =>
      this.lastWhere((e) => test(e), orElse: orElse).populateChildrenPath();

  int nodeIndexWhere(bool Function(T element) test, [int start = 0]) {
    final index = this.indexWhere((e) => test(e), start);
    this[index].populateChildrenPath();
    return index;
  }
}

class RootListNode<T extends ListNode<T>> with ListNode<T> {
  final List<ListNode<T>> children;
  final String key;

  RootListNode(this.children) : this.key = TreeNode.ROOT_KEY;
}

mixin ListNode<T extends TreeNode> implements _ListNode<T>, TreeNode {
  List<ListNode<T>> get children;

  /// [key] should be unique, if you are overriding it then make sure that it has a unique value
  final String key = UniqueKey().toString();

  String path = "";

  bool isExpanded = false;

  bool get hasChildren => children.isNotEmpty;

  int get level => TreeNode.PATH_SEPARATOR.allMatches(path).length - 1;

  String get childrenPath => "$path${TreeNode.PATH_SEPARATOR}$key";

  ListNode<T> getNodeAt(String path) {
    assert(key != TreeNode.ROOT_KEY ? !path.contains(TreeNode.ROOT_KEY) : true,
        "Path with ROOT_KEY = ${TreeNode.ROOT_KEY} can only be called from the root node");

    final nodes = ListNode.normalizePath(path).split(TreeNode.PATH_SEPARATOR);

    var currentNode = this;
    for (final node in nodes) {
      if (node.isEmpty) {
        return currentNode;
      } else {
        currentNode = currentNode.children.firstNodeWhere((n) => n.key == node);
      }
    }
    return currentNode;
  }

  ListNode<T> populateChildrenPath({bool refresh = false}) {
    if (children.isEmpty) return this;
    if (!refresh && children.first.path.isNotEmpty) return this;
    for (final child in children) {
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
      identical(this, other) || other is ListNode && key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() {
    return 'Node {key: $key}, path: $path, child_count: ${children.length}';
  }
}

mixin _ListNode<T> implements TreeNode {
  List<_ListNode<T>> get children;

  _ListNode<T> populateChildrenPath({bool refresh});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ListNode &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}
