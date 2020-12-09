*** Settings ***
Library         SSHLibrary      4min
Library         BuiltIn
Library         lib/tftp_server.py
Variables       lib/glob_config.py   ${target}
*** Variables ***
${OBR_HOST}      <ip address>
${OBR_USERNAME}  <username>
${OBR_PASSWORD}  <password>
${TFTP_FOLDER}   D:/DM/LSD/MSPS_ITEST/DAT/config/tftp_folder
${server}        tftpy.TftpServer('/tftpboot')
*** Keywords ***
Open Device in Linux   
    ${device_prompt}=    Open Connection  ${OBR_HOST}
    Set Global Variable     ${device_prompt}
    Enable SSH Logging  ssh.log
    Login  ${OBR_USERNAME}  ${OBR_PASSWORD}
    Set Client Configuration	prompt=CLI#
Linux Terminal   
    ${linux_prompt}=    Open Connection  ${OBR_HOST}
    Set Global Variable     ${linux_prompt}
    Enable SSH Logging  ssh.log
    Login  ${OBR_USERNAME}  ${OBR_PASSWORD}
    Set Client Configuration	prompt=#

Get_CLI_Prompt_after_Login_State
    Open Device in Linux 
    ${output}=  Write     screen /dev/ttyS0 115200
    log to console  ${\n}${output}
    Write   ${\n}
    Sleep   2sec
    ${output} =     Read
    log to console  ${\n}${output}
    ${passed} =	Run Keyword And Return Status       Should Contain  ${output}  CLI#
    Return From Keyword If  ${passed}
    ${passed} =	Run Keyword And Return Status       Should Contain  ${output}  Login:
    Run Keyword if  ${passed}   Write     <username>
    Sleep   2sec
    ${output} =     Read
    ${passed} =	Run Keyword And Return Status       Should Contain  ${output}  Password:
    Run Keyword if  ${passed}   Write  <password>
    Sleep   2sec
    ${output} =     Read   	      
    ${passed} =	Run Keyword And Return Status       Should Contain  ${output}  Login:
    Run Keyword if  ${passed}
    ...     Run Keywords
    ...     Write   <username>
    ...     AND     Sleep   1sec
    ...     AND     Write   <username>
    ...     AND     Sleep   1sec
    ...     AND     Write   n
    ...     AND     Sleep   1sec
    ...     AND     Write   <password>
    ...     AND     Sleep   1sec
    ...     AND     Write   <password> 
    ...     AND     Read Until  CLI#
    ...     AND     Initial_Configuration  

Get_CLI_Config
    Switch Connection   ${device_prompt}
    Write  ${\n}
    Write  end
    ${output}=	Read Until  CLI#
    Write   c t 
    ${output}=	Read Until  CLI(config)#

Get_CLI
    Switch Connection   ${device_prompt}
    Write  ${\n}
    Write  end
    ${output}=	Read Until  CLI#
    
Login_Device
    Switch Connection   ${device_prompt}
    Write   ${\n}
    ${output}=  Read Until  Login:
    Write   ${\n}
    Write   <username>
    Sleep   1sec
    ${output} =     Read
    ${passed} =	    Run Keyword And Return Status       Should Contain  ${output}  Password:
    Run Keyword if  ${passed}   Write  <password>
    ${output}=	Read Until  CLI#

Restart_Device_with_Restart_Factory
    Get_CLI
    Write   end;restart factory
    ${output}=	Read Until  Do you want to continue (y/n)
    Write   y
    Read Until  Login:
    Write     <username>
    ${passed} =	Run Keyword And Return Status   Read Until  Password:
    Run Keyword if  ${passed}   Write  <username>   	      
    ${passed} =	Run Keyword And Return Status   Read Until  Default admin user to be changed (y/n)?
    Run Keyword if  ${passed}   Write  n
    ${passed} =	Run Keyword And Return Status   Read Until  Enter a new non-default admin password:
    Run Keyword if  ${passed}   Write  <password>
    ${passed} =	Run Keyword And Return Status   Read Until  Confirm new non-default admin password:
    Run Keyword if  ${passed}   Write  <password>
    ${output}=	Read Until  CLI#

Restart_Device
    Get_CLI
    Write   restart
    Read Until  Login:
    Write     <username>
    ${passed} =	Run Keyword And Return Status   Read Until  Password:
    Run Keyword if  ${passed}   Write  <password>   
    ${output}=	Read Until  CLI#

