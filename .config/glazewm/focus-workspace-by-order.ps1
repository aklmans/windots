param(
  [Parameter(Mandatory = $true)]
  [ValidateRange(1, 9)]
  [int]$Slot
)

function Get-WorkspaceOrder {
  param([object]$Workspace)

  if ($null -ne $Workspace.name -and "$($Workspace.name)" -match '^\d+$') {
    return [int]$Workspace.name
  }

  if ($null -ne $Workspace.displayName -and "$($Workspace.displayName)" -match '^\s*(\d+)') {
    return [int]$matches[1]
  }

  return 9999
}

try {
  $workspaceResponse = glazewm query workspaces | ConvertFrom-Json
  if (-not $workspaceResponse.success -or $null -eq $workspaceResponse.data.workspaces) {
    exit 0
  }
  $workspaces = @($workspaceResponse.data.workspaces)
  $sortedWorkspaces = @($workspaces | Sort-Object `
    @{ Expression = { Get-WorkspaceOrder $_ } }, `
    @{ Expression = { "$($_.name)" } })

  $orderedNames = @($sortedWorkspaces | ForEach-Object { "$($_.name)" })

  if ($orderedNames.Count -eq 0 -or $Slot -gt $orderedNames.Count) {
    exit 0
  }

  $targetWorkspace = $orderedNames[$Slot - 1]
  glazewm command focus --workspace $targetWorkspace | Out-Null
}
catch {
  exit 0
}

