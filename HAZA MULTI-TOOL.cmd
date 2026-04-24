<# :
@echo off
chcp 65001 >nul
title HAZA MULTI-TOOL - System Initialization
color 0B
cls
echo =============================================
echo.
echo      ██╗  ██╗ █████╗ ███████╗ █████╗ 
echo      ██║  ██║██╔══██╗╚══███╔╝██╔══██╗
echo      ███████║███████║  ███╔╝ ███████║
echo      ██╔══██║██╔══██║ ███╔╝  ██╔══██║
echo      ██║  ██║██║  ██║███████╗██║  ██║
echo      ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
echo.                                          
echo         M U L T I - T O O L   v2.0
echo =============================================
echo.
echo  [*] Initializing Core Environment...
echo  [*] Loading UI Components and Modules...
echo  [*] Starting HAZA Engine...
echo.
echo  Please wait... Your workspace is getting ready!
echo.
echo ==============================================
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command - < "%~f0"
exit /b
#>
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[System.Windows.Forms.Application]::EnableVisualStyles()

# Colors and Styling
$bgColor = [System.Drawing.Color]::FromArgb(30, 30, 35)
$panelColor = [System.Drawing.Color]::FromArgb(45, 45, 50)
$textColor = [System.Drawing.Color]::White
$accentColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$accentHover = [System.Drawing.Color]::FromArgb(45, 145, 235)
$btnColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
$btnHoverColor = [System.Drawing.Color]::FromArgb(85, 85, 90)

$form = New-Object System.Windows.Forms.Form
$form.Text = "HAZA MULTI-TOOL v2.0"
$form.Size = New-Object System.Drawing.Size(750, 680)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bgColor
$form.ForeColor = $textColor
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$titleFont = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$subTitleFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)
$headerFont = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$font = New-Object System.Drawing.Font("Segoe UI", 11)
$smallFont = New-Object System.Drawing.Font("Segoe UI", 9)

function Convert-PathShortcut {
    param([string]$path)
    if ([string]::IsNullOrWhiteSpace($path)) { return "" }
    $lower = $path.ToLower().Trim()
    if ($lower -eq "desktop") { return [Environment]::GetFolderPath("Desktop") }
    if ($lower -eq "documents") { return [Environment]::GetFolderPath("MyDocuments") }
    if ($lower -eq "downloads") { return (Join-Path $env:USERPROFILE "Downloads") }
    return $path
}

function Add-HoverEffect($btn, $defaultColor, $hoverColor) {
    $btn.Add_MouseEnter({ $this.BackColor = $hoverColor }.GetNewClosure())
    $btn.Add_MouseLeave({ $this.BackColor = $defaultColor }.GetNewClosure())
}

# Panels
$pnlMainMenu = New-Object System.Windows.Forms.Panel; $pnlMainMenu.Dock = "Fill"
$pnlBackup = New-Object System.Windows.Forms.Panel; $pnlBackup.Dock = "Fill"; $pnlBackup.Visible = $false
$pnlCreate = New-Object System.Windows.Forms.Panel; $pnlCreate.Dock = "Fill"; $pnlCreate.Visible = $false
$pnlOpen = New-Object System.Windows.Forms.Panel; $pnlOpen.Dock = "Fill"; $pnlOpen.Visible = $false
$pnlNet = New-Object System.Windows.Forms.Panel; $pnlNet.Dock = "Fill"; $pnlNet.Visible = $false
$pnlReadme = New-Object System.Windows.Forms.Panel; $pnlReadme.Dock = "Fill"; $pnlReadme.Visible = $false
$pnlGitMenu = New-Object System.Windows.Forms.Panel; $pnlGitMenu.Dock = "Fill"; $pnlGitMenu.Visible = $false
$pnlGit = New-Object System.Windows.Forms.Panel; $pnlGit.Dock = "Fill"; $pnlGit.Visible = $false
$pnlGitClone = New-Object System.Windows.Forms.Panel; $pnlGitClone.Dock = "Fill"; $pnlGitClone.Visible = $false
$pnlGitRelease = New-Object System.Windows.Forms.Panel; $pnlGitRelease.Dock = "Fill"; $pnlGitRelease.Visible = $false
$pnlGitRepoMgr = New-Object System.Windows.Forms.Panel; $pnlGitRepoMgr.Dock = "Fill"; $pnlGitRepoMgr.Visible = $false
$pnlGitRepoCreate = New-Object System.Windows.Forms.Panel; $pnlGitRepoCreate.Dock = "Fill"; $pnlGitRepoCreate.Visible = $false
$pnlGitRepoDelete = New-Object System.Windows.Forms.Panel; $pnlGitRepoDelete.Dock = "Fill"; $pnlGitRepoDelete.Visible = $false

$form.Controls.AddRange(@($pnlMainMenu, $pnlBackup, $pnlCreate, $pnlOpen, $pnlNet, $pnlReadme, $pnlGitMenu, $pnlGit, $pnlGitClone, $pnlGitRelease, $pnlGitRepoMgr, $pnlGitRepoCreate, $pnlGitRepoDelete))

function Switch-Panel($showPnl) {
    $pnlMainMenu.Visible = $false; $pnlBackup.Visible = $false; $pnlCreate.Visible = $false
    $pnlOpen.Visible = $false; $pnlNet.Visible = $false
    $pnlReadme.Visible = $false; $pnlGitMenu.Visible = $false; $pnlGit.Visible = $false; $pnlGitClone.Visible = $false; $pnlGitRelease.Visible = $false
    $pnlGitRepoMgr.Visible = $false; $pnlGitRepoCreate.Visible = $false; $pnlGitRepoDelete.Visible = $false
    $showPnl.Visible = $true
}

