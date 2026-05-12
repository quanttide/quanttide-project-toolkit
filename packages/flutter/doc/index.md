# 组件

## 看板`BoardView`

看板主视图，渲染 `Board` 的列表映射。

```dart
BoardView(list: List<Task>)
```

接收 `Board` 实例，将其 `lists` Map 渲染为水平滚动的列集合。每列由 `BoardColumn` 渲染。

## 看板列`BoardColumn`

通用外壳组件，提供白底圆角容器 + 标题栏 + 内容插槽。

```dart
BoardColumn(title: Widget, content: Widget)
```

## 看板卡片`BoardCard`

通用卡片外壳，提供 Card + InkWell + padding。

```dart
BoardCard(content: Widget, onTap: VoidCallback?)
```
