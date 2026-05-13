# FastAPI Example

```bash
pip install uvicorn
uvicorn main:app --reload
```

## 对比

| | 手写 CRUD | 使用本库 |
|---|---|---|
| main.py | 168 行 | 8 行 |
| Schema | 4 个 class | 自动生成 |
| 路由函数 | 10 个 | 2 个 `include_router` |
