<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR Qualys
.COMPANY NAME Qualys Inc
.COPYRIGHT Copyright (c) 2023 Qualys Inc. All rights reserved.
.DISCLAIMER Modification by the recipient is strickly unadvised.
. LICENSE This script is provided to you "AS IS." To the extent permitted by law, Qualys hereby disclaims all warranties and liability for the provision or use of this script. In no event shall these scripts be deemed to be cloud services as provided by Qualys.

#>

<#
.SYNOPSIS
    Remove traces of Qualys Windows Cloud Agent "if any" remaining post uninstallation or in case of unsuccessful installation attempt.
.DESCRIPTION
    This script will remove traces of Qualys Windows Cloud Agent "if any" remaining post uninstallation or in case of unsuccessful installation attempt.
	A new folder with Name "Qualys_Cloud_Agent_Traces_Removal_<date_time>" will be created under "C:\windows\Temp\" folder.
	Log file as "<Computer name>_Qualys_Cloud_Agent_Traces_Removal.log" will be created inside "C:\windows\Temp\Qualys_Cloud_Agent_Traces_Removal_<date_time>\" folder.
	Before cleaning any registry traces, a backup of those files will be taken as "Merged_Registry_Entries.reg.txt" file inside "C:\windows\Temp\Qualys_Cloud_Agent_Traces_Removal_<date_time>\Backed_up_Entries\" folder.
	If required, rename file to "Merged_Registry_Entries.reg" and restore removed registry entries by double clicking the file.
		
.PARAMETER
    None

.REQUIREMENT
	Elevated powershell window 

.EXAMPLE / USAGE

    PS C:\> .\Qualys_Windows_Cloud_Agent_Traces_Removal_Script.ps1
#>

