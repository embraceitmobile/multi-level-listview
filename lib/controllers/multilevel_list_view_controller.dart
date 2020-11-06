import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/list_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_map/map_node.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class MultiLevelListViewController<T extends TreeNode>
    implements IterableTree<T> {
  void attach(
      {IterableTree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController});

  void toggleNodeExpandCollapse(T item);
}

class EfficientMultiLevelListViewController<T extends TreeNode>
    implements MultiLevelListViewController<T> {
  ListenableIterableTree<T> _listenableTree;
  AnimatedListController _listController;
  AutoScrollController _scrollController;

  EfficientMultiLevelListViewController();

  void attach(
      {IterableTree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = tree;
    _listController = listController;
    _scrollController = scrollController;
  }

  @override
  void add(TreeNode value, {String path}) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<TreeNode> iterable, {String path}) {
    // TODO: implement addAll
  }

  @override
  Iterable<T> clearAll({String path}) {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  void remove(TreeNode value) {
    // TODO: implement remove
  }

  @override
  void removeItems(Iterable<TreeNode> iterable) {
    // TODO: implement removeItems
  }

  @override
  // TODO: implement root
  T get root => throw UnimplementedError();

  @override
  void toggleNodeExpandCollapse(T item) {
    // TODO: implement toggleNodeExpandCollapse
  }
}

class InsertableMultiLevelListViewController<T extends TreeNode>
    implements MultiLevelListViewController<T>, InsertableIterableTree<T> {
  ListenableInsertableIterableTree<T> _listenableTree;
  AnimatedListController _listController;
  AutoScrollController _scrollController;

  InsertableMultiLevelListViewController();

  void attach(
      {IterableTree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = tree;
    _listController = listController;
    _scrollController = scrollController;
  }

  @override
  T get root => _listenableTree.root;

  @override
  void add(TreeNode value, {String path}) => _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<TreeNode> iterable, {String path}) =>
      _listenableTree.addAll(iterable, path: path);

  @override
  void insert(TreeNode value, int index, {String path}) =>
      _listenableTree.insert(value, index, path: path);

  @override
  int insertBefore(T value, T itemBefore, {String path}) =>
      _listenableTree.insertBefore(value, itemBefore, path: path);

  @override
  int insertAfter(T value, T itemAfter, {String path}) =>
      _listenableTree.insertAfter(value, itemAfter, path: path);

  @override
  void insertAll(Iterable<T> iterable, int index, {String path}) =>
      _listenableTree.insertAll(iterable, index, path: path);

  @override
  int insertAllBefore(Iterable<T> iterable, T itemBefore, {String path}) =>
      _listenableTree.insertAllBefore(iterable, itemBefore, path: path);

  @override
  int insertAllAfter(Iterable<T> iterable, T itemAfter, {String path}) =>
      _listenableTree.insertAllAfter(iterable, itemAfter, path: path);

  @override
  void remove(TreeNode value) => _listenableTree.remove(value);

  @override
  TreeNode removeAt(int index, {String path}) =>
      _listenableTree.removeAt(index, path: path);

  @override
  void removeItems(Iterable<TreeNode> iterable) =>
      _listenableTree.removeItems(iterable);

  @override
  Iterable<T> clearAll({String path}) => _listenableTree.clearAll(path: path);

  void scrollToIndex(int index) => _scrollController.scrollToIndex(index);

  void scrollToItem(T item) =>
      _scrollController.scrollToIndex(_listController.indexOf(item));

  @override
  void toggleNodeExpandCollapse(T item) =>
      _listController.toggleExpansion(item);


}
