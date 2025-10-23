# 符号链接创建脚本
# 用于将 common 目录下的文件链接到 .claude 目录

# 配置：定义需要创建符号链接的文件
# 格式：@{ "源路径(相对于项目根目录)" = "目标路径(相对于项目根目录)" }
$linkMappings = @{
    "common\commands\commit.md" = ".claude\commands\commit.md"
    # 未来添加更多文件映射，例如：
    # "common\commands\review.md" = ".claude\commands\review.md"
    # "common\config\settings.json" = ".claude\config\settings.json"
}

# 获取脚本所在目录（项目根目录）
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`n=== 符号链接创建工具 ===" -ForegroundColor Cyan
Write-Host "项目根目录: $scriptDir`n" -ForegroundColor Gray

$successCount = 0
$skipCount = 0
$errorCount = 0

foreach ($mapping in $linkMappings.GetEnumerator()) {
    $sourcePath = Join-Path $scriptDir $mapping.Key
    $targetPath = Join-Path $scriptDir $mapping.Value
    $displayPath = "$($mapping.Key) -> $($mapping.Value)"

    # 检查源文件是否存在
    if (-not (Test-Path $sourcePath)) {
        Write-Host "[ERROR] $displayPath - 源文件不存在" -ForegroundColor Red
        $errorCount++
        continue
    }

    # 确保目标目录存在
    $targetDir = Split-Path -Parent $targetPath
    if (-not (Test-Path $targetDir)) {
        Write-Host "[INFO] 创建目录: $($mapping.Value | Split-Path -Parent)" -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # 检查目标文件状态
    if (Test-Path $targetPath) {
        $item = Get-Item $targetPath -Force

        # 检查是否已经是符号链接
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            # 检查链接目标是否正确
            $linkTarget = $item.Target
            if ($linkTarget -eq $sourcePath) {
                Write-Host "[SKIP] $displayPath - 符号链接已存在" -ForegroundColor Magenta
                $skipCount++
            } else {
                Write-Host "[WARN] $displayPath - 符号链接指向错误目标，需手动处理" -ForegroundColor Yellow
                $skipCount++
            }
        } else {
            # 是普通文件
            Write-Host "[WARN] $displayPath - 目标位置已存在普通文件，需手动删除" -ForegroundColor Yellow
            $skipCount++
        }
    } else {
        # 目标不存在，创建符号链接
        try {
            New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath -Force | Out-Null
            Write-Host "[OK] $displayPath - 符号链接创建成功" -ForegroundColor Green
            $successCount++
        } catch {
            Write-Host "[ERROR] $displayPath - 创建失败，可能需要管理员权限" -ForegroundColor Red
            $errorCount++
        }
    }
}

# 输出统计信息
Write-Host "=== 完成 ===" -ForegroundColor Cyan
Write-Host "成功创建: $successCount" -ForegroundColor Green
Write-Host "跳过: $skipCount" -ForegroundColor Yellow
Write-Host "失败: $errorCount" -ForegroundColor Red

if ($errorCount -gt 0) {
    Write-Host "`n提示: 如果遇到权限错误，请以管理员身份运行此脚本" -ForegroundColor Yellow
}

Write-Host "`n按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
