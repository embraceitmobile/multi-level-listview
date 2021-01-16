library multi_level_list_view;

import 'package:flutter/material.dart';
import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/controllers/list_view_controller/base/i_tree_list_view_controller.dart';
import 'package:multi_level_list_view/tree/tree_change_notifier.dart';
import 'package:multi_level_list_view/widgets/list_item_container.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'controllers/list_view_controller/tree_list_view_controller.dart';
import 'listenable_collections/listenable_tree.dart';
import 'node/node.dart';
import 'tree/tree.dart';
export 'package:multi_level_list_view/controllers/list_view_controller/base/i_tree_list_view_controller.dart';

typedef LeveledItemWidgetBuilder<T> = Widget Function(
    BuildContext context, int level, T item);

const TAG = "MultiLevelListView";
const DEFAULT_INDENT_PADDING = 24.0;
const DEFAULT_EXPAND_ICON = const Icon(Icons.keyboard_arrow_down);
const DEFAULT_COLLAPSE_ICON = const Icon(Icons.keyboard_arrow_up);
const DEFAULT_SHOW_EXPANSION_INDICATOR = true;

class MultiLevelListView<T extends Node<T>> extends StatefulWidget {
  final ListenableTree<T> listenableTree;
  final LeveledItemWidgetBuilder<T> builder;
  final ITreeListViewController<T> controller;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final ValueSetter<T> onItemTap;

  const MultiLevelListView._({
    Key key,
    @required this.builder,
    this.listenableTree,
    this.controller,
    this.onItemTap,
    this.showExpansionIndicator,
    this.indentPadding,
    this.expandIcon,
    this.collapseIcon,
  }) : super(key: key);

  /// The default [MultiLevelListView] uses a TreeMap structure internally for
  /// handling the nodes. The TreeMap does not allow insertion and removal of
  /// items at index positions. This allows for more efficient insertion and
  /// retrieval of items at child nodes, as child items can be readily accessed
  /// using the map keys.
  ///
  /// The complexity for accessing child nodes in [MultiLevelListView] is simply O(node_level).
  /// e.g. for path './.level1/level2', complexity is simply O(2).
  ///
  /// For a [MultiLevelListView] that allows for insertion and removal of
  /// items at index positions, use the alternate [MultiLevelListView.insertable]
  factory MultiLevelListView({
    Key key,
    @required LeveledItemWidgetBuilder<T> builder,
    Map<String, Node<T>> initialItems,
    TreeListViewController<T> controller,
    ValueSetter<T> onItemTap,
    bool showExpansionIndicator,
    double indentPadding,
    Icon expandIcon,
    Icon collapseIcon,
  }) =>
      MultiLevelListView._(
        key: key,
        builder: builder,
        listenableTree: ListenableTree(Tree.fromMap(initialItems)),
        controller: controller,
        onItemTap: onItemTap,
        showExpansionIndicator:
            showExpansionIndicator ?? DEFAULT_SHOW_EXPANSION_INDICATOR,
        indentPadding: indentPadding ?? DEFAULT_INDENT_PADDING,
        expandIcon: expandIcon ?? DEFAULT_EXPAND_ICON,
        collapseIcon: collapseIcon ?? DEFAULT_COLLAPSE_ICON,
      );

  /// The [MultiLevelListView.insertable] uses a [TreeList] structure internally
  /// for handling nodes. Using a [List] structure allows for insertion and
  /// removal of items in child nodes. However, this makes the node access
  /// operation less efficient as the children need to be iterated for each
  /// node level.
  ///
  /// The complexity for accessing nodes for [MultiLevelListView.insertable] is
  /// O(n^m), where n is the number of children in a node, and m is the node level.
  ///
  /// If you do not have a requirement for insertion and removal of items in a
  /// node, use the more efficient [MultiLevelListView] instead.
  // factory MultiLevelListView.indexed({
  //   Key key,
  //   @required LeveledIndexedWidgetBuilder<T> builder,
  //   List<T> initialItems,
  //   InsertableMultiLevelListViewController<T> controller,
  //   ValueSetter<T> onItemTap,
  //   bool showExpansionIndicator,
  //   double indentPadding,
  //   Icon expandIcon,
  //   Icon collapseIcon,
  // }) =>
  //     MultiLevelListView._(
  //       key: key,
  //       builder: builder,
  //       listenableTree: ListenableTreeList.from(initialItems ?? <T>[]),
  //       controller: controller,
  //       onItemTap: onItemTap,
  //       showExpansionIndicator:
  //           showExpansionIndicator ?? DEFAULT_SHOW_EXPANSION_INDICATOR,
  //       indentPadding: indentPadding ?? DEFAULT_INDENT_PADDING,
  //       expandIcon: expandIcon ?? DEFAULT_EXPAND_ICON,
  //       collapseIcon: collapseIcon ?? DEFAULT_COLLAPSE_ICON,
  //     );

  @override
  State<StatefulWidget> createState() => _MultiLevelListView<T>();
}

class _MultiLevelListView<T extends Node<T>>
    extends State<MultiLevelListView<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedListController<T> _animatedListController;
  AutoScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    widget.listenableTree.addedItems.listen(_handleItemAdditionEvent);
    widget.listenableTree.insertedItems.listen(_handleItemAdditionEvent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollController ??= AutoScrollController();

    _animatedListController = AnimatedListController(
      listKey: _listKey,
      tree: widget.listenableTree,
      removedItemBuilder: _buildRemovedItem,
    );

    widget.controller.attach(
      tree: widget.listenableTree.value,
      scrollController: _scrollController,
      listController: _animatedListController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _animatedListController.list;
    if (list.isEmpty) return SizedBox.shrink();

    return AnimatedList(
      key: _listKey,
      initialItemCount: list.length,
      controller: _scrollController,
      itemBuilder: (context, index, animation) =>
          _buildItem(list[index], animation, index: index),
    );
  }

  /// Used to build list items that haven't been removed.
  Widget _buildItem(Node<T> node, Animation<double> animation,
      {bool remove = false, int index}) {
    final itemContainer = ListItemContainer(
      animation: animation,
      item: node,
      child: widget.builder(context, node.level, node),
      indentPadding: widget.indentPadding * node.level,
      showExpansionIndicator:
          widget.showExpansionIndicator && node.childrenAsList.isNotEmpty,
      expandedIndicatorIcon:
          node.isExpanded ? widget.collapseIcon : widget.expandIcon,
      onTap: remove
          ? null
          : (item) {
              _animatedListController.toggleExpansion(item);
              if (widget.onItemTap != null) widget.onItemTap(item);
            },
    );

    if (index == null) return itemContainer;

    return AutoScrollTag(
      key: ValueKey(node.key),
      controller: _scrollController,
      index: index,
      child: itemContainer,
    );
  }

  Widget _buildRemovedItem(
          T item, BuildContext context, Animation<double> animation) =>
      _buildItem(item, animation, remove: true);

  void _handleItemAdditionEvent(NodeEvent<T> event) {
    Future.delayed(
        Duration(milliseconds: 300),
        () => _scrollController
            .scrollToIndex(_animatedListController.indexOf(event.items.first)));
  }
}
