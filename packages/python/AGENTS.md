# AGENTS — python

## 代码风格

- 不写注释（除非被明确要求）
- ruff lint，target-version = py310
- ruff select = `["E", "F", "I", "N", "W"]`
- hatchling 构建
- pytest：testpaths = `["tests"]`，pythonpath = `["src"]`
- 遵循现有代码约定，模仿邻接文件风格
