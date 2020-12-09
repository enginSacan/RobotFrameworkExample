*** Settings ***
Library         Telnet   
*** Variables ***
${DEVICE_USER}  <username>
${DEVICE_PASSWORD}  <password>
${GLOBAL_IP_ADDRESS}    <ip address>
*** Keywords ***
Open Device CLI via TELNET
    Open Connection  ${GLOBAL_IP_ADDRESS}
     Write     admin 
    ${output}=	Read Until  Password:
    Write     ${DEVICE_PASSWORD} 
    ${output}=	Read Until  CLI# 

*** Test Cases ***
Connect Device via TELNET
    Open Device CLI via TELNET 
    Write  sh ru
    ${output}=	Read Until  end 


