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
Assign Language Variables
    [Arguments]     ${selected_lang}
    ${language}=        Run Keyword If  '${selected_lang}' == 'en'  Set Variable   English 
    ${login_text}=      Run Keyword If  '${selected_lang}' == 'en'  Set Variable   Name:
    ${button_text}=     Run Keyword If  '${selected_lang}' == 'en'  Set Variable   Refresh
    ${tab_text}=        Run Keyword If  '${selected_lang}' == 'en'  Set Variable   Create
    Run Keyword Unless      '${language}' == 'None'      Return From Keyword    ${language}    ${login_text}    ${button_text}      ${tab_text} 
    ${language}=        Run Keyword If  '${selected_lang}' == 'de'  Set Variable   Deutsch 
    ${login_text}=      Run Keyword If  '${selected_lang}' == 'de'  Set Variable   Name:
    ${button_text}=     Run Keyword If  '${selected_lang}' == 'de'  Set Variable   Aktualisieren
    ${tab_text}=        Run Keyword If  '${selected_lang}' == 'de'  Set Variable   Erstellen
    Run Keyword Unless      '${language}' == 'None'      Return From Keyword    ${language}    ${login_text}    ${button_text}      ${tab_text} 
    ${language}=        Run Keyword If  '${selected_lang}' == 'fra'  Set Variable   Français 
    ${login_text}=      Run Keyword If  '${selected_lang}' == 'fra'  Set Variable   Nom:
    ${button_text}=     Run Keyword If  '${selected_lang}' == 'fra'  Set Variable   Actualiser
    ${tab_text}=        Run Keyword If  '${selected_lang}' == 'fra'  Set Variable   Créer
    Run Keyword Unless      '${language}' == 'None'      Return From Keyword    ${language}    ${login_text}    ${button_text}      ${tab_text} 
    ${language}=        Run Keyword If  '${selected_lang}' == 'esp'  Set Variable   Español 
    ${login_text}=      Run Keyword If  '${selected_lang}' == 'esp'  Set Variable   Nombre:
    ${button_text}=     Run Keyword If  '${selected_lang}' == 'esp'  Set Variable   Actualizar
    ${tab_text}=        Run Keyword If  '${selected_lang}' == 'esp'  Set Variable   Crear
    Run Keyword Unless      '${language}' == 'None'      Return From Keyword    ${language}    ${login_text}    ${button_text}      ${tab_text} 
    ${language}=        Run Keyword If  '${selected_lang}' == 'ita'  Set Variable   Italiano 
    ${login_text}=      Run Keyword If  '${selected_lang}' == 'ita'  Set Variable   Nome:
    ${button_text}=     Run Keyword If  '${selected_lang}' == 'ita'  Set Variable   Aggiorna
    ${tab_text}=        Run Keyword If  '${selected_lang}' == 'ita'  Set Variable   Crea
    Run Keyword Unless      '${language}' == 'None'      Return From Keyword    ${language}    ${login_text}    ${button_text}      ${tab_text} 
    ${language}=        Run Keyword If  '${selected_lang}' == 'chi'  Set Variable   中文 
    ${login_text}=      Run Keyword If  '${selected_lang}' == 'chi'  Set Variable   登录:
    ${button_text}=     Run Keyword If  '${selected_lang}' == 'chi'  Set Variable   刷新
    ${tab_text}=        Run Keyword If  '${selected_lang}' == 'chi'  Set Variable   創建
    
*** Variables ***
@{languages}    de  en
${language_combobox}    id:slBoxLangSelect
${language_confirm}     xpath://div[@class='lang_confirm']
${refresh_button}       id:btnRefresh
${layer2_button}        xpath://*[@id="navigation_group1"]/ul/li[3]/table/tbody/tr/td[2]/label/a
${vlan_button}          xpath://a[@href='?newtab=obselete_vlan.mwp']
${create_button}        id:btnCreate
${info_button}          xpath://*[@id="navigation_group1"]/ul/li[1]/table/tbody/tr/td[2]/label/a
${start_page_button}    xpath://a[@href='?newtab=startpage.mwp']
${language}     lang
${login_text}   logintext
${button_text}  buttontext
${tab_text}     tabtext

*** Test Cases ***
Language_Support
    [Tags]      ${target}
    Get_CLI_Prompt_after_Login_State
    Check_Initial_Configuration
    Assign Ip Address vlan  20
    Open Browser To Login Page
    FOR     ${lang}     IN      @{languages}
        Select From List By Value   ${language_combobox}    ${lang}
        Click Element   ${language_confirm}
        ${language}     ${login_text}   ${button_text}   ${tab_text}    Assign Language Variables   ${lang}
        Wait Until Element Is Visible   id:bigLoginName
        Page Should Contain     ${language}
        Page Should Contain     ${login_text}
    END
    Login WBM by Admin User    
    FOR     ${lang}     IN      @{languages}
        Select From List By Value   ${language_combobox}    ${lang}
        Click Element   ${language_confirm}
        ${language}     ${login_text}   ${button_text}   ${tab_text}    Assign Language Variables   ${lang}    
        Sleep   2sec
        Wait Until Element Is Not Visible   id:simplemodal-overlay
        Wait Until Element Is Enabled       ${refresh_button}
        Element Attribute Value Should Be  ${refresh_button}    value    ${button_text}
        Click Element   ${layer2_button}
        Wait Until Element Is Enabled   ${vlan_button}
        Click Element   ${vlan_button}
        Wait Until Element Is Not Visible   id:simplemodal-overlay
        Wait Until Element Is Enabled       ${create_button}
        Element Attribute Value Should Be  ${create_button}    value    ${tab_text}
        Click Element   ${info_button}
        Wait Until Element Is Not Visible   id:simplemodal-overlay
        Wait Until Element Is Enabled       ${start_page_button}
        Click Element   ${start_page_button}
        Wait Until Element Is Not Visible   id:simplemodal-overlay
    END





