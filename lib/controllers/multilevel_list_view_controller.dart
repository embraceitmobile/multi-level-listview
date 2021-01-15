import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_tree.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class IMultiLevelListViewController<T extends Node<T>>
    implements ITree<T> {
  void attach(
      {ITree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController});

  void scrollToItem(T item);

  void scrollToIndex(int index);

  void toggleNodeExpandCollapse(T item);
}

class MultiLevelListViewController<T extends Node<T>>
    implements IMultiLevelListViewController<T> {
  ListenableTree<T> _listenableTree;
  AnimatedListController _listController;
  AutoScrollController _scrollController;

  MultiLevelListViewController();

  void attach(
      {ITree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = ListenableTree(tree);
    _listController = listController;
    _scrollController = scrollController;
  }

  @override
  void add(Node<T> value, {String path}) =>
      _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<Node<T>> iterable, {String path}) =>
      _listenableTree.addAll(iterable, path: path);

  @override
  void clear({String path}) => _listenableTree.clear(path: path);

  @override
  void scrollToIndex(int index) => _scrollController.scrollToIndex(index);

  @override
  void scrollToItem(T item) =>
      _scrollController.scrollToIndex(_listController.indexOf(item));

  @override
  void toggleNodeExpandCollapse(Node<T> item) =>
      _listController.toggleExpansion(item);

  @override
  Node<T> operator [](covariant at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  Node<T> elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    // TODO: implement removeWhere
  }

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();

  @override
  void remove(String key, {String path}) {
    // TODO: implement remove
  }

  @override
  void removeAll(Iterable<String> keys, {String path}) {
    // TODO: implement removeAll
  }
}
