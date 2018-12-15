#
# This command won't be executed exactly and so can be modified, it's just an example of what you could add with 'crontab -e'
# 

# Every two minutes
*/2 * * * * echo "$(date)" >> /home/$USER/cron.log 2>&1; docker exec batch-cg bash -c '/opt/IBM/WebSphere/AppServer/bin/lrcmd.sh -userid=wsadmin -password=`cat /tmp/PASSWORD` -port=9443 -cmd=submit -xJCL=/work/xjcl/Mailer.xml'
