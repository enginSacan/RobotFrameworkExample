def get_variables(target):
     if target == 'xr328wgv4l2':
        variables={
            "glob_tftp_server_address":"",
            "glob_tftp_folder":"",
            "glob_mgmt_interface_enabled":0,
            "glob_target_mlfb":"",
		    "glob_hw_version":"1",
		    "glob_bg_version":"4.2",
		    "glob_target_layer":2,
		    "glob_running_fw_name":"04.02.00",
		    "glob_old_fw_name":"04.01.00",
            "glob_enforced_pw_policy_wbm_support":1,
            "glob_power_reset_state_on": [ 
                "left", 
                "left", 
                "left", 
                "left" 
            ],
            "glob_power_reset_state_off": [ 
                "left", 
                "left", 
                "left", 
                "left" 
            ],
            "glob_type_of_power_reset_equip": "0",
            "glob_tlv_folder_name_1":"MIB_Package_XR328WG_v4.2_system1.zip",
            "glob_tlv_folder_name_2":"MIB_Package_XR328WG_v4.2_system2.zip",
            "glob_adaptation_for_SC600":"0",	
            "glob_security_event_enabled":"1",
            "glob_secure_smtp_enabled":"1",
            "glob_mrp_interconnection_enable":"0",
            "glob_default_user_pw_change":"1",
            "glob_firmware_file":"",
            "glob_config_file":"",
            "glob_configpack_file":"",
            "glob_configbackup_file":"",
            "glob_copyright_file":"",
            "glob_debug_file":"",
            "glob_eds_file":"",
            "glob_gsdml_file":"",
            "glob_logbook_file": "",
            "glob_startup_file": "",
            "glob_mib_file": "",
            "glob_free_port_on_device": 1,
            "glob_cabletester_open_port":"fastethernet 0/8",
            "glob_cabletester_link_up_port":"fastethernet 0/2",
            "glob_cabletester_open_port_wbm": "8",
            "glob_cabletester_link_up_port_wbm": "2",
            "glob_cabletester_link_up_speed":"100MBonly",
            "glob_management_port":"0/7",
            "glob_combo_port_wbm":"P0.25",
            "glob_combo_port":"Gi 0/25",
            "glob_combo_ports_supported": 1,
            "glob_dynamic_aging_time": 1,
            "glob_default_aging_time": 30,
            "glob_default_status_of_dcp":"read-write",
            "glob_interface_mgmt":"eth8",
            "glob_dat_path":"",
            "glob_ipv6_enabled":"0",
            "glob_ipv6_address":"3099::20",
            "glob_ipv6_subnet":"64"
            
        }
        return variables
     else:
        return None