param (
    [string]$Folder
)

Get-ChildItem -Path $Folder -File | ForEach-Object {
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


