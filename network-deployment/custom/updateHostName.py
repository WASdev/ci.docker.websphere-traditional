#####################################################################################
#                                                                                   #
#  Script to update Hostname                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updateHostName.py <node name >  < host name >    # 
#                                                                                   #
#####################################################################################


def updateHostName(nodename,hostname):

        AdminTask.changeHostName('[-nodeName '+ nodename +' -hostName '+ hostname +']')

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName BOOTSTRAP_ADDRESS -host '+ hostname +' -port 2809 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS -host '+ hostname +' -port 9202 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS -host '+ hostname +' -port 9201 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName NODE_DISCOVERY_ADDRESS -host '+ hostname +' -port 7272 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName ORB_LISTENER_ADDRESS -host '+ hostname +' -port 9900 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName OVERLAY_TCP_LISTENER_ADDRESS -host '+ hostname +' -port 11004 -modifyShared true]')

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName OVERLAY_UDP_LISTENER_ADDRESS -host '+ hostname +' -port 11003 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName SAS_SSL_SERVERAUTH_LISTENER_ADDRESS -host '+ hostname +' -port 9901 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName SOAP_CONNECTOR_ADDRESS -host '+ hostname +' -port 8878 -modifyShared true]') 

	AdminTask.modifyServerPort('nodeagent', '[-nodeName '+ nodename +' -endPointName XDAGENT_PORT -host '+ hostname +' -port 7062 -modifyShared true]')  

	AdminConfig.save()

updateHostName(sys.argv[0], sys.argv[1])	