Write_Startup_Config
    Switch Connection   ${device_prompt}
    Write  ${\n}
    Write  end
    ${output_config}=	Read Until  CLI#
    Write   write startup-config
    ${output_config}=	Read Until  CLI#
    FOR    ${index}    IN RANGE    20
        ${passed} =	Run Keyword And Return Status  Should Contain  ${output_config}    [OK]
        Sleep   6 sec
        Run Keyword if  ${passed}   Exit For Loop
        Write   write startup-config
        ${output_config}=	Read Until Prompt
    END
    Write   ${\n}
    ${output_config}=	Read Until Prompt
    Should Not Contain  ${output_config}    %
Initial_Configuration
    Write_Startup_Config
    ${output}=	Read Until  CLI#
    Write   configure terminal
    Write   interface vlan 1
    Write   shutdown
    Write   no ip address
    Write   ip address 120.80.1.20 255.255.255.0
    Write   no shutdown
    Write   end
    ${output}=	Read Until  CLI#

Check_Initial_Configuration
    Get_CLI
    Write       show running-config
    Sleep       2sec
    ${output}=	Read
    ${status}   ${value}=    Run Keyword And Ignore Error    Should Contain  ${output}  interface vlan 1
    Run Keyword Unless  '${status}' == 'PASS'   Log    interface vlan 1 is missing  WARN 
    ${status}   ${value}=    Run Keyword And Ignore Error    Should Contain  ${output}  no ip address dhcp
    Run Keyword Unless  '${status}' == 'PASS'   Log    no ip address is missing  WARN 
    ${status}   ${value}=    Run Keyword And Ignore Error    Should Contain  ${output}  ip address  120.80.1.20 255.255.255.0
    Run Keyword Unless  '${status}' == 'PASS'   Log    ip address 120.80.1.20 is missing  WARN 

Set_TFTP_Server_IP_In_Device
    Get_CLI
    Write   end;configure terminal
    Write   loadsave
    Write   tftp server ipv4 120.80.1.200 port 69
    ${output}=  Read Until  )#
    Should Not Contain  ${output}   %

HARD_RESET
    Linux Terminal
    Write  ${\n}
    Write  ${\n}
    Write   sispmctl -f 1
    ${output}=	Read Until  off
    Should Contain  ${output}   outlet 1
    Write   sispmctl -o 1
    ${output}=	Read Until  on
    Should Contain  ${output}   outlet 1

KILL_ALL_SCREEN
    Linux Terminal
    Write   killall screen

Save Debug Info
    Get_CLI_Config
    Write   interface vlan 1
    Write   no ip address
    Write   ip ad 120.80.1.20 255.255.255.0
    Write   end
    ${output_debug}=  Read Until  CLI#
    Set_TFTP_Server_IP_In_Device
    Write   tftp save filetype Debug
    ${output_debug}=  Read Until  )#
    Should Not Contain  ${output_debug}   %
    Should Contain  ${output_debug}   File was successfully saved
    Write   end;clear logbook
    ${output_debug}=  Read Until  )#
    Should Contain  ${output_debug}   cleared

Check Internal Error
    Get_CLI
    Write   show logbook
    Sleep   1sec
    ${output}=  Read
    FOR    ${i}    IN RANGE    999999
       ${internal_error_found}=    Run Keyword And Return Status   Should Contain  ${output}   Internal error(s) and/or exception(s) occurred.
       Run Keyword if  ${internal_error_found}
       ...  Run Keywords
       ...  Log     Internal Error Occured  WARN
       ...  AND     Write   q
       ...  AND     Save Debug Info
       ...  AND     Exit For Loop
       ${more}=    Run Keyword And Return Status   Should Contain  ${output}   --More--
       Run Keyword if  ${more}  Write   c
       ${output}=  Read    delay=0.5sec
       ${more_finished}=    Run Keyword And Return Status   Should Not Contain  ${output}   --More--
       ${internal_error_found}=    Run Keyword And Return Status   Should Contain  ${output}   Internal error(s) and/or exception(s) occurred.
       Run Keyword if  ${internal_error_found}
       ...  Run Keywords
       ...  Log     Internal Error Occured  WARN
       ...  AND     Save Debug Info
       ...  AND     Exit For Loop
       Exit For Loop If    ${more_finished}
    END
Check MAC Aging Time
    ## Aging-time dynamic calculation is starting
	[Arguments]     ${aging_time}
    ${aging_time_cal} =	Set Variable    0
    ${status}=  Evaluate	 10<=${aging_time}<=15
    ${aging_time_cal}=  Run Keyword if  ${glob_dynamic_aging_time} == 1 and ${status}    Set Variable    15
	${aging_time_cal}=  Run Keyword if  ${glob_dynamic_aging_time} == 1 and ${status} is ${FALSE}   Evaluate     round(${aging_time}/15)*15
    Write   end;show mac-address-table aging-time
    ${output_mac}=	Read	delay=0.5s
    Should Contain  ${output_mac}   Mac Address Aging Time: ${aging_time_cal}

    


