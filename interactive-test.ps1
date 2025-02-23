Add-Type -AssemblyName System.Windows.Forms

# Create the form and combo box
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select an Option"
$form.Size = New-Object System.Drawing.Size(300, 200)

$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$comboBox.Items.AddRange(@("Option 1", "Option 2", "Option 3", "Option 4"))  # Corrected here: using an array
$comboBox.Location = New-Object System.Drawing.Point(50, 50)
$form.Controls.Add($comboBox)

# Create the "OK" button
$button = New-Object System.Windows.Forms.Button
$button.Text = "OK"
$button.Location = New-Object System.Drawing.Point(100, 100)
$button.Add_Click({
    $selectedOption = $comboBox.SelectedItem
    Write-Host "You selected: $selectedOption"
    $form.Close()
})
$form.Controls.Add($button)

# Show the form and wait for user input
$form.ShowDialog()
