# Promptor

个人 AI 工作流的模块化上下文工程框架。

## 概述

Promptor 提供结构化的方式来管理跨项目的 AI 提示词、命令和上下文知识。通过符号链接机制共享通用资源，同时维护项目特定配置。

## 安装

通过 GitHub（推荐）：

```shell
/plugin marketplace add pchuan98/promptor

/plugin install core@chuan
/plugin install common@chuan
/plugin install avalonia@chuan
```

## 架构

框架由三个核心模块组成：

- **common**: 共享资源，包括命令、代理和提示词库
- **core**: 基础思维框架和核心工具
- **avalonia**: Avalonia项目特定的上下文配置和模板

## 其他

### 1. 管理链接

`link.ps1` 脚本负责符号链接自动创建。编辑 `$linkMappings` 变量以配置额外的资源链接：

```powershell
$linkMappings = @{
    "common\commands\commit.md" = ".claude\commands\commit.md"
    "common\agents\reviewer.md" = ".claude\agents\reviewer.md"
}
```