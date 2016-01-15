#! /bin/bash                                                                         
#####################################################################################
#                                                                                   #
#  Script to build docker image and verify the image                                #
#                                                                                   #
#  Usage : buildAndVerify.sh <Image name> <Dockerfile location> <URL>               #
#                                                                                   #
#####################################################################################

image1=$1                                                                  
image=`echo $image1 | cut -d ":" -f1`
tag=`echo $image1 | cut -d ":" -f2`
dloc=$2                                                                   
url=$3
cname=$image'test'                                                                                     

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
   docker build --build-arg user=was1 --build-arg group=was1 --build-arg URL=$url -t $imagename -f $dloc/Dockerfile.prereq $dloc
}

install_build()
{
   echo "******************************************************************************"
   echo "           Starting docker install build for $image                           "                                                           
   echo "******************************************************************************"    
   imagename=$image'install'
   docker build --build-arg user=was1 --build-arg group=was1 -t $imagename -f $dloc/Dockerfile.install $dloc
}

profile_build()
{
   echo "******************************************************************************"                                                        
   echo "           Starting docker profile build for $image                           "                                                        
   echo "******************************************************************************"  

   imagename=$image'profile'
   docker build -t $imagename -f $dloc/Dockerfile.profile $dloc
}

cleanup()                                                                                                          
{                                                                                                                  
                                                                                                                   
   echo "------------------------------------------------------------------------------"                           
   echo "Starting Cleanup  "                                                                                       
   echo "Stopping Container $cname"                                                                                
   docker kill $cname                                                                                              
   echo "Removing Container $cname"                                                                                
   docker rm $cname                                                                                                
   echo "Cleanup Completed "                                                                                       
   echo "------------------------------------------------------------------------------"                           
}  

test1()                                                                                                            
{                                                                                                                  
   echo "******************************************************************************"                           
   echo "          Executing  test1  - Install container with default values           "                                    
   echo "******************************************************************************"                           
                                                                                                                   
   docker ps -a | grep -i $cname                                                                                   
   if [ $? = 0 ]                                                                                                   
   then                                                                                                            
        cleanup                                                                                                    
   fi                                                                                                              
                                                                                                                   
   cid=`docker run --name $cname -h $cname -p 9060:9060 -p 9080:9080 -d $image'install'`                                                                    
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
                        cleanup                                                                                    
               else                                                                                                
                        echo " Server not started , exiting "                                                      
                        cleanup                                                                                    
                        exit 1                                                                                     
               fi                                                                                                  
         else                                                                                                      
               echo "Container $cname not running, exiting"                                                        
               cleanup                                                                                             
               exit 1                                                                                              
         fi                                                                                                        
   else                                                                                                            
         echo "Container not started successfully, exiting"                                                        
         cleanup                                                                                                   
         exit 1                                                                                                    
   fi        
}

test2()                                                                                     
{                                                                                           
   echo "******************************************************************************"    
   echo "      Executing  test2  - Install container started with user defined values  "             
   echo "******************************************************************************"   
                                                                                          
   docker ps -a | grep -i $cname                                                          
   if [ $? = 0 ]                                                                          
   then                                                                                   
        cleanup                                                                           
   fi                                                                                     
                                                                                          
   cid=`docker run --name $cname -h $cname -e HOST_NAME=$cname -e PROFILE_NAME=AppSrv02 -e CELL_NAME=DefaultCell02 -e NODE_NAME=DefaultNode02 -p 9060:9060 -p 9080:9080 -d $image'install'`  
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
                        cleanup                                                              
               else                                                                          
                        echo " Server not started , exiting "                                
                        cleanup                                                              
                        exit 1                                                               
               fi                                                                            
         else                                                                                
               echo "Container $cname not running, exiting"                                                                  
               cleanup                                                                       
               exit 1                                                                        
         fi                                                                                     
   else                                                                                      
         echo "Container not started successfully, exiting"                                  
         cleanup                                                                             
         exit 1                                                                              
   fi                                                                                        
}         

