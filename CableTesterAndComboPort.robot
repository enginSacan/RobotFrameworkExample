*** Settings ***
Suite Teardown  Run Keywords    Close All Connections   KILL_ALL_SCREEN     Close All Browsers
Suite Setup     KILL_ALL_SCREEN
Test Teardown   Check Internal Error
Resource        LoginDeviceSerial.robot
Resource        OpenBrowser.robot 
Variables       lib/glob_config.py   ${target}
*** Test Cases ***
Cable_Test_CLI
    [Tags]      ${target}
    Run Keyword if  '${glob_free_port_on_device}' == 0   
    ...     Run Keywords
    ...     Write     admin
    ...     AND     Linux Terminal
    ...     AND     Write     ifdown eth0
    ...     AND     Read Until  sh-4.3#
    Get_CLI_Prompt_after_Login_State
    Check_Initial_Configuration
    Write      end;c t;cabletest int ${glob_cabletester_open_port}
    ${output}=	Read Until  CLI(config)#
    Should Contain X Times  ${output}   Open    2
    Should Contain X Times  ${output}   Not tested    2
    Write      end;c t;cabletest int ${glob_cabletester_link_up_port}
    ${output}=	Read Until  CLI(config)#
    Should Contain  ${output}   	% Interface has link up. Cabletester will cause a temporary link down.
    Write      end;c t;cabletest int ${glob_cabletester_link_up_port} force
    ${output}=	Read Until  CLI(config)#
    Should Contain X Times  ${output}   Normal    2
    Should Contain X Times  ${output}   Not tested    2
    Should Contain X Times  ${output}   Unknown length    2
    Write      end;show cabletest int ${glob_cabletester_open_port}
    ${output}=	Read Until  CLI#
    Should Contain X Times  ${output}   Open    2
    Should Contain X Times  ${output}   Not tested    2
    Write      end;show cabletest int ${glob_cabletester_link_up_port}
    ${output}=	Read Until  CLI#
    Should Contain X Times  ${output}   Normal    2
    Should Contain X Times  ${output}   Not tested    2
    Should Contain X Times  ${output}   Unknown length    2
    Run Keyword if  '${glob_free_port_on_device}' == 0   
    ...     Run Keywords
    ...     Write     admin
    ...     AND     Linux Terminal
    ...     AND     Write     ifup eth0
    ...     AND     Read Until  sh-4.3#

Cable_Test_WBM
    [Tags]      ${target}
    Run Keyword if  '${glob_free_port_on_device}' == 0   
    ...     Run Keywords
    ...     Write     admin
    ...     AND     Linux Terminal
    ...     AND     Write     ifdown eth0
    ...     AND     Read Until  sh-4.3#
    Open Browser To Login Page
    Login WBM by Admin User
    Click Element   link:System
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Click Element   link:Port Diagnostics
    Wait Until Element Is Visible   id:CabletesterPortList_0
    Select From List By Value   id:CabletesterPortList_0    ${glob_cabletester_link_up_port_wbm}
    Sleep   4sec
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Enabled   id:CabletestRuntest_0
    Click Element   id:CabletestRuntest_0
    Element Should Contain  id:divMsgBoxContent   Running the cable test will break the link for a moment.
    Click Element   id:btnOk
    Sleep   4sec
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Enabled   id:btnRefresh
    Click Element   id:btnRefresh
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    ${value_1} =    Get Value   xpath://*[@id="UITable_cabletesterDiagd2_0"]/td[2]/input
    ${value_2} =    Get Value   xpath://*[@id="UITable_cabletesterDiagd2_1"]/td[2]/input
    Should Be Equal     ${value_1}  OK
    Should Be Equal     ${value_1}  OK
    Select From List By Value   id:CabletesterPortList_0    ${glob_cabletester_open_port_wbm}
    Sleep   4sec
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Visible   id:CabletestRuntest_0
    Wait Until Element Is Enabled   id:CabletestRuntest_0
    Click Element   id:CabletestRuntest_0
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Enabled   id:btnRefresh
    ${value_1} =    Get Value   xpath://*[@id="UITable_cabletesterDiagd8_0"]/td[2]/input
    ${value_2} =    Get Value   xpath://*[@id="UITable_cabletesterDiagd8_1"]/td[2]/input
    Should Be Equal     ${value_1}  open
    Should Be Equal     ${value_1}  open
    Click Element   class:logout
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Run Keyword if  '${glob_free_port_on_device}' == 0   
    ...     Run Keywords
    ...     Write     admin
    ...     AND     Linux Terminal
    ...     AND     Write     ifup eth0
    ...     AND     Read Until  sh-4.3#

Comboport_CLI
    [Tags]      ${target}
    Pass Execution If  '${glob_combo_ports_supported}' == 0     Comboport is not supported.
    Get_CLI_Config
    Check_Initial_Configuration
    Write   c t
    Write   interface ${glob_combo_port}
    Write   media-type rj45
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Write   end
    Write   show interface ${glob_combo_port}
    ${output}=	Read Until  CLI#
    Should Contain  ${output}   rj45
    Write   c t
    Write   interface ${glob_combo_port}
    Write   media-type sfp
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Write   do show interface ${glob_combo_port}
    ${output}=  Read Until  )#
    Should Contain  ${output}   sfp
    Write   media-type auto
    Write   do show interface ${glob_combo_port}
    ${output}=  Read Until  )#
    Should Contain  ${output}   auto

Comboport_WBM
    [Tags]      ${target}
    Pass Execution If  '${glob_combo_ports_supported}' == 0     Comboport is not supported.
    Switch Browser      1
    Login WBM by Admin User
    Click Element   link:System
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Sleep   1sec
    Click Element   link:Ports
    Wait Until Element Is Visible   xpath://input[@value='${glob_combo_port_wbm}']
    Click Element   xpath://input[@value='${glob_combo_port_wbm}']
    Wait Until Element Is Visible   id:EvCfgsWbmPortMediaType_0
    Select From List By Value   id:EvCfgsWbmPortMediaType_0   2
    Wait Until Element Is Enabled   id:btnWrite
    Click Element   id:btnWrite
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Enabled   class:inactiveReg
    Click Element   class:inactiveReg
    Wait Until Element Is Visible   xpath://*[@id="gridGeneralPortsd19"]/td[4]
    Element Should Contain  xpath://*[@id="gridGeneralPortsd19"]/td[4]  rj45
    Click Element   xpath://input[@value='${glob_combo_port_wbm}']
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Select From List By Value   id:EvCfgsWbmPortMediaType_0   3
    Wait Until Element Is Enabled   id:btnWrite
    Click Element   id:btnWrite
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Enabled   class:inactiveReg
    Click Element   class:inactiveReg
    Wait Until Element Is Visible   xpath://*[@id="gridGeneralPortsd19"]/td[4]
    Element Should Contain  xpath://*[@id="gridGeneralPortsd19"]/td[4]  sfp
    Click Element   xpath://input[@value='${glob_combo_port_wbm}']
    Wait Until Element Is Not Visible   id:simplemodal-overlay
    Wait Until Element Is Visible   id:EvCfgsWbmPortMediaType_0
    Select From List By Value   id:EvCfgsWbmPortMediaType_0   1
    Wait Until Element Is Enabled   id:btnWrite
    Click Element   id:btnWrite
