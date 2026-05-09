## 0.1.0+1

- 更新 README：修正包名引用

## 0.1.0

- 新增 `Project` 模型：看板项目，持有一个 `Board`
- 新增 `Board` 模型：看板，包含一组具名列表
- 新增 `BoardList` 模型：看板列表，包含一组卡片
- 新增 `BoardCard` 模型：看板卡片，支持标题、描述、分类、标签、负责人、日期、自定义字段等属性
- 所有模型支持 JSON 序列化与反序列化（`toJson` / `fromJson`）
- `BoardCard` 支持 `copyWith` 方法部分更新字段
- `BoardCard` 支持自定义字段分离：非预定义字段自动归入 `custom` Map
