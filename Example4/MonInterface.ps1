[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$datePicker1 = $Form.Findname("datePicker1")
$datePicker1_textbox = $Form.Findname("datePicker1_textbox")
$datePicker1.Add_SelectedDateChanged({		
	$datePicker1_textbox.Text = $datePicker1.SelectedDate
})

$Form.ShowDialog() | Out-Null
