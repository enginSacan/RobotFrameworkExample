*** Settings ***
Suite Teardown  Run Keywords    Close All Connections   KILL_ALL_SCREEN     Close All Browsers
Suite Setup     KILL_ALL_SCREEN
Resource        LoginDeviceSerial.robot
Resource        OpenBrowser.robot 
*** Test Cases ***
Check Port Number for Telnet
    [Tags]      ${target}
    Get_CLI_Prompt_after_Login_State
    Write   c t 
    ${output}=	Read Until  CLI(config)#
    Write   no telnet-server
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   telnet-server port 49499
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   telnet-server port 65536
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   telnet-server port 49501
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   telnet-server port 65535
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   end; sh running-config
    ${output}=	Read Until  CLI#
    Should Contain  ${output}   telnet-server port 65535
    Should Contain  ${output}   no telnet-server
    Write   c t 
    ${output}=	Read Until  CLI(config)#

Check Port Number for SSH
    [Tags]      ${target}
    Get_CLI_Config
    Write   no ssh-server
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   ssh-server port 49499
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   ssh-server port 65536
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   ssh-server port 65535
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   The specified port number is used by another service
    Write   no telnet-server port
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   telnet-server
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   ssh-server port 65534
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   ssh-server port 49500
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   end; sh running-config
    ${output}=	Read Until  CLI#
    Should Contain  ${output}   ssh-server port 49500
    Should Contain  ${output}   no ssh-server
    Write   c t;no ssh-server port 
    ${output}=	Read Until  CLI(config)#
    Write   ssh-server
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %

Check Port Number for HTTP
    [Tags]      ${target}
    Get_CLI_Config
    Write   no ip http
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   ip http port 49499
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   ip http port 65536
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   ip http port 49507
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   HTTP port number will take effect only when HTTP is disabled and enabled again
    Write   end; sh running-config
    ${output}=	Read Until  CLI#
    Should Contain  ${output}   ip http port 49507
    Should Contain  ${output}   no ip http
    Write   c t;no ip http port
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   end; sh running-config
    Should Not Contain  ${output}   ip http port 49507
    Write   c t;ip http
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %

Check Port Number for HTTPS
    [Tags]      ${target}
    Get_CLI_Config
    Write   no ip http secure
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   ip http secure port 49499
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   ip http secure port 65536
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   Invalid input detected at '^' marker
    Write   ip http secure port 49509
    ${output}=	Read Until  CLI(config)#
    Write   end; sh running-config
    ${output}=	Read Until  CLI#
    Should Contain  ${output}   ip http secure port 49509
    Should Contain  ${output}   no ip http secure
    Write   c t;no ip http secure port
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %
    Write   ip http secure
    ${output}=	Read Until  CLI(config)#
    Should Not Contain  ${output}   %

Check Port Number for Telnet,SSH,HTTPS,HTTP in WBM
    [Tags]      ${target}
    Open Browser To Login Page
    Login WBM by Admin User
    ${system_button} =	Get WebElement  xpath://a[text()='System']
    Click Element   ${system_button} 
    ${config_button} =	Get WebElement  xpath://a[text()='Configuration']
    Click Element   ${config_button} 
    Unselect Checkbox    id:AutomationTelnetAdminStatus_0
    ${telnet_port} =	Get WebElement	id:EvTelnetPort_0
    Input Text  ${telnet_port}     49499
    Element Text Should Be  id:msgcontent   Value must be 23 (default) or between 49500 and 65535
    Input Text  ${telnet_port}     65536
    Element Text Should Be  id:msgcontent   Value must be 23 (default) or between 49500 and 65535
    Input Text  ${telnet_port}     49500
    Click Element   id:btnWrite
    Wait Until Element Is Enabled   id:SnMspsHttpSshStatus_0    timeout=5
    Unselect Checkbox   id:SnMspsHttpSshStatus_0
    ${ssh_port} =	Get WebElement	id:EvSshPort_0
    Input Text  ${ssh_port}     49499
    Element Text Should Be  id:msgcontent   Value must be 22 (default) or between 49500 and 65535
    Input Text  ${ssh_port}     65536
    Element Text Should Be  id:msgcontent   Value must be 22 (default) or between 49500 and 65535
    Input Text  ${ssh_port}     49500
    Click Element   id:page_content
    Element Text Should Be  id:msgcontent   The specified port number is used by another service
    Input Text  ${ssh_port}     65000
    Click Element   id:btnWrite
    Wait Until Element Is Enabled   id:EvHttpsServer_0    timeout=5
    Unselect Checkbox    id:EvHttpsServer_0
    ${https_port} =	Get WebElement	id:EvHttpsPort_0
    Input Text  ${https_port}     49499
    Wait Until Element Is Visible   id:msgcontent    timeout=5
    Element Text Should Be  id:msgcontent   Value must be 443 (default) or between 49500 and 65535
    Input Text  ${https_port}     65536
    Element Text Should Be  id:msgcontent   Value must be 443 (default) or between 49500 and 65535
    Input Text  ${https_port}     65450
    Wait Until Element Is Enabled   id:EvHttpServer_0    timeout=5
    Unselect Checkbox    id:EvHttpServer_0
    ${http_port} =	Get WebElement	id:EvHttpPort_0
    Input Text  ${http_port}     49499
    Element Text Should Be  id:msgcontent   Value must be 80 (default) or between 49500 and 65535
    Input Text  ${http_port}     65536
    Element Text Should Be  id:msgcontent   Value must be 80 (default) or between 49500 and 65535
    Select Checkbox    id:EvHttpServer_0
    Input Text  ${http_port}     62500
    Click Element   id:btnWrite
    Open Browser Other Port To Login Page
    Login WBM by Admin User
    ${system_button} =	Get WebElement  xpath://a[text()='System']
    Click Element   ${system_button} 
    ${config_button} =	Get WebElement  xpath://a[text()='Configuration']
    Click Element   ${config_button} 
    Unselect Checkbox    id:AutomationTelnetAdminStatus_0
    ${telnet_port} =	Get WebElement	id:EvTelnetPort_0
    ${ssh_port} =	Get WebElement	id:EvSshPort_0
    ${http_port} =	Get WebElement	id:EvHttpPort_0
    ${https_port} =	Get WebElement	id:EvHttpsPort_0
    Clear Element Text  ${telnet_port}
    Input Text  ${telnet_port}     23
    Clear Element Text  ${ssh_port}
    Input Text  ${ssh_port}     22
    Clear Element Text  ${http_port}
    Input Text  ${http_port}     80
    Clear Element Text  ${https_port}
    Input Text  ${https_port}     443
    Select Checkbox     id:AutomationTelnetAdminStatus_0
    Select Checkbox     id:SnMspsHttpSshStatus_0
    Select Checkbox     id:EvHttpsServer_0
    Click Element   id:btnWrite
    