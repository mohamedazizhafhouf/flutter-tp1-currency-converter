$ErrorActionPreference = 'Stop'

$projectDirectory = Split-Path -Parent $PSScriptRoot
$sourceDirectory = Join-Path $projectDirectory 'lib'

$startInfo = [System.Diagnostics.ProcessStartInfo]::new()
$startInfo.FileName = 'cmd.exe'
$startInfo.Arguments = '/d /c flutter run -d chrome'
$startInfo.WorkingDirectory = $projectDirectory
$startInfo.UseShellExecute = $false
$startInfo.RedirectStandardInput = $true
$startInfo.CreateNoWindow = $true

$flutterProcess = [System.Diagnostics.Process]::new()
$flutterProcess.StartInfo = $startInfo
$flutterProcess.EnableRaisingEvents = $true

try {
  [void]$flutterProcess.Start()

  $lastSourceChange = Get-ChildItem $sourceDirectory -Filter '*.dart' -Recurse |
    Measure-Object -Property LastWriteTimeUtc -Maximum |
    Select-Object -ExpandProperty Maximum

  while (-not $flutterProcess.HasExited) {
    Start-Sleep -Milliseconds 500

    $latestSourceChange = Get-ChildItem $sourceDirectory -Filter '*.dart' -Recurse |
      Measure-Object -Property LastWriteTimeUtc -Maximum |
      Select-Object -ExpandProperty Maximum

    if ($latestSourceChange -gt $lastSourceChange) {
      $lastSourceChange = $latestSourceChange
      $flutterProcess.StandardInput.WriteLine('r')
      $flutterProcess.StandardInput.Flush()
    }
  }

  exit $flutterProcess.ExitCode
}
finally {
  if (-not $flutterProcess.HasExited) {
    $flutterProcess.StandardInput.WriteLine('q')
    $flutterProcess.StandardInput.Flush()
    $flutterProcess.WaitForExit(5000)
  }

  $flutterProcess.Dispose()
}
