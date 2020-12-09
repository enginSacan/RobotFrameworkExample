*** Settings ***
Library         TftpLibrary.py
Library         lib/tftp_server.py
Suite Teardown  Run Keywords    Close All Connections   KILL_ALL_SCREEN     Close All Browsers  TFTP STOP
Suite Setup     KILL_ALL_SCREEN
Test Teardown   Check Internal Error
Resource        LoginDeviceSerial.robot
Resource        OpenBrowser.robot
Variables       lib/glob_config.py   ${target}
*** Variables ***
${rdm_num}      22
${rdm_num_2}    32
${rdm_num_3}    42
${std_num}      20
*** Keywords ***
Assign Ip Address vlan
    [Arguments]     ${last_digit}
    Write   !;interface vlan 1
    write   no ip address
    write   ip add 120.80.1.${last_digit} 255.255.255.0
    Write   do show ip interface
    ${output}=  Read Until  )#
    Should Contain  ${output}   120.80.1.${last_digit}

*** Test Cases ***
Autosave_And_Factory_Restart
    [Tags]      ${target}
    Get_CLI_Prompt_after_Login_State
    Restart_Device_with_Restart_Factory
    Initial_Configuration
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Write_Startup_Config
    Restart_Device_with_Restart_Factory
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Not Contain  ${output}   10.0.0.${rdm_num}
    Write   show ip interface vlan 1 
    ${output}=  Read    delay=0.5s
    Should Not Contain  ${output}   120.80.1.${rdm_num}
    Check MAC Aging Time    ${glob_default_aging_time}

Autosave_And_Ping
    [Tags]      ${target}
    Initial_Configuration
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
     Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Write_Startup_Config
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.${rdm_num}
    Sleep   0.5sec
    Write   end;show ip interface vlan 1
    ${output}=  Read Until    Broadcast Address  
    Should Contain  ${output}   120.80.1.${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Write   end;ping ${glob_tftp_server_address}
    ${output}=  Read    delay=0.5s
    Should Contain  ${output}   Reply Received
    Assign Ip Address vlan  ${std_num}

Autosave_and_Restart
    [Tags]      ${target}
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num_2} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num_2}
    Write   !;mac-address-table aging-time ${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    Write   end;restart
    ${output}=  Read Until  Login:
    Write   admin
    ${output}=  Read Until  Password:
    Write   Sc123456.
    ${output}=  Read Until  CLI#
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.${rdm_num_2}
    Sleep   0.5sec
    Write   end;show ip interface vlan 1
    ${output}=  Read Until    Broadcast Address  
    Should Contain  ${output}   120.80.1.${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    Write   end;ping ${glob_tftp_server_address}
    ${output}=  Read    delay=0.5s
    Should Contain  ${output}   Reply Received
    Assign Ip Address vlan  ${std_num}

During_Autosave_Hard_Reset
    [Tags]      ${target}
    Check_Initial_Configuration
    Write_Startup_Config
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    HARD_RESET
    Login_Device
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Not Contain  ${output}   10.0.0.${rdm_num}
    Write   show ip interface vlan 1
    ${output}=  Read Until  CLI#
    Should Not Contain  ${output}   120.80.1.${rdm_num}
    Check MAC Aging Time    ${glob_default_aging_time}
    Write   ping ${glob_tftp_server_address}
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   Reply Received
    Assign Ip Address vlan  ${std_num}

Autosave_And_Hard_Reset 
    [Tags]      ${target}
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num_2} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num_2}
    Write   !;mac-address-table aging-time ${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    Write_Startup_Config
    HARD_RESET
    Login_Device
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.${rdm_num_2}
    Write   show ip interface vlan 1
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   120.80.1.${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    Write   ping ${glob_tftp_server_address}
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   Reply Received
    Assign Ip Address vlan  ${std_num}

No_Autosave_And_Factory_Restart
    [Tags]      ${target}
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Restart_Device_with_Restart_Factory
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Not Contain  ${output}   10.0.0.${rdm_num}
    Write   show ip interface vlan 1 
    ${output}=  Read    delay=0.5s
    Should Not Contain  ${output}   120.80.1.${rdm_num}
    Check MAC Aging Time    ${glob_default_aging_time}
    Initial_Configuration

Autosave_After_Loadsave_Load
    [Tags]      ${target}
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    TFTP START      ${glob_tftp_server_address}
    Set_TFTP_Server_IP_In_Device
    Write   tftp save filetype Config
    ${output}=  Read Until  saved
    Should Not Contain  ${output}   %
    Should Contain  ${output}   File was successfully 
    Restart_Device_with_Restart_Factory
    Assign Ip Address vlan  ${rdm_num_3}
    Set_TFTP_Server_IP_In_Device
    Write   tftp load filetype Config
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Should Contain  ${output}   File was successfully loaded
    Restart_Device
    Assign Ip Address vlan  ${rdm_num_2}
    Write   !;mac-address-table aging-time ${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    Write_Startup_Config
    HARD_RESET
    Login_Device
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.${rdm_num_2}
    Write   show ip interface vlan 1
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   120.80.1.${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    Write   ping ${glob_tftp_server_address}
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   Reply Received
    Write   !; mac-address-table aging
    Assign Ip Address vlan  ${std_num}
    TFTP STOP

Autosave_To_Trial_And_Hard_Reset_Without_Manual_Save
    [Tags]      ${target}
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Write   !;no auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num_2} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num_2}
    Write   !;mac-address-table aging-time ${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    HARD_RESET
    Login_Device
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.${rdm_num}
    Write   show ip interface vlan 1
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   120.80.1.${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Write   ping ${glob_tftp_server_address}
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   Reply Received
    Write   !; mac-address-table aging
    Assign Ip Address vlan  ${std_num}

No_Autosave_After_Loadsave_Load
    [Tags]      ${target}
    Check_Initial_Configuration
    Write   !;auto-save
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.${rdm_num} 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  ${rdm_num}
    Write   !;mac-address-table aging-time ${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    TFTP START      ${glob_tftp_server_address}
    Set_TFTP_Server_IP_In_Device
    Write   tftp save filetype Config
    ${output}=  Read Until  saved
    Should Not Contain  ${output}   %
    Should Contain  ${output}   File was successfully 
    Restart_Device_with_Restart_Factory
    Assign Ip Address vlan  ${rdm_num_3}
    Set_TFTP_Server_IP_In_Device
    Write   tftp load filetype Config
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %
    Should Contain  ${output}   File was successfully loaded
    Restart_Device
    Assign Ip Address vlan  ${rdm_num_2}
    Write   !;mac-address-table aging-time ${rdm_num_2}
    Check MAC Aging Time    ${rdm_num_2}
    HARD_RESET
    Login_Device
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.${rdm_num}
    Write   show ip interface vlan 1
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   120.80.1.${rdm_num}
    Check MAC Aging Time    ${rdm_num}
    Write   ping ${glob_tftp_server_address}
    ${output}=  Read Until  CLI#
    Should Contain  ${output}   Reply Received
    Write   !; mac-address-table aging
    Assign Ip Address vlan  ${std_num}