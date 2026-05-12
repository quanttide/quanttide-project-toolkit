# 融合目标模型

以 Matter 为主体，融合 Task 的 `assignee`，移除 `custom`（非基础库职责）。

| 字段 | 类型 | 必填 | 来源 | 说明 |
|:----|:----|:---:|:----|:----|
| `id` | `String` | 是 | Matter | 唯一标识 |
| `number` | `int` | 是 | Matter | 编号 |
| `createdAt` | `DateTime` | 是 | Matter | 创建时间 |
| `updatedAt` | `DateTime` | 是 | Matter | 更新时间 |
| `title` | `String` | 否 | Matter | 标题，默认 `''` |
| `description` | `String` | 否 | Matter | 描述，默认 `''` |
| `priority` | `String` | 否 | Matter | 优先级，默认 `low` |
| `status` | `String` | 否 | Matter | 状态，默认 `drafting` |
| `type` | `String` | 否 | Matter | 类型，默认 `default` |
| `assignee` | `String?` | 否 | Task | 负责人 |

**已移除的 Task 字段：** `category`、`tags`、`date`、`custom`

**结论：** Matter 结构更完整、更务实，是下一版本的基准模型。
