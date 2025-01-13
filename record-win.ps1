# Function to ask for seed information
function Get-Seed {
    Write-Host "=========== Run Overview ==========="
    $seedInfo = @{
        "Seed Number" = Read-Host "|| Seed"
        "Deck Name" = Read-Host "|| Deck"
        "Stake Color" = Read-Host "|| Stake"
    }
    return $seedInfo
}

# Function to ask for deck information in a loop
function Get-Jokers {
    Write-Host "============== Jokers =============="
    $deck = @()
    do {
        $card = @{
            "Card Name" = Read-Host "|| Card Name (or type 'done' to finish)"
        }
        if ($card["Card Name"] -ne "done") {
            $name = $card["Card Name"]
            $card["End Value"] = Read-Host "|| End Value"
            $card["Modifications"] = Read-Host "|| Modifications"
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
    $handLevels = @("Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card")
    
    foreach ($hand in $handLevels) {
        $handInfo = @{
            "Hand Name" = $hand
            "Hand Level" = Read-Host "|| $hand level"
            "Times Played" = Read-Host "|| $hand play count"
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
            $blindInfo["Tag"] = Read-Host "|| $blind tag"
            $blindInfo["Blind Status"] = Read-Host "|| $blind status"
        }

        if ($blind -eq "Boss Blind") {
            $blindInfo["Blind Name"] = Read-Host "|| Boss Blind name"
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
        $voucherName = Read-Host "|| Voucher Name (or type 'done' to finish)"
        if ($voucherName -ne "done") {
            $vouchers += $voucherName
        }
    } while ($voucherName -ne "done")
    return $vouchers
}

function Out-File {
    param (
        [hashtable]$Seed,
        [array]$Jokers,
        [array]$Hands,
        [array]$Blinds,
        [object]$Vouchers,
        [string]$AggregateFilepath,
        [string]$DetailFilepath
    )
    
    # Write the collected information
    "$($Seed['Seed Number'])|$($Seed['Deck Name'])|$($Seed['Stake Color'])" >> $AggregateFilepath
    Write-Host "Seed Info written to Overview File"
    

    "# $($Seed['Deck Name'])-$($Seed['Stake Color'])-$($Seed['Seed Number'])" >> $DetailFilepath
    "**Seed:** *$($Seed['Seed Number'])*" >> $DetailFilepath
    "**Deck:** *$($Seed['Deck Name'])*" >> $DetailFilepath
    "**Stake:** *$($Seed['Stake Color'])*" >> $DetailFilepath
    Write-Host "Run Info written to Detail File"
    
    "## Jokers:" >> $DetailFilepath
    "*$ included when impactful" >> $DetailFilepath
    "Rank|Card|Value ($*x+)|Modifications" >> $DetailFilepath
    "-|-|-|- " >> $DetailFilepath
    $index = 1
    foreach ($joker in $Jokers) {
        "$index|$($joker['Card Name'])|$($joker['End Value'])|$($joker['Modifications'])" >> $DetailFilepath
        $index = $index + 1
    }
    Write-Host "Joker Info written to Detail File"

     
    "## Hands:" >> $DetailFilepath
    "Level|Hand|Chips x Mult|Play Count" >> $DetailFilepath
    "-|-|-|- " >> $DetailFilepath
    foreach ($hand in $Hands) {
        "$($hand['Hand Level'])|$($hand['Hand Name'])|$($hand['Chips x Mult'])|$($hand['Times Played'])" >> $DetailFilepath
    }
    Write-Host "Hand Info written to Detail File"
    
    "## Blinds:" >> $DetailFilepath
    "Blind|Status|Min|Tag" >> $DetailFilepath
    "-|-|-|- " >> $DetailFilepath
    foreach ($blind in $Blinds) {
        "$($blind['Blind Name'])|$($blind['Blind Status'])|$($blind['Minimum Score'])|$($blind['Tag'])" >> $DetailFilepath
    }
    Write-Host "Blind Info written to Detail File"

     
    "## Vouchers:" >> $DetailFilepath
    foreach ($voucher in $Vouchers) {
        "$voucher," >> $DetailFilepath
    }
    Write-Host "Voucher Info written to Detail File"
}

function Out-Console {
    param (
        [hashtable]$Seed,
        [array]$Jokers,
        [array]$Hands,
        [array]$Blinds,
        [object]$Vouchers
    )

    # Display the collected information
    Write-Host "Collected Information:"
    Write-Host "Seed Info: Seed Number - $($Seed['Seed Number']), Deck Name - $($Seed['Deck Name']), Stake Color - $($Seed['Stake Color'])"

    Write-Host "Deck Info:"
    foreach ($joker in $Jokers) {
        Write-Host "Card: $($joker['Card Name']), End Value: $($joker['End Value']), Modifications: $($joker['Modifications'])"
    }

    Write-Host "Hand Info:"
    foreach ($hand in $Hands) {
        Write-Host "Hand Level: $($hand['Hand Level']), Chips x Mult: $($hand['Chips x Mult']), Times Played: $($hand['Times Played'])"
    }

    Write-Host "Blind Info:"
    foreach ($blind in $Blinds) {
        Write-Host "Blind Status: $($blind['Blind Status']), Min Score: $($blind['Minimum Score']), Tag: $($blind['Tag'])"
        if ($blind.ContainsKey("Boss Blind Name")) {
            Write-Host "Boss Blind Name: $($blind['Boss Blind Name'])"
        }
    }

    Write-Host "Voucher Info:"
    foreach ($voucher in $Vouchers) {
        Write-Host "Voucher Name: $voucher"
    }
}

# Main script to collect all information
function Main {
    param (
        [switch]$Dry,
        [switch]$Detail
    )

    Write-Host "Welcome to the Balatro Winning Run Recorder!"
    
    # Collect seed information
    $seed = Get-Seed
    
    # Collect deck information
    $jokers = Get-Jokers
    
    # Collect hand information
    $hands = Get-Hands
    
    # Collect blind information
    $blinds = Get-Blinds
    
    # Collect voucher information
    $vouchers = Get-Vouchers

    $scriptDirectory = $PSScriptRoot
    $overviewFilePath = "$scriptDirectory\balatro.md"
    $detailFilePath = "$scriptDirectory\winning-details\$($seed['Deck Name'])-$($seed['Stake Color'])-$($seed['Seed Number']).md"

    if (-Not (Test-Path $overviewFilePath)) {
        # If the file does not exist, create it
        if (-not $Dry) {
            New-Item -Path $overviewFilePath -ItemType File
            "## Winning Seeds" >> $overviewFilePath
            "Run Seed|Deck Name|Stake" >> $overviewFilePath
            "-|-|-" >> $overviewFilePath
        }
        Write-Host "File created: $overviewFilePath (should only happen once)"
    } else {
        Write-Host "File already exists: $overviewFilePath (this is good)"
    }

    if (-Not (Test-Path $detailFilePath)) {
        # If the file does not exist, create it
        if (-not $Dry) {
            New-Item -Path $detailFilePath -ItemType File
        }
        Write-Host "File created: $detailFilePath (this is good)"
    } else {
        Write-Host "File already exists: $detailFilePath (this is bad)"
    }

    if ($Detail -or $Dry) {
        Out-Console -Seed $seed -Jokers $jokers -Hands $hands -Blinds $blinds -Vouchers $vouchers
    }
    if (-not $Dry) {
        Out-File -Seed $seed -Jokers $jokers -Hands $hands -Blinds $blinds -Vouchers $vouchers -AggregateFilepath $overviewFilePath -DetailFilepath $detailFilePath
    }
}

# Run the main function
Main -Dry