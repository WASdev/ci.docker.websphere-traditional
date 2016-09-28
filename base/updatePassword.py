#####################################################################################
#                                                                                   #
#  Script to update Password                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updatePassword.py userId password                # 
#                                                                                   #
#####################################################################################


def updatePassword(userId, password):

	AdminTask.changeFileRegistryAccountPassword('[-userId ' + userId + ' -password '+ password +']') 
	AdminConfig.save()

updatePassword(sys.argv[0], sys.argv[1])	
