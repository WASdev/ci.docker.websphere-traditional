import os

cellName = os.environ.get('WAS_CELL')
if cellName is None:
	cellName = "DefaultCell01"
	
nodeName = os.environ.get('NODE_NAME')
if nodeName is None:
	nodeName = "DefaultNode01"
	
serverName = os.environ.get('SERVER_NAME')
if serverName is None:
	serverName = "server1"

HPELService = AdminConfig.getid("/Cell:%s/Node:%s/Server:%s/HighPerformanceExtensibleLogging:/"%(cellName,nodeName,serverName))
AdminConfig.modify(HPELService, "[[enable true]]")

RASLogging = AdminConfig.getid("/Cell:%s/Node:%s/Server:%s/RASLoggingService:/"%(cellName,nodeName,serverName))
AdminConfig.modify(RASLogging, "[[enable false]]")

AdminConfig.save()