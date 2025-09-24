<#
.SYNOPSIS
    M365环境健康报告生成器
.DESCRIPTION
    自动化检查Exchange Online, Azure AD, Teams的健康状态
#>

param(
    [string]$ConfigPath = ".\config.json"
)

# 导入模块
. ".\Modules\Exchange-Report.ps1"
. ".\Modules\AzureAD-Report.ps1"
. ".\Modules\Teams-Report.ps1"

# 初始化
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReportData = @{}

try {
    # 连接到M365服务
    Write-Host "连接到Microsoft 365服务..." -ForegroundColor Green
    Connect-M365Services
    
    # 执行各项检查
    $ReportData.Exchange = Get-ExchangeHealth
    $ReportData.AzureAD = Get-AzureADHealth  
    $ReportData.Teams = Get-TeamsHealth
    
    # 生成报告
    Generate-Report -Data $ReportData -Timestamp $Timestamp
    
} catch {
    Write-Error "脚本执行失败: $_"
} finally {
    # 清理连接
    Disconnect-M365Services
}
