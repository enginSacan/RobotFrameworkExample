*** Settings ***
Library        lib/Check_firmware_size.py
Variables      lib/glob_config.py   ${target}

*** Test Cases ***
Check Firmware Size
    Pass Execution If   "${target}"=="xr328wgv4l2"      This Case is not supported for ${target}  
    Pass Execution If   "${target}"=="xc216gv4l2"       This Case is not supported for ${target}
    Pass Execution If   "${target}"=="xf204v4l2"        This Case is not supported for ${target}
    Pass Execution If   "${target}"=="xb208eipv4l2"     This Case is not supported for ${target}  
    Pass Execution If   "${target}"=="s646v2l2"         This Case is not supported for ${target}
    ${passed} =     Run Keyword And Return Status   file_size   ${target}   ${glob_firmware_file}   0
    RUN KEYWORD IF  ${passed}       Set Test Message   File checked
    ...         ELSE    FAIL    Please Check Log file
