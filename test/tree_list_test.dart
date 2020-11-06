import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';
import 'mocks.dart';

void main() {
  TreeList<TestNode> items;
  setUp(() {
    items = TreeList.from(List.of(itemsWithoutIds));
  });

  group('test add method', () {
    test('on adding an item, the length of list increases', () async {
      final origLength = items.children.length;
      items.add(TestNode());
      expect(items.children.length, equals(origLength + 1));
    });

    test('on adding an item at path, the length of list increases', () async {
      final path = items.children.firstNode.path;
      final lengthOrigChild = items.root.getNodeAt(path).children.length;

      items.add(TestNode(), path: path);
      expect(items.children.length, equals(lengthOrigChild + 1));
    });
  });

  group('test addAll method', () {
    final itemsToAdd = [TestNode(), TestNode()];

    test('on adding items, the length of list increases', () async {
      final origLength = items.children.length;
      items.addAll(itemsToAdd);
      expect(items.children.length, equals(origLength + itemsToAdd.length));
    });

    test('on adding items at path, the length of list increases', () async {
      final lengthOrigChild = items.children.length;
      final path = items.children.firstNode.path;
      items.addAll(itemsToAdd, path: path);
      expect(
          items.children.length, equals(lengthOrigChild + itemsToAdd.length));
    });
  });

  group('test insert method', () {
    test(
        'on inserting item, the item at the index is updated, and the length of '
        'list increases', () async {
      final origLength = items.children.length;
      final itemToInsert = TestNode();
      items.insert(itemToInsert, 0);
      expect(items.root.children.firstNode.key, equals(itemToInsert.key));
      expect(items.children.length, equals(origLength + 1));
    });

    test(
        'on inserting items at path, the items at and after the index are updated,'
        ' and the length of list increases', () async {
      final node = items.children.firstNode;
      final itemToInsert = TestNode();
      final path = node.childrenPath;
      final origLength = items.root.getNodeAt(path).children.length;
      final insertAt = 0;
      items.insert(itemToInsert, insertAt, path: path);
      expect(items.root.getNodeAt(path).children[insertAt].key,
          equals(itemToInsert.key));
      expect(
          items.root.getNodeAt(path).children.length, equals(origLength + 1));
    });
  });

  group('test insertAll method', () {
    test(
        'on inserting items, the item at the index is updated, and the length of '
        'list increases', () async {
      final origLength = items.children.length;
      final itemsToInsert = [TestNode(), TestNode()];
      items.insertAll(itemsToInsert, 0);
      expect(
          items.root.children.firstNode.key, equals(itemsToInsert.first.key));
      expect(items.children.length, equals(origLength + itemsToInsert.length));
    });

    test(
        'on inserting items at path, the items at and after the index are updated,'
        ' and the length of list increases', () async {
      final node = items.children.firstNode;
      final itemsToInsert = [TestNode(), TestNode()];
      final path = node.path;
      final insertAt = 0;
      final origLength = items.root.getNodeAt(path).children.length;

      items.insertAll(itemsToInsert, insertAt, path: path);
      expect(items.root.getNodeAt(path).children[insertAt].key,
          equals(itemsToInsert.first.key));
      expect(items.root.getNodeAt(path).children.length,
          equals(origLength + itemsToInsert.length));
    });
  });

  group('test remove method', () {
    test('on removing an item, the item is no longer available in the list',
        () async {
      final origLength = items.children.length;
      final itemToRemove = items.children.firstNode;
      items.remove(itemToRemove);
      expect(items.children.contains(itemToRemove), isFalse);
      expect(items.children.length, equals(origLength - 1));
    });

    test('on removing an item at path, the length of list increases', () async {
      final node = items.children.firstNode;
      final itemToRemove = node.children.firstNode;
      final path = node.childrenPath;
      final origLength = items.root.getNodeAt(path).children.length;

      items.remove(itemToRemove, path: path);
      expect(
          items.root.getNodeAt(path).children.contains(itemToRemove), isFalse);
      expect(
          items.root.getNodeAt(path).children.length, equals(origLength - 1));
    });
  });

  group('test removeItems method', () {
    test('on removing items, the items are no longer available in the list',
        () async {
      final origLength = items.children.length;
      final itemsToRemove = [items.children.first, items.children.last];
      items.removeItems(itemsToRemove);
      expect(items.children.contains(itemsToRemove.first), isFalse);
      expect(items.children.contains(itemsToRemove.last), isFalse);
      expect(items.children.length, equals(origLength - itemsToRemove.length));
    });

    test(
        'on removing items at path, the items are no longer available in the list at the path',
        () async {
      final items = TreeList.from(List.of(itemsWithoutIds2));
      final node = items.children.firstNode.children.firstNode;
      final origLength = node.children.length;
      final itemsToRemove = [node.children.firstNode, node.children.lastNode];
      final path = node.children.firstNode.path;
      items.removeItems(itemsToRemove, path: path);
      expect(node.children.contains(itemsToRemove), isFalse);
      expect(node.children.length, equals(origLength - itemsToRemove.length));
    });
  });

  group('test removeAt method', () {
    test(
        'on removing an item at the index, the item is no longer available in the list',
        () async {
      final origLength = items.children.length;
      final itemToRemove = 0;
      items.removeAt(itemToRemove);
      expect(items.children.contains(itemToRemove), isFalse);
      expect(items.children.length, equals(origLength - 1));
    });

    test('on removing an item at index at path, the length of list increases',
        () async {
      final node = items.children.firstNode;
      final origLength = node.children.length;
      final itemToRemove = 0;
      final path = node.childrenPath;
      items.removeAt(itemToRemove, path: path);
      expect(node.children.contains(itemToRemove), isFalse);
      expect(node.children.length, equals(origLength - 1));
    });
  });

  group('test clear method', () {
    test('on clearing a list, the list length is zero', () async {
      items.clearAll();
      expect(items.root.children.isEmpty, isTrue);
    });

    test('on clearing a list at a path, the list length is zero at that path',
        () async {
      final node = items.children.firstNode;
      final path = node.path;
      items.clearAll(path: path);
      expect(items.root.getNodeAt(path).children.isEmpty, isTrue);
    });
  });
}
