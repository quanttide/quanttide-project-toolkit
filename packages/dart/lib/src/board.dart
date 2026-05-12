import 'task.dart';
import 'board_list.dart';

/// 看板。包含一组具名列表，列表名称由上层业务约定。
///
/// 例如 OODA 工作流使用 observe / orient / decide / act 四个列表。
///
/// 即将废弃。看板是 UI 层概念，后续版本将移除此数据结构，
/// 改用直接在容器层管理 [Task] 集合（如 flat list 或 query-based 分组）。
@Deprecated('看板是 UI 层概念，后续版本将移除此数据结构')
class Board {
  /// 列表 Map，键为列表名称，值为 [BoardList]，顺序由上游约定。
  final Map<String, BoardList> lists;

  const Board({required this.lists});

  /// 从 JSON Map 构造。Map 的每个键对应一个列表名称，
  /// 值为 Task JSON 数组。
  factory Board.fromJson(Map<String, dynamic> json) {
    final map = <String, BoardList>{};
    json.forEach((key, value) {
      final cards = (value as List<dynamic>)
          .map((c) => Task.fromJson(c as Map<String, dynamic>))
          .toList();
      map[key] = BoardList(name: key, cards: cards);
    });
    return Board(lists: map);
  }

  /// 序列化为 JSON Map。键为列表名称，值为任务 JSON 数组。
  Map<String, dynamic> toJson() {
    return lists.map(
      (key, value) => MapEntry(
        key,
        value.cards.map((c) => c.toJson()).toList(),
      ),
    );
  }
}
