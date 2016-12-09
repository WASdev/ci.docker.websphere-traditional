#! /bin/bash                                                                         
#####################################################################################
#                                                                                   #
#  Script to build docker image and verify the image                                #
#                                                                                   #
#  Usage : buildAndVerifyNDCell.sh <Image name> <Dockerfile location> <URL>         #
#                                                                                   #
#####################################################################################

image=$1                                                                  
dloc=$2                                                                   
url=$3
cname=$image'test'                                                                                     
nname=$image'net'

if [ $# != 3 ]                                                                       
then                                                                                 
    echo "Usage : buildAndVerify.sh <Image name> <Dockerfile location> <URL> "           
    exit 1                                                                         
fi                                                                                      
                                                                                        
prereq_build()
{
    echo "******************************************************************************"   
    echo "           Starting docker prereq build for $image                            "   
    echo "******************************************************************************"   

    imagename=$image'tar'
    dloc1=$dloc'/install'

    docker build --build-arg user=was1 --build-arg group=was1 --build-arg URL=$url -t $imagename -f $dloc1/Dockerfile.prereq $dloc1
}

install_build()
{
    echo "******************************************************************************"
    echo "           Starting docker install build for $image                           "                                                       
    echo "******************************************************************************"    
    docker build --build-arg user=was1 --build-arg group=was1 -t $image -f $dloc1/Dockerfile.install $dloc1
}

dmgr_build()
{
   echo "******************************************************************************"
   echo "              Starting docker dmgr build for $image                           "                                                        
   echo "******************************************************************************"  
   imagename=dmgr
   dloc1=$dloc'/dmgr'
   docker build -t $imagename -f $dloc1/Dockerfile $dloc1
}

custom_build()
{
   echo "******************************************************************************"
   echo "              Starting docker custom build for $image                         "
   echo "******************************************************************************"
   imagename=custom
   dloc1=$dloc'/custom'                                                                                                          
   docker build -t $imagename -f $dloc1/Dockerfile $dloc1                                                                      
}

appserver_build()
{
   echo "******************************************************************************"
   echo "              Starting docker appserver build for $image                      "
   echo "******************************************************************************"
   imagename=appserver
   dloc1=$dloc'/appserver'                                                                                                          
   docker build -t $imagename -f $dloc1/Dockerfile $dloc1                                                                      
}

cleanup()                                                                                                          
{                                                                                                                  
   echo $1                                                                                                                
   echo "------------------------------------------------------------------------------"                           
   echo "Starting Cleanup  "                                                                                       
   echo "Stopping Container $1"                                                                                
   docker kill $1                                                                                              
   echo "Removing Container $1"                                                                                
   docker rm $1                                                                                                
   echo "Cleanup Completed "                                                                                       
   echo "------------------------------------------------------------------------------"                           
}  

teardown()
{
   cleanup dmgr
   cleanup custom1
   cleanup server1 
}

createnetwork()                                                                                                                 
{                                                                                                                              
   echo "------------------------------------------------------------------------------"                                       
   echo "Creating network $nname"                                                                                                    
   docker network create $nname                                                                                           
   echo "------------------------------------------------------------------------------"                                       
} 

rmnetwork()
{
   echo "------------------------------------------------------------------------------"
   echo "Removing network $nname"
   docker network rm $nname
   echo "------------------------------------------------------------------------------"
}

test1()                                                                                                            
{                                                                                                                  
   echo "******************************************************************************"                           
   echo "                Executing  test1  - Start Deployment Manager                  "                                    
   echo "******************************************************************************"                           
 
   cname=dmgr                                                                                                                  
   docker ps -a | grep -i $cname                                                                                   
   if [ $? = 0 ]                                                                                                   
   then                                                                                                            
        cleanup $cname                                                                                                   
   fi                                                                                                              
                                                                                                                   
   cid=`docker run --name $cname -h $cname --net=$nname -e UPDATE_HOSTNAME=true -p 9060:9060 -d $cname`                                                                    
   scid=${cid:0:12}                                                                                                
   sleep 10                                                                                                        
   if [ $scid != "" ]                                                                                              
   then                                                                                                            
         rcid=`docker ps -q | grep -i $scid `                                                                      
         if [ rcid != " " ]                                                                                        
         then                                                                                                      
               sleep 200
               docker logs $cname | grep -i ADMU3000I                                                                                                                  
               if [ $? = 0 ]                                                                                       
               then                                                                                                
                        echo "Product version is"                                                                  
                        docker exec $cname /opt/IBM/WebSphere/AppServer/bin/versionInfo.sh                                    
               else                                                                                                
                        echo " Server not started , exiting "                                                      
                        cleanup $cname                                                                                   
                        exit 1                                                                                     
               fi                                                                                                  
         else                                                                                                      
               echo "Container $cname not running, exiting"                                                        
               cleanup $cname                                                                                            
               exit 1                                                                                              
         fi                                                                                                        
   else                                                                                                            
         echo "Container not started successfully, exiting"                                                        
         cleanup $cname                                                                                                  
         exit 1                                                                                                    
   fi        
}

test2()                                                                                                                        
{                                                                                                                              
   echo "******************************************************************************"                                       
   echo "                Executing  test2  - Starting Custom node                      "                                       
   echo "******************************************************************************"                                       
                                                                                                                               
   cname=custom1  
   docker ps -a | grep -i $cname                                                                                               

   if [ $? = 0 ]                                                                                                               
   then                                                                                                                        
        cleanup $cname                                                                                                                
   fi                                                                                                                          
                                                                                                                               
   cid=`docker run --name $cname -h $cname --net=$nname -e NODE_NAME=$cname'Node' -d custom `                                                
   scid=${cid:0:12}                                                                                                            
   sleep 10                                                                                                                    
   if [ $scid != "" ]                                                                                                          
   then                                                                                                                        
         rcid=`docker ps -q | grep -i $scid `                                                                                  
         if [ rcid != " " ]                                                                                                    
         then                                                                                                                  
               sleep 200                                                                                                       
               docker logs $cname | grep -i ADMU3000I                                                                          
               if [ $? = 0 ]                                                                                                   
               then                                                                                                            
                        echo "Product version is"                                                                              
                        docker exec $cname /opt/IBM/WebSphere/AppServer/bin/versionInfo.sh                                     
               else                                                                                                            
                         echo " Server not started , exiting "                                                                  
                        cleanup $cname                                                                                               
                        exit 1                                                                            
               fi                                                                                         
         else                                                                                             
               echo "Container $cname not running, exiting"                                               
               cleanup $cname                                                                                   
               exit 1                                                                                     
         fi                                                                                               
   else                                                                                                   
         echo "Container not started successfully, exiting"                                               
         cleanup $cname                                                                                         
         exit 1                                                                                           
   fi                                                                                                     
}                                                                                                         

test3()                                                                                                                        
{                                                                                                                              
   echo "******************************************************************************"                                       
   echo "                Executing  test3  - Start Nodeagent and AppServer             "                                       
   echo "******************************************************************************"                                       
                                                                                                                               
   cname=server1

   docker ps -a | grep -i $cname                                                                                               
   if [ $? = 0 ]                                                                                                               
   then                                                                                                                        
        cleanup $cname                                                                                                                
   fi                                                                                                                          

   cid=`docker run --name $cname -h $cname --net=$nname -e NODE_NAME=$cname'Node' -p 9080:9080 -d appserver `                                                
   scid=${cid:0:12}                                                                                                            
   sleep 10                                                                                                                    
   if [ $scid != "" ]                                                                                                          
   then                                                                                                                        
         rcid=`docker ps -q | grep -i $scid `                                                                                  
         if [ rcid != " " ]                                                                                                    
         then                                                                                                                  
               sleep 200                                                                                                       
               docker logs $cname | grep -i ADMU3000I                                                                          
               if [ $? = 0 ]                                                                                                   
               then                                                                                                            
                        echo "Product version is"                                                                              
                        docker exec $cname /opt/IBM/WebSphere/AppServer/bin/versionInfo.sh                                     
               else                                                                                                            
                        echo " Server not started , exiting "                                                                  
                        cleanup $cname                                                                                               
                        exit 1                                                                            
               fi                                                                                         
         else                                                                                             
               echo "Container $cname not running, exiting"                                               
               cleanup $cname                                                                                   
               exit 1                                                                                     
         fi                                                                                               
   else                                                                                                   
         echo "Container not started successfully, exiting"                                               
         cleanup $cname                                                                                         
         exit 1                                                                                           
   fi                                                                                                     
}                                                                                                         

prereq_build
if [ $? = 0 ]
then
   docker run --rm -v $(pwd):/tmp $imagename
   mv was.tar $dloc1

   echo "******************************************************************************"
   echo "           Prereq build completed successfully                                "
   echo "******************************************************************************"
else
   echo "Prereq Build failed , exiting......."
fi
install_build
if [ $? = 0 ]
then
   echo "******************************************************************************"
   echo "              Install build completed successfully                            "
   rm -f $dloc1/was.tar
   echo "******************************************************************************"
else
   echo "Install Build failed , exiting......."
fi
createnetwork
dmgr_build
if [ $? = 0 ]
then
   echo "******************************************************************************"
   echo "              Dmgr Build completed successfully                               "
   echo "******************************************************************************"
else
   echo "Dmgr Build failed , exiting....."
fi
custom_build
if [ $? = 0 ]
then
   echo "******************************************************************************"
   echo "              Custom Build completed successfully                               "
   echo "******************************************************************************"
else
   echo "Custom Build failed , exiting....."
fi
appserver_build
if [ $? = 0 ]
then
   echo "******************************************************************************"
   echo "              AppServer Build completed successfully                               "
   echo "******************************************************************************"
else
   echo "AppServer Build failed , exiting....."
fi
test1                                                                                                          
if [ $? = 0 ]                                                                                                  
then                                                                                                           
   echo "******************************************************************************"                      
   echo "                       Test1 Completed Successfully                           "                      
   echo "******************************************************************************"                      
fi                                                                                                             
test2                                                                                                                                       
if [ $? = 0 ]                                                                                                                               
then                                                                                                                                        
   echo "******************************************************************************"                                                   
   echo "                       Test2 Completed Successfully                           "                                                   
   echo "******************************************************************************"                                                   
fi  
test3                                                                                                                                       
if [ $? = 0 ]                                                                                                                               
then                                                                                                                                        
   echo "******************************************************************************"                                                   
   echo "                       Test3 Completed Successfully                           "                                                   
   echo "******************************************************************************"                                                   
fi  
teardown
rmnetwork                                                                                                            
