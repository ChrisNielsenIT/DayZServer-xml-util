function Set-DZSItemMinimumValue
{
<#
.Synopsis
	Changes the min value for an item or all items in types.xml
.Example
	Set-DZSItemMinimumValue -typesXML $types_xml_in -item AK101 -absoluteValue 10 -WhatIf
.Example
	Set-DZSItemMinimumValue -typesXML $types_xml_in -all -percentageValue 25
#>
#Requires -Version 3.0
[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	Param
    (
        [Parameter(Mandatory)]
    	[xml]$typesXML,
		[Parameter(ParameterSetName='SingleItem_AbsValue')]
		[Parameter(ParameterSetName='SingleItem_PercentageValue')]
		[AllowNull()]
		[string]$item = $null,
		[Parameter(ParameterSetName='AllItems_AbsValue')]
		[Parameter(ParameterSetName='AllItems_PercentageValue')]
		[switch]$all,
		[Parameter(ParameterSetName='SingleItem_AbsValue')]
		[Parameter(ParameterSetName='AllItems_AbsValue')]
    	[int]$absoluteValue,
		[Parameter(ParameterSetName='SingleItem_PercentageValue')]
		[Parameter(ParameterSetName='AllItems_PercentageValue')]
    	[int]$percentageValue

    )
	BEGIN
	{
		$DebugPreference = "Continue";
	}
    PROCESS 
	{
		if(-not [String]::IsNullOrEmpty($item))
		{
			$selectedItem = $typesXML.SelectSingleNode("/types/type[@name='$item']");
			if($selectedItem.name -eq $null -or $selectedItem.name -lt 0)
			{
				throw "Selected item '$($item)' could not be found, check spelling";
				#return;
			}
			else
			{
				if($absoluteValue)
				{
					if($PSCmdlet.ShouldProcess($selectedItem.name, "Changing min value to $($absoluteValue)"))
					{
						$selectedItem.min = $absoluteValue.ToString();
					}
					
				}
				if($percentageValue)
				{
					if($PSCmdlet.ShouldProcess($selectedItem.name, "Changing min value"))
					{
						if($percentageValue -gt 0)
						{
							[int]$baseminValue = $selectedItem.min;
							$incrementValue = [math]::Round($baseminValue * ($percentageValue / 100));
							$selectedItem.min = ($baseminValue + $incrementValue).ToString(); 
						}
						if($percentageValue -lt 0)
						{
							[int]$baseminValue = $selectedItem.min;
							$decrementValue = [math]::Round($baseminValue * ([math]::Abs($percentageValue) / 100));
							$selectedItem.min = ($baseminValue - $decrementValue).ToString(); 
						}
					}
				}
			
				write-debug $($selectedItem).InnerXml;
			}
			
		}
		if($all.IsPresent)
		{
			$allValidItems = $typesXML.SelectNodes("/types/type[min]");
			if($absoluteValue)
			{
				Foreach($validItem in $allValidItems)
				{
					if($PSCmdlet.ShouldProcess($validItem.name, "Changing min value to $($absoluteValue)"))
					{
						$validItem.min = $absoluteValue.ToString();
					}
					write-debug $($validItem).InnerXml;
				}
			}
			if($percentageValue)
				{
					if($PSCmdlet.ShouldProcess($selectedItem.name, "Changing min value"))
					{
						if($percentageValue -gt 0)
						{
							[int]$baseminValue = $selectedItem.min;
							$incrementValue = [math]::Round($baseminValue * ($percentageValue / 100));
							$selectedItem.min = ($baseminValue + $incrementValue).ToString(); 
						}
						if($percentageValue -lt 0)
						{
							[int]$baseminValue = $selectedItem.min;
							$decrementValue = [math]::Round($baseminValue * ([math]::Abs($percentageValue) / 100));
							$selectedItem.min = [math]::Abs(($baseminValue - $decrementValue)).ToString(); 
						}
					}
				}
		}
    }
	END
	{	
		$savePath = ($pwd).Path + "\types.changed.xml";
		if($PSCmdlet.ShouldProcess($savePath,"Saving changes"))
		{
			$typesXML.Save($savePath);
		}
	}
} 