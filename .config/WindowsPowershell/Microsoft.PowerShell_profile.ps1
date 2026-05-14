function __go_ws {
    param(
        [string]$SubPath = ""
    )
    $base = Join-Path $HOME "workspace"
    $target = if ([string]::IsNullOrWhiteSpace($SubPath)) { $base } else { Join-Path $base $SubPath }
    if (Test-Path $target) {
        Set-Location $target
    } else {
        Write-Host "Path not found: $target"
    }
}

function wp { __go_ws }
function proj { __go_ws "projects" }
function sb { __go_ws "sandbox" }
function shared { __go_ws "shared" }
function tpl { __go_ws "templates" }
function arc { __go_ws "archive" }
function note { __go_ws "notes" }
function tmp { __go_ws "temp" }

# >>> windots >>>
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
}
if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}
Set-Alias -Name c -Value clear -Force
# <<< windots <<<