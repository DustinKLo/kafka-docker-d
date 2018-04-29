# run image
docker-compose -f docker-compose.yml up

# safely take image down
docker-compose -f docker-compose.yml down

# creates 3 brokers
docker-compose scale kafka=3

# enters container for only 1 broker
# docker exec -it kafkadocker_kafka_1 bash

# enters container for multiple brokers
docker run --rm -it --net=host wurstmeister/kafka bash

# works for one broker
# kafka-topics.sh --create --zookeeper $KAFKA_ZOOKEEPER_CONNECT --replication-factor 1 --partitions 1 --topic topic1

# works for multiple brokers
kafka-topics.sh --list --zookeeper localhost:2181

docker-compose scale kafka=3

kafka-topics.sh --create --zookeeper 127.0.0.1:2181 --replication-factor 1 --partitions 1 --topic topic1

kafka-console-producer.sh --broker-list localhost:9092 --topic topic1
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topic1 --from-beginning

docker cp register-postgres.json wurstmeister/kafka

docker-compose -f docker-compose.yml exec postgres env PGOPTIONS="--search_path=inventory" bash -c 'psql -U postgres postgres'



docker kill $(docker ps -aq)
docker rm $(docker ps -qa)

docker rmi --force $(docker images -aq)


apk update && apk add jq


curl -s 127.0.0.1:8083/ | jq
curl -s 127.0.0.1:8083/connector-plugins | jq
curl -s 127.0.0.1:8083/connectors | jq
curl -s 127.0.0.1:8083/connectors/source-twitter-distributed/tasks | jq
curl -s 127.0.0.1:8083/connectors/file-stream-demo-distributed/status | jq
curl -s -X PUT 127.0.0.1:8083/connectors/file-stream-demo-distributed/pause
curl -s -X PUT 127.0.0.1:8083/connectors/file-stream-demo-distributed/resume
curl -s 127.0.0.1:8083/connectors/file-stream-demo-distributed | jq
curl -s -X DELETE 127.0.0.1:8083/connectors/file-stream-demo-distributed
curl -s -X POST -H "Content-Type: application/json" --data '{"name": "file-stream-demo-distributed", "config":{"connector.class":"org.apache.kafka.connect.file.FileStreamSourceConnector","key.converter.schemas.enable":"true","file":"/demo-file.txt","tasks.max":"1","value.converter.schemas.enable":"true","name":"file-stream-demo-distributed","topic":"demo-2-distributed","value.converter":"org.apache.kafka.connect.json.JsonConverter","key.converter":"org.apache.kafka.connect.json.JsonConverter"}}' http://127.0.0.1:8083/connectors | jq
curl -s -X PUT -H "Content-Type: application/json" --data '{"connector.class":"org.apache.kafka.connect.file.FileStreamSourceConnector","key.converter.schemas.enable":"true","file":"demo-file.txt","tasks.max":"2","value.converter.schemas.enable":"true","name":"file-stream-demo-distributed","topic":"demo-2-distributed","value.converter":"org.apache.kafka.connect.json.JsonConverter","key.converter":"org.apache.kafka.connect.json.JsonConverter"}' 127.0.0.1:8083/connectors/file-stream-demo-distributed/config | jq


curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-postgres.json

curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d '{"name":"inventory-connector","config":{"connector.class":"io.debezium.connector.postgresql.PostgresConnector","tasks.max":"1","database.hostname":"postgres","database.port":"5432","database.user":"postgres","database.password":"postgres","database.dbname":"postgres","database.server.name":"dbserver1","database.whitelist":"inventory","database.history.kafka.bootstrap.servers":"kafka:9092","database.history.kafka.topic":"schema-changes.inventory"}}'

curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8084/connectors/ -d @register-twitter.json

kafka-topics.sh --list --zookeeper localhost:2181
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver1.inventory.orders --from-beginning


