# XOSSBaselineW2k19DSC

The XOSSBaselineW2k19DSC PowerShell module provides
DSC resources that can be used to ... (explain what functionality the resources are meant to provide)

## Installation

To manually install the module, download the source code and unzip the contents
of the \Modules\XOSSBaselineW2k19DSC directory to the
$env:ProgramFiles\WindowsPowerShell\Modules folder

To install from the PowerShell gallery using PowerShellGet (in PowerShell 5.0)
run the following command:

    Find-Module -Name XOSSBaselineW2k19DSC -Repository PSGallery | Install-Module

To confirm installation, run the below command and ensure you see the
XOSSBaselineW2k19DSC DSC resoures available:

    Get-DscResource -Module XOSSBaselineW2k19DSC

## Usage

Include the following in your DSC configuration

    Import-DSCResource -ModuleName XOSSBaselineW2k19DSC

### MyResource

    MyResource resourceName {
        Ensure  =   "Present"
    }

## Requirements

The minimum PowerShell version required is 4.0, which ships in Windows 8.1
or Windows Server 2012R2 (or higher versions). The preferred version is
PowerShell 5.0 or higher, which ships with Windows 10 or Windows Server 2016.

