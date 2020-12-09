*** Settings ***
Suite Teardown  Run Keywords    Close All Connections   KILL_ALL_SCREEN
Suite Setup     KILL_ALL_SCREEN
Resource        LoginDeviceSerial.robot
*** Test Cases ***
Check Boot Message for Fully Equipped Device 
    Restart_Device_with_Restart_Factory
    Write   c t
    ${output}=	Read Until  CLI(config)#
    Write   !; no spanning-tree
    ${output}=	Read Until  CLI(config)#
    Write   ring-redundancy mode mrpauto
    ${output}=	Read Until  CLI(config)#
    Write    ring-redundancy configuration
    ${output}=	Read Until  CLI(config-red)#
    Write    mrpinterconnection 1
    ${output}=	Read Until  CLI(config-red-mrpin-1)#
    Write    domain-id 1
    ${output}=	Read Until  CLI(config-red-mrpin-1)#
    Write    domain-name Test123
    ${output}=	Read Until  CLI(config-red-mrpin-1)#
    Write    interface gigabitethernet 11/1
    ${output}=	Read Until  CLI(config-red-mrpin-1)#
    Write    interconnection enable
    ${output}=	Read Until  CLI(config-red-mrpin-1)#
    Write    !
    ${output}=	Read Until  CLI(config)#
    Write   ring-redundancy mrpinterconnection
    ${output}=	Read Until  CLI(config)#
    Write   end
    ${output}=	Read Until  CLI#
    Write   show logbook info
    ${output}=	Read Until  --More--
    Log To Console  ${output}
    Write     \b
    Read Until  CLI#
    Log To Console  ${output}