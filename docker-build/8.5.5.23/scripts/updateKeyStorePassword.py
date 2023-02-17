#####################################################################################
#                                                                                   #
#  Script to update keystore Password                                                        #
#                                                                                   #
#  Usage : wsadmin -lang jython -f updateKeystorePassword.py userId password                # 
#                                                                                   #
#####################################################################################


def updateKeystorePassword(keyStoreName, keyStorePassword, newPassword):

    AdminTask.changeKeyStorePassword('[-keystoreName ' + keyStoreName + ' -keyStorePassword ' + keyStorePassword + ' -newKeyStorePassword ' + newPassword + ' -newKeyStorePasswordVerify ' + newPassword + ']')
    AdminConfig.save()

updateKeystorePassword(sys.argv[0], sys.argv[1])	