# Component Builders
function Create-Button($text, $x, $y, $w, $h, $action, $isAccent) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text; $btn.Size = New-Object System.Drawing.Size($w, $h); $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.Font = $font; $btn.FlatStyle = 'Flat'; $btn.FlatAppearance.BorderSize = 0; $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    if ($isAccent) { $btn.BackColor = $accentColor; Add-HoverEffect $btn $accentColor $accentHover }
    else { $btn.BackColor = $btnColor; Add-HoverEffect $btn $btnColor $btnHoverColor }
    $btn.Add_Click($action); return $btn
}

function Create-Label($text, $fnt, $x, $y) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text; $lbl.Font = $fnt; $lbl.AutoSize = $true; $lbl.Location = New-Object System.Drawing.Point($x, $y)
    return $lbl
}

function Create-TextBox($x, $y, $w) {
    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Location = New-Object System.Drawing.Point($x, $y); $txt.Size = New-Object System.Drawing.Size($w, 30)
    $txt.Font = $font; $txt.BackColor = $panelColor; $txt.ForeColor = $textColor; $txt.BorderStyle = 'FixedSingle'
    return $txt
}

# --- MAIN MENU ---
$lblTitle = Create-Label "HAZA MULTI-TOOL" $titleFont 0 40
$lblTitle.AutoSize = $false; $lblTitle.Width = 750; $lblTitle.TextAlign = 'MiddleCenter'

$lblSub = Create-Label "Advanced Utility Dashboard - Elevated Experience" $subTitleFont 0 85
$lblSub.AutoSize = $false; $lblSub.Width = 750; $lblSub.TextAlign = 'MiddleCenter'; $lblSub.ForeColor = [System.Drawing.Color]::Gray

$pnlMainMenu.Controls.AddRange(@($lblTitle, $lblSub))

# Dashboard Grid Buttons
$btnMainBackup = Create-Button "BACKUP FOLDER`nSync Data Safely" 80 140 280 80 { Switch-Panel $pnlBackup } $true
$btnMainCreate = Create-Button "CREATE FILES`nQuick File Generator" 380 140 280 80 { Switch-Panel $pnlCreate } $true
$btnMainOpen   = Create-Button "APP PROFILES`nLaunch Workspaces" 80 240 280 80 { Switch-Panel $pnlOpen } $true
$btnMainNet    = Create-Button "NETWORK TOOLS`nTesting & IPs" 380 240 280 80 { Switch-Panel $pnlNet } $true
$btnMainGit    = Create-Button "GITHUB MANAGER`nManage your GitHub" 80 340 280 80 { Switch-Panel $pnlGitMenu } $true
$btnMainReadme = Create-Button "READ ME`nInstructions & Help" 380 340 280 80 { Switch-Panel $pnlReadme } $true
$btnMainExit   = Create-Button "EXIT TOOL" 225 440 300 50 { $form.Close() } $false

$lblFooter = Create-Label "Designed by HAZA" $smallFont 0 580
$lblFooter.AutoSize = $false; $lblFooter.Width = 750; $lblFooter.TextAlign = 'MiddleCenter'; $lblFooter.ForeColor = [System.Drawing.Color]::DarkGray

$pnlMainMenu.Controls.AddRange(@($btnMainBackup, $btnMainCreate, $btnMainOpen, $btnMainNet, $btnMainGit, $btnMainReadme, $btnMainExit, $lblFooter))

# --- BACKUP MODULE ---
$lblBackupTitle = Create-Label "BACKUP WIZARD" $headerFont 0 40
$lblBackupTitle.AutoSize = $false; $lblBackupTitle.Width = 750; $lblBackupTitle.TextAlign = 'MiddleCenter'

$lblSrc = Create-Label "Source Folder (type 'desktop', 'documents', 'downloads' to auto-detect):" $font 50 120
$txtSrc = Create-TextBox 50 150 530
$btnBrowseSrc = Create-Button "Browse" 590 150 90 28 {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") { $txtSrc.Text = $fbd.SelectedPath }
} $false
$btnBrowseSrc.Font = $smallFont

$lblDst = Create-Label "Destination Folder:" $font 50 200
$txtDst = Create-TextBox 50 230 530
$btnBrowseDst = Create-Button "Browse" 590 230 90 28 {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") { $txtDst.Text = $fbd.SelectedPath }
} $false
$btnBrowseDst.Font = $smallFont

$lblBackupStatus = Create-Label "" $font 50 300
$lblBackupStatus.AutoSize = $false; $lblBackupStatus.Width = 650

$btnStartBackup = Create-Button "START BACKUP" 50 400 300 50 {
    $src = Convert-PathShortcut $txtSrc.Text
    $dst = Convert-PathShortcut $txtDst.Text
    if ($src -eq "" -or $dst -eq "") { [System.Windows.Forms.MessageBox]::Show("Please enter both source and destination folders."); return }
    if (!(Test-Path $src)) { [System.Windows.Forms.MessageBox]::Show("Source folder does not exist!"); return }
    $lblBackupStatus.Text = "Status: Processing Backup... Please wait."
    $lblBackupStatus.ForeColor = [System.Drawing.Color]::Yellow; $form.Update()
    Start-Process -FilePath "robocopy" -ArgumentList "`"$src`" `"$dst`" /E /MT:4 /NFL /NDL /NJH /NJS /NP" -Wait -WindowStyle Hidden
    $lblBackupStatus.Text = "Status: Backup Completed Successfully!"
    $lblBackupStatus.ForeColor = [System.Drawing.Color]::LightGreen
} $true

$btnBackBackup = Create-Button "BACK TO MENU" 380 400 300 50 {
    $lblBackupStatus.Text = ""; Switch-Panel $pnlMainMenu
} $false

$pnlBackup.Controls.AddRange(@($lblBackupTitle, $lblSrc, $txtSrc, $btnBrowseSrc, $lblDst, $txtDst, $btnBrowseDst, $lblBackupStatus, $btnStartBackup, $btnBackBackup))

