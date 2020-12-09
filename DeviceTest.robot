*** Settings ***
Suite Teardown  Run Keywords    Close All Connections   KILL_ALL_SCREEN     Close All Browsers  TFTP STOP
Suite Setup     KILL_ALL_SCREEN
Test Teardown   Check Internal Error
Resource        LoginDeviceSerial.robot
Resource        OpenBrowser.robot
Variables       lib/glob_config.py   ${target}
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
PNIO_Test_With_PST_Tool
    [Tags]      ${target}
    Get_CLI_Prompt_after_Login_State
    Restart_Device_with_Restart_Factory
    Initial_Configuration
    Check_Initial_Configuration
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Write   configure terminal
    ...     AND     Write   interface cpu
    ...     AND     Write   ip address 10.0.0.10 255.0.0.0
    ...     AND     Write   exit
    ...     AND     Write   do show ip interface
    Assign Ip Address vlan  10
    Write   !;mac-address-table aging-time 22
    Check MAC Aging Time    22
    Sleep   5sec
    Write_Startup_Config
    ${output}=  Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   show ip interface
    ...     AND     Read    delay=0.5s
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1
    ...     Run Keywords
    ...     Should Contain  ${output}   10.0.0.10
    Get_CLI
    Write   show ip interface vlan 1 
    ${output_cli}=  Read Until      active
    Should Contain  ${output_cli}   120.80.1.10
    Linux Terminal
    Write   tcpreplay --intf1=${glob_interface_mgmt} ${glob_dat_path}/config/pcap_files/pst_tool_captured_frame.cap
    ${output_linux}=    Read Until Prompt
    Should Contain      ${output_linux}     Actual: 1 packets (48 bytes) sent
    Should Not Contain  ${output_linux}     Fatal Error
    Sleep   10sec
    Get_CLI
    Write   ping 120.80.1.25
    ${output_device}=   Read Until  Packets Loss
    Should Contain      ${output_device}     Reply Received From: 120.80.1.25
    Should Not Contain  ${output_device}     From 120.80.1.7: icmp_seq=1 Destination Host Unreachable
    #Undo All configuration which done in this test.
    Write   configure terminal
    Write   mac-address-table aging-time ${glob_default_aging_time}
    Run Keyword if  ${glob_mgmt_interface_enabled} == 1    
    ...     Run Keywords
    ...     Write   interface cpu0
    ...     AND     Write   ip address  192.168.1.20 255.0.0.0
    ...     AND     Write   exit
    Assign Ip Address vlan  20
    Run Keyword if  ${glob_ipv6_enabled} == 1    
    ...     Run Keywords
    ...     Write   ipv6 enable
    ...     AND     Write   ipv6 address  ${glob_ipv6_address} ${glob_ipv6_subnet} unicast
    ...     AND     Write   exit
    Run Keyword if  ${glob_default_status_of_dcp} == "read-only"    Write   !; dcp server read-only
    Write   end