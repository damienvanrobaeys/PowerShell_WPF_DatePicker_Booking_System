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
$Button = $Form.Findname("Button")

$Button.Add_Click({
	$Selected_Date = $datePicker1.SelectedDate
	[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Selected date", "$Selected_Date")							

})

$BlackoutDates = $datePicker1.BlackoutDates
$CalendarDateRange = New-Object System.Windows.Controls.CalendarDateRange 
$Date_Start = $CalendarDateRange.Start = "03/15/2020"
$Date_End = $CalendarDateRange.End = "03/20/2020"
$BlackoutDates.Add($CalendarDateRange)

$Form.ShowDialog() | Out-Null
