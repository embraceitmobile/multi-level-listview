import 'package:flutter/material.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_list.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_tree.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_listenable_tree.dart';
import 'package:multi_level_list_view/tree/tree_update_notifier.dart';

class AnimatedListController<T extends Node<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final dynamic _removedItemBuilder;
  final IListenableTree<T> _listenableTree;
  final List<Node<T>> _flatList;

  AnimatedListController(
      {@required GlobalKey<AnimatedListState> listKey,
      @required dynamic removedItemBuilder,
      @required IListenableTree<T> tree})
      : _listKey = listKey,
        _listenableTree = tree,
        _removedItemBuilder = removedItemBuilder,
        _flatList = List.from(tree.root.childrenAsList),
        assert(listKey != null),
        assert(removedItemBuilder != null) {
    _listenableTree.addedNodes.listen(handleAddItemsEvent);
    _listenableTree.removedNodes.listen(handleRemoveItemsEvent);
    _listenableTree.insertedNodes.listen(handleInsertItemsEvent);
  }

  List<Node<T>> get list => _flatList;

  int get length => _flatList.length;

  AnimatedListState get _animatedList => _listKey.currentState;

  int indexOf(T item) =>
      _flatList.indexWhere((e) => e.path == item.path && e.key == item.key);

  int indexFromKeyAndPath(String key, String path) =>
      _flatList.indexWhere((e) => e.path == path && e.key == key);

  void insert(int index, Node<T> item) {
    _flatList.insert(index, item);
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<Node<T>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  Node<T> removeAt(int index) {
    final removedItem = _flatList.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            _removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  void remove(Node<T> item) => removeAt(indexOf(item));

  void removeAll(List<Node<T>> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => removeAt(indexOf(item)));
    }
  }

  void collapseNode(Node<T> item) {
    final removeItems = _flatList.where((element) => element.path
        .startsWith('${item.path}${Node.PATH_SEPARATOR}${item.key}'));

    removeAll(removeItems.toList());
    item.isExpanded = false;
  }

  void expandNode(Node<T> item) {
    if (item.childrenAsList.isEmpty) return;
    insertAll(indexOf(item) + 1, List.from(item.childrenAsList));
    item.isExpanded = true;
  }

  void toggleExpansion(T item) {
    if (item.isExpanded)
      collapseNode(item);
    else
      expandNode(item);
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeAddEvent<T> event) {
    if (event.path == null) {
      insertAll(_flatList.length, event.items);
      return;
    }

    final parentKey = event.path.split(Node.PATH_SEPARATOR).last;
    final parentIndex =
        _flatList.indexWhere((element) => element.key == parentKey);
    if (parentIndex < 0) return;

    final parentNode = _flatList[parentIndex];
    for (final item in event.items) {
      item.path = event.path;
    }

    if (!parentNode.isExpanded) {
      expandNode(parentNode);
    } else {
      // if the node is expanded, add the items in the flatList and
      // the animatedList
      insertAll(parentIndex + parentNode.childrenAsList.length, event.items);
    }
  }

  @visibleForTesting
  void handleInsertItemsEvent(NodeInsertEvent<T> event) {
    //check if the path is visible in the animatedList
    if (_flatList.any((item) => item.path == event.path)) {
      // get the last child in the path
      final firstChild =
          _flatList.firstWhere((element) => element.path == event.path);
      // for visible path, add the items in the flatList and the animatedList
      insertAll(indexOf(firstChild) + event.index, event.items);
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeRemoveEvent event) {
    for (final key in event.keys) {
      //if item is in the root of the list, then remove the item
      if (_flatList.any((item) => item.key == key)) {
        final removedItem = removeAt(indexFromKeyAndPath(key, event.path));

        if (removedItem.isExpanded) {
          //if the item is expanded, also remove its children
          removeAll(_flatList
              .where((element) =>
                  element.path.startsWith(removedItem.childrenPath))
              .toList());
        }
      }
    }
  }
}
