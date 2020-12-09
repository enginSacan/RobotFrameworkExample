"""This file is created for checking file size in a specific limit for file specified."""
import os

FIRMWARE_MAX_LIMIT = 40000000
TARGET_PATH = "D:/DM/LSD/MSPS_ITEST/DAT/AutoDAT/"
def file_size(target, file_name, threshold):
    """This function is checking file size under the target folder."""
    THRESHOLD = 400*1024
    print("Target: ", str(target))
    print("File Name: ", str(file_name))
    print("Target M270: ", str(threshold))
    statinfo = os.stat(TARGET_PATH+target+'/'+file_name)
    file_size = statinfo.st_size
    if threshold.strip() == "0":
        print("Threshold: ", str(THRESHOLD))
    else:
       THRESHOLD = 300*1024
       print("Threshold: ", str(THRESHOLD))
    firmware_size_limit = FIRMWARE_MAX_LIMIT - THRESHOLD
    print("file_size:", str(file_size))
    print("firmware_size_limit:", str(firmware_size_limit))
    if file_size > firmware_size_limit :
        return False
    else:
        return True