# Create Datewise folders by folder with variable name 'log_path'
$folderName = (Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") 
$log_path = New-Item -ItemType Directory -Path "$Env:windir\Temp\" -Name "Qualys_Cloud_Agent_Traces_Removal_$FolderName\"
$null = New-Item -ItemType Directory -Path $log_path\Backed_up_Entries

# Define'tempFolder' and 'outputFile' path to store script output log and registry backup files
$tempFolder = "$log_path\Backed_up_Entries"
$null = New-Item -ItemType file $log_path\Backed_up_Entries\Merged_Registry_Entries.reg.txt  -Force
$outputFile = "$log_path\Backed_up_Entries\Merged_Registry_Entries.reg.txt"
'Windows Registry Editor Version 5.00' | Set-Content $outputFile -Encoding Unicode

$Logfile_Path = "$log_path\$(Get-Content env:computername)_Qualys_Cloud_Agent_Traces_Removal.log"

# Create a Log writing function
function WriteToLog {
	param (
		[string]$LogText
	)
	Add-Content -Path $Logfile_Path -Value "$(Get-Date) $LogText" -Encoding Unicode
}

Add-Content -Path $Logfile_Path -Value "`n`n$(Get-Date) ---------------------- Qualys Windows Cloud Agent Traces Removal Script - START ---------------------- `n"  -Encoding Unicode

# Get System information to capture in log from Transcript function
$null = Start-Transcript -Append $Logfile_Path
$null = Stop-Transcript

function CleanUpTraces {		
	# Define function to get all child items inside folder
	function Get-Tree($Path, $Include = '*') { 
		@(Get-Item $Path -Include $Include -Force) + 
    (Get-ChildItem $Path -Recurse -Include $Include -Force) | 
		Sort-Object pspath -Descending -unique
	}
	# Defining function to remove all items inside folder
	function Remove-Tree($Path, $Include = '*') { 
		Get-Tree $Path $Include | Remove-Item -force -recurse
	} 

	# Removing left over Qualys Cloud Agent Installation from Program files
	if (Get-Item -Path "C:\Program Files\Qualys" -ErrorAction SilentlyContinue) {
		WriteToLog -LogText "[Found]	The folder C:\Program Files\Qualys\" 
		Remove-Tree  "C:\Program Files\Qualys\" 
		WriteToLog -LogText "[Deleted]	C:\Program Files\Qualys\ folder and all files inside it"
	}
	else {
		WriteToLog -LogText "[Not Found]	The folder C:\Program Files\Qualys " 
 }

	# Creating  an Array to store Scrambled GUID from Qualys Cloud Agent 4.5.3.1 to 5.1.1.41 version
	$prod_scr_guid_list = [System.Collections.Arraylist]@()
	$null = $prod_scr_guid_list.add("775805F68D4A18749B7C0CB053EA986D")
	$null = $prod_scr_guid_list.add("599943FAA06B6F1428FE268C8B94C4E3")
	$null = $prod_scr_guid_list.add("CC7B9F7A6BA34D04A88AAA3679F1FD6B")
	$null = $prod_scr_guid_list.add("6A89656E1398ACF4AB4B6BCD4BCC65A3")
	$null = $prod_scr_guid_list.add("F050522E895349049A54A14DD78BCA0E")
	$null = $prod_scr_guid_list.add("4C7B15ACD60883342841869A3A6A8139")
	$null = $prod_scr_guid_list.add("DD5D5D6212E5B944EACB2598BB9781CE")
	$null = $prod_scr_guid_list.add("C53876DA67B5F5043A1561B34AA84079")
	$null = $prod_scr_guid_list.add("83E0FB7CBDF334B4A89B69E797EE7744")
	$null = $prod_scr_guid_list.add("1DDFFEFEFB7A1C04DB4D919FDDC2D5CD")
	$null = $prod_scr_guid_list.add("38D6D0FE37CE2254A95197974EB462F7")
	$null = $prod_scr_guid_list.add("D8ADF798962FAEA4F980F2BE5F02C322")
	$null = $prod_scr_guid_list.add("EE99EA36DC05D6B47A5BEBB7EA5A3812")
	$null = $prod_scr_guid_list.add("C8B68C451A7A6E84C9FE35187BF8D5CD")
	$null = $prod_scr_guid_list.add("FAE08E14794DF7B448A19D2CECED8BEE")
	$null = $prod_scr_guid_list.add("15744824D1A26614CBAB264C3395D736")
	$null = $prod_scr_guid_list.add("8C49B1AD3EAAFEA4EA82859094497AF9")
	$null = $prod_scr_guid_list.add("D17BDB13D0381A04FACA89A4CA77FF3B")
	$null = $prod_scr_guid_list.add("AF34B78688CFC71459488F3E1CDAB9BE")
	$null = $prod_scr_guid_list.add("C736861B7820A53419018BDC42FDA9E2")
	$null = $prod_scr_guid_list.add("ABA0DEA86DC62184FB3D5A2C77D729C9")
	$null = $prod_scr_guid_list.add("5E36E2F09C5274148A56AE959A070B9A")
	$null = $prod_scr_guid_list.add("FB072CB777A0CA6479A5A0754EE3DF93")
	$null = $prod_scr_guid_list.add("12E771F166429A543B84DEEDE227358C")
	$null = $prod_scr_guid_list.add("86703F78339FF6746946095EE80468EC")
	$null = $prod_scr_guid_list.add("A0C53B4724EB24F41B15D3691D2E1B3A")
	$null = $prod_scr_guid_list.add("1F8B3AD834AA1804781E3C1367DFDF92")
	$null = $prod_scr_guid_list.add("319868B2BCCB9F64598F03CBC964095D")
	$null = $prod_scr_guid_list.add("B0276D68D7BC3C348BC53A5177FFA6CE")
	$null = $prod_scr_guid_list.add("1130284D36D4DE34A90501C205160879")
	$null = $prod_scr_guid_list.add("B5908CE5F89E59248AB349E0AD1E5015")
	$null = $prod_scr_guid_list.add("B3322BE8A35E0E34C82AB64386237C98")
	$null = $prod_scr_guid_list.add("CAAF903254C135D46964E6E3E0E3D5F8")
	$null = $prod_scr_guid_list.add("9EC7D1B19C6F85C499A3AB6B83868882")
	
	# Creating  an Array to store Product GUID from Qualys Cloud Agent 4.5.3.1 to 5.1.1.41 version
	$prod_guid_list = [System.Collections.Arraylist]@()
	$null = $prod_guid_list.add("{6F508577-A4D8-4781-B9C7-C00B35AE89D6}")
	$null = $prod_guid_list.add("{AF349995-B60A-41F6-82EF-62C8B8494C3E}")
	$null = $prod_guid_list.add("{A7F9B7CC-3AB6-40D4-8AA8-AA63971FDFB6}")
	$null = $prod_guid_list.add("{E65698A6-8931-4FCA-BAB4-B6DCB4CC563A}")
	$null = $prod_guid_list.add("{E225050F-3598-4094-A945-1AD47DB8ACE0}")
	$null = $prod_guid_list.add("{CA51B7C4-806D-4338-8214-68A9A3A61893}")
	$null = $prod_guid_list.add("{26D5D5DD-5E21-449B-AEBC-5289BB7918EC}")
	$null = $prod_guid_list.add("{AD67835C-5B76-405F-A351-163BA48A0497}")
	$null = $prod_guid_list.add("{C7BF0E38-3FDB-4B43-8AB9-967E79EE7744}")
	$null = $prod_guid_list.add("{EFEFFDD1-A7BF-40C1-BDD4-19F9DD2C5DDC}")
	$null = $prod_guid_list.add("{EF0D6D83-EC73-4522-9A15-7979E44B267F}")
	$null = $prod_guid_list.add("{897FDA8D-F269-4AEA-9F08-2FEBF5203C22}")
	$null = $prod_guid_list.add("{63AE99EE-50CD-4B6D-A7B5-BE7BAEA58321}")
	$null = $prod_guid_list.add("{54C86B8C-A7A1-48E6-9CEF-5381B78F5DDC}")
	$null = $prod_guid_list.add("{41E80EAF-D497-4B7F-841A-D9C2CEDEB8EE}")
	$null = $prod_guid_list.add("{42844751-2A1D-4166-BCBA-62C433597D63}")
	$null = $prod_guid_list.add("{DA1B94C8-AAE3-4AEF-AE28-58094994A79F}")
	$null = $prod_guid_list.add("{31BDB71D-830D-40A1-AFAC-984AAC77FFB3}")
	$null = $prod_guid_list.add("{687B43FA-FC88-417C-9584-F8E3C1AD9BEB}")
	$null = $prod_guid_list.add("{B168637C-0287-435A-9110-B8CD24DF9A2E}")
	$null = $prod_guid_list.add("{0F2E63E5-25C9-4147-A865-EA59A970B0A9}")
	$null = $prod_guid_list.add("{8AED0ABA-6CD6-4812-BFD3-A5C2777D929C}")
	$null = $prod_guid_list.add("{7BC270BF-0A77-46AC-975A-0A57E43EFD39}")
	$null = $prod_guid_list.add("{1F177E21-2466-45A9-B348-EDDE2E7253C8}")
	$null = $prod_guid_list.add("{87F30768-F933-476F-9664-90E58E4086CE}")
	$null = $prod_guid_list.add("{74B35C0A-BE42-4F42-B151-3D96D1E2B1A3}")
	$null = $prod_guid_list.add("{8DA3B8F1-AA43-4081-87E1-C33176FDFD29}")
	$null = $prod_guid_list.add("{2B868913-BCCB-46F9-95F8-30BC9C4690D5}")
	$null = $prod_guid_list.add("{86D6720B-CB7D-43C3-B85C-A31577FF6AEC}")
	$null = $prod_guid_list.add("{D4820311-4D63-43ED-9A50-102C50618097}")
	$null = $prod_guid_list.add("{5EC8095B-E98F-4295-A83B-940EDAE10551}")
	$null = $prod_guid_list.add("{8EB2233B-E53A-43E0-8CA2-6B346832C789}")
	$null = $prod_guid_list.add("{2309FAAC-1C45-4D53-9646-6E3E0E3E5D8F}")
	$null = $prod_guid_list.add("{1B1D7CE9-F6C9-4C58-993A-BAB638688828}")
	
	# Check for all Scrambled Product GUID in Registry. If found, back up the key and remove entry.
	$backup_number = 0
	foreach ($scr_guid in $prod_scr_guid_list) {
		if (Get-Item -Path Registry::"HKEY_CLASSES_ROOT\Installer\Products\$scr_guid" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	Registry key at :  HKEY_CLASSES_ROOT\Installer\Products\$scr_guid "
			$null = reg export "HKEY_CLASSES_ROOT\Installer\Products\$scr_guid" "$tempFolder\$backup_number$scr_guid.txt" /y
			WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_CLASSES_ROOT\Installer\Products\$scr_guid backed up at  '$tempFolder\$backup_number$scr_guid.txt' "
			$null = Remove-Item -Path Registry::"HKEY_CLASSES_ROOT\Installer\Products\$scr_guid" -Recurse
			WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_CLASSES_ROOT\Installer\Products\$scr_guid "
			$null = $backup_number += 1
		}
		else { 
			WriteToLog -LogText "[Not Found]	Registry key at :  HKEY_CLASSES_ROOT\Installer\Products\$scr_guid " 
  }

		if (Get-Item -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid "
			$null = reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid" "$tempFolder\$backup_number$scr_guid.txt" /y
			WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid backed up at  '$tempFolder\$backup_number$scr_guid.txt'"
			$null = Remove-Item -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid" -Recurse
			WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid "
			$null = $backup_number += 1
		}
		else { 
			WriteToLog -LogText "[Not Found]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\$scr_guid " 
  }
			
		if (Get-Item -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid " 
			$null = reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid" "$tempFolder\$backup_number$scr_guid.txt" /y
			WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid backed up at  '$tempFolder\$backup_number$scr_guid.txt'"
			$null = Remove-Item -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid" -Recurse
			WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid "
			$null = $backup_number += 1
		}
		else { 
			WriteToLog -LogText "[Not Found]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$scr_guid " 
  }
			
		if (Get-ItemProperty -Path Registry::"HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25" -Name "$scr_guid" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	Registry value at :  HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25  $scr_guid "
			$null = reg export "HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25" "$tempFolder\$backup_number$scr_guid.txt" /y
			WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25 - $scr_guid backed up at  '$tempFolder\$backup_number$scr_guid.txt'"
			$null = Remove-ItemProperty -Path Registry::"HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25" -Name "$scr_guid"
			WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25 -$scr_guid "
			$null = $backup_number += 1
		}
		else { 
			WriteToLog -LogText "[Not Found]	The registry entry VALUE HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25 $scr_guid " 
  }
	}

	#Check for all Product GUID in Registry. If found, back up the key and remove entry.
	foreach ($guid in $prod_guid_list) {
		if (Get-Item -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid "
			$null = reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid" "$tempFolder\$backup_number$guid.txt" /y
			WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid backed up at  '$tempFolder\$backup_number$guid.txt'"
			$null = Remove-Item -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid"  -Recurse
			WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid "
			$null = $backup_number += 1 
		}
		else { 
			WriteToLog -LogText "[Not Found]	Registry key at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid " 
  }
			
		if (Get-ItemProperty -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Windows\Installer\$guid\" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	Registry value at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders -Name C:\Windows\Installer\$guid\ " 
			$null = reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" "$tempFolder\$backup_number$guid.txt" /y
			WriteToLog -LogText "[Backed up]	Registry value at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders -Name C:\Windows\Installer\$guid\ backed up at  '$tempFolder\$backup_number$guid.txt'"
			$null = Remove-ItemProperty -Path Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" -Name "C:\Windows\Installer\$guid\"
			WriteToLog -LogText "[Deleted]	Registry value at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders -Name C:\Windows\Installer\$guid\ "
			$null = $backup_number += 1
		}
		else { 
			WriteToLog -LogText "[Not Found]	Registry value at :  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders -Name C:\Windows\Installer\$guid\ " 
  }
			
		if (Test-Path -Path "$Env:windir\Installer\$guid" -ErrorAction SilentlyContinue) {
			WriteToLog -LogText "[Found]	The folder C:\Windows\Installer\$guid " 
			$null = Remove-Tree "$Env:windir\Installer\$guid"
			WriteToLog -LogText "[Deleted]	The folder C:\Windows\Installer\$guid " 
		}
		else { 
			WriteToLog -LogText "[Not Found]	The folder C:\Windows\Installer\$guid " 
  }
	}

	# Keeping each individually backed up registry files as txt file post merged file if in specific registry is to be imported
	# Merging each individually backed up .txt file into one and keep inside \Backed_up_Entries folder
		(Get-Content "$tempFolder\*.txt" -ErrorAction SilentlyContinue) | Where-Object {
		$_ -ne 'Windows Registry Editor Version 5.00'
	} | Add-Content $outputFile 

	# Cleaning up left over Driver files, Driver registry entries and uninstall folder forcefully if found
		
	if (Get-Item -Path "C:\Program Files\_QualysUninstall" -ErrorAction SilentlyContinue) { 
		WriteToLog -LogText "[Found]	The folder C:\Program Files\_QualysUninstall " 
		$null = Remove-Item -Path "C:\Program Files\_QualysUninstall" -Force
		WriteToLog -LogText "[Deleted]	The folder C:\Program Files\_QualysUninstall is deleted" 
	}
 else { 
		WriteToLog -LogText "[Not Found]	The folder C:\Program Files\_QualysUninstall " 
 }

	if (Get-Item -Path "$Env:windir\system32\drivers\qmon.sys" -ErrorAction SilentlyContinue) {
		WriteToLog -LogText "[Found]	The file c:\windows\system32\drivers\qmon.sys " 
		$null = Remove-Item -Path "$Env:windir\system32\drivers\qmon.sys" -Force
		WriteToLog -LogText "[Deleted]	The file c:\windows\system32\drivers\qmon.sys is deleted" 
	}
 else { 
		WriteToLog -LogText "[Not Found]	The file c:\windows\system32\drivers\qmon.sys " 
 }

	if (Get-Item -Path "$Env:windir\system32\drivers\qnetmon.sys" -ErrorAction SilentlyContinue) {
		WriteToLog -LogText "[Found]	The file c:\windows\system32\drivers\qnetmon.sys " 
		$null = Remove-Item -Path "$Env:windir\system32\drivers\qnetmon.sys" -Force
		WriteToLog -LogText "[Deleted]	The file c:\windows\system32\drivers\qnetmon.sys is deleted" 
	}
 else { 
		WriteToLog -LogText "[Not Found]	The file c:\windows\system32\drivers\qnetmon.sys " 
 }

	if (Get-Item -Path "$Env:windir\system32\drivers\qexprt.sys" -ErrorAction SilentlyContinue) {
		WriteToLog -LogText "[Found]	The file c:\windows\system32\drivers\qexprt.sys " 
		$null = Remove-Item -Path "$Env:windir\system32\drivers\qexprt.sys" -Force
		WriteToLog -LogText "[Deleted]	The file c:\windows\system32\drivers\qexprt.sys is deleted" 
	}
 else	{ 
		WriteToLog -LogText "[Not Found]	The file c:\windows\system32\drivers\qexprt.sys " 
 }
	
	if (Get-Item -Path Registry::"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon" -ErrorAction SilentlyContinue) {
		WriteToLog -LogText "[Found]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon "
		$null = reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon" "$tempFolder\qmon.txt"  /y
		WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon backed up"
		$null = Remove-Item -Path Registry::"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon"   -Recurse
		WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon "
		$null = $backup_number += 1
	}
 else { 
		WriteToLog -LogText "[Not Found]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qmon " 
 }
		
	if (Get-Item -Path Registry::"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon" -ErrorAction SilentlyContinue) {
		WriteToLog -LogText "[Found]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon "
		$null = reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon" "$tempFolder\qnetmon.txt" /y
		WriteToLog -LogText "[Backed up]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon backed up"
		$null = Remove-Item -Path Registry::"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon"   -Recurse
		WriteToLog -LogText "[Deleted]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon "
		$null = $backup_number += 1
	}
 else { 
		WriteToLog -LogText "[Not Found]	Registry key at :  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\qnetmon " 
 }
	
}

# Checking for Qualys Cloud Agent Service and QualysAgent.exe file presence to decide if to run Script further or Exit.

WriteToLog -LogText " [Verification]	Checking if Agent Service is installed and running."
$Service_Exists = Get-Service -Name QualysAgent -ErrorAction SilentlyContinue
if ($Service_Exists.Name -eq "QualysAgent") {
	WriteToLog -LogText "[Verification]	Qualys Agent Service found "
	if (Test-Path -Path "C:\Program Files\Qualys\QualysAgent\QualysAgent.exe" -ErrorAction SilentlyContinue) {
 	WriteToLog -LogText "[Verification]	Qualys Agent Binary found at : C:\Program Files\Qualys\QualysAgent\QualysAgent.exe " 
		WriteToLog -LogText "[Action]	Qualys Windows Cloud Agent Traces Removal Script exiting without further actions."
		WriteToLog -LogText "[End]	Exiting Qualys Windows Cloud Agent Traces Removal script without any modification to Current System's state"
		#Returing result back to SCCM that cleanup execution is not done.
		Write-host "NA"
	}
 else {
		WriteToLog -LogText "[Verification]	System's state is inconsistent. Please contact Qualys Support Team as Windows Cloud Agent Service exists and binary is missing"
		WriteToLog -LogText "[Action]	Qualys Windows Cloud Agent Traces Removal Script exiting without further actions."
		WriteToLog -LogText "[End]	Exiting Qualys Windows Cloud Agent Traces Removal script without any modification to Current System's state"
		#Returing result back to SCCM that cleanup execution is not done.
		Write-host "NA"
	}
}
else {
	WriteToLog -LogText " [Verification]	Qualys Cloud Agent Service is not installed"
	WriteToLog -LogText "[Start]	Initiating Qualys Windows Cloud Agent Traces Removal "
	#Calling Cleanup Routine Function
	CleanUpTraces
	WriteToLog -LogText "[End]	Finishing Qualys Windows Cloud Agent Traces Removal "
	#Returing result back to SCCM that cleanup execution is done
	Write-host "Done"
}

Add-Content -Path $Logfile_Path -Value "`n`n$(Get-Date) ---------------------- Qualys Windows Cloud Agent Traces Removal Script - END  ---------------------- `n"  -Encoding Unicode
# SIG # Begin signature block
# MIISgwYJKoZIhvcNAQcCoIISdDCCEnACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC2a7N7jrg46eE6
# poC72dZU8v+1prsn2wIiklWapkOPgaCCDqowggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggfyMIIF2qADAgECAhAF6XAahZb+vM7kFb4oNpPCMA0G
# CSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjIwNTEyMDAwMDAwWhcNMjMwNTEy
# MjM1OTU5WjCBxzETMBEGCysGAQQBgjc8AgEDEwJVUzEZMBcGCysGAQQBgjc8AgEC
# EwhEZWxhd2FyZTEdMBsGA1UEDwwUUHJpdmF0ZSBPcmdhbml6YXRpb24xEDAOBgNV
# BAUTBzMxNTIxNDAxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRQw
# EgYDVQQHEwtGb3N0ZXIgQ2l0eTEVMBMGA1UEChMMUXVhbHlzLCBJbmMuMRUwEwYD
# VQQDEwxRdWFseXMsIEluYy4wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQCWaSHr/CQZO4dnW0QUTEMUDAadbv3ndhxpUR8ayWxsv0X/zoddEYnZue4Sya22
# 8DJj+xN5R19r+h3Eqz6TAWBQE3N5jZr4uxiYVh8L00aJAvlkpleA+6gIulVVySn4
# QSuIm2MqINI7eM632ywtxPD6MKSATin8SNtP/8mkH57XxHUKqWgD6eTCMsCUsvJx
# pCt2mAdD9zWoR3RUSPGO2xLQXmL+D+WqEngftXOH/g+tPuP/8dDz/bMCShfQrjTH
# jkvbxxf6vLH7zcPlIF8LVARY6a+bqwdDhaJhIuNaFfDgi04b6btViuIsW+P5ALm4
# Arz2B0XRh+ZbxYRLQoDGTF13I4eMWfpw/VITIX1qFhQKY1pq5+hYLG/hglmY5EAl
# 26+SmQh9R1tpDz1tRh8GHUXg7cvehlkdk0iauUWG7cmSTilen2bRWq0NaiVcDaN+
# mO7FiGpJTPHLDfKaf+IEFa3Tv2s8GPdS/YoAm5Du/pUJLgn8kRObBlVNBmt/1e/j
# bYKqokskcsrpiA153MLZsdwLjkvvAn6LBCBB3wPpF4zqFkNOdgYqJZWE1DGPen6I
# pLj5QyGSBvVxjteARBFSXwlDEch9GSFf+VRFfKoBf4oktWkR2d30c5i1qWK6F1+E
# DEqmeAHrRckamO001ysaNtEVYgKtYj8hkT8Y6aBIcaFhBwIDAQABo4ICNTCCAjEw
# HwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYDVR0OBBYEFKgUgdoh
# aa2Y+HG0LWvecQ8KbW5+MC4GA1UdEQQnMCWgIwYIKwYBBQUHCAOgFzAVDBNVUy1E
# RUxBV0FSRS0zMTUyMTQwMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEF
# BQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQyMDIx
# Q0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmwwPQYD
# VR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIBFhtodHRwOi8vd3d3LmRpZ2lj
# ZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGEMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUHMAKGUGh0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVTaWduaW5nUlNBNDA5
# NlNIQTM4NDIwMjFDQTEuY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQAD
# ggIBAKXggDTvMiVkGHZGCNOOb87VJ2nEmGUgXJt0VdZ8kkih6OvwfioYGNs4gZ3m
# K93fCuc5wk5XO4F7DCsiaQDU1VT0beSsQqTxc17muloWUCloQqaZTz/+Bv//Je3N
# cv0gFHYlJu54P0BrK8LlXUhv+RR/BlawrDI4tkgbTRW9nsOFgmQEJtPL4oz3iQ4D
# NREpPyg+L6s5qphvBeLPqrGFREqftLCI6dkdMxaThYu9fT91VzCtQhN7GOqqEVQI
# mszKWE+T9Gmij9xIFFbcbRr/5P5gr75XfItbznvLkCwX1b7IXfOB32Kars6Bhi5h
# IJrxViwy4MSLn6B/WHoAxElJJ07GP8vU8Ia6sL8qlM5GWPpK7DXPW/cSA0fQR+kZ
# 44VTEiUbaOrJHU5BHlAY3bv7fYZj+YxADL+PSYIsM9X2gMLSAVkUDxms+RwKfRvj
# 1Pl/7RNShxTwY4oDLmWVKrIhfBIVNurvdC0RyRmV91H5nvhoie8IqPSRlLv6yMoI
# P2Q5ePRCwIXFslSJMgEW53sKooqY5c3P9FfJm5Eo3Mq3fHPbIw9u8a8w+ghRBddu
# /K/+VvpRdrYa7KIpctT+xBZ8q9zP+rc+EX78qoXK9tQICMhOcf9HEB7MRaTpqDr+
# ctVSzfv9AEXFASi4i+W7PWk14KoZqaRIyPZRAoFTi2U81JTBMYIDLzCCAysCAQEw
# fTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNV
# BAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWduaW5nIFJTQTQwOTYgU0hB
# Mzg0IDIwMjEgQ0ExAhAF6XAahZb+vM7kFb4oNpPCMA0GCWCGSAFlAwQCAQUAoIGE
# MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkE
# MSIEIPY7cv0JrnkMW6V3HHQglwQ+0G3FMbZvyvB/ajnt91J7MA0GCSqGSIb3DQEB
# AQUABIICABSLnefbEn2w2/km2N3JiMBiI5RjgcaOdiMqi2IbQtvzZdZ1Xc/VGqoi
# amQl63F/DVDV5pkW1NsKR6Qudo40myj2QuIg+B2k/6N9YITwatdojnpjlBytMI6q
# EkVNz7A20HghwjGJRMfm5CWCMc6mEV6RyMam5l4kZMrzFMC8GLPcEjv/wv2kmC18
# uBSCHAY6N2HuCppr2C+A1Ybm+RO3BEbsvDxJvxUooWQcterT/FubeyLSHvgbyANU
# 4SvCkxci5rSGVVlQZ5wWxwCkh8N+ixCkGspLsp5K11vODqOLcBrMPXFOYKQql3XG
# vA6PeUmeH5ggWJIb82tU4/LrQOSNEyky6nGsflANjLVUQjiP6geE+nr0isrbssXi
# VUUB5cAOmP/8iSgI8nUQbvCv1pNbwc+8TBhSPcZ/sU/bT768xTxZnhcDVFJD8LNR
# eZ7iagmwIdzq4p6WspbJ6EYh/wQgFblTnSJ/mLWwwwj2LjCZ4a8G5heW/+4Xy7is
# anN/AGsO2gGEvLQqH+MU4qvLk4wsLWRARJpSZA2zY4TH1og4wIEGNWJRbvF3/mmA
# mgWqK31bmyxMGD11ulFk4piw3naqFtiFZ1MGwB9ZnOZHDvYnRVuHTjoi8V3b3ci6
# vxfCa+UUKfmKve7N8y1LFXDwv2Lz6mLoOX/DF9QaPnfPAroCC2nn
# SIG # End signature block
