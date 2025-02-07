param (
    [switch]$Dry,
    [switch]$Verbose,
    [switch]$Silent,
    [switch]$Interactive,
    [switch]$Help
)

if ($Help) {
    Write-Host "SYNTAX"
    Write-Host "    record-win.ps1 [options]"
    Write-Host ""
    Write-Host "OPTIONS"
    Write-Host "    -d, -dry           Display effects of running script without making changes"
    Write-Host "    -h, -help          Display help menu"
    Write-Host "    -i, -interactive   Enables GUI input for certain questions"
    Write-Host "    -s, -silent        Does not dipslay output text"
    Write-Host "    -v, -verbose       Display additional script runtime information"
    exit
}

if ($Silent) {
    Write-Host "Silent mode enabled"
}

if (-not $Silent) {
    if ($Dry) {
        Write-Host "Dry run enabled"
    }
    
    if ($Verbose) {
        Write-Host "Verbose mode enabled"
    }

    if ($Interactive) {
        Write-Host "Interactive mode enabled"
    }
}

if ($Interactive) {
    Write-Host "Sorry, that feature isn't completely ready yet. Please try again later.";
    exit
}

# Function to ask for seed information
function Get-Seed {
    Write-Host "=========== Run Overview ==========="
    Write-Host "|| If recording a challenge win, "
    Write-Host "|| Deck  = 'challenge'"
    Write-Host "|| Stake = <challenge name>"
    Write-Host "||----------------------------------"
    $seedInfo = @{
        "Seed Number" = Read-Host "|| Seed (0000AAAA)"
        "Deck Name" = Read-Host "|| Deck (red)"
        "Stake Color" = Read-Host "|| Stake (white)"
    }
    if ($seedInfo["Seed Number"] -eq "") {
        $seedInfo["Seed Number"] = "0000AAAA"
    }
    if ($seedInfo["Deck Name"] -eq "") {
        $seedInfo["Deck Name"] = "red"
    }
    if ($seedInfo["Stake Color"] -eq "") {
        $seedInfo["Stake Color"] = "white"
    } else {
        $str1 = $seedInfo["Stake Color"]
        $str2 = $str1 -replace " ", "-"
        $seedInfo["Stake Color"] = $str2
    }
    return $seedInfo
}

# Function to ask for deck information in a loop
function Get-Jokers {
    Write-Host "============== Jokers =============="
    $deck = @()
    do {
        $card = @{
            "Card Name" = Read-Host "|| Card Name, or 'done' to finish (done)"
        }
        if ($card["Card Name"] -eq "") {
            $card["Card Name"] = "done"
        }
        if ($card["Card Name"] -ne "done") {
            $card["End Value"] = Read-Host "|| End Value (n/a)"
            $card["Modifications"] = Read-Host "|| Modifications (none)"
        }
        if ($card["End Value"] -eq "") {
            $card["End Value"] = "n/a"
        }
        if ($card["End Value"] -eq "") {
            $card["End Value"] = "none"
        }
        if ($card["Card Name"] -ne "done") {
            $deck += $card
        }
    } while ($card["Card Name"] -ne "done")
    return $deck
}

# Function to ask for hand information
function Get-Hands {
    Write-Host "========== Upgraded Hands =========="
    $hands = @()
    $handLevels = @("Flush Full House", "Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card")
    $withflushfullhouse = Read-Host "|| Flush Full House? (y/N)"
    if ($withflushfullhouse -eq "") {
        $handLevels = @("Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card")
    }
    Write-Host "||----------------------------------"
    
    foreach ($hand in $handLevels) {
        $handInfo = @{
            "Hand Name" = $hand
            "Hand Level" = Read-Host "|| $hand level (1)"
            "Times Played" = Read-Host "|| $hand play count (0)"
        }
        if ($handInfo["Hand Level"] -eq "") {
            $handInfo["Hand Level"] = "1"
        }
        if ($handInfo["Times Played"] -eq "") {
            $handInfo["Times Played"] = "0"
        }
        $hands += $handInfo
    }
    return $hands
}

# Function to ask for blind information
function Get-Blinds {
    Write-Host "============ Last Blind ============"
    $blinds = @()
    $blindLevels = @("Small Blind", "Big Blind", "Boss Blind")
    
    foreach ($blind in $blindLevels) {
        $blindInfo = @{
            "Blind Type" = $blind
            "Blind Name" = $blind
        }
        
        if ($blind -ne "Boss Blind") {
            $blindInfo["Tag"] = Read-Host "|| $blind tag (speed)"
            if ($blindInfo["Tag"] -eq "") {
                $blindInfo["Tag"] = "speed"
            }
            $blindInfo["Blind Status"] = Read-Host "|| $blind status (defeated)"
            if ($blindInfo["Blind Status"] -eq "") {
                $blindInfo["Blind Status"] = "defeated"
            }
        }
        if ($blind -eq "Boss Blind") {
            $blindInfo["Blind Name"] = Read-Host "|| Boss Blind name (violet vessel)"
            if ($blindInfo["Blind Name"] -eq "") {
                $blindInfo["Blind Name"] = "violet vessel"
            }
            $blindInfo["Blind Status"] = "Defeated"
        }
        
        $blinds += $blindInfo
    }
    return $blinds
}

# Function to ask for voucher information
function Get-Vouchers {
    Write-Host "============= Vouchers ============="
    $vouchers = @()
    do {
        $voucherName = Read-Host "|| Voucher Name, or 'done' to finish (done)"
        if ($voucherName -eq "") {
            $voucherName = "done"
        }
        if ($voucherName -ne "done") {
            $vouchers += $voucherName
        }
    } while ($voucherName -ne "done")
    return $vouchers
}

