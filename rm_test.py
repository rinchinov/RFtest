import os.path
import subprocess
import sys
import re
class rm_test(object):

    def __init__(self):    

        self._status = ''

    def rm_remove(self,args,stdin_str = None ):
        command = "rm " + args
        process = subprocess.Popen(command,  shell=True,stdin=subprocess.PIPE,
                                    stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        if stdin_str != None:
            stdin_str = re.sub('[0]', 'no\n', stdin_str)
            stdin_str = re.sub('[1]', 'yes\n', stdin_str)
            
            self._status = process.communicate(input=bytes(stdin_str,'UTF-8'))[0].strip().decode("utf8")

            #process.communicate(input=bytes(stdin_str,'UTF-8'))[0]
        else:
            self._status = process.communicate()[0].strip().decode("utf8")
            

    def status_should_be(self, expected_status):
        if expected_status != self._status:
            raise AssertionError("Expected status to be '%s' but was '%s'."
                                 % (expected_status, self._status))

