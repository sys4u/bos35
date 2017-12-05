# bos35

# you have to build for docker image.
# WARFILE is argument. you input what you want to deploy 
docker build -t popoya67/admin --build-arg WARFILE=http://nexus.x2framework.org/nexus/content/groups/public/x2-commerce/admin/0.0.1-SNAPSHOT/admin-0.0.1-20171128.010902-1.war .

# next stage, you have to start service.
# this is example when using docker swarm.
# When using docker swarm, you have to configure shared file system. 
# I used glusterfs. 
docker service create \
--mount type=bind,src=/mnt,dst=/usr/local/tomcat/upload-temp  \
--replicas 2 
-p 12009:8009 --name admin \
--network admin-network \
popoya67/admin

# this is example when using docker 
docker service create --name admin \
--network admin-network \
-p 12009:8009 \
popoya67/admin
