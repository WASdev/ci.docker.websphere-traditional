# Batch (Compute Grid)

A simple Batch "Compute Grid" base application server that deploys two well-known IBM-provided batch samples:  the [SimpleCI](https://www.ibm.com/support/knowledgecenter/SSAW57_8.5.5/com.ibm.websphere.samples.doc/ae/sample_mb_simpleci.html), and [Mailer](https://www.ibm.com/support/knowledgecenter/SSAW57_8.5.5/com.ibm.websphere.samples.doc/ae/sample_jb_mailer.html) applications, with security enabled.  

We also add configuration for diagnostic features:  enabling the server for debug mode and configuring collection of [Health Center](https://www.ibm.com/support/knowledgecenter/en/SS3KLZ/com.ibm.java.diagnostics.healthcenter.doc/homepage/plugin-homepage-hc.html) metrics.

The intent, though, is not to provide a complete batch environment out of the box, but more to include a couple non-trivial things with the docker build.

## Building the application image

See the Dockerfile for a breakdown of what the build does.

`docker build -t batch-cg .`


## Running the container

`docker run --name batch-cg -p 9043:9043 -p 9443:9443 -p 7777:7777 -it batch-cg:latest`


## Running the jobs

### Security

In this container we use a single userid, 'wsadmin' for both administering the server (via wsadmin and admin console) and also submitting and viewing the batch jobs.
The password can be found in the container at /tmp/PASSWORD.   See the doc for alternatives to mount password from a volume.

### Simple CI

1. Use the Job Management Console at [https://localhost:9443/jmc](https://localhost:9443/jmc) and submit the 'SimpleCIxJCL.xml' job.
2. Job should end it **Ended** state.  Also you will see HFS output like */work/batch-output/simpleciout_Mon_Dec_17_02.55.12_UTC_2018.txt*.

        Mon Dec 17 02:55:12 UTC 2018: SimpleCI application starting...
        -->Will loop processing a variety of math functions for approximately 5.0 seconds!
        Mon Dec 17 02:55:17 UTC 2018: SimpleCI application complete!
        -->Actual Processing time = 5.005 seconds!

### Mailer

1. Use the Job Management Console at [https://localhost:9443/jmc](https://localhost:9443/jmc) and submit the 'SimpleCIxJCL.xml' job.

2. Job should end it **Ended** state, as will each of the subjobs. You will see one output file for each subjob, a x.0, x.1, x.2 file, like:

        was@8aef33fa4f31:/$ ls /work/batch-output/
        promotionalMailings.txt.MailerSample.000000.0
        promotionalMailings.txt.MailerSample.000000.1
        promotionalMailings.txt.MailerSample.000000.2

3. To run the job from within the container, open a bash shell via `docker exec -it batch-cg bash` and do:

`/opt/IBM/WebSphere/AppServer/bin/lrcmd.sh -userid=wsadmin -password=$(cat /tmp/PASSWORD) -port=9443 -cmd=submit -xJCL=/work/xjcl/Mailer.xml`

4. To schedule a job using the host OS "cron" command.

See the [sample](cron.cmd) crontab command.  The approach here is to set up a cron job in the **host** operation system, (via  `crontab -e`) that does a `docker exec` to run *inside* the container.

Thus it would not work on Windows (unless using a cygwin or some kind of port).

## Collecting Health Center output

Note there is no *need* to do this.  But in the sample here, the premise is that you might want to use Health Center to do some profiling of your application execution

1. stop server cleanly to pull into HC

`/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/stopServer.sh server1 -user wsadmin -password $(cat /tmp/PASSWORD)`

**Note:** This will stop the container along with the server.  *However*, a `docker stop batch-cg` will stop  the container too abruptly to allow the Health Center data collection to complete cleanly, and may not leave you with valid, usable Health Center data.

2. Copy Health Center data out of container

`docker cp batch-cg:/work/hc .`

3. Import into Health Center.  See the [Performance Cookbook section](https://publib.boulder.ibm.com/httpserv/cookbook/Major_Tools-IBM_Java_Health_Center.html) on Health Center.


### NOTE - Disk space Usage !

The Health Center data which the image is configured to collect may take up an unexpected amount of disk space, since the properties are set to collect 10 files, each of size 1GB.

To Health Center data collection in this sample image is configured in file [jvm.hc.props](jvm.hc.props).   See [here](https://www.ibm.com/support/knowledgecenter/SS3KLZ/com.ibm.java.diagnostics.healthcenter.doc/topics/configproperties.html) for a complete reference.
