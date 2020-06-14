function Fix-DZSNominalMinimumRelationship
{
<#
.Synopsis
	Fixes the nominal and minimum values of types to conform to the rule that minimum values must be less than or equal to nominal.
.Example
	Fix-DZSNominalMinimumRelationship -typesXML $typesXMLObject -changeMin -WhatIf
.Example
	Fix-DZSNominalMinimumRelationship -typesXML $typesXMLObject -changeNominal
#>
#Requires -Version 3.0
[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	Param
    (
        [Parameter(Mandatory)]
    	[xml]$typesXML,
		[Parameter(Mandatory,ParameterSetName='AffectedMinimum')]
    	[switch]$changeMin,
		[Parameter(Mandatory,ParameterSetName='AffectedNominal')]
    	[switch]$changeNominal
    )
	BEGIN{}
    PROCESS 
	{
		$allValidItems = $typesXML.SelectNodes("/types/type[nominal]");
		Foreach($item in $allValidItems)
		{
			if($item.nominal -lt $item.min)
			{
				if($changeMin.IsPresent)
				{
					if($PSCmdlet.ShouldProcess($item.name, "Changing min value to $($item.nominal)"))
					{
						$item.min = $item.nominal;
					}
				}
				if($changeNominal.IsPresent)
				{
					if($PSCmdlet.ShouldProcess($item.name, "Changing nominal value to $($item.min)"))
					{
						$item.nominal = $item.min;
					}
				}
			}
		}
    }
	END
	{	
		$savePath = ($pwd).Path + "\types.fixed.xml";
		if($PSCmdlet.ShouldProcess($savePath,"Saving changes"))
		{
			$typesXML.Save($savePath);
		}
	}
} 