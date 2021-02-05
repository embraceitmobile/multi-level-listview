import 'package:flutter/material.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_list.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_tree.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/tree_update_notifier.dart';

class AnimatedListController<T extends Node<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final TreeUpdateNotifier<T> _treeUpdateNotifier;
  final dynamic _removedItemBuilder;
  final ListenableList<Node<T>> _items;

  AnimatedListController(
      {@required GlobalKey<AnimatedListState> listKey,
      @required dynamic removedItemBuilder,
      @required ListenableTree<T> tree})
      : _listKey = listKey,
        _items = ListenableList.from(tree.root.childrenAsList),
        _removedItemBuilder = removedItemBuilder,
        _treeUpdateNotifier = tree,
        assert(listKey != null),
        assert(removedItemBuilder != null) {
    _treeUpdateNotifier.addedNodes.listen(handleAddItemsEvent);
    _treeUpdateNotifier.removedNodes.listen(handleRemoveItemsEvent);
    _treeUpdateNotifier.insertedNodes.listen(handleInsertItemsEvent);
  }

  ListenableList<Node<T>> get list => _items;

  int get length => _items.length;

  AnimatedListState get _animatedList => _listKey.currentState;

  int indexOf(T item) =>
      _items.indexWhere((e) => e.path == item.path && e.key == item.key);

  int indexFromKeyAndPath(String key, String path) =>
      _items.indexWhere((e) => e.path == path && e.key == key);

  void insert(int index, Node<T> item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<Node<T>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  Node<T> removeAt(int index) {
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

  void remove(Node<T> item) => removeAt(indexOf(item));

  void removeAll(List<Node<T>> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => removeAt(indexOf(item)));
    }
  }

  void collapseNode(Node<T> item) {
    final removeItems = _items.where((element) => element.path
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
    final parentKey = event.path.split(Node.PATH_SEPARATOR).last;
    final parentIndex =
        _items.indexWhere((element) => element.key == parentKey);
    if (parentIndex < 0) return;

    final parentNode = _items[parentIndex];
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
    if (_items.any((item) => item.path == event.path)) {
      // get the last child in the path
      final firstChild =
          _items.firstWhere((element) => element.path == event.path);
      // for visible path, add the items in the flatList and the animatedList
      insertAll(indexOf(firstChild) + event.index, event.items);
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeRemoveEvent event) {
    for (final key in event.keys) {
      //if item is in the root of the list, then remove the item
      if (_items.any((item) => item.key == key)) {
        final removedItem = removeAt(indexFromKeyAndPath(key, event.path));

        if (removedItem.isExpanded) {
          //if the item is expanded, also remove its children
          removeAll(_items
              .where((element) =>
                  element.path.startsWith(removedItem.childrenPath))
              .toList());
        }
      }
    }
  }
}
