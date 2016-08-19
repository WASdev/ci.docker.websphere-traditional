#####################################################################################
#                                                                                   #
#  Script to update Password                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updatePassword.py password                       # 
#                                                                                   #
#####################################################################################


def updatePassword(password):

	AdminTask.changeFileRegistryAccountPassword('[-userId wsadmin -password '+ password +']') 

	AdminConfig.save()

updatePassword(sys.argv[0])	
