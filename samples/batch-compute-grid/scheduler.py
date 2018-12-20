SID="WebSphere:cell=DefaultCell01,node=DefaultNode01,server=server1"

print AdminTask.modifyJobSchedulerAttribute("[-name deploymentTarget -value " +  SID + "]")
print AdminConfig.save()
print 'Scheduler targeted'

