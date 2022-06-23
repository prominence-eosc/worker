#!/usr/bin/python3
import distutils.spawn
import pwd
import os
import shutil
import multiprocessing

# Check for udocker
if not os.path.exists('/usr/local/bin/udocker'):
    print('NODE_IS_HEALTHY = False')
    print('NODE_STATUS = "Udocker_Missing"')
    exit(0)

# Check disk size and usage
total, used, free = shutil.disk_usage("/")

cpus = multiprocessing.cpu_count()
if total/(2**30) < 10 + 2*cpus:
    print('NODE_IS_HEALTHY = False')
    print('NODE_STATUS = "Total_Disk"')
    exit(0)

if used/total > 0.90:
    print('NODE_IS_HEALTHY = False')
    print('NODE_STATUS = "Disk_Usage"')
    exit(0)

# Check users
users = []
for user in pwd.getpwall():
    if 'user' in user[0]:
        users.append(user[0])

for count in range(1, 96):
    if 'user%02d' % count not in users:
        print('NODE_IS_HEALTHY = False')
        print('NODE_STATUS = "Host_Users"')
        exit(0)

# Check load
load = os.getloadavg()[0]
if load > 2*cpus:
    print('NODE_IS_HEALTHY = False')
    print('NODE_STATUS = "System_Load"')
    exit(0)

# All is ok
print('NODE_IS_HEALTHY = True')
print('NODE_STATUS = "OK"')
