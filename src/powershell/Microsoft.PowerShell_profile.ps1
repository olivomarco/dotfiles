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
# plugin-equivalent modules (imported only if installed)
# ---------------------------------------------------------------------------
# posh-git => git plugin (branch/status in prompt is handled by Oh My Posh,
# but posh-git still gives rich `git` tab-completion)
if (Get-Module -ListAvailable -Name posh-git)       { Import-Module posh-git }
# Terminal-Icons => file-type icons in Get-ChildItem / ls
if (Get-Module -ListAvailable -Name Terminal-Icons) { Import-Module Terminal-Icons }
# Az.Tools.Predictor => az completion / suggestions
if (Get-Module -ListAvailable -Name Az.Tools.Predictor) { Import-Module Az.Tools.Predictor }
# DockerCompletion => docker plugin completions
if (Get-Module -ListAvailable -Name DockerCompletion) { Import-Module DockerCompletion }

# PSFzf => fzf plugin (Ctrl+R history, Ctrl+T files)
if ((Get-Module -ListAvailable -Name PSFzf) -and (Get-Command fzf -ErrorAction SilentlyContinue)) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ---------------------------------------------------------------------------
# external tool integrations
# ---------------------------------------------------------------------------
# zoxide => autojump replacement (`z <dir>` smart jumping)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell --cmd z | Out-String) })
}

# fnm => nvm replacement (fast Node version manager). Only init if installed.
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}

# kubectl completion (kubectl plugin)
if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    kubectl completion powershell | Out-String | Invoke-Expression
}

# ---------------------------------------------------------------------------
# aliases & functions (ported from .zshrc)
# ---------------------------------------------------------------------------
# ll => detailed listing. Terminal-Icons makes this colorful with icons.
function ll { Get-ChildItem -Force @args }
# x => exit
function x  { exit }
# always launch GitHub Copilot CLI with all permissions enabled
function copilot { copilot.exe --yolo @args }
# prefer bat over Get-Content for viewing files, if installed
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat @args }
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