# --- CREATE MODULE ---
$lblCreateTitle = Create-Label "FILE CREATOR" $headerFont 0 40
$lblCreateTitle.AutoSize = $false; $lblCreateTitle.Width = 750; $lblCreateTitle.TextAlign = 'MiddleCenter'

$lblCPath = Create-Label "Folder Path (type 'desktop', 'documents', 'downloads' to auto-detect):" $font 80 120
$txtCPath = Create-TextBox 80 150 490
$btnCBrowse = Create-Button "Browse" 580 150 90 28 {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") { $txtCPath.Text = $fbd.SelectedPath }
} $false
$btnCBrowse.Font = $smallFont

$lblCName = Create-Label "Filename (e.g., index.html, script.js):" $font 80 200
$txtCName = Create-TextBox 80 230 490

$lblCreateStatus = Create-Label "" $font 80 300
$lblCreateStatus.AutoSize = $false; $lblCreateStatus.Width = 590

$btnStartCreate = Create-Button "CREATE FILE" 80 400 280 50 {
    $path = Convert-PathShortcut $txtCPath.Text
    $name = $txtCName.Text
    if ($path -eq "" -or $name -eq "") { [System.Windows.Forms.MessageBox]::Show("Please enter path and filename."); return }
    try {
        if (!(Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
        $fullPath = Join-Path $path $name
        New-Item -ItemType File -Path $fullPath -Force | Out-Null
        $lblCreateStatus.Text = "Success: '$name' created in $($path)."
        $lblCreateStatus.ForeColor = [System.Drawing.Color]::LightGreen
    } catch {
        $lblCreateStatus.Text = "Error: $($_.Exception.Message)"
        $lblCreateStatus.ForeColor = [System.Drawing.Color]::Red
    }
} $true

$btnBackCreate = Create-Button "BACK TO MENU" 390 400 280 50 {
    $lblCreateStatus.Text = ""; Switch-Panel $pnlMainMenu
} $false

$pnlCreate.Controls.AddRange(@($lblCreateTitle, $lblCPath, $txtCPath, $btnCBrowse, $lblCName, $txtCName, $lblCreateStatus, $btnStartCreate, $btnBackCreate))

# --- OPEN MODULE ---
$lblOpenTitle = Create-Label "ENVIRONMENT PROFILES" $headerFont 0 40
$lblOpenTitle.AutoSize = $false; $lblOpenTitle.Width = 750; $lblOpenTitle.TextAlign = 'MiddleCenter'

$btnOpenDev = Create-Button "DEVELOPMENT (VS Code, Notepad, Browser)" 120 120 510 60 {
    Start-Process "code" -ArgumentList "." -ErrorAction SilentlyContinue
    Start-Process "notepad.exe"
    Start-Process "https://github.com"
    Switch-Panel $pnlMainMenu
} $true

$btnOpenEnt = Create-Button "ENTERTAINMENT (YouTube, Facebook, Netflix)" 120 200 510 60 {
    Start-Process "https://www.youtube.com"
    Start-Process "https://www.facebook.com"
    Start-Process "https://www.netflix.com"
    Switch-Panel $pnlMainMenu
} $true

$btnOpenProd = Create-Button "PRODUCTIVITY (Excel, PowerPoint, Word)" 120 280 510 60 {
    Start-Process "excel" -ErrorAction SilentlyContinue
    Start-Process "powerpnt" -ErrorAction SilentlyContinue
    Start-Process "winword" -ErrorAction SilentlyContinue
    Switch-Panel $pnlMainMenu
} $true

$btnBackOpen = Create-Button "BACK TO MENU" 220 380 310 50 {
    Switch-Panel $pnlMainMenu
} $false

$pnlOpen.Controls.AddRange(@($lblOpenTitle, $btnOpenDev, $btnOpenEnt, $btnOpenProd, $btnBackOpen))

# --- NETWORK MODULE ---
$lblNetTitle = Create-Label "NETWORK TOOLS" $headerFont 0 40
$lblNetTitle.AutoSize = $false; $lblNetTitle.Width = 750; $lblNetTitle.TextAlign = 'MiddleCenter'

$txtNetLogs = New-Object System.Windows.Forms.TextBox
$txtNetLogs.Location = New-Object System.Drawing.Point(80, 100)
$txtNetLogs.Size = New-Object System.Drawing.Size(590, 260)
$txtNetLogs.Multiline = $true; $txtNetLogs.ReadOnly = $true; $txtNetLogs.ScrollBars = 'Vertical'
$txtNetLogs.BackColor = $panelColor; $txtNetLogs.ForeColor = $textColor; $txtNetLogs.Font = $smallFont

$btnPing = Create-Button "Check Internet (Ping)" 80 380 180 50 {
    $txtNetLogs.Text = "Pinging Google (8.8.8.8)...`r`n"
    $form.Update()
    $result = Test-Connection -ComputerName "8.8.8.8" -Count 4 -ErrorAction SilentlyContinue
    if ($result) {
        $txtNetLogs.AppendText("Internet Connected:`r`n")
        $result | ForEach-Object { $txtNetLogs.AppendText("Reply from $($_.Address) : time=$($_.ResponseTime)ms`r`n") }
    } else {
        $txtNetLogs.AppendText("Request timed out. No internet access.`r`n")
    }
} $true

$btnIp = Create-Button "Show My IP" 280 380 180 50 {
    $txtNetLogs.Text = "Fetching Network Configuration...`r`n"
    $form.Update()
    $ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Wi-Fi -ErrorAction SilentlyContinue).IPAddress
    if (!$ip) { $ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet -ErrorAction SilentlyContinue).IPAddress }
    if ($ip) { $txtNetLogs.AppendText("`r`nLocal IPv4 Address: $ip`r`n") }
    else { $txtNetLogs.AppendText("`r`nCould not determine Local IP Address.`r`n") }
} $true

$btnBackNet = Create-Button "MENU" 490 380 180 50 {
    $txtNetLogs.Text = ""; Switch-Panel $pnlMainMenu
} $false

