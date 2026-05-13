## 0.2.0

- 新增 CamelCase 模型支持：JSON 输入输出自动转换 camelCase（`createdAt`），Python 代码保持 snake_case（`created_at`）
- 新增 `CamelCaseModel` 基类，Create/Update/Response Schema 均继承此基类
- 新增响应模型别名支持，所有端点使用 `response_model_by_alias=True`
- 更新文档，说明 camelCase JSON 传输约定

## 0.1.1

- 移除内置 storage 模块，存储通过回调注入
- 新增 ProjectRouter、TaskRouter 标准路由器
- 新增示例和用户文档

## 0.1.0

- 正式发布
- ModelRouter 自动注册 CRUD 路由
- 标准路由器（ProjectRouter、TaskRouter 等）

## 0.1.0-rc.1

- 初始测试发布
- ModelRouter 自动注册 CRUD 路由
- 标准路由器（ProjectRouter、TaskRouter 等）
