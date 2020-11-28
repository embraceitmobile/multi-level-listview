abstract class TreeNode {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  String get key;

  String path;

  dynamic get children;

  bool isExpanded;

  bool get hasChildren;

  int get level;

  String get childrenPath;

  TreeNode getNodeAt(String path);

  TreeNode populateChildrenPath({bool refresh});
}
