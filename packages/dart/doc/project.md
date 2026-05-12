# Project

`flutter_quanttide_projects` 中的 Project 模型。

| 字段 | 类型 | 必填 | 说明 |
|:----|:----|:---:|:----|
| `id` | `String` | 是 | 唯一标识 |
| `name` | `String` | 是 | 项目标识名 |
| `createdAt` | `DateTime` | 是 | 创建时间 |
| `updatedAt` | `DateTime` | 是 | 更新时间 |
| `verboseName` | `String?` | 否 | 显示名称 |
| `readme` | `String?` | 否 | 项目说明 |
| `status` | `String` | 否 | 状态，默认 `drafting` |
| `priority` | `String` | 否 | 优先级，默认 `low` |

使用 freezed (`@unfreezed`) 生成不可变数据类，支持 `copyWith` 和 JSON 序列化。
