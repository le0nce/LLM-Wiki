<#
.SYNOPSIS
    Installs LLM Wiki into a target project directory.
.DESCRIPTION
    Copies the wiki scaffold (CLAUDE.md, sources/, wiki/) into an existing project
    so Claude Code automatically picks up the wiki instructions.
.PARAMETER TargetPath
    Path to the project where the wiki should be installed. Defaults to current directory.
.EXAMPLE
    .\install.ps1 -TargetPath C:\Projects\my-app
    .\install.ps1  # installs into current directory
#>
param(
    [string]$TargetPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetPath = Resolve-Path $TargetPath -ErrorAction SilentlyContinue
if (-not $TargetPath) {
    Write-Error "Target path does not exist."
    exit 1
}

$targetStr = $TargetPath.ToString()

# Check for existing CLAUDE.md
if (Test-Path (Join-Path $targetStr "CLAUDE.md")) {
    $existing = Get-Content (Join-Path $targetStr "CLAUDE.md") -Raw
    if ($existing -match "LLM Wiki") {
        Write-Warning "CLAUDE.md already contains LLM Wiki instructions. Skipping CLAUDE.md."
    } else {
        # Append wiki instructions to existing CLAUDE.md
        $wikiInstructions = Get-Content (Join-Path $ScriptDir "CLAUDE.md") -Raw
        Add-Content -Path (Join-Path $targetStr "CLAUDE.md") -Value "`n`n$wikiInstructions"
        Write-Host "[+] Appended wiki instructions to existing CLAUDE.md"
    }
} else {
    Copy-Item (Join-Path $ScriptDir "CLAUDE.md") -Destination $targetStr
    Write-Host "[+] Created CLAUDE.md"
}

# Create directory structure
$dirs = @("sources", "wiki\_index", "wiki\sources", "wiki\entities", "wiki\concepts", "wiki\analyses")
foreach ($dir in $dirs) {
    $fullPath = Join-Path $targetStr $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "[+] Created $dir/"
    }
}

# Copy template files (don't overwrite existing)
$templates = @(
    @{ Src = "wiki\_index\index.md";  Dst = "wiki\_index\index.md" },
    @{ Src = "wiki\_index\log.md";    Dst = "wiki\_index\log.md" },
    @{ Src = "wiki\overview.md";      Dst = "wiki\overview.md" },
    @{ Src = "wiki\conventions.md";   Dst = "wiki\conventions.md" }
)

foreach ($t in $templates) {
    $dst = Join-Path $targetStr $t.Dst
    if (-not (Test-Path $dst)) {
        Copy-Item (Join-Path $ScriptDir $t.Src) -Destination $dst
        Write-Host "[+] Created $($t.Dst)"
    } else {
        Write-Host "[ ] Skipped $($t.Dst) (already exists)"
    }
}

Write-Host ""
Write-Host "LLM Wiki installed into: $targetStr"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Drop source documents into sources/"
Write-Host "  2. Open Claude Code and say: /wiki ingest"
Write-Host "  3. Query with: /wiki query <your question>"
