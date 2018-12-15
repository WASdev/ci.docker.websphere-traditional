jdbcProvider = AdminTask.createJDBCProvider('[-scope Cell=DefaultCell01 -databaseType Derby -providerType "Derby JDBC Provider" -implementationType "XA data source" -name "Derby Embedded XA for Apps" -description "Derby embedded XA JDBC Provider for apps" -classpath [${DERBY_JDBC_DRIVER_PATH}/derby.jar ] -nativePath "" ]')
    
AdminConfig.save()
print "Created JDBC Provider"

print AdminTask.createDatasource(jdbcProvider, '[-name MailerDS -jndiName jdbc/mailer -dataStoreHelperClassName com.ibm.websphere.rsadapter.DerbyDataStoreHelper -containerManagedPersistence false -componentManagedAuthenticationAlias -xaRecoveryAuthAlias -configureResourceProperties [[databaseName java.lang.String /work/mailerdb]]]')

AdminConfig.save()

print "Created Mailer DS"



