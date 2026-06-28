# PowerShell 7 profile — the Windows counterpart of ~/.zshrc.
#
# This file is symlinked to $PROFILE by setup-windows.ps1. It mirrors the zsh
# setup as closely as PowerShell allows: Oh My Posh provides the prompt (the
# powerlevel10k equivalent), PSReadLine provides syntax-aware editing,
# autosuggestions and persistent history, and a handful of modules cover the
# oh-my-zsh plugins (git, fzf, z/autojump, kube/docker completions).

# ---------------------------------------------------------------------------
# environment
# ---------------------------------------------------------------------------
$env:EDITOR = 'vim'
# add common ~/-relative tool dirs to PATH for this session (mirrors the
# PATH= line in .zshrc). System tool installs that non-pwsh apps also need
# (Python, kubelogin) are instead written to the *persistent* User PATH by
# setup-windows.ps1, so they are intentionally not repeated here.
$userPaths = @(
    "$HOME\bin",
    "$HOME\.local\bin",
    "$HOME\go\bin",
    "$HOME\.dotnet\tools"
)
foreach ($p in $userPaths) {
    if ((Test-Path $p) -and ($env:Path -notlike "*$p*")) {
        $env:Path = "$p;$env:Path"
    }
}

# ---------------------------------------------------------------------------
# PSReadLine — syntax highlighting, autosuggestions, history
# (zsh-syntax-highlighting + zsh-autosuggestions + history)
# ---------------------------------------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -MaximumHistoryCount 20000          # HISTSIZE/SAVEHIST=20000
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    # inline ghost-text suggestions from history + predictors (autosuggestions).
    # Prediction needs a real VT-capable terminal; swallow the error on
    # redirected/non-interactive hosts (e.g. when a script dot-sources this).
    try {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction Stop
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction Stop
        Set-PSReadLineOption -Colors @{ InlinePrediction = 'DarkGray' }
    } catch {
        # non-interactive / no virtual terminal — prediction unavailable, ignore
    }
    # arrow keys search history by what's already typed (like zsh history-substring)
    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    # Tab => rich menu completion (closer to zsh-completions feel)
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# ---------------------------------------------------------------------------
# plugin-equivalent modules (lazy-loaded to keep shell startup fast)
# ---------------------------------------------------------------------------
function Import-OptionalModuleOnce {
    param([Parameter(Mandatory)][string]$Name)
    if (-not (Get-Module -Name $Name)) {
        Import-Module $Name -ErrorAction SilentlyContinue
    }
}

# posh-git => git plugin. Oh My Posh already renders git status, so posh-git is
# loaded only on the first git command to enable its completions/helpers later.
function git {
    Remove-Item Function:\git -ErrorAction SilentlyContinue
    Import-OptionalModuleOnce posh-git
    & git @args
}

# Terminal-Icons => file-type icons in Get-ChildItem / ll, loaded on first use.
function Enable-TerminalIcons { Import-OptionalModuleOnce Terminal-Icons }

# Az.Tools.Predictor is intentionally not imported at startup; it adds noticeable
# latency to new shell sessions.

# DockerCompletion => docker plugin completions, loaded on first docker command.
function docker {
    Remove-Item Function:\docker -ErrorAction SilentlyContinue
    Import-OptionalModuleOnce DockerCompletion
    & docker @args
}

# PSFzf => fzf plugin (Ctrl+R history, Ctrl+T files). Run Enable-PsFzf once in a
# session to rebind the chords if needed.
function Enable-PsFzf {
    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        Import-OptionalModuleOnce PSFzf
        if (Get-Module -Name PSFzf) {
            Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        }
    }
}
Enable-PsFzf

# ---------------------------------------------------------------------------
# external tool integrations
# ---------------------------------------------------------------------------
# zoxide => autojump replacement (`z <dir>` smart jumping), loaded on first use.
function z {
    Remove-Item Function:\z -ErrorAction SilentlyContinue
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Invoke-Expression (& { (zoxide init powershell --cmd z | Out-String) })
        z @args
    }
}

# fnm => nvm replacement. Like the zsh profile's nvm setup, initialize it only
# when Node tooling is used.
function Initialize-Fnm {
    Remove-Item Function:\fnm,Function:\node,Function:\npm,Function:\npx -ErrorAction SilentlyContinue
    if (Get-Command fnm -CommandType Application -ErrorAction SilentlyContinue) {
        fnm env --use-on-cd | Out-String | Invoke-Expression
    }
}
function fnm  { Initialize-Fnm; & fnm @args }
function node { Initialize-Fnm; & node @args }
function npm  { Initialize-Fnm; & npm @args }
function npx  { Initialize-Fnm; & npx @args }

# kubectl completion is intentionally not generated at startup; generating the
# completion script adds noticeable latency to new shell sessions.

# ---------------------------------------------------------------------------
# aliases & functions (ported from .zshrc)
# ---------------------------------------------------------------------------
# ll => detailed listing. Terminal-Icons makes this colorful with icons.
function ll { Enable-TerminalIcons; Get-ChildItem -Force @args }
# x => exit
function x  { exit }
# always launch GitHub Copilot CLI with all permissions enabled
function copilot { copilot.exe --yolo @args }
# prefer bat over Get-Content for viewing files, if installed
function cat {
    if (Get-Command bat -ErrorAction SilentlyContinue) {
        bat @args
    } else {
        Get-Content @args
    }
}

# ---------------------------------------------------------------------------
# Oh My Posh prompt (the powerlevel10k equivalent) — loaded last
# ---------------------------------------------------------------------------
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $theme = "$HOME\prompt.omp.json"
    # The transient prompt (collapsing past prompts to a minimal symbol) is
    # driven by the "transient_prompt" block in the theme JSON and wired up by
    # `oh-my-posh init` automatically — no separate enable call is needed.
    if (Test-Path $theme) {
        oh-my-posh init pwsh --config $theme | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}

# ---------------------------------------------------------------------------
# machine-specific overrides (untracked; keeps the repo clean). Put any local
# or experimental tweaks in this file instead of editing the tracked profile,
# so `git status` stays clean. Sourced last so it can override anything above.
# ---------------------------------------------------------------------------
$localProfile = Join-Path (Split-Path $PROFILE) 'Microsoft.PowerShell_profile.local.ps1'
if (Test-Path $localProfile) { . $localProfile }
