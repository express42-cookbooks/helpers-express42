from __future__ import print_function
from twisted.internet.defer import succeed
import os
import multiprocessing

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


class Express42_Load(object):

    def __init__(self):
        self.sysinfo = None

        global current_instance
        current_instance = self

    def register(self, sysinfo):
        self._sysinfo = sysinfo

    def run(self):
        cores = multiprocessing.cpu_count()
        loadavg = os.getloadavg()
        loadavg_1 = str(loadavg[0]) if loadavg[0] < cores else bcolors.FAIL + str(loadavg[0]) + bcolors.ENDC
        loadavg_5 = str(loadavg[1]) if loadavg[1] < cores else bcolors.FAIL + str(loadavg[1]) + bcolors.ENDC
        loadavg_10 = str(loadavg[2]) if loadavg[2] < cores else bcolors.FAIL + str(loadavg[2]) + bcolors.ENDC

        self._sysinfo.add_header('Load Average',', '.join([loadavg_1, loadavg_5, loadavg_10]))

        return succeed(None)
