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
$datePicker2 = $Form.Findname("datePicker2")
$Set_Date = $Form.Findname("Set_Date")

$BlackoutDates = $datePicker1.BlackoutDates
$CalendarDateRange = New-Object System.Windows.Controls.CalendarDateRange 
$Date_Start = $CalendarDateRange.Start = "03/15/2020"
$Date_End = $CalendarDateRange.End = "03/20/2020"
$BlackoutDates.Add($CalendarDateRange)

$Set_Date.Add_Click({	
	$Start_Date = (get-date($datePicker1.SelectedDate)).ToString("MM/dd/yyyy")
	$End_Date = (get-date($datePicker2.SelectedDate)).ToString("MM/dd/yyyy")		
	If($End_Date -lt $Start_Date)	
		{		
			$ok = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::Affirmative	
			$Button_Style_Obj = [MahApps.Metro.Controls.Dialogs.MetroDialogSettings]::new()
	
			$Button_Style_Obj.DialogTitleFontSize = "18"
			$Button_Style_Obj.DialogMessageFontSize = "14"			
		
			[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal($Form,"Oops :-(","The end date should be greater than the start date !!!",$ok, $Button_Style_Obj)
		}
})


$Form.ShowDialog() | Out-Null
