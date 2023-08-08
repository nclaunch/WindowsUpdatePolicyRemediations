$keys = @()
 
#Windows Update - AutoUpdate
$keys+= New-Object -TypeName psobject -Property @{
    RegistryPath = 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\'
    Entries = @('UseUpdateClassPolicySource','UseWUServer','AUOptions','AllowAutoUpdate','NoAutoUpdate')
}

#Windows Update
$keys+= New-Object -TypeName psobject -Property @{
    RegistryPath = 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate'
    Entries = @('DeferFeatureUpdates','DeferFeatureUpdatesPeriodInDays','PauseFeatureUpdatesStartTime','DeferQualityUpdates','DeferQualityUpdatesPeriodInDays','PauseQualityUpdatesStartTime','ScheduledInstallDay','ScheduledInstallTime','ExcludeWUDriversInQualityUpdate','BranchReadinessLevel','DoNotConnectToWindowsUpdateInternetLocations','DisableWindowsUpdateAccess','SetPolicyDrivenUpdateSourceForDriverUpdates','SetPolicyDrivenUpdateSourceForQualityUpdates','SetPolicyDrivenUpdateSourceForFeatureUpdates','WUServer')
}

foreach ($key in $keys)
{
    try
    {
        $value = $null = Get-ItemProperty -Path $key.RegistryPath -ErrorAction Stop

        foreach ($entry in $key.Entries)
        {
            if (-not [string]::IsNullOrWhiteSpace($value.$entry))
            {
                try
                {
                    Write-Host ('[{0}]: Removing conflicting value [{1}].' -f $key.RegistryPath, $entry)
                    $null = Remove-ItemProperty -Path $key.RegistryPath -Name $entry -ErrorAction Stop
                }
                catch
                {
                    Write-Host ('[{0}]: Issue remove conflicting value [{1}].' -f $key.RegistryPath, $entry)
                }
            } 
        }
    }
    catch
    {
        Write-Host ('[{0}]: Issue removing key.' -f $key.RegistryPath)
    }
}
