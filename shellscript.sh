docker build -t popoya67/admin --build-arg WARFILE=http://nexus.x2framework.org/nexus/content/groups/public/x2-commerce/admin/0.0.1-SNAPSHOT/admin-0.0.1-20171128.010902-1.war .

docker service rm admin || true

docker network rm admin-network || true

docker network create --driver overlay admin-network

docker service create --mount type=bind,src=/mnt,dst=/usr/local/tomcat/upload-temp  --replicas 2 -p 12009:8009 --name admin --network admin-network popoya67/admin
