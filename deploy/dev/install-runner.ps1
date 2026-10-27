# ติดตั้ง runner ของ GitHub บนเครื่อง dev (รอบซ้อม = notebook) — รันครั้งเดียวด้วย PowerShell
# ทำอะไร: ดาวน์โหลดโปรแกรม runner · ลงทะเบียนกับ repo ติดป้าย "dev" · เปิดให้รอรับงาน · ตั้งให้เปิดเองทุกครั้งที่ login
# ทำเพื่อ: ให้ workflow deploy-dev สั่ง "ดึง image ใหม่แล้วเปิด" บนเครื่องนี้ได้ โดยไม่ต้องเปิดพอร์ตจากข้างนอกเข้ามา
#         (runner เป็นฝ่ายต่อออกไปหา GitHub เอง)
# ต้องมี: gh auth login แล้ว · Docker Desktop เปิดอยู่
$ErrorActionPreference = "Stop"
$repo = "bankpiaroZ/test_platform"
$dir = "C:\actions-runner"

$ver = (gh api repos/actions/runner/releases/latest --jq .tag_name).TrimStart('v')
Write-Host "1/4 ดาวน์โหลด runner รุ่น $ver ไปที่ $dir"
New-Item -ItemType Directory -Force $dir | Out-Null
if (-not (Test-Path "$dir\config.cmd")) {
  $zip = "$dir\runner.zip"
  Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v$ver/actions-runner-win-x64-$ver.zip" -OutFile $zip
  Expand-Archive -Path $zip -DestinationPath $dir -Force
  Remove-Item $zip
}

Write-Host "2/4 ลงทะเบียนกับ repo $repo (ป้าย dev)"
$token = gh api -X POST "repos/$repo/actions/runners/registration-token" --jq .token
Set-Location $dir
if (-not (Test-Path "$dir\.runner")) {
  & .\config.cmd --url "https://github.com/$repo" --token $token --name "dev-$env:COMPUTERNAME" --labels dev --work _work --unattended --replace
}

Write-Host "3/4 เปิด runner รอรับงาน (หน้าต่างซ่อน)"
Start-Process -FilePath "$dir\run.cmd" -WorkingDirectory $dir -WindowStyle Hidden

Write-Host "4/4 ตั้งให้เปิดเองทุกครั้งที่ login (Task Scheduler: github-runner-dev)"
$action = New-ScheduledTaskAction -Execute "$dir\run.cmd" -WorkingDirectory $dir
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask -TaskName "github-runner-dev" -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null

Start-Sleep 8
Write-Host "สถานะ runner ที่ GitHub เห็น:"
gh api "repos/$repo/actions/runners" --jq '.runners[] | "\(.name)  \(.status)  labels=\([.labels[].name] | join(","))"'
Write-Host "ถอนทีหลัง: cd $dir; .\config.cmd remove --token (gh api -X POST repos/$repo/actions/runners/remove-token --jq .token); Unregister-ScheduledTask github-runner-dev -Confirm:`$false"
