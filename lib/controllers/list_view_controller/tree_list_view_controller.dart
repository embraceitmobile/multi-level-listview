import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_tree.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'base/i_tree_list_view_controller.dart';

class TreeListViewController<T extends Node<T>>
    implements ITreeListViewController<T>, ITree<T> {
  ListenableTree<T> _listenableTree;
  AnimatedListController _listController;
  AutoScrollController _scrollController;

  TreeListViewController();

  void attach(
      {@required ITree<T> tree,
      @required AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = ListenableTree(tree);
    _listController = listController;
    _scrollController = scrollController;
  }

  @override
  Node<T> get root => _listenableTree.root;

  @override
  int get length => _listenableTree.length;

  @override
  Node<T> elementAt(String path) => _listenableTree.elementAt(path);

  @override
  Node<T> operator [](String at) => _listenableTree[at];

  @override
  void scrollToIndex(int index) => _scrollController?.scrollToIndex(index);

  @override
  void scrollToItem(T item) =>
      _scrollController?.scrollToIndex(_listController.indexOf(item));

  @override
  void toggleNodeExpandCollapse(Node<T> item) =>
      _listController.toggleExpansion(item);

  @override
  void add(Node<T> value, {String path}) =>
      _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<Node<T>> iterable, {String path}) =>
      _listenableTree.addAll(iterable, path: path);

  @override
  void remove(String key, {String path}) =>
      _listenableTree.remove(key, path: path);

  @override
  void removeAll(Iterable<String> keys, {String path}) =>
      _listenableTree.removeAll(keys, path: path);

  @override
  void removeWhere(bool Function(Node<T> element) test, {String path}) =>
      _listenableTree.removeWhere(test, path: path);

  @override
  void clear({String path}) => _listenableTree.clear(path: path);
}