$pnlNet.Controls.AddRange(@($lblNetTitle, $txtNetLogs, $btnPing, $btnIp, $btnBackNet))

# --- GITHUB SUB-MENU MODULE ---
$lblGitMenuTitle = Create-Label "GITHUB MANAGER" $headerFont 0 40
$lblGitMenuTitle.AutoSize = $false; $lblGitMenuTitle.Width = 750; $lblGitMenuTitle.TextAlign = 'MiddleCenter'

$btnGitMenuPush = Create-Button "PUSH TO GITHUB`nSync & Upload Files" 120 100 510 55 { Switch-Panel $pnlGit } $true
$btnGitMenuClone = Create-Button "CLONE FROM GITHUB`nDownload Repository" 120 165 510 55 { Switch-Panel $pnlGitClone } $true
$btnGitMenuRelease = Create-Button "CREATE RELEASE`nDraft Release Version" 120 230 510 55 { Switch-Panel $pnlGitRelease } $true
$btnGitMenuRepoMgr = Create-Button "REPOSITORY MANAGER`nCreate or Delete Repos" 120 295 510 55 { Switch-Panel $pnlGitRepoMgr } $true

$btnBackGitMenu = Create-Button "BACK TO DASHBOARD" 225 370 300 50 { Switch-Panel $pnlMainMenu } $false
$pnlGitMenu.Controls.AddRange(@($lblGitMenuTitle, $btnGitMenuPush, $btnGitMenuClone, $btnGitMenuRelease, $btnGitMenuRepoMgr, $btnBackGitMenu))

# --- GITHUB REPOSITORY MANAGER SUB-MENU ---
$lblGitRepoTitle = Create-Label "REPOSITORY MANAGER" $headerFont 0 40
$lblGitRepoTitle.AutoSize = $false; $lblGitRepoTitle.Width = 750; $lblGitRepoTitle.TextAlign = 'MiddleCenter'

$btnRepoGoCreate = Create-Button "CREATE NEW REPOSITORY`nSetup new project on GitHub" 120 120 510 65 { Switch-Panel $pnlGitRepoCreate } $true
$btnRepoGoDelete = Create-Button "DELETE REPOSITORY`nRemove existing repo permanently" 120 200 510 65 { Switch-Panel $pnlGitRepoDelete } $false
$btnRepoGoDelete.BackColor = [System.Drawing.Color]::FromArgb(180, 40, 40)

$btnBackRepoMgr = Create-Button "BACK TO GITHUB MENU" 225 320 300 50 { Switch-Panel $pnlGitMenu } $false
$pnlGitRepoMgr.Controls.AddRange(@($lblGitRepoTitle, $btnRepoGoCreate, $btnRepoGoDelete, $btnBackRepoMgr))

# --- CREATE REPOSITORY PANEL ---
$lblRepoCTitle = Create-Label "CREATE NEW REPOSITORY" $headerFont 0 30
$lblRepoCTitle.AutoSize = $false; $lblRepoCTitle.Width = 750; $lblRepoCTitle.TextAlign = 'MiddleCenter'

$lblRepoCName = Create-Label "Repository Name:" $smallFont 50 80
$txtRepoCName = Create-TextBox 50 105 310

$lblRepoCVis = Create-Label "Visibility:" $smallFont 380 80
$cmbRepoCVis = New-Object System.Windows.Forms.ComboBox
$cmbRepoCVis.Items.AddRange(@("public", "private")); $cmbRepoCVis.SelectedIndex = 0
$cmbRepoCVis.Location = New-Object System.Drawing.Point(380, 105); $cmbRepoCVis.Size = New-Object System.Drawing.Size(120, 30)
$cmbRepoCVis.Font = $smallFont; $cmbRepoCVis.DropDownStyle = "DropDownList"

$chkAddReadme = New-Object System.Windows.Forms.CheckBox
$chkAddReadme.Text = "Add README.md"; $chkAddReadme.Location = New-Object System.Drawing.Point(520, 105)
$chkAddReadme.Font = $smallFont; $chkAddReadme.AutoSize = $true; $chkAddReadme.ForeColor = $textColor

$lblRepoCDesc = Create-Label "Description:" $smallFont 50 150
$txtRepoCDesc = Create-TextBox 50 175 600

# Master Lists for Search
$allLicenses = @("none", "agpl-3.0", "apache-2.0", "bsd-2-clause", "bsd-3-clause", "bsl-1.0", "cc0-1.0", "epl-2.0", "gpl-2.0", "gpl-3.0", "lgpl-2.1", "mit", "mpl-2.0", "unlicense")
$allIgnores = @("none", "Actionscript", "Ada", "Agda", "Android", "AppEngine", "AppceleratorTitanium", "ArchLinuxPackages", "Autotools", "C++", "C", "CakePHP", "Clojure", "CMake", "CodeIgniter", "CommonLisp", "Composer", "Concrete5", "Coq", "CraftCMS", "CUDA", "D", "Dart", "Delphi", "Drupal", "Eagle", "Elisp", "Elixir", "Elm", "Erlang", "ExpressionEngine", "ExtJS", "Fancy", "Finale", "ForceDotCom", "Fortran", "FuelPHP", "GWT", "Go", "Gradle", "Grails", "Haskell", "IGEPV8", "IgorPro", "Java", "JBoss", "Jekyll", "Joomla", "Julia", "Kohana", "Kotlin", "LabVIEW", "Laravel", "Leiningen", "LemonStand", "LilyPond", "Lithium", "Lua", "Magento", "Maven", "Mercury", "MetaProgrammingSystem", "Nanoc", "Nim", "Node", "OCaml", "Objective-C", "Opa", "OracleForms", "Packer", "Perl", "Phalcon", "PHP", "PlayFramework", "Plone", "PreSTop", "Puppet", "Python", "Qmake", "R", "Racket", "Rails", "Rhinoceros", "Ruby", "Rust", "Scala", "Scheme", "Scrivener", "Sdcc", "SeamGen", "SketchUp", "Smalltalk", "Stella", "SugarCRM", "Swift", "Symfony", "Tex", "Topne", "Typo3", "Umbraco", "Unity", "UnrealEngine", "VisualStudio", "VVVV", "Waf", "WordPress", "Xojo", "Yeoman", "ZendFramework", "Zephir")

