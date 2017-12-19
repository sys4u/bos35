# image build
you have to build for docker image.
WARFILE is argument. you input what you want to deploy 
```
docker build -t popoya67/admin \
--build-arg WARFILE=http://nexus.x2framework.org/nexus/content/groups/public/x2-commerce/admin/0.0.1-SNAPSHOT/admin-0.0.1-20171128.010902-1.war .
```

# service run
next stage, you have to start service.
this is example when using docker swarm.
When using docker swarm, you have to configure shared file system. 
I used glusterfs. 
```
docker service create \
--mount type=bind,src=/mnt,dst=/usr/local/tomcat/upload-temp  \
--replicas 2 
-p 12009:8009 --name admin \
--network admin-network \
--with-registry-auth 
popoya67/admin
```

this is example when using docker (but our company use docker swarm. so this is not used at our company.) 
```
docker service create --name admin \
--network admin-network \
-p 12009:8009 \
popoya67/admin
```

# comment for our company
I automated this procedure through jenkins. I introduce the procedure using at jenkins.
cow server and lion server are managed swarm. lion server is manager node. 
jenkins installed in cow server. 

1. checkout github project - bos35
   parameter necessary - WARFILE, VERSION
2. execute shell - cow server. Because jenkins is installed cow server, command execute cow server. 
   ```
   sudo docker build  -t popoya67/admin:${VERSION} \
   --build-arg WARFILE=${WARFILE} \
   --build-arg VERSION=${VERSION} \
   /root/bos35/
   sudo docker tag popoya67/admin:${VERSION} lion_ip:12000/x2-commerce-bos:${VERSION}
   sudo docker login [nexus_repository_ip]:12000 -u [nexus_repository_id] -p [nexus_repository_pw]
   sudo docker push [nexus_repository_ip]:12000/x2-commerce-bos:${VERSION}
   ```
  
3. execute shell script on remote host using ssh - lion server. Because lion server is manager node, command execute lion server.   
  ```
  sudo docker login 218.38.15.94:12000 -u [nexus_repository_id] -p [nexus_repository_pw]
  sudo docker service rm x2-commerce-bos || true
  sudo docker network rm x2-commerce-bos-network || true
  sudo docker network create --driver overlay x2-commerce-bos-network 
  sudo docker service create \
  --mount type=bind,src=/gluster-mount/x2-bos-data,dst=/usr/local/tomcat/webapps/admin/upload  \
  --replicas 2 \
  --with-registry-auth \
  -p 12009:8009 --name x2-commerce-bos \
  --network x2-commerce-bos-network  \
  [nexus_repository_ip]:12000/x2-commerce-bos:${VERSION}
   ```
  I installed nexus repository through docker swarm. so [nexus_repository_ip] allowed cow server ip and lion server ip. 
