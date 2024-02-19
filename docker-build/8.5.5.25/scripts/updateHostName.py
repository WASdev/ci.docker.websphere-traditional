#####################################################################################
#                                                                                   #
#  Script to update Hostname                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updateHostName.py <node name >  < host name >    # 
#                                                                                   #
#####################################################################################


def updateHostName(nodename,hostname):

        AdminTask.changeHostName('[-nodeName '+ nodename +' -hostName '+ hostname +' -regenDefaultCert true ]')

	AdminConfig.save()

updateHostName(sys.argv[0], sys.argv[1])	
