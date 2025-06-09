param (
    [string]$targetFolder,
    [int]$startValue,
    [int]$endValue,
    [int]$delValue
)

function deleteRandomly {
param (
    [string]$targetFolder,
    [int]$startValue,
    [int]$endValue,
    [int]$delValue
)


$deletedCount = 0
$attempts = 0

while ($deletedCount -lt $delValue) {
    $randomNum = Get-Random -Minimum $startValue -Maximum ($endValue + 1)
    $pattern = "$targetFolder\$randomNum*"
    if (Test-Path $pattern) {
        Remove-Item $pattern -Force
        Write-Host "Deleted $randomNum"
        $deletedCount++
    }   
}

Write-Host "Deleted $deletedCount screenshots."
}

function setTimeStamps {

param (
    [string]$targetFolder
)


Get-ChildItem -Path $targetFolder -File | ForEach-Object {
    $filename = $_.BaseName
    if ($filename -match '_([0-9]{8})-([0-9]{6})') {
        $datePart = $matches[1]
        $timePart = $matches[2]

        $year = $datePart.Substring(0, 4)
        $month = $datePart.Substring(4, 2)
        $day = $datePart.Substring(6, 2)
        $hour = $timePart.Substring(0, 2)
        $minute = $timePart.Substring(2, 2)
        $second = $timePart.Substring(4, 2)

        $newDate = "$year-$month-$day $hour`:$minute`:$second"
        Write-Host "Adjusting $_ !"
        $_.LastWriteTime = [datetime]$newDate
    }
}
}

if (-not $PSBoundParameters.ContainsKey('startValue')) {
    if (-not $targetFolder) {
        Write-Host "Error: You must provide a target folder."
        exit 1
    }
    setTimeStamps -targetFolder $targetFolder
}
else {
    deleteRandomly -targetFolder $targetFolder -startValue $startValue -endValue $endValue -delValue $delValue
}