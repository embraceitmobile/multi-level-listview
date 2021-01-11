import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';
import 'package:multi_level_list_view/tree_structures/tree.dart';

class TestNode extends MapNode<TestNode>{
  void run(){
    final test = TestNode();

  }
}

List<NodeWithGivenId> itemsWithIds = [
  NodeWithGivenId(
      key: "0A", children: <NodeWithGivenId>[NodeWithGivenId(key: "1A")]),
  NodeWithGivenId(key: "0B"),
  NodeWithGivenId(key: "0C", children: <NodeWithGivenId>[
    NodeWithGivenId(key: "0C1A"),
    NodeWithGivenId(key: "0C1B"),
    NodeWithGivenId(key: "0C1C", children: <NodeWithGivenId>[
      NodeWithGivenId(key: "0C1C2A", children: <NodeWithGivenId>[
        NodeWithGivenId(key: "0C1C2A3A"),
        NodeWithGivenId(key: "0C1C2A3B"),
        NodeWithGivenId(key: "0C1C2A3C"),
      ]),
    ]),
  ]),
  NodeWithGivenId(key: "0D"),
];

List<TestNode> itemsWithoutIds = [
  TestNode(children: <TestNode>[
    TestNode(children: [
      TestNode(),
      TestNode(),
      TestNode(),
    ])
  ]),
  TestNode(),
  TestNode(children: <TestNode>[
    TestNode(),
    TestNode(),
    TestNode(children: <TestNode>[
      TestNode(children: <TestNode>[
        TestNode(),
        TestNode(),
        TestNode(),
      ]),
    ]),
  ]),
  TestNode(),
];

List<TestNode> itemsWithoutIds2 = [
  TestNode(children: <TestNode>[
    TestNode(children: [
      TestNode(),
      TestNode(),
      TestNode(),
    ])
  ]),
  TestNode(),
  TestNode(children: <TestNode>[
    TestNode(),
    TestNode(),
    TestNode(children: <TestNode>[
      TestNode(children: <TestNode>[
        TestNode(),
        TestNode(),
        TestNode(),
      ]),
    ]),
  ]),
  TestNode(),
];