test3()                                                                                     
{                                                                                           
   echo "******************************************************************************"    
   echo "          Executing  test3  - Profile Container with default values           "             
   echo "******************************************************************************"   
                                                                                          
   docker ps -a | grep -i $cname                                                          
   if [ $? = 0 ]                                                                          
   then                                                                                   
        cleanup                                                                           
   fi                                                                                     
                                                                                          
   cid=`docker run --name $cname -h $cname -p 9060:9060 -p 9080:9080 -d $image'profile'`  
   scid=${cid:0:12}                                                                          
   sleep 10                                                                                  
   if [ $scid != "" ]                                                                        
   then                                                                                      
         rcid=`docker ps -q | grep -i $scid `                                                
         if [ rcid != " " ]                                                                  
         then                                                                                
               sleep 100                                                                     
               docker logs $cname | grep -i ADMU3000I                                        
               if [ $? = 0 ]                                                                 
               then                                                                          
                        echo "Product version is"                                            
                        docker exec $cname /opt/IBM/WebSphere/AppServer/bin/versionInfo.sh   
                        cleanup                                                              
               else                                                                          
                        echo " Server not started , exiting "                                
                        cleanup                                                              
                        exit 1                                                               
               fi                                                                            
         else                                                                                
               echo "Container $cname not running, exiting"                                                                  
               cleanup                                                                       
               exit 1                                                                        
         fi                                                                                     
   else                                                                                      
         echo "Container not started successfully, exiting"                                  
         cleanup                                                                             
         exit 1                                                                              
   fi                                                                                        
}         

test4()                                                                                     
{                                                                                           
   echo "******************************************************************************"    
   echo "          Executing  test4  - Profile container with user defined values      "             
   echo "******************************************************************************"   
                                                                                          
   docker ps -a | grep -i $cname                                                          
   if [ $? = 0 ]                                                                          
   then                                                                                   
        cleanup                                                                           
   fi                                                                                     
                                                                                          
   cid=`docker run --name $cname -h $cname -e UPDATE_HOSTNAME=true -p 9060:9060 -p 9080:9080 -d $image'profile'`  
   scid=${cid:0:12}                                                                          
   sleep 10                                                                                  
   if [ $scid != "" ]                                                                        
   then                                                                                      
         rcid=`docker ps -q | grep -i $scid `                                                
         if [ rcid != " " ]                                                                  
         then                                                                                
               sleep 100                                                                     
               docker logs $cname | grep -i ADMU3000I                                        
               if [ $? = 0 ]                                                                 
               then                                                                          
                        echo "Product version is"                                            
                        docker exec $cname /opt/IBM/WebSphere/AppServer/bin/versionInfo.sh   
                        cleanup                                                              
               else                                                                          
                        echo " Server not started , exiting "                                
                        cleanup                                                              
                        exit 1                                                               
               fi                                                                            
         else                                                                                
               echo "Container $cname not running, exiting"                                                                  
               cleanup                                                                       
               exit 1                                                                        
         fi                                                                                     
   else                                                                                      
         echo "Container not started successfully, exiting"                                  
         cleanup                                                                             
         exit 1                                                                              
   fi                                                                                        
}         

prereq_build
if [ $? = 0 ]                                                                                                                                   
then                                                                                                                                            
   docker run --rm -v $(pwd):/tmp $imagename                                                                                                    
   mv was.tar $dloc                                                                                                                             
   echo "******************************************************************************"                                                        
   echo "           Prereq build completed successfully                                "                                                        
   echo "******************************************************************************"                                                        
else                                                                                                                                            
   echo "Build failed , exiting......."                                                                                                         
   exit 1
fi  
install_build
if [ $? = 0 ]                                                                                                                                   
then                                                                                                                                            
   echo "******************************************************************************"                                                        
   echo "           Install build completed successfully                               "                                                        
   rm -f $dloc/was.tar                                                                                                                          
   echo "******************************************************************************"                                                        
else
   echo "Install build failed , exiting....."
   exit 1
fi  
if [ "$tag" = "profile" ]
then
   profile_build
   if [ $? = 0 ]                                                                                                             
   then                                                                                                                                         
      echo "******************************************************************************"                                      
      echo "           Profile build completed successfully                               "                                            
      echo "******************************************************************************"                                                     
   else
      echo "Profile build failed , exiting....."
      exit 1  
   fi
fi
if [ $? = 0 ]                                                                                                      
then                                                                                                               
    echo "******************************************************************************"                          
    echo "                     $image built successfully                                "                          
    echo "******************************************************************************"                          
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
test4                                                                                                                                       
if [ $? = 0 ]                                                                                                                               
then                                                                                                                                        
    echo "******************************************************************************"                                                   
    echo "                       Test4 Completed Successfully                           "                                                   
    echo "******************************************************************************"                                                   
fi  
