import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/list_node.dart';
import 'iterable_tree_update_provider.dart';

abstract class ListenableIterableTree<T extends TreeNode>
    with IterableTreeUpdateProvider<T>
    implements IterableTree<T>, ValueListenable<IterableTree<T>> {}

abstract class ListenableInsertableIterableTree<T extends TreeNode>
    with IterableTreeUpdateProvider<T>
    implements
        IterableTree<T>,
        InsertableIterableTree<T>,
        ValueListenable<IterableTree<T>> {}
