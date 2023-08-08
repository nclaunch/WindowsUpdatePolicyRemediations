$keys = @()

#Windows Update - AutoUpdate
$keys += New-Object -TypeName psobject -Property @{
    RegistryPath = 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\'
    Entries = @('UseUpdateClassPolicySource','UseWUServer','AUOptions','AllowAutoUpdate','NoAutoUpdate')
}

#Windows Update
$keys += New-Object -TypeName psobject -Property @{
    RegistryPath = 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate'
    Entries = @('DeferFeatureUpdates','DeferFeatureUpdatesPeriodInDays','PauseFeatureUpdatesStartTime','DeferQualityUpdates','DeferQualityUpdatesPeriodInDays','PauseQualityUpdatesStartTime','ScheduledInstallDay','ScheduledInstallTime','ExcludeWUDriversInQualityUpdate','BranchReadinessLevel','DoNotConnectToWindowsUpdateInternetLocations','DisableWindowsUpdateAccess','SetPolicyDrivenUpdateSourceForDriverUpdates','SetPolicyDrivenUpdateSourceForQualityUpdates','SetPolicyDrivenUpdateSourceForFeatureUpdates','WUServer')
}

foreach ($key in $keys)
{
    try
    {
        $value = Get-ItemProperty -Path $key.RegistryPath -ErrorAction Stop
        Write-Host ('[{0}]: Registry Key exists. Checking for individual values.' -f $key.RegistryPath)

        foreach ($entry in $key.Entries)
        {
            if (-not [string]::IsNullOrWhiteSpace($value.$entry))
            {
                Write-Host ('[{0}]: Found conflicting value [{1}].' -f $key.RegistryPath, $entry)
                exit 1
            }
        }
    }
    catch
    {
        Write-Host ('[{0}]: Registry Key does not exist. No action needed.' -f $key.RegistryPath)
    }
}
