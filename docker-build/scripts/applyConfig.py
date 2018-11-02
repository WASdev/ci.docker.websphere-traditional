import os
import sys
filename = sys.argv[0]
AdminTask.applyConfigProperties('[-propertiesFileName ' + filename + ' -validate true]')
AdminConfig.save()
