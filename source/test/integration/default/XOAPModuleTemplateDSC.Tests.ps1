Describe 'When setting up a webserver' {
  Context 'to start the default website' {

    It 'verifies IIS is installed' {
      (Get-WindowsFeature web-server).installed | should be $true
    }

    It 'installs a default website' {
      Get-Website 'Default Web Site' | should not be $null
    }
  }
}
