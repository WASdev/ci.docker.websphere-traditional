#####################################################################################
#                                                                                   #
#  Script to update Hostname                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updateNodeName.py <old nodename > <new nodename> # 
#                                                                                   #
#####################################################################################


def updateNodeName(oldnodename, newnodename):

	AdminTask.renameNode('[-nodeName '+ oldnodename +' -newNodeName '+ newnodename +']') 

	AdminConfig.save()

updateNodeName(sys.argv[0], sys.argv[1])	
