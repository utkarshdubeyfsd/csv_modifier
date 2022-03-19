# File path, location need to be change as per file location
$inputFilePath = "C:\Users\john\Documents\Sample_CSV.csv"
$outputFilePath = "C:\Users\john\Documents\Sample_CSV_Output.csv"

# Read CSV file
$csv = Import-Csv $inputFilePath

# declaring an empty array
$outputArray = @()

Write-Host ("Reading INPUT column of CSV file.") -ForegroundColor Green

# loop on column name -- INPUT
$csv.INPUT | ForEach-Object {
    # @V_  we dont want so needs to be removed. 
    # @ is replaced by \
    $String = $_.replace('@V_', '').replace('@', '\')

    # Get last character of string which needs to be merge with \Vaults
    $lastCharsOfString = $String.Split("_")
    
    # last   0 ,7,3 last digit is replaced by  Vaults0 or  Vaults7 (depends on last number)
    $tempOutput = $String.Substring(0,$String.Length-($lastCharsOfString[$lastCharsOfString.Length - 1].Length + 1)) 
    + "\Vaults" + $lastCharsOfString[$lastCharsOfString.Length - 1]

    # split text into array
    $CharArray = $tempOutput.Split("\")

    # reverse the array
    [array]::reverse($CharArray)

    # Path is reversed generated(see input & output )
    $output = $CharArray -join '\'

    # \\SERVER\data$  can be hardcoded in some variable
    $output = "\\SERVER\data$\" + $output

    # adding output in an array
    $outputArray += $output
}

# all columns with one new column is going to append into new CSV
$obj = @()
$i = 0

Write-Host ("adding new column name -- Powershell Output and generating new CSV") -ForegroundColor Green

foreach ($row in $csv)
{
    # adding current row to new object
    $item = New-Object PSObject -ArgumentList $row
    # adding new column with new row to same object
    $item | Add-Member -MemberType NoteProperty "Powershell Output" -Value $outputArray[$i]
    $obj += $item
    $i++
}

# generating new CSV
$obj | Export-Csv -Append -Force -NoTypeInformation $outputFilePath

Write-Host ("Script executed successfully!!!") -ForegroundColor Green