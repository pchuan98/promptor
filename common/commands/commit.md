# /commit <ISSUE>

---

根据当前stage的内容和过往的风格创建一个 git commit

## STRICT RULES

1. 如果过往的风格不确定，默认使用传统的 `feat: xxx` 这种风格
2. 如果用户输出了是 `#xx` ， 默认提交的是issue的id，commit需要能展现它，比如 `fix: xxx (#1)`
3. 允许使用的Type从Types Section中找

---

## Types

feat: A new feature
fix: A bug fix
docs: Documentation changes
style: Code style changes (formatting, etc)
refactor: Code changes that neither fix bugs nor add features
perf: Performance improvements
test: Adding or fixing tests
chore: Changes to the build process, tools, etc.

## Examples

```
feat: initialize personal context project (#1)

- Set up basic project structure
- Add initial configuration files (.gitignore, README.md)
- Create core directories src/ and docs/
- Add base build and run scripts
```