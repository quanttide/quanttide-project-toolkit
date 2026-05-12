# 任务`Task`

标识
- 标识`id`(`String`): 唯一标识。
- 标题`title`(`String`): 标题。
- 描述`description`(`String`): 描述，默认 `''`。

分类
- 类型`type`(`String?`): 系统维护的互斥分类。
- 类别`category`(`String?`): 人类或 AI 维护的互斥分类。
- 标签`tags`(`Map<String, String>`): 非互斥的多维度标记，默认 `{}`。

状态
- 状态`status`(`String?`): 状态。
- 优先级`priority`(`String?`): 优先级。

上下文
- 指派者`assigner`(`String?`): 指派者。
- 负责人`assignee`(`String?`): 负责人。

计划
- 开始时间`startAt`(`DateTime?`): 开始时间。
- 结束时间`endAt`(`DateTime?`): 结束时间。

审计
- 创建人`createdBy`(`String?`): 创建人。
- 创建时间`createdAt`(`DateTime?`): 创建时间。
- 更新人`updatedBy`(`String?`): 更新人。
- 更新时间`updatedAt`(`DateTime?`): 更新时间。
