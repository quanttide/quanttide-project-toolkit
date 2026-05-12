import 'task.dart';

/// 具名看板列表。一个看板由多个 [BoardList] 组成。
///
/// 即将废弃。卡片状态迁移至 [Task.status] 后，看板不再依赖列表名称表达状态语义。
@Deprecated('将迁移至 Task.status，后续版本移除')
class BoardList {
  /// 列表名称，如 "todo"、"done" 或 "observe"。
  final String name;

  /// 列表中的任务集合。
  final List<Task> cards;

  const BoardList({
    required this.name,
    required this.cards,
  });
}
