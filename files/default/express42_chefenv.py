from __future__ import print_function
from twisted.internet.defer import succeed
import json

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


class Express42_ChefEnv(object):

    def __init__(self):
        self.sysinfo = None

        global current_instance
        current_instance = self

    def register(self, sysinfo):
        self._sysinfo = sysinfo

    def run(self):
        chef_env = None
        with open("/etc/chef/env.json", "r") as json_file:
            chef_env = json.load(json_file)

        self._sysinfo.add_header("Environment", str(chef_env['env']))
        self._sysinfo.add_header("Node name", str(chef_env['node_name']))
        self._sysinfo.add_header("Run list", str(chef_env['run_list']))

        return succeed(None)
