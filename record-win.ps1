# Function to ask for seed information
function Get-Seed {
    Write-Host "REQUESTING: Seed Information"
    $seedInfo = @{
        "Seed Number" = Read-Host "Enter the seed number"
        "Deck Name" = Read-Host "Enter the deck name"
        "Stake Color" = Read-Host "Enter the stake color"
    }
    return $seedInfo
}

# Function to ask for deck information in a loop
function Get-Jokers {
    Write-Host "REQUESTING: Joker Information"
    $deck = @()
    do {
        $card = @{
            "Card Name" = Read-Host "Enter the card name (or type 'done' to finish)"
            "End Value" = Read-Host "Enter the end value"
            "Modifications" = Read-Host "Enter modifications"
        }
        if ($card["Card Name"] -ne "done") {
            $deck += $card
        }
    } while ($card["Card Name"] -ne "done")
    return $deck
}

# Function to ask for hand information
function Get-Hands {
    Write-Host "REQUESTING: Hand Information"
    $hands = @()
    $handLevels = @("Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card")
    
    foreach ($hand in $handLevels) {
        $handInfo = @{
            "Hand Name" = $hand
            "Hand Level" = Read-Host "Enter $hand level"
            "Times Played" = Read-Host "Enter $hand play count"
        }
        $hands += $handInfo
    }
    return $hands
}

# Function to ask for blind information
function Get-Blinds {
    Write-Host "REQUESTING: Blind Information"
    $blinds = @()
    $blindLevels = @("Small Blind", "Big Blind", "Boss Blind")
    
    foreach ($blind in $blindLevels) {
        $blindInfo = @{
            "Blind Type" = $blind
            "Blind Name" = $blind
        }
        
        if (!($blind -eq "Boss Blind")) {
            $blindInfo["Tag"] = Read-Host "Enter $blind tag"
            $blindInfo["Blind Status"] = Read-Host "Enter $blind status"
        }

        if ($blind -eq "Boss Blind") {
            $blindInfo["Blind Name"] = Read-Host "Enter the Boss Blind's name"
            $blindInfo["Blind Status"] = "Defeated"
        }
        
        $blinds += $blindInfo
    }
    return $blinds
}

# Function to ask for voucher information
function Get-Vouchers {
    Write-Host "REQUESTING: Voucher Information"
    $vouchers = @()
    do {
        $voucherName = Read-Host "Enter voucher name (or type 'done' to finish)"
        if ($voucherName -ne "done") {
            $vouchers += $voucherName
        }
    } while ($voucherName -ne "done")
    return $vouchers
}

# Main script to collect all information
function Main {
    Write-Host "Welcome to the Balatro Winning Run Recorder!"
    
    # Collect seed information
    $seedInfo = Get-Seed
    
    # Collect deck information
    $deck = Get-Jokers
    
    # Collect hand information
    $hands = Get-Hands
    
    # Collect blind information
    $blinds = Get-Blinds
    
    # Collect voucher information
    $vouchers = Get-Vouchers

    # 
    $scriptDirectory = $PSScriptRoot
    $overviewFilePath = "$scriptDirectory\balatro.md"
    $detailFilePath = "$scriptDirectory\winning-details\$($seedInfo['Deck Name'])-$($seedInfo['Stake Color'])-$($seedInfo['Seed Number']).md"

    if (-Not (Test-Path $overviewFilePath)) {
        # If the file does not exist, create it
        New-Item -Path $overviewFilePath -ItemType File
        "## Winning Seeds" >> $overviewFilePath
        "Run Seed|Deck Name|Stake" >> $overviewFilePath
        "-|-|-" >> $overviewFilePath
        Write-Host "File created: $overviewFilePath (should only happen once)"
    } else {
        Write-Host "File already exists: $overviewFilePath (this is good)"
    }

    if (-Not (Test-Path $detailFilePath)) {
        # If the file does not exist, create it
        New-Item -Path $detailFilePath -ItemType File
        Write-Host "File created: $detailFilePath (this is good)"
    } else {
        Write-Host "File already exists: $detailFilePath (this is bad)"
    }
    
    # Write the collected information
    "$($seedInfo['Seed Number'])|$($seedInfo['Deck Name'])|$($seedInfo['Stake Color'])" >> $overviewFilePath
    Write-Host "Seed Info written to Overview File"
    

    "# $($seedInfo['Deck Name'])-$($seedInfo['Stake Color'])-$($seedInfo['Seed Number'])" >> $detailFilePath
    "**Seed:** *$($seedInfo['Seed Number'])*" >> $detailFilePath
    "**Deck:** *$($seedInfo['Deck Name'])*" >> $detailFilePath
    "**Stake:** *$($seedInfo['Stake Color'])*" >> $detailFilePath
    Write-Host "Run Info written to Detail File"
    
    "## Jokers:" >> $detailFilePath
    "*$ included when impactful" >> $detailFilePath
    "Rank|Card|Value ($*x+)|Modifications" >> $detailFilePath
    "-|-|-|- " >> $detailFilePath
    $index = 1
    foreach ($card in $deck) {
        "$index|$($card['Card Name'])|$($card['End Value'])|$($card['Modifications'])" >> $detailFilePath
        $index = $index + 1
    }
    Write-Host "Joker Info written to Detail File"

     
    "## Hands:" >> $detailFilePath
    "Level|Hand|Chips x Mult|Play Count" >> $detailFilePath
    "-|-|-|- " >> $detailFilePath
    foreach ($hand in $hands) {
        "$($hand['Hand Level'])|$($hand['Hand Name'])|$($hand['Chips x Mult'])|$($hand['Times Played'])" >> $detailFilePath
    }
    Write-Host "Hand Info written to Detail File"
    
    "## Blinds:" >> $detailFilePath
    "Blind|Status|Min|Tag" >> $detailFilePath
    "-|-|-|- " >> $detailFilePath
    foreach ($blind in $blinds) {
        "$($blind['Blind Name'])|$($blind['Blind Status'])|$($blind['Minimum Score'])|$($blind['Tag'])" >> $detailFilePath
    }
    Write-Host "Blind Info written to Detail File"

     
    "## Vouchers:" >> $detailFilePath
    foreach ($voucher in $vouchers) {
        "$voucher," >> $detailFilePath
    }
    Write-Host "Voucher Info written to Detail File"
}

# Run the main function
Main


#  # Display the collected information
#  Write-Host "Collected Information:"
#  Write-Host "Seed Info: Seed Number - $($seedInfo['Seed Number']), Deck Name - $($seedInfo['Deck Name']), Stake Color - $($seedInfo['Stake Color'])"
 
#  Write-Host "Deck Info:"
#  foreach ($card in $deck) {
#      Write-Host "Card: $($card['Card Name']), End Value: $($card['End Value']), Modifications: $($card['Modifications'])"
#  }
 
#  Write-Host "Hand Info:"
#  foreach ($hand in $hands) {
#      Write-Host "Hand Level: $($hand['Hand Level']), Chips x Mult: $($hand['Chips x Mult']), Times Played: $($hand['Times Played'])"
#  }
 
#  Write-Host "Blind Info:"
#  foreach ($blind in $blinds) {
#      Write-Host "Blind Status: $($blind['Blind Status']), Min Score: $($blind['Minimum Score']), Tag: $($blind['Tag'])"
#      if ($blind.ContainsKey("Boss Blind Name")) {
#          Write-Host "Boss Blind Name: $($blind['Boss Blind Name'])"
#      }
#  }
 
#  Write-Host "Voucher Info:"
#  foreach ($voucher in $vouchers) {
#      Write-Host "Voucher Name: $voucher"
#  }