#####################################################################################
#                                                                                   #
#  Script to update Hostname                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updateHostName.py <node name >  < host name >    # 
#                                                                                   #
#####################################################################################


def updateHostName(nodename,hostname):

	nlist = AdminConfig.list('ServerIndex')
	attr=[["hostName", hostname ]]
	AdminConfig.modify(nlist,attr)

	AdminTask.modifyServerPort('server1', '[-nodeName '+ nodename +' -endPointName BOOTSTRAP_ADDRESS -host '+ hostname +' -port 2809 -modifyShared true]') 

	AdminTask.modifyServerPort('server1', '[-nodeName '+ nodename +' -endPointName CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS -host '+ hostname +' -port 9202 -modifyShared true]') 

	AdminTask.modifyServerPort('server1', '[-nodeName '+ nodename +' -endPointName CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS -host '+ hostname +' -port 9201 -modifyShared true]') 

	AdminTask.modifyServerPort('server1', '[-nodeName '+ nodename +' -endPointName ORB_LISTENER_ADDRESS -host '+ hostname +' -port 9900 -modifyShared true]') 

	AdminTask.modifyServerPort('server1', '[-nodeName '+ nodename +' -endPointName SAS_SSL_SERVERAUTH_LISTENER_ADDRESS -host '+ hostname +' -port 9901 -modifyShared true]') 

	AdminTask.modifyServerPort('server1', '[-nodeName '+ nodename +' -endPointName SOAP_CONNECTOR_ADDRESS -host '+ hostname +' -port 8878 -modifyShared true]') 

	AdminConfig.save()

updateHostName(sys.argv[0], sys.argv[1])	
