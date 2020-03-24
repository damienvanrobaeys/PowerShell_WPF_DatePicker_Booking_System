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


$User = $Form.Findname("User")
$datePicker1 = $Form.Findname("datePicker1")
$datePicker2 = $Form.Findname("datePicker2")
$datePicker1_textbox = $Form.Findname("datePicker1_textbox")
$datePicker2_textbox = $Form.Findname("datePicker2_textbox")
$Set_Date = $Form.Findname("Set_Date")

$Booking_CSV = ".\booking_users.csv"

$datePicker1.Add_SelectedDateChanged({		
	$Start_Date = (get-date($datePicker1.SelectedDate)).ToString("MM/dd/yyyy")	
	If(($datePicker2.SelectedDate) -ne $null)
		{
			$End_Date = (get-date($datePicker2.SelectedDate)).ToString("MM/dd/yyyy")					
			If($End_Date -lt $Start_Date)				
				{
				
					$ok = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::Affirmative	
					$Button_Style_Obj = [MahApps.Metro.Controls.Dialogs.MetroDialogSettings]::new()
			
					$Button_Style_Obj.DialogTitleFontSize = "18"
					$Button_Style_Obj.DialogMessageFontSize = "14"			
				
					[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal($Form,"Oops :-(","The end date should be greater than the start date !!!",$ok, $Button_Style_Obj)
				}
		}			
})

$datePicker2.Add_SelectedDateChanged({	
	$End_Date = (get-date($datePicker2.SelectedDate)).ToString("MM/dd/yyyy")		
	If(($datePicker1.SelectedDate) -ne $null)	
		{
			$Start_Date = (get-date($datePicker1.SelectedDate)).ToString("MM/dd/yyyy")
			If($End_Date -lt $Start_Date)				
				{
				
					$ok = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::Affirmative	
					$Button_Style_Obj = [MahApps.Metro.Controls.Dialogs.MetroDialogSettings]::new()
			
					$Button_Style_Obj.DialogTitleFontSize = "18"
					$Button_Style_Obj.DialogMessageFontSize = "14"			
				
					[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal($Form,"Oops :-(","The end date should be greater than the start date !!!",$ok, $Button_Style_Obj)
				}
		}		
})


$Get_CSV_Datas = import-csv $Booking_CSV -delimiter ";"	
ForEach($Line in $Get_CSV_Datas)
	{
		$BlackoutDates = $datePicker1.BlackoutDates 
		$CalendarDateRange = New-Object System.Windows.Controls.CalendarDateRange 
		$Get_User_Name = $Line.User_Name 
		
		$Get_Start_date = ($Line.Start_date)
		$Get_End_date = ($Line.End_date) 			
		
		$Date_Start = $CalendarDateRange.Start = $Get_Start_date
		$Date_End = $CalendarDateRange.End = $Get_End_date	
		$BlackoutDates.Add($CalendarDateRange)		
		
		
		
		$BlackoutDates_Picker2 = $datePicker2.BlackoutDates 
		$CalendarDateRange_Picker2 = New-Object System.Windows.Controls.CalendarDateRange 
		$Get_User_Name = $Line.User_Name 
		
		$Get_Start_date = ($Line.Start_date)
		$Get_End_date = ($Line.End_date) 			
		
		$Date_Start = $CalendarDateRange_Picker2.Start = $Get_Start_date
		$Date_End = $CalendarDateRange_Picker2.End = $Get_End_date	
		$BlackoutDates_Picker2.Add($CalendarDateRange_Picker2)	
	}
	
$Set_Date.Add_Click({
	$Get_User_Name = $User.Text.ToString()
	
	$Start_Date = (get-date($datePicker1.SelectedDate)).ToString("MM/dd/yyyy")
	$End_Date = (get-date($datePicker2.SelectedDate)).ToString("MM/dd/yyyy")	
	
	If($End_Date -gt $Start_Date)
		{
			$Users_booking_report = @()
			$User_Obj = New-Object PSObject
			$User_Obj | Add-Member NoteProperty -Name "User_Name" -Value $Get_User_Name
			$User_Obj | Add-Member NoteProperty -Name "Start_date" -Value $Start_Date -force
			$User_Obj | Add-Member NoteProperty -Name "End_date" -Value $End_Date -force	
			$Users_booking_report += $User_Obj
			
			$Users_booking_report

			$User_Obj | Select User_Name, Start_date, End_date | export-csv –append $Booking_CSV -noType  -delimiter ";"				
		}
	Else
		{
		
			$ok = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::Affirmative	
			$Button_Style_Obj = [MahApps.Metro.Controls.Dialogs.MetroDialogSettings]::new()
	
			$Button_Style_Obj.DialogTitleFontSize = "18"
			$Button_Style_Obj.DialogMessageFontSize = "14"			
		
			[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal($Form,"Oops :-(","The end date should be greater than the start date !!!",$ok, $Button_Style_Obj)
		}
})



$Form.ShowDialog() | Out-Null