function Get-Notes {
    Write-Host "========= Additional Notes ========="
    $notes = Read-Host "|| Run Notes (none)"
    if ($notes -eq "") {
        $notes = "none"
    }
    return $notes
}

Write-Host "Welcome to the Balatro Winning Run Recorder!"

$seed = Get-Seed
$jokers = Get-Jokers
$hands = Get-Hands
$blinds = Get-Blinds
$vouchers = Get-Vouchers
$notes = Get-Notes

$scriptDirectory = $PSScriptRoot
$overviewFilePath = "$scriptDirectory\balatro.md"
$detailFilePath = "$scriptDirectory\winning-details\$($($seed['Deck Name']).Trim())-$($($seed['Stake Color']).Trim())-$($($seed['Seed Number']).Trim()).md"

if (-Not (Test-Path $overviewFilePath)) {
    # If the file does not exist, create it
    if (-not $Dry) {
        New-Item -Path $overviewFilePath -ItemType File
        "## Winning Seeds" >> $overviewFilePath
        "Run Seed|Deck Name|Stake" >> $overviewFilePath
        "-|-|-" >> $overviewFilePath
    }
    if (-not $Silent) {
        Write-Host "File created: $overviewFilePath (should only happen once)"
    }
} else {
    if (-not $Silent) {
        Write-Host "File already exists: $overviewFilePath (this is good)"
    }
}

if (-Not (Test-Path $detailFilePath)) {
    # If the file does not exist, create it
    if (-not $Dry) {
        $null = New-Item -Path $detailFilePath -ItemType File
    }
    if (-not $Silent) {
        Write-Host "File created: $detailFilePath (this is good)"\
    }
} else {
    if (-not $Silent) {
        Write-Host "File already exists: $detailFilePath (this is bad)"
    }
}

if (($Verbose -or $Dry) -and (-not $Silent)) {
    # Out-Console
    Write-Host "Collected Information:"
    Write-Host "Seed Info: Seed Number - $($seed['Seed Number']), Deck Name - $($seed['Deck Name']), Stake Color - $($seed['Stake Color'])"

    Write-Host "Deck Info:"
    foreach ($joker in $jokers) {
        Write-Host "Card: $($joker['Card Name']), End Value: $($joker['End Value']), Modifications: $($joker['Modifications'])"
    }

    Write-Host "Hand Info:"
    foreach ($hand in $hands) {
        Write-Host "Hand Level: $($hand['Hand Level']), Chips x Mult: $($hand['Chips x Mult']), Times Played: $($hand['Times Played'])"
    }

    Write-Host "Blind Info:"
    foreach ($blind in $blinds) {
        Write-Host "Blind Status: $($blind['Blind Status']), Min Score: $($blind['Minimum Score']), Tag: $($blind['Tag'])"
        if ($blind.ContainsKey("Boss Blind Name")) {
            Write-Host "Boss Blind Name: $($blind['Boss Blind Name'])"
        }
    }

    Write-Host "Voucher Info:"
    foreach ($voucher in $vouchers) {
        Write-Host "Voucher Name: $voucher"
    }
}

if (-not $Dry) {
    # Out-File 
    "$($seed['Seed Number'])|$($seed['Deck Name'])|$($seed['Stake Color'])" >> $overviewFilePath
    if (-not $Silent) {
        Write-Host "Seed Info written to Overview File"
    }
    

    "# $($seed['Deck Name'])-$($seed['Stake Color'])-$($seed['Seed Number'])" >> $detailFilePath
    "**Seed:** *$($seed['Seed Number'])*" >> $detailFilePath
    "**Deck:** *$($seed['Deck Name'])*" >> $detailFilePath
    "**Stake:** *$($seed['Stake Color'])*" >> $detailFilePath
    if (-not $Silent) {
        Write-Host "Run Info written to Detail File"
    }

    "## Jokers:" >> $detailFilePath
    "*$ included when impactful" >> $detailFilePath
    "Rank|Card|Value ($*x+)|Modifications" >> $detailFilePath
    "-|-|-|- " >> $detailFilePath
    $index = 1
    foreach ($joker in $jokers) {
        "$index|$($joker['Card Name'])|$($joker['End Value'])|$($joker['Modifications'])" >> $detailFilePath
        $index = $index + 1
    }
    if (-not $Silent) {
        Write-Host "Joker Info written to Detail File"
    }
    
    "## Hands:" >> $detailFilePath
    "Level|Hand|Chips x Mult|Play Count" >> $detailFilePath
    "-|-|-|- " >> $detailFilePath
    foreach ($hand in $hands) {
        "$($hand['Hand Level'])|$($hand['Hand Name'])|$($hand['Chips x Mult'])|$($hand['Times Played'])" >> $detailFilePath
    }
    if (-not $Silent) {
        Write-Host "Hand Info written to Detail File"
    }

    "## Blinds:" >> $detailFilePath
    "Blind|Status|Min|Tag" >> $detailFilePath
    "-|-|-|- " >> $detailFilePath
    foreach ($blind in $blinds) {
        "$($blind['Blind Name'])|$($blind['Blind Status'])|$($blind['Minimum Score'])|$($blind['Tag'])" >> $detailFilePath
    }
    if (-not $Silent) {
        Write-Host "Blind Info written to Detail File"
    }
    
    "## Vouchers:" >> $detailFilePath
    foreach ($voucher in $vouchers) {
        "$voucher," >> $detailFilePath
    }
    if (-not $Silent) {
        Write-Host "Voucher Info written to Detail File"
    }

    "## Run Notes:" >> $detailFilePath
    $notes >> $detailFilePath
    if (-not $Silent) {
        Write-Host "Run Notes written to Detail File"
    }


    Write-Host "Finished."
}