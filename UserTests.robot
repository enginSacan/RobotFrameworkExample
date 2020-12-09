*** Settings ***
Library         Collections
Suite Teardown  Run Keywords    Close All Connections   KILL_ALL_SCREEN     Close All Browsers
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
*** Variables ***
${user_limit}    6
#${rights}        1
*** Test Cases ***
UMAC_CLI
    [Tags]      ${target}
    Get_CLI_Prompt_after_Login_State
    Check_Initial_Configuration
    # Creating Groups and Roles in Admin Role
    # =========================
    Get_CLI_Config
    FOR    ${i}    IN RANGE    ${user_limit}
        ${rights}=  Run Keyword if  ${i}==5   Set Variable  15
        ...         ELSE    Set Variable    1
        Write   role roleTest${i} function-rights ${rights} description testingRole
        ${output_umac_for1}=     Read Until  )#
        Should Not Contain  ${output_umac_for1}     % Unsupported function rights
    END
    FOR    ${x}    IN RANGE    ${user_limit}
        Write   user-group testingGroup${x} role roleTest${x} description GroupingTestRoles
        ${output_umac_for2}=     Read Until  )#
        Should Not Contain  ${output_umac_for2}     % Invalid input
    END
    # Creating 6 User Account and Assign a Role
    # =========================
    FOR    ${i}    IN RANGE    ${user_limit}
        Write   user-account test${i} password Sc123456. role roleTest${i} description AssigningAccountToRole
        ${output_umac_for3}=     Read Until  )#
        Should Not Contain  ${output_umac_for3}     %
    END
    # Creating 6 External User Account and Assign a Role
    # =========================
    FOR    ${i}    IN RANGE    ${user_limit}
        Write   user-account-ext testEx${i} role roleTest${i} description AssigningExternalAccountToRole
        ${output_umac_for4}=     Read Until  )#
        Should Not Contain  ${output_umac_for4}     % Invalid input
    END
    Write   role adminRole1 function-rights 15
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}      % Unsupported function rights
    Write   user-account admin_test1 password Sc123456. role adminRole1
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}      %
    Write   role adminRole1 function-rights 1
    ${output_umac}=     Read Until  )#
    Should Contain  ${output_umac}      % Role entry is referred by
    # Checking Roles, Groups and Function Rights
    # =========================
    Write   do show user-account external
    ${output_umac}=     Read Until  )#
    Should Contain  ${output_umac}      testEx5
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   do show role
    ${output_umac}=     Read Until  )#
    Should Contain  ${output_umac}      roleTest5
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   do show user-group
    ${output_umac}=     Read Until  )#
    Should Contain  ${output_umac}      testingGroup
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   do show function-rights
    ${output_umac}=     Read Until  )#
    Should Contain  ${output_umac}      Read-only
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   end;exit
    ${output_umac}=     Read Until  Login:
    Should Not Contain  ${output_umac}      % Invalid   Input
    # Checking User-Account Restrictions
    # =========================
    Write   test1
    ${output_umac}=     Read Until  Password:
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   Sc123456.
    ${output_umac}=     Read Until  CLI>
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   configure terminal
    ${output_umac}=     Read Until  CLI>
    Should Contain  ${output_umac}      % Invalid Command
    Write   show user-accounts
    ${output_umac}=     Read Until  CLI>
    Should Contain  ${output_umac}      % Admin privilege needed
    Write   show user-account external
    ${output_umac}=     Read Until  CLI>
    Should Contain  ${output_umac}      % Admin privilege needed
    Should Not Contain  ${output_umac}      testEx5
    Write   show role
    ${output_umac}=     Read Until  CLI>
    Should Not Contain  ${output_umac}      roleTest5
    Should Contain  ${output_umac}      % Admin privilege needed
    Write   show user-group
    ${output_umac}=     Read Until  CLI>
    Should Not Contain  ${output_umac}      testingGroup
    Should Contain  ${output_umac}      % Admin privilege needed
    Write   show function-rights
    ${output_umac}=     Read Until  CLI>
    Should Not Contain  ${output_umac}      Read-only
    Should Contain  ${output_umac}      % Admin privilege needed
    Write   exit
    ${output_umac}=     Read Until  Login:
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   <username>
    ${output_umac}=     Read Until  Password:
    Should Not Contain  ${output_umac}      % Invalid   Input
    Write   <password>
    ${output_umac}=     Read Until  CLI#
    # Deleting Roles, Groups and Function Rights
    # =========================
    Write   configure terminal
    ${output_umac}=     Read Until  CLI(config)#
    FOR    ${x}    IN RANGE    ${user_limit}
        Write   no user-group testingGroup${x}
        ${output_umac_for2}=     Read Until  )#
        Should Not Contain  ${output_umac_for2}     % Invalid input
    END
    FOR    ${i}    IN RANGE    ${user_limit}
        Write   no user-account test${i} 
        ${output_umac_for3}=     Read Until  )#
        Should Not Contain  ${output_umac_for3}     % Invalid input
    END
    FOR    ${i}    IN RANGE    ${user_limit}
        Write   no user-account-ext testEx${i} 
        ${output_umac_for4}=     Read Until  )#
        Should Not Contain  ${output_umac_for4}     % Invalid input
    END
    FOR    ${i}    IN RANGE    ${user_limit}
        Write   no role roleTest${i} 
        ${output_umac_for1}=     Read Until  )#
        Should Not Contain  ${output_umac_for1}     % Invalid input
        Should Not Contain  ${output_umac_for1}     % Role entry is
    END
    # Deleting Users and Groups
    # =========================
    Write   end;exit
    ${output_umac}=     Read Until  Login:
    Write   admin
    ${output_umac}=     Read Until  Password:
    Write   Sc123456.
    ${passed} =	Run Keyword And Return Status   Read Until  Default admin user to be changed (y/n)?
    Run Keyword if  ${passed}   Write  n
    ${passed} =	Run Keyword And Return Status   Read Until  Login:
    Run Keyword if  ${passed}   Write  admin
    ${passed} =	Run Keyword And Return Status   Read Until  Password:
    Run Keyword if  ${passed}   Write  Sc123456.
    ${output_umac}=     Read Until  CLI#
    Write   configure terminal
    ${output_umac}=     Read Until  CLI(config)#
    Write   no user-account admin_test1
    ${output_umac}=     Read Until  )#
    Write   no role adminRole1
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}     % Role entry is referred by
    Write   no user-account test2
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}     % Active user cannot be modified
    Write   no user-group testingGroup
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}     % Invalid
    Write   no user-group testingGroup1
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}     % Invalid
    Write   no role testRole1
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}     % Role entry is referred by
    Write   no role testRole11
    ${output_umac}=     Read Until  )#
    Should Not Contain  ${output_umac}     % Role entry is referred by
UMAC_WBM
    [Tags]      ${target}
    Open Browser To Login Page
    Login WBM by Admin User
    



    