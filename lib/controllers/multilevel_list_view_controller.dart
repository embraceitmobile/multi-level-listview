import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';
import 'package:multi_level_list_view/tree_structures/tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class IMultiLevelListViewController<T extends Node<T>>
    implements Tree<T> {
  void attach(
      {Tree<T> tree,
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
      {Tree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = ListenableTree(tree);
    _listController = listController;
    _scrollController = scrollController;
  }

  @override
  Node<T> get root => _listenableTree.root;

  @override
  void add(T value, {String path}) => _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<T> iterable, {String path}) =>
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
  T operator [](covariant String at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(covariant String at, T value) {
    // TODO: implement []=
  }

  @override
  // TODO: implement children
  Map<String, Node<T>> get children => throw UnimplementedError();

  @override
  T elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  void remove(T element, {String path}) {
    // TODO: implement remove
  }

  @override
  void removeAll(Iterable<T> iterable, {String path}) {
    // TODO: implement removeAll
  }

  @override
  void removeWhere(bool Function(T element) test, {String path}) {
    // TODO: implement removeWhere
  }
}
