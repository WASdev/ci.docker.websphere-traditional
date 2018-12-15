import sys

SID="WebSphere:cell=DefaultCell01,node=DefaultNode01,server=server1"

PROJ_LOC = "/work/app/"


SIMPLE_CI_EAR = 'SimpleCIEar.ear'
SIMPLE_CI_LOC = PROJ_LOC + SIMPLE_CI_EAR


print "Installing SimpleCI app"
AdminApp.install(SIMPLE_CI_LOC, '[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -appname SimpleCIEar -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude -asyncRequestDispatchType DISABLED -nouseAutoLink -MapModulesToServers [[ SimpleCIEarEJBs SimpleCIEarEJBs.jar,META-INF/ejb-jar.xml '  + SID + ']]]')
print "SimpleCI app installed, saving..."
AdminConfig.save()


MAILER_EAR = 'MailerSample.ear'  # This may be the externally-shipped sample by now, not sure and haven't had time to investigate.
MAILER_LOC= PROJ_LOC + MAILER_EAR

print "Installing Mailer app"
AdminApp.install(MAILER_LOC, '[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -appname MailerSample -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude -asyncRequestDispatchType DISABLED -nouseAutoLink -MapModulesToServers [[ MailerSampleEJBs MailerSampleEJBs.jar,META-INF/ejb-jar.xml ' + SID + ']]]')
print "Mailer app installed, saving..."
AdminConfig.save()
