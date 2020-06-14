# DayZServer-xml-util
Powershell functions to easily change and validate DayZServer XML files

Example 1: 
$typesXMLPath = Resolve-Path types.xml;  
$typesXML_in = [xml](Get-Content $typesXMLPath);  
. .\Validate-DZSNominalMinimumRelationship.ps1  
Validate-DZSNominalMinimumRelationship.ps1 -typesXML $typesXML_in  
