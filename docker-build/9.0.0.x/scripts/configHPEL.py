HPELService = AdminConfig.getid("/Cell:DefaultCell01/Node:DefaultNode01/Server:server1/HighPerformanceExtensibleLogging:/")
AdminConfig.modify(HPELService, "[[enable true]]")

RASLogging = AdminConfig.getid("/Cell:DefaultCell01/Node:DefaultNode01/Server:server1/RASLoggingService:/")
AdminConfig.modify(RASLogging, "[[enable false]]")

AdminConfig.save()