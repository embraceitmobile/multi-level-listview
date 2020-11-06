import 'package:multi_level_list_view/interfaces/tree_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/list_node.dart';

abstract class IterableTree<T extends TreeNode> {
  external factory IterableTree();

  TreeNode get root;

  void add(TreeNode value, {String path});

  void addAll(List<TreeNode> iterable, {String path});

  void remove(TreeNode value);

  void removeItems(List<TreeNode> iterable);

  Iterable<TreeNode> clearAll({String path});
}

abstract class InsertableIterableTree<T extends TreeNode>
    with IterableTree<T> {
  external factory InsertableIterableTree();

  external factory InsertableIterableTree.from(List<ListNode<T>> list);

  void insert(T value, int index, {String path});

  int insertAfter(T value, T itemAfter, {String path});

  int insertBefore(T value, T itemBefore, {String path});

  void insertAll(Iterable<T> iterable, int index, {String path});

  int insertAllAfter(Iterable<T> iterable, T itemAfter, {String path});

  int insertAllBefore(Iterable<T> iterable, T itemBefore, {String path});

  TreeNode removeAt(int index, {String path});
}
