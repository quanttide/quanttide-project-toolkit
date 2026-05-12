# 组件

## 看板`BoardView`

看板主视图，渲染 `Board` 的列表映射。

```dart
BoardView(list: List<Task>)
```

接收 `Board` 实例，将其 `lists` Map 渲染为水平滚动的列集合。每列由 `BoardColumn` 渲染。

## 看板列`BoardColumn`

看板列，对应 `BoardList`。

```dart
BoardColumn(list: List<Task>)
```

渲染列标题（`BoardList.name`）和卡片列表（`BoardList.cards`）。每张卡片由 `BoardCard` 渲染。

## 看板卡片`BoardCard`

```dart
BoardCard(task: Task)
```

渲染任务标题、状态、负责人等关键字段。
