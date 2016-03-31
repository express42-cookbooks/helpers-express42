from __future__ import print_function
from twisted.internet.defer import succeed
import json
import time
import os
from datetime import date

current_instance = None


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


class Express42_Chef(object):

    def __init__(self):
        self.sysinfo = None

        global current_instance
        current_instance = self

    def register(self, sysinfo):
        self._sysinfo = sysinfo

    def is_running(self, pid, daemon):
        if os.path.isdir("/proc/"+pid):
            with open("/proc/"+pid+"/cmdline","r") as cmdline:
                cmd = cmdline.read().split("\000")[1]
            if cmd == daemon:
                return True
        return False

    def run(self):
        chef_env = None
        if os.path.isfile("/etc/init.d/chef-client"):
            with open("/etc/init.d/chef-client", "r") as chef_init:
                for line in chef_init:
                    if line.find('PIDFILE=') >= 0:
                        pidfile = line.split('=')[1].strip('\n')
                    elif line.find('DAEMON=') >= 0:
                        daemon = line.split('=')[1].strip('\n')
            if os.path.isfile(pidfile):
                pid = open(pidfile, "r").read()
                if self.is_running(pid, daemon):
                    status = bcolors.OKGREEN + 'running' + bcolors.ENDC
                else:
                    status = bcolors.FAIL + 'not running' + bcolors.ENDC
            else:
                status = bcolors.FAIL + 'not running' + bcolors.ENDC
        else:
            status = bcolors.FAIL + 'init file not found' + bcolors.ENDC

        self._sysinfo.add_header("Chef client status", status )

        if os.path.isfile('/var/chef/cache/last_successful_chef_run'):
            last_time = open('/var/chef/cache/last_successful_chef_run', 'r').read()
            if last_time != "":
                stime = int(time.time() - int(last_time))/60
                if stime < 6:
                    status2 = bcolors.OKGREEN
                else:
                    status2 = bcolors.FAIL
                status2 += str(stime) + " minute(s) ago" + bcolors.ENDC
            else:
                status2 = bcolors.FAIL + "unknown" + bcolors.ENDC
        else:
            status2 = bcolors.FAIL + "unknown" + bcolors.ENDC
        '''
        if os.path.isfile('/var/log/chef/client.log'):
            for line in reversed(open("/var/log/chef/client.log").readlines()):
                if line.find('Chef run process exited') >= 0:
                    ltime = line[line.find('[') + 1:line.find(']')]
                    break
            ktime = time.strptime(ltime.split('+')[0], '%Y-%m-%dT%H:%M:%S')
            if ktime > time.ctime(int(last_time)):
                status = bcolors.FAIL + 'unsuccessful' + bcolors.ENDC
            else:
                status = bcolors.OKGREEN + 'successful' + bcolors.ENDC
        else:
            status = bcolors.FAIL + "unknown" + bcolors.ENDC

        self._sysinfo.add_header("Last chef run was", status+ ' at ' + time.strftime("%d %b %Y %H:%M:%S", ktime) )
        '''
        self._sysinfo.add_header("Last succesful chef run", status2 )



        return succeed(None)