$lblLicense = Create-Label "License (Searchable):" $smallFont 50 220
$cmbLicense = New-Object System.Windows.Forms.ComboBox
$cmbLicense.Items.AddRange($allLicenses); $cmbLicense.Text = "none"
$cmbLicense.Location = New-Object System.Drawing.Point(50, 245); $cmbLicense.Size = New-Object System.Drawing.Size(200, 30)
$cmbLicense.Font = $smallFont; $cmbLicense.DropDownStyle = "DropDown"
$cmbLicense.AutoCompleteMode = 'SuggestAppend'; $cmbLicense.AutoCompleteSource = 'ListItems'

$lblIgnore = Create-Label "Gitignore (Searchable):" $smallFont 270 220
$cmbIgnore = New-Object System.Windows.Forms.ComboBox
$cmbIgnore.Items.AddRange($allIgnores); $cmbIgnore.Text = "none"
$cmbIgnore.Location = New-Object System.Drawing.Point(270, 245); $cmbIgnore.Size = New-Object System.Drawing.Size(200, 30)
$cmbIgnore.Font = $smallFont; $cmbIgnore.DropDownStyle = "DropDown"
$cmbIgnore.AutoCompleteMode = 'SuggestAppend'; $cmbIgnore.AutoCompleteSource = 'ListItems'

$txtRepoCLogs = New-Object System.Windows.Forms.TextBox
$txtRepoCLogs.Location = New-Object System.Drawing.Point(50, 300)
$txtRepoCLogs.Size = New-Object System.Drawing.Size(630, 180)
$txtRepoCLogs.Multiline = $true; $txtRepoCLogs.ReadOnly = $true; $txtRepoCLogs.ScrollBars = 'Vertical'
$txtRepoCLogs.BackColor = $panelColor; $txtRepoCLogs.ForeColor = $textColor; $txtRepoCLogs.Font = $smallFont

