# Metadata Service 

## Reusable MicroServices Build using Spring Boot

Metadata service is similar to config service. It hold the metadata/config required across different services which needs to be stored in database and not in application properties along with code.

## API Endpoints 


```$xslt
# to validate Application is up and running (More endpoints [here](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-endpoints))
 curl -X GET  http://192.168.64.12:32323/actuator/info

GET /actuator/info
```

```$xslt
# to store metadata to DB
curl -X POST -H 'Content-Type: application/json' --data '{"name":"manali","group":"TW","value":"abcd"}'  http://192.168.64.12:32323/metadata

POST /metadata {
   "group": "agilitytoday",
   "name": "company",
   "value": "Thoughtworks"
}
```

```$xslt
# to get metadata from DB
curl -X GET  http://192.168.64.12:32323/metadata  
GET /metadata
```

## DB Configiuration

The Application requires environment variable `MONGODB_URI` to connect to a standalone Mongo DB Instance

## Docker Image Configuration

`sunitparekh/metadata:v2.0` - for Java Application connecting to DB

`mongo:latest` - for DB Container


