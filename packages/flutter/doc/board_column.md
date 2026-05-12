# 看板列`BoardColumn`

纯布局组件，只提供视觉外壳，不做任何内容假设。

```
┌──────────────────────────────────┐
│            title                 │  ← 标题栏，底部有分割线
├──────────────────────────────────┤
│                                  │
│           content                │  ← Expanded 填充剩余空间
│                                  │
└──────────────────────────────────┘
```

## UI

白色背景，圆角 10，浅阴影。标题栏固定内边距，内容区填满剩余垂直空间。

| 区域 | 描述 |
|------|------|
| 标题栏 | 内边距 18/14/10，底部 `#E6E6E6` 分割线 |
| 内容区 | 被 `Expanded` 包裹，调用方填充任意内容 |

## API

```dart
const BoardColumn({
  required this.title,    // 标题栏内容（任意 widget）
  required this.content,  // 内容插槽（被 Expanded 包裹）
  super.key,
});
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `title` | `Widget` | 标题栏。通常为 `Row`，内含图标、标题文字、计数等 |
| `content` | `Widget` | 内容插槽，被 `Expanded` 包裹。通常传 `ListView` |

## 使用示例

```dart
BoardColumn(
  title: Row(children: [
    const Icon(Icons.list, size: 16, color: Color(0xFF333333)),
    const SizedBox(width: 8),
    const Flexible(
      child: Text('待办事项',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
    ),
    const Spacer(),
    Flexible(
      child: Text('${items.length} 项',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11, color: Color(0xFF999999))),
    ),
  ]),
  content: ListView(
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
    children: items.map((i) => ItemCard(item: i)).toList(),
  ),
)
```
