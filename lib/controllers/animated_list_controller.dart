import 'package:flutter/material.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree_update_provider.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';
import 'package:multi_level_list_view/listenables/listenable_list.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/list_node.dart';

class AnimatedListController<T extends TreeNode> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final ListenableIterableTree<T> _listenableIterableTree;
  final dynamic _removedItemBuilder;
  final ListenableList<TreeNode> _items;

  AnimatedListController(
      {@required GlobalKey<AnimatedListState> listKey,
      @required dynamic removedItemBuilder,
      ListenableIterableTree<T> tree})
      : _listKey = listKey,
        _items = ListenableList.from(tree.root.children),
        _removedItemBuilder = removedItemBuilder,
        _listenableIterableTree = tree,
        assert(listKey != null),
        assert(removedItemBuilder != null) {
    if (tree != null) {
      _listenableIterableTree.addedItems.listen(handleAddItemsEvent);
      _listenableIterableTree.insertedItems.listen(handleInsertItemsEvent);
      _listenableIterableTree.removedItems.listen(handleRemoveItemsEvent);
    }
  }

  ListenableList<ListNode<T>> get list => _items;

  int get length => _items.length;

  AnimatedListState get _animatedList => _listKey.currentState;

  int indexOf(T item) =>
      _items.nodeIndexWhere((e) => e.path == item.path && e.key == item.key);

  void insert(int index, TreeNode item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<TreeNode> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  TreeNode removeAt(int index) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            _removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  void remove(TreeNode item) => removeAt(indexOf(item));

  void removeAll(List<TreeNode> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => removeAt(indexOf(item)));
    }
  }

  List<TreeNode> childrenAt([String path]) {
    if (path?.isEmpty ?? true) return _items.value;
    var children = _items.value;
    var nodes = ListNode.normalizePath(path).split(TreeNode.PATH_SEPARATOR);
    for (final node in nodes) {
      children = children.firstWhere((element) => node == element.key).children;
    }
    return children;
  }

  void collapseNode(TreeNode item) {
    final removeItems = _items.where((element) => element.path
        .startsWith('${item.path}${TreeNode.PATH_SEPARATOR}${item.key}'));

    removeAll(removeItems.toList());
    item.isExpanded = false;
  }

  void expandNode(TreeNode item) {
    if (item.children.isEmpty) return;
    insertAll(indexOf(item) + 1, item.children);
    item.isExpanded = true;
  }

  void toggleExpansion(TreeNode item) {
    if (item.isExpanded)
      collapseNode(item);
    else
      expandNode(item);
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeEvent<T> event) {
    final parentKey = event.path.split(TreeNode.PATH_SEPARATOR).last;
    final parentIndex =
        _items.indexWhere((element) => element.key == parentKey);
    final parentNode = _items[parentIndex];
    for (final item in event.items) {
      item.path = event.path;
    }

    if (!parentNode.isExpanded) {
      expandNode(parentNode);
    } else {
      // if the node is expanded, add the items in the flatList and
      // the animatedList
      insertAll(parentIndex + parentNode.children.length, event.items);
    }
  }

  @visibleForTesting
  void handleInsertItemsEvent(NodeEvent<T> event) {
    //check if the path is visible in the animatedList
    if (_items.any((item) => item.path == event.path)) {
      // get the last child in the path
      final firstChild =
          _items.firstWhere((element) => element.path == event.path);
      // for visible path, add the items in the flatList and the animatedList
      insertAll(indexOf(firstChild) + event.index, event.items);
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeEvent<T> event) {
    for (final item in event.items) {
      //if item is in the root of the list, then remove the item
      if (_items.contains(item)) {
        remove(item);

        if (item.isExpanded) {
          //if the item is expanded, also remove its children
          removeAll(_items
              .where((element) => element.path.startsWith(item.childrenPath))
              .toList());
        }
      }
      // if item is not in the root list, then remove its value from the _items
      if (ListNode.normalizePath(item.path).isNotEmpty ?? false) {
        childrenAt(item.path).remove(item);
      }
    }
  }
}
