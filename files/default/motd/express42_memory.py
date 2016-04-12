from __future__ import print_function
from twisted.internet.defer import succeed
from collections import OrderedDict


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


class Express42_Memory(object):

    def __init__(self):
        self.sysinfo = None
        self.has_run = True

        global current_instance
        current_instance = self

    def register(self, sysinfo):
        self._sysinfo = sysinfo

    def meminfo(self):
        ''' Return the information in /proc/meminfo
        as a dictionary '''
        meminfo=OrderedDict()

        with open('/proc/meminfo') as f:
            for line in f:
                meminfo[line.split(':')[0]] = line.split(':')[1].strip()
        return meminfo

    def run(self):
        units = [ 'KB', 'MB', 'GB', 'TB' ]
        meminfo = self.meminfo()
        memfree = float(meminfo['MemFree'].split(' ')[0])
        memtotal = float(meminfo['MemTotal'].split(' ')[0])
        memused = float(memtotal-memfree)
        mempcnt = 100.0*memused/memtotal
        i = 0
        while memtotal > 10000:
            memused /= 1024.0
            memtotal /= 1024.0
            i += 1
        msg = '{0:.2f}/{1:.2f} {2} ({3:.2f}%) '.format(memused, memtotal, units[i], mempcnt)

        if mempcnt < 85:
            status = msg
        else:
            status = bcolors.FAIL + msg + bcolors.ENDC

        self._sysinfo.add_header( 'Memory usage', status)

        return succeed(None)
