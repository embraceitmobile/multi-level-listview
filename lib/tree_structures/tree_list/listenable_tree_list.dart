import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree_update_provider.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/list_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/tree_list.dart';

class ListenableTreeList<T extends ListNode<T>> extends ChangeNotifier
    with IterableTreeUpdateProvider<T>
    implements ListenableIterableTree<T>, ListenableInsertableIterableTree<T> {
  ListenableTreeList._(TreeList<T> list) : _value = list;

  factory ListenableTreeList() => ListenableTreeList._(TreeList<T>());

  factory ListenableTreeList.from(List<TreeNode> list) =>
      ListenableTreeList._(TreeList.from(list));

  final TreeList<T> _value;

  @protected
  @visibleForTesting
  @override
  TreeList<T> get value => _value;

  @override
  ListNode<T> get root => _value.root;

  @override
  void add(TreeNode item, {String path}) {
    _value.add(item, path: path);
    notifyListeners();
    emitAddItems([item], path: path);
  }

  @override
  void addAll(Iterable<TreeNode> iterable, {String path}) {
    _value.addAll(iterable, path: path);
    notifyListeners();
    emitAddItems(iterable, path: path);
  }

  @override
  void insert(TreeNode item, int index, {String path}) {
    _value.insert(item, index, path: path);
    notifyListeners();
    emitInsertItems([item], index, path: path);
  }

  @override
  int insertBefore(TreeNode value, TreeNode itemBefore, {String path}) {
    final index = _value.insertBefore(value, itemBefore, path: path);
    notifyListeners();
    emitInsertItems([value], index, path: path);
    return index;
  }

  @override
  int insertAfter(TreeNode value, TreeNode itemAfter, {String path}) {
    final index = _value.insertAfter(value, itemAfter, path: path);
    notifyListeners();
    emitInsertItems([value], index, path: path);
    return index;
  }

  @override
  void insertAll(Iterable<TreeNode> iterable, int index, {String path}) {
    _value.insertAll(iterable, index, path: path);
    notifyListeners();
    emitInsertItems(iterable, index, path: path);
  }

  @override
  int insertAllBefore(Iterable<TreeNode> iterable, TreeNode itemBefore, {String path}) {
    final index = _value.insertAllAfter(iterable, itemBefore, path: path);
    notifyListeners();
    emitInsertItems(iterable, index, path: path);
    return index;
  }

  @override
  int insertAllAfter(Iterable<TreeNode> iterable, TreeNode itemAfter, {String path}) {
    final index = _value.insertAllAfter(iterable, itemAfter, path: path);
    notifyListeners();
    emitInsertItems(iterable, index, path: path);
    return index;
  }

  @override
  void remove(TreeNode value, {String path}) {
    _value.remove(value, path: path);
    notifyListeners();
    emitRemoveItems([value], path: path);
  }

  @override
  T removeAt(int index, {String path}) {
    final item = _value.removeAt(index, path: path);
    notifyListeners();
    emitRemoveItems([item], path: path);
    return item;
  }

  @override
  void removeItems(Iterable<TreeNode> iterable, {String path}) {
    _value.removeItems(iterable, path: path);
    notifyListeners();
    emitRemoveItems(iterable, path: path);
  }

  @override
  List<TreeNode> clearAll({String path}) {
    final clearedItems = _value.clearAll(path: path);
    notifyListeners();
    emitRemoveItems(clearedItems, path: path);
    return clearedItems;
  }
}
