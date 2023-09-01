import 'package:state_notifier/state_notifier.dart';

import '../models/project.dart';


/// 项目列表状态管理器
class ProjectListNotifier extends StateNotifier<List<Project>> {
  ProjectListNotifier() : super([]);

  // TODO: 进一步定义
  void addProject(Project project) {
    state = [...state, project];
  }

  // TODO: 进一步定义
  void removeProject(Project project) {
    state = state.where((p) => p.id != project.id).toList();
  }
}