$btnDoCreateRepo = Create-Button "CREATE REPOSITORY" 50 510 250 50 {
    $name = $txtRepoCName.Text; $desc = $txtRepoCDesc.Text; $vis = $cmbRepoCVis.Text
    $lic = $cmbLicense.Text; $ign = $cmbIgnore.Text
    if (!$name) { [System.Windows.Forms.MessageBox]::Show("Please enter a Repository Name."); return }
    
    $txtRepoCLogs.Text = "Building repository: $name...`r`n"
    $form.Update()
    
    $cmd = "gh repo create `"$name`" --$vis"
    if ($desc) { $cmd += " --description `"$desc`"" }
    if ($chkAddReadme.Checked) { $cmd += " --add-readme" }
    if ($lic -ne "none") { $cmd += " --license `"$lic`"" }
    if ($ign -ne "none") { $cmd += " --gitignore `"$ign`"" }
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "cmd.exe"; $pinfo.Arguments = "/c $cmd"
    $pinfo.RedirectStandardError = $true; $pinfo.RedirectStandardOutput = $true; $pinfo.UseShellExecute = $false; $pinfo.CreateNoWindow = $true
    
    $p = New-Object System.Diagnostics.Process; $p.StartInfo = $pinfo; $p.Start() | Out-Null
    $out = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    
    $txtRepoCLogs.AppendText($out)
    if ($p.ExitCode -eq 0) { 
        $txtRepoCLogs.AppendText("`r`n`r`n[!] SUCCESS! Your repository is ready.")
        $repoUrl = $out.Trim().Split("`n")[-1]
        if ($out -match "https://github.com/\S+") { 
             $txtRepoCLogs.AppendText("`r`n[!] REPO URL: $matches[0]")
        }
    }
} $true

$btnBackRepoC = Create-Button "BACK" 320 510 200 50 { Switch-Panel $pnlGitRepoMgr } $false

$pnlGitRepoCreate.Controls.AddRange(@($lblRepoCTitle, $lblRepoCName, $txtRepoCName, $lblRepoCVis, $cmbRepoCVis, $chkAddReadme, $lblRepoCDesc, $txtRepoCDesc, $lblLicense, $cmbLicense, $lblIgnore, $cmbIgnore, $txtRepoCLogs, $btnDoCreateRepo, $btnBackRepoC))

# --- DELETE REPOSITORY PANEL ---
$lblRepoDTitle = Create-Label "DELETE REPOSITORY" $headerFont 0 40
$lblRepoDTitle.AutoSize = $false; $lblRepoDTitle.Width = 750; $lblRepoDTitle.TextAlign = 'MiddleCenter'

$lblRepoDName = Create-Label "Repository URL or Name (eg: user/repo):" $font 80 120
$txtRepoDName = Create-TextBox 80 150 590

$txtRepoDLogs = New-Object System.Windows.Forms.TextBox
$txtRepoDLogs.Location = New-Object System.Drawing.Point(80, 220)
$txtRepoDLogs.Size = New-Object System.Drawing.Size(590, 200)
$txtRepoDLogs.Multiline = $true; $txtRepoDLogs.ReadOnly = $true; $txtRepoDLogs.ScrollBars = 'Vertical'
$txtRepoDLogs.BackColor = $panelColor; $txtRepoDLogs.ForeColor = $textColor; $txtRepoDLogs.Font = $smallFont

$btnDoDeleteRepo = Create-Button "DELETE PERMANENTLY" 80 450 250 50 {
    $input = $txtRepoDName.Text.Trim()
    if (!$input) { [System.Windows.Forms.MessageBox]::Show("Please enter the repository URL or Name (Owner/Repo)."); return }
    
    $confirm = [System.Windows.Forms.MessageBox]::Show("CRITICAL: Delete '$input'? This cannot be undone.", "Danger!", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Stop)
    if ($confirm -eq "No") { return }
    
    $txtRepoDLogs.Text = "Attempting to delete: $input...`r`n"
    $form.Update()
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "cmd.exe"; $pinfo.Arguments = "/c gh repo delete `"$input`" --yes"
    $pinfo.RedirectStandardError = $true; $pinfo.RedirectStandardOutput = $true; $pinfo.UseShellExecute = $false; $pinfo.CreateNoWindow = $true
    
    $p = New-Object System.Diagnostics.Process; $p.StartInfo = $pinfo; $p.Start() | Out-Null
    $out = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    
    $txtRepoDLogs.AppendText($out)
    if ($p.ExitCode -eq 0) { $txtRepoDLogs.AppendText("`r`n[!] SUCCESS: Repository Deleted!") }
    else { $txtRepoDLogs.AppendText("`r`n[!] FAILED: Check permissions or name format.") }
} $false
$btnDoDeleteRepo.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)

$btnRefreshScope = Create-Button "REFRESH PERMISSIONS" 350 450 180 50 {
    Start-Process "cmd.exe" -ArgumentList "/c gh auth refresh -h github.com -s delete_repo & pause"
} $false

$btnBackRepoD = Create-Button "BACK" 550 450 120 50 { Switch-Panel $pnlGitRepoMgr } $false

$pnlGitRepoDelete.Controls.AddRange(@($lblRepoDTitle, $lblRepoDName, $txtRepoDName, $txtRepoDLogs, $btnDoDeleteRepo, $btnRefreshScope, $btnBackRepoD))

# --- GITHUB RELEASE MODULE ---
$lblGitReleaseTitle = Create-Label "CREATE GITHUB RELEASE" $headerFont 0 40
$lblGitReleaseTitle.AutoSize = $false; $lblGitReleaseTitle.Width = 750; $lblGitReleaseTitle.TextAlign = 'MiddleCenter'

$lblGitRelPath = Create-Label "Project Folder (Path):" $font 50 80
$txtGitRelPath = Create-TextBox 50 110 530
$btnBrowseGitRel = Create-Button "Browse" 590 110 90 28 {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") { $txtGitRelPath.Text = $fbd.SelectedPath }
} $false
$btnBrowseGitRel.Font = $smallFont

$lblGitRelUrl = Create-Label "Repository URL (Required):" $font 50 150
$txtGitRelUrl = Create-TextBox 50 180 630

$lblGitRelTag = Create-Label "Version Tag (v1.0.0):" $font 50 230
$txtGitRelTag = Create-TextBox 50 260 250

$lblGitRelMsg = Create-Label "Release Notes / Message:" $font 330 230
$txtGitRelMsg = Create-TextBox 330 260 350
$txtGitRelMsg.Text = "Release v1.0"

$txtGitRelLogs = New-Object System.Windows.Forms.TextBox
$txtGitRelLogs.Location = New-Object System.Drawing.Point(50, 310)
$txtGitRelLogs.Size = New-Object System.Drawing.Size(630, 220)
$txtGitRelLogs.Multiline = $true; $txtGitRelLogs.ReadOnly = $true; $txtGitRelLogs.ScrollBars = 'Vertical'
$txtGitRelLogs.BackColor = $panelColor; $txtGitRelLogs.ForeColor = $textColor; $txtGitRelLogs.Font = $smallFont

$btnStartRelease = Create-Button "CREATE FULL RELEASE" 50 550 200 50 {
    $path = Convert-PathShortcut $txtGitRelPath.Text
    $url = $txtGitRelUrl.Text
    $tag = $txtGitRelTag.Text; $msg = $txtGitRelMsg.Text
    
    if (!$path -or !$tag -or !$url) { [System.Windows.Forms.MessageBox]::Show("Please fill all fields (Path, URL, Tag)."); return }
    if (!(Test-Path $path)) { [System.Windows.Forms.MessageBox]::Show("Project path does not exist!"); return }

    # Check and Auto-Install GitHub CLI (gh)
    if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
        $msgResult = [System.Windows.Forms.MessageBox]::Show("GitHub CLI (gh) is not installed. Would you like to install it automatically now?", "Install Requirement", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
        if ($msgResult -eq "Yes") {
            $txtGitRelLogs.Text = "Status: Downloading and Installing GitHub CLI...`r`nThis may take a minute. Please wait.`r`n"
            $form.Update()
            
            # Use winget to install GitHub CLI
            $installPkg = Start-Process "winget" -ArgumentList "install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements" -Wait -PassThru -WindowStyle Hidden
            
            if ($installPkg.ExitCode -eq 0) {
                [System.Windows.Forms.MessageBox]::Show("Installation successful!`r`n`r`nIMPORTANT: Please RESTART HAZA MULTI-TOOL for the new settings to take effect.", "Restart Required")
                return
            } else {
                [System.Windows.Forms.MessageBox]::Show("Auto-installation failed.`r`nPlease install manually from: https://cli.github.com/", "Installation Error")
                return
            }
        }
        return
    }
    
    $txtGitRelLogs.Text = "Initiating release process...`r`n"
    $form.Update()

    # The command builds the release directly. If tag exists, it uses it.
    # Set upstream explicitly with -u origin HEAD
    $gitCmds = "git init & git remote remove origin 2>nul & git remote add origin `"$url`" & git add . & git commit -m `"Release $tag`" & git push -u origin HEAD & git tag -a `"$tag`" -m `"$msg`" 2>nul & git push origin `"$tag`" & gh release create `"$tag`" --title `"$tag`" --notes `"$msg`" --draft"
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "cmd.exe"
    $pinfo.RedirectStandardError = $true; $pinfo.RedirectStandardOutput = $true; $pinfo.UseShellExecute = $false; $pinfo.CreateNoWindow = $true
    $pinfo.WorkingDirectory = $path
    $pinfo.Arguments = "/c $gitCmds"
    
    $p = New-Object System.Diagnostics.Process; $p.StartInfo = $pinfo; $p.Start() | Out-Null
    $out = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    
    $txtGitRelLogs.AppendText($out)
    if ($out -like "*github.com/*/releases/tag/*" -or $out -like "*Draft release created*") {
        $txtGitRelLogs.AppendText("`r`n`r`n[!] SUCCESS: Draft Release Created!")
        $txtGitRelLogs.AppendText("`r`n[!] ACTION REQUIRED: Please visit your GitHub repository's 'Releases' page, edit the draft, and click 'Publish release' to make it public.")
    } else {
        $txtGitRelLogs.AppendText("`r`n`r`n[!] Push failed or Login required. Use the 'LOGIN TO GITHUB' button below.")
    }
} $true

$btnRelLogin = Create-Button "LOGIN TO GITHUB" 265 550 190 50 { 
    Start-Process "cmd.exe" -ArgumentList "/c gh auth login & pause"
} $false

$btnBackGitRelOps = Create-Button "BACK" 470 550 210 50 { 
    $txtGitRelLogs.Text = ""; Switch-Panel $pnlGitMenu 
} $false

$pnlGitRelease.Controls.AddRange(@($lblGitReleaseTitle, $lblGitRelPath, $txtGitRelPath, $btnBrowseGitRel, $lblGitRelUrl, $txtGitRelUrl, $lblGitRelTag, $txtGitRelTag, $lblGitRelMsg, $txtGitRelMsg, $txtGitRelLogs, $btnStartRelease, $btnRelLogin, $btnBackGitRelOps))

# --- GITHUB CLONE MODULE ---
$lblGitCloneTitle = Create-Label "CLONE REPOSITORY" $headerFont 0 40
$lblGitCloneTitle.AutoSize = $false; $lblGitCloneTitle.Width = 750; $lblGitCloneTitle.TextAlign = 'MiddleCenter'

$lblGitCloneUrl = Create-Label "Repository URL:" $font 50 120
$txtGitCloneUrl = Create-TextBox 50 150 630

$lblGitClonePath = Create-Label "Destination Folder (Path):" $font 50 220
$txtGitClonePath = Create-TextBox 50 250 530
$btnBrowseGitClone = Create-Button "Browse" 590 250 90 28 {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") { $txtGitClonePath.Text = $fbd.SelectedPath }
} $false
$btnBrowseGitClone.Font = $smallFont

$txtGitCloneLogs = New-Object System.Windows.Forms.TextBox
$txtGitCloneLogs.Location = New-Object System.Drawing.Point(50, 320)
$txtGitCloneLogs.Size = New-Object System.Drawing.Size(630, 180)
$txtGitCloneLogs.Multiline = $true; $txtGitCloneLogs.ReadOnly = $true; $txtGitCloneLogs.ScrollBars = 'Vertical'
$txtGitCloneLogs.BackColor = $panelColor; $txtGitCloneLogs.ForeColor = $textColor; $txtGitCloneLogs.Font = $smallFont

$btnStartClone = Create-Button "START CLONE" 50 520 200 50 {
    $url = $txtGitCloneUrl.Text
    $path = Convert-PathShortcut $txtGitClonePath.Text
    if (!$url -or !$path) { [System.Windows.Forms.MessageBox]::Show("Please fill all fields."); return }
    if (!(Test-Path $path)) { [System.Windows.Forms.MessageBox]::Show("Destination path does not exist!"); return }
    
    $txtGitCloneLogs.Text = "Cloning repository into: $path`r`n--------------------------------------------`r`n"
    $form.Update()
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "cmd.exe"
    $pinfo.RedirectStandardError = $true; $pinfo.RedirectStandardOutput = $true; $pinfo.UseShellExecute = $false; $pinfo.CreateNoWindow = $true
    $pinfo.WorkingDirectory = $path
    $pinfo.Arguments = "/c git clone `"$url`""
    
    $p = New-Object System.Diagnostics.Process; $p.StartInfo = $pinfo; $p.Start() | Out-Null
    $out = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    
    $txtGitCloneLogs.AppendText($out + "`r`n`r`n[!] Clone Completed!")
} $true

$btnBackGitCloneOps = Create-Button "BACK TO GIT MENU" 430 520 250 50 { 
    $txtGitCloneLogs.Text = ""; Switch-Panel $pnlGitMenu 
} $false

$pnlGitClone.Controls.AddRange(@($lblGitCloneTitle, $lblGitCloneUrl, $txtGitCloneUrl, $lblGitClonePath, $txtGitClonePath, $btnBrowseGitClone, $txtGitCloneLogs, $btnStartClone, $btnBackGitCloneOps))

# --- GITHUB OPS MODULE ---
$lblGitTitle = Create-Label "PUSH TO GITHUB" $headerFont 0 30
$lblGitTitle.AutoSize = $false; $lblGitTitle.Width = 750; $lblGitTitle.TextAlign = 'MiddleCenter'

$lblGitPath = Create-Label "Project Folder (Path):" $font 50 80
$txtGitPath = Create-TextBox 50 110 530
$btnBrowseGit = Create-Button "Browse" 590 110 90 28 {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq "OK") { $txtGitPath.Text = $fbd.SelectedPath }
} $false
$btnBrowseGit.Font = $smallFont

$lblGitMsg = Create-Label "Commit Message:" $font 50 150
$txtGitMsg = Create-TextBox 50 180 300
$txtGitMsg.Text = "Init"

$lblGitBranch = Create-Label "Branch:" $font 380 150
$txtGitBranch = Create-TextBox 380 180 200
$txtGitBranch.Text = "main"

$lblGitUrl = Create-Label "Repository URL:" $font 50 220
$txtGitUrl = Create-TextBox 50 250 530

$txtGitLogs = New-Object System.Windows.Forms.TextBox
$txtGitLogs.Location = New-Object System.Drawing.Point(50, 300)
$txtGitLogs.Size = New-Object System.Drawing.Size(630, 200)
$txtGitLogs.Multiline = $true; $txtGitLogs.ReadOnly = $true; $txtGitLogs.ScrollBars = 'Vertical'
$txtGitLogs.BackColor = $panelColor; $txtGitLogs.ForeColor = $textColor; $txtGitLogs.Font = $smallFont

function Run-GitCommand($pwd, $cmds) {
    if (!(Test-Path $pwd)) { [System.Windows.Forms.MessageBox]::Show("Folder path does not exist!"); return }
    $txtGitLogs.Text = "Running commands inside: $pwd`r`n--------------------------------------------`r`n"
    $form.Update()
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "cmd.exe"
    $pinfo.RedirectStandardError = $true; $pinfo.RedirectStandardOutput = $true; $pinfo.UseShellExecute = $false; $pinfo.CreateNoWindow = $true
    $pinfo.WorkingDirectory = $pwd
    $pinfo.Arguments = "/c " + $cmds
    
    $p = New-Object System.Diagnostics.Process; $p.StartInfo = $pinfo; $p.Start() | Out-Null
    $out = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    
    $txtGitLogs.AppendText($out + "`r`n`r`n[!] Process Completed!")
}

$btnNormalPush = Create-Button "NORMAL PUSH" 50 520 180 50 {
    $path = Convert-PathShortcut $txtGitPath.Text
    $msg = $txtGitMsg.Text; $branch = $txtGitBranch.Text; $url = $txtGitUrl.Text
    if (!$path -or !$msg -or !$branch -or !$url) { [System.Windows.Forms.MessageBox]::Show("Please fill all fields."); return }
    
    # Normal Push: Initialise, commit local files, pull remote files (like existing README) to merge, then push together
    $gitFolder = Join-Path $path ".git"; if (Test-Path $gitFolder) { Remove-Item -Path $gitFolder -Recurse -Force -ErrorAction SilentlyContinue }
    Run-GitCommand $path "git init & git add . & git commit -m `"$msg`" & git branch -M `"$branch`" & git remote remove origin & git remote add origin `"$url`" & git pull origin `"$branch`" --allow-unrelated-histories --no-edit & git push -u origin `"$branch`""
} $true

$btnForcePush = Create-Button "FORCE PUSH" 240 520 180 50 {
    $path = Convert-PathShortcut $txtGitPath.Text
    $msg = $txtGitMsg.Text; $branch = $txtGitBranch.Text; $url = $txtGitUrl.Text
    if (!$path -or !$msg -or !$branch -or !$url) { [System.Windows.Forms.MessageBox]::Show("Please fill all fields."); return }
    
    # Force Push: Overwrite remote with local completely
    $gitFolder = Join-Path $path ".git"; if (Test-Path $gitFolder) { Remove-Item -Path $gitFolder -Recurse -Force -ErrorAction SilentlyContinue }
    Run-GitCommand $path "git init & git add . & git commit -m `"$msg`" & git branch -M `"$branch`" & git remote remove origin & git remote add origin `"$url`" & git push -u origin `"$branch`" --force"
} $true

$btnBackGitOps = Create-Button "BACK TO GIT MENU" 430 520 250 50 { 
    $txtGitLogs.Text = ""; Switch-Panel $pnlGitMenu 
} $false

$pnlGit.Controls.AddRange(@($lblGitTitle, $lblGitPath, $txtGitPath, $btnBrowseGit, $lblGitMsg, $txtGitMsg, $lblGitBranch, $txtGitBranch, $lblGitUrl, $txtGitUrl, $txtGitLogs, $btnNormalPush, $btnForcePush, $btnBackGitOps))

# --- README MODULE ---
$lblReadmeTitle = Create-Label "DOCUMENTATION & READ ME" $headerFont 0 40
$lblReadmeTitle.AutoSize = $false; $lblReadmeTitle.Width = 750; $lblReadmeTitle.TextAlign = 'MiddleCenter'

$txtReadme = New-Object System.Windows.Forms.TextBox
$txtReadme.Location = New-Object System.Drawing.Point(50, 100)
$txtReadme.Size = New-Object System.Drawing.Size(650, 400)
$txtReadme.Multiline = $true; $txtReadme.ReadOnly = $true; $txtReadme.ScrollBars = 'Vertical'
$txtReadme.BackColor = $panelColor; $txtReadme.ForeColor = $textColor; $txtReadme.Font = $font
$txtReadme.Text = "HAZA MULTI-TOOL v2.0`r`n=====================`r`n`r`n" +
"WARNING: This is a demo platform. Before performing any actions, please ensure you have taken a backup or a copy of your important files.`r`n`r`n" +
"1. BACKUP FOLDER: Type your source folder and destination to sync files securely.`r`n" +
"   - Protip: Type 'desktop', 'documents', or 'downloads' to autocomplete paths!`r`n`r`n" +
"2. CREATE FILES: Fast way to create nested folders and text files in one single click.`r`n`r`n" +
"3. APP PROFILES: One-click application workspaces for Development, Productivity, or Entertainment.`r`n`r`n" +
"4. NETWORK TOOLS: Internet connectivity test and Fetch local Wi-Fi IP address in seconds.`r`n`r`n" +
"Developed & Designed by HAZA Team."

$btnBackReadme = Create-Button "BACK TO DASHBOARD" 225 520 300 50 { Switch-Panel $pnlMainMenu } $false
$pnlReadme.Controls.AddRange(@($lblReadmeTitle, $txtReadme, $btnBackReadme))

[void]$form.ShowDialog()