#####################################################################################
#                                                                                   #
#  Script to update keystore Password                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updateKeystorePassword.py userId password                # 
#                                                                                   #
#####################################################################################


def updateKeystorePassword(keyStoreName, keyStorePassword, newPassword):

    AdminTask.changeKeyStorePassword('[-keyStoreName %s -keyStorePassword %s -newKeyStorePassword %s -newKeyStorePasswordVerify %s]' % (keyStoreName, keyStorePassword, newPassword, newPassword))
    AdminConfig.save()

updateKeystorePassword(sys.argv[0], sys.argv[1], sys.argv[2])	
