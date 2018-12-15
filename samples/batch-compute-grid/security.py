AdminTask.configureAdminWIMUserRegistry('[-verifyRegistry true ]')
AdminConfig.save()
secCfgId = AdminConfig.getid("/Security:/")
AdminConfig.modify(secCfgId,[['appEnabled','true']])
AdminConfig.save()
print "appSecurityEnabled = " + AdminTask.isAppSecurityEnabled()
print "globalSecurityEnabled = " + AdminTask.isGlobalSecurityEnabled()

AdminApp.edit('LongRunningScheduler', '[ -MapRolesToUsers [[ lradmin AppDeploymentOption.No AppDeploymentOption.No wsadmin "" AppDeploymentOption.No user:defaultWIMFileBasedRealm/uid=wsadmin,o=defaultWIMFileBasedRealm "" ]]]' )
print AdminConfig.save()
print 'wsadmin -> lradmin'

