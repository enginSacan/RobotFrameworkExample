*** Settings ***
Library         SSHLibrary  
*** Variables ***
${DEVICE_USER}  <username>
${DEVICE_PASSWORD}  <password>
${GLOBAL_IP_ADDRESS}    <ip address>
*** Keywords ***
Open Device CLI via SSH
    Open Connection  ${GLOBAL_IP_ADDRESS}
    Enable SSH Logging  ssh.log
    Login  ${DEVICE_USER}  ${DEVICE_PASSWORD}

*** Test Cases ***
Connect Device via SSH
    Open Device CLI via SSH 
    Write  sh ru
    ${output}=	Read Until  end 


