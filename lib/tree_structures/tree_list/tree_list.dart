import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/tree_node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/list_node.dart';

class TreeList<T extends ListNode<T>> implements InsertableIterableTree<T> {
  TreeList._(RootListNode<T> root) : _root = root {
    if (_root.hasChildren) {
      for (final node in _root.children) {
        node.path = _root.childrenPath;
      }
    }
  }

  RootListNode<T> _root;

  ListNode<T> get root => _root;

  List<ListNode<T>> get children => _root.children;

  factory TreeList() => TreeList._(RootListNode(<T>[]));

  factory TreeList.from(List<ListNode<T>> list) =>
      TreeList._(RootListNode(list));

  void add(TreeNode element, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.add(element);
    node.populateChildrenPath(refresh: true);
  }

  void addAll(Iterable<TreeNode> iterable, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.addAll(iterable);
    node.populateChildrenPath(refresh: true);
  }

  void insert(TreeNode element, int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.insert(index, element);
    node.populateChildrenPath(refresh: true);
  }

  int insertAfter(TreeNode value, TreeNode itemAfter, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final index = node.children.indexOf(itemAfter) + 1;
    node.children.insert(index, value);
    node.populateChildrenPath(refresh: true);
    return index;
  }

  int insertBefore(TreeNode value, TreeNode itemBefore, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final index = node.children.indexOf(itemBefore);
    node.children.insert(index, value);
    node.populateChildrenPath(refresh: true);
    return index;
  }

  void insertAll(Iterable<TreeNode> iterable, int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.insertAll(index, iterable);
    node.populateChildrenPath(refresh: true);
  }

  @override
  int insertAllAfter(Iterable<TreeNode> iterable, TreeNode itemAfter, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final index = node.children.indexOf(itemAfter);
    node.children.insertAll(index, iterable);
    node.populateChildrenPath(refresh: true);
    return index;
  }

  @override
  int insertAllBefore(Iterable<TreeNode> iterable, TreeNode itemBefore, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final index = node.children.indexOf(itemBefore) - 1;
    node.children.insertAll(index, iterable);
    node.populateChildrenPath(refresh: true);
    return index;
  }

  void remove(TreeNode value, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.remove(value);
  }

  void removeItems(List<TreeNode> iterable, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);

    for (final item in iterable) {
      node.children.remove(item);
    }
  }

  T removeAt(int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final item = node.children[index];
    node.children.removeAt(index);
    return item;
  }

  List<TreeNode> clearAll({String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final items = List.of(node.children, growable: false);
    node.children.clear();
    return items;
  }
}
