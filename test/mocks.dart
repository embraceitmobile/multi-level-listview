import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/tree/tree.dart';

get mockTreeWithIds => Tree()
  ..addAll([
    MapNode("0A")..add(MapNode("0A1A")),
    MapNode("0B"),
    MapNode("0C")
      ..addAll([
        MapNode("0C1A"),
        MapNode("0C1B"),
        MapNode("0C1C")
          ..addAll([
            MapNode("0C1C2A")
              ..addAll([
                MapNode("0C1C2A3A"),
                MapNode("0C1C2A3B"),
                MapNode("0C1C2A3C"),
              ])
          ]),
      ])
  ]);

get mockTreeWithOutIds => Tree()
  ..addAll([
    MapNode()..add(MapNode()),
    MapNode(),
    MapNode()
      ..addAll([
        MapNode(),
        MapNode(),
        MapNode()
          ..addAll([
            MapNode()
              ..addAll([
                MapNode(),
                MapNode(),
                MapNode(),
              ])
          ]),
      ])
  ]);
