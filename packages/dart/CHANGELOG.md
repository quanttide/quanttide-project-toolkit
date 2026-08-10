# Changelog

## [0.2.0] - 2026-05-12

> **Breaking changes** — 从 0.1.x 升级需迁移代码。

### Changed

- 重命名 `BoardCard` → `Task`，保留 `BoardCard` 为 deprecated typedef
- JSON 序列化中时间字段使用 ISO 8601 字符串格式

### Added

- `Project.id`、`Project.description` 字段
- `Task.type`、`Task.priority`、`Task.assigner` 字段
- `Task.startAt`、`Task.endAt`（计划时间）
- 审计字段：`createdBy`、`createdAt`、`updatedBy`、`updatedAt`（Project 和 Task）

### Removed

- `Board`、`BoardList` 模型（原看板 UI 概念）
- `Project.board` 字段（Project 不再关联看板）
- `Task.custom`、`Task.date` 字段（`date` 不再保留）

## [0.1.0] - 2026-05-09

### Added

- 新增 `Project` 模型：看板项目，持有一个 `Board`
- 新增 `Board` 模型：看板，包含一组具名列表
- 新增 `BoardList` 模型：看板列表，包含一组卡片
- 新增 `BoardCard` 模型：看板卡片，支持标题、描述、分类、标签、负责人、日期、自定义字段等属性
- 所有模型支持 JSON 序列化与反序列化（`toJson` / `fromJson`）
- `BoardCard` 支持 `copyWith` 方法部分更新字段
- `BoardCard` 支持自定义字段分离：非预定义字段自动归入 `custom` Map
