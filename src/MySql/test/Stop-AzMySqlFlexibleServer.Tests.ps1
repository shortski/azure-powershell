$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'Stop-AzMySqlFlexibleServer.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'Stop-AzMySqlFlexibleServer' {
    It 'Stop' {
        {
            Stop-AzMySqlFlexibleServer -ResourceGroupName $env.resourceGroup -Name $env.serverName
            Start-AzMySqlFlexibleServer -ResourceGroupName $env.resourceGroup -Name $env.serverName
        } | Should -Not -Throw
    }

    It 'StopViaIdentity' {
        {
            $ID = "/subscriptions/$($env.SubscriptionId)/resourceGroups/$($env.resourceGroup)/providers/Microsoft.DBForMySql/flexibleServers/$($env.serverName)/stop"
            Stop-AzMySqlFlexibleServer -InputObject $ID
        } | Should -Not -Throw
    }
}
