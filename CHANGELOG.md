# Changelog

## [未发布]

### 变更

- 删除 `ROADMAP.md`（内容已过时）。随之撤下的未完成项：lint + test CI、枚举类（`ProjectType` / `Status` / `Priority`）、Rust SDK。仓库现状：`packages/{python,fastapi}` 均有 README 与 CHANGELOG；`.github/workflows/` 只有 `deploy-docs.yml` 与五个 `publish-*`

## [0.1.2] - 2026-05-13

### Added

- **FastAPI CamelCase 支持** (`packages/fastapi`): JSON 输入输出自动转换 camelCase，Python 代码保持 snake_case
- **文档更新**: 用户指南补充 camelCase JSON 传输约定说明

## [0.1.0] - 2026-05-13

### Added

- **Dart SDK** (`packages/dart`): 项目管理核心数据模型，Project/Task 不可变模型，JSON 序列化支持
- **Python SDK** (`packages/python`): Pydantic 模型，等效 Dart API，`replace()` 更新模式
- **FastAPI 集成** (`packages/fastapi`): 标准 CRUD 路由，自动 Schema 推导
- **Flutter 组件** (`packages/flutter`): 看板 UI 组件（BoardView/BoardColumn/BoardCard），自适应桌面/移动端
- **Django 集成** (`packages/django`): Django 数据模型和 Admin 配置
- **文档系统**: MyST Markdown 文档站，用户指南 + 开发者文档，GitHub Pages 自动部署
- **CI/CD**: Dart/pub.dev、Python/PyPI、Flutter/pub.dev、FastAPI/PyPI、Django/PyPI 自动发布工作流
