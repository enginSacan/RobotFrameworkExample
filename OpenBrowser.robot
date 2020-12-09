*** Settings ***
Library           Selenium2Library

*** Variables ***
${DEVICE_IP}      <ipaddress>
${BROWSER}        Chrome
${DELAY}          1
${TIMEOUT}        60
${VALID USER}     <username>
${VALID PASSWORD}    <password>
${LOGIN URL}      http://${DEVICE_IP}/
${LOGIN_URL_PORT}   http://${DEVICE_IP}:62500/
${SECURE LOGIN URL}    https://${DEVICE_IP}/

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Set Selenium Timeout    ${TIMEOUT}
    Login Page Should Be Open
Login Page Should Be Open
    Wait Until Element Is Visible   class:BigLogin
    ${elem} =	Get WebElement	class:BigLogin
    ${elem_text}=   Get Text    ${elem}
    Should Be Equal     ${elem_text}    LOGIN
Login WBM by Admin User
    Wait Until Element Is Visible   id:bigLoginName
    ${username} =	Get WebElement	id:bigLoginName
    Input Text  ${username}     ${VALID USER}
    ${password} =	Get WebElement	id:bigPassword
    Input Password  ${password}     ${VALID PASSWORD}
    ${login_button} =	Get WebElement  id:loginLink
    Click Element   ${login_button}
    Wait Until Element Is Visible   id:lbl_EvDiagnosticsMode_0
Open Browser Other Port To Login Page
    Open Browser    ${LOGIN_URL_PORT}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login Page Should Be Open           
