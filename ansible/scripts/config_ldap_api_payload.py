#!/usr/bin/python3
import os
import json

# no of LDAP entries
ldapCfgList_count = max(int(var.split("_")[2]) for var in os.environ.keys() if var.startswith("settings_url_"))

# Retrieve config values from environment variables. Wherever applicable, assign default values for undefined enviorment variables
provider = os.getenv('settings_provider', 'LDAP')
cacheSize = os.getenv('settings_cacheSize','10')
cacheTTL = os.getenv('settings_cacheTTL', '60')
cdsRunning = os.getenv('settings_cdsRunning', 'false')

# Create ldapCfgList
ldapCfgList = []
for i in range(ldapCfgList_count):
    index_key     =f'settings_index_{i}'
    url_key       = f'settings_url_{i}'
    principal_key = f'settings_principal_{i}'
    password_key  = f'settings_password_{i}'
    timeout_key   = f'settings_timeout_{i}'
    poolMax_key   = f'settings_poolMax_{i}'
    poolMin_key   = f'settings_poolMin_{i}'
    useaf_key     = f'settings_synthesizeDN_{i}'
    dnPrefix_key  = f'settings_dnPrefix_{i}'
    dnSuffix_key  = f'settings_dnSuffix_{i}'
    uidProp_key   = f'settings_uidProp_{i}'
    userRootDn_key         = f'settings_userRootDn_{i}'
    userEmailAttribute_key = f'settings_userEmailAttribute_{i}'
    group_key              = f'settings_group_{i}'
    groupIdProperty_key    = f'settings_groupIdProperty_{i}'
    groupRootDN_key        = f'settings_groupRootDN_{i}'
    memberAttribute_key    = f'settings_memberAttribute_{i}'

    index_val     = os.getenv(index_key)
    url_val       = os.getenv(url_key)
    principal_val = os.getenv(principal_key)
    password_val  = os.getenv(password_key)
    timeout_val   = os.getenv(timeout_key, '5')
    poolMax_val   = os.getenv(poolMax_key, '10')
    poolMin_val   = os.getenv(poolMin_key, '0')
    useaf_val     = os.getenv(useaf_key)
    dnPrefix_val  = os.getenv(dnPrefix_key)
    dnSuffix_val  = os.getenv(dnSuffix_key)
    uidProp_val   = os.getenv(uidProp_key)
    userRootDn_val         = os.getenv(userRootDn_key)
    userEmailAttribute_val = os.getenv(userEmailAttribute_key)
    group_val              = os.getenv(group_key)
    groupIdProperty_val    = os.getenv(groupIdProperty_key)
    groupRootDN_val        = os.getenv(groupRootDN_key)
    memberAttribute_val    = os.getenv(memberAttribute_key)

    ldapCfgList.append({'index': index_val, 'url': url_val, 'principal': principal_val, 'password': password_val, 'timeout': timeout_val, 'poolMax': poolMax_val, 'poolMin': poolMin_val, 'useaf': useaf_val, 'dnPrefix': dnPrefix_val, 'dnSuffix': dnSuffix_val, 'uidProp': uidProp_val, 'userRootDn': userRootDn_val, 'userEmailAttribute': userEmailAttribute_val, 'group': group_val, 'groupIdProperty': groupIdProperty_val, 'groupRootDN': groupRootDN_val, 'memberAttribute': memberAttribute_val})

# Create JSON payload
json_payload = {'ldapConfig': {'provider': provider, 'cacheSize': cacheSize, 'cacheTTL': cacheTTL,  'ldapDirectoryList': ldapCfgList, 'cdsRunning': cdsRunning}}

print(json.dumps(json_payload))
