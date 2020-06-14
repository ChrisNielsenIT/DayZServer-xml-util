function Validate-DZSNominalMinimumRelationship
{
<#
.Synopsis
	Validates that all items with a nominal and min value, have a nominal value that is greater than or equal to the min value.
.Example
	$result = Validate-DZSNominalMinimumRelationship -typesXML $typesXMLObject
#>
#Requires -Version 3.0
[CmdletBinding()]
	Param
    (
        [Parameter(Mandatory)]
    	[xml]$typesXML
    )
	BEGIN
	{
		[bool]$result = $true; #$true for NO VALIDATION ERRORS and $false for ERRORS.
	}
    PROCESS 
	{
		$allValidItems = $typesXML.SelectNodes("/types/type[nominal]");
		Foreach($item in $allValidItems)
		{
			if($item.nominal -lt $item.min)
			{
				$result = $false;
				Write-Verbose "$($item.name): Nominal is $($item.nominal) but Minimum is $($item.min)";
			}
		}
    }
	END
	{
		return $result;
	}
} 