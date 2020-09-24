#!/bin/bash
if [ -d "/fuseki/databases" ] 
then
    echo "Database already initialized. Removing old lock and exit"
    rm /fuseki/system/tdb.lock
    rm /fuseki/databases/colid-dataset/tdb.lock
    exit 0
fi

echo "Starting initializing database."
mkdir /fuseki/databases

echo "Start uploading metadata graphs.
###################################"
./tdbloader --graph https://pid.bayer.com/kos/19050/367403                               --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/metadata_graph_configuration.ttl
./tdbloader --graph https://pid.bayer.com/pid_enterprise_core_ontology/1.0               --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid_enterprise_core_ontology__1.0.ttl
./tdbloader --graph https://pid.bayer.com/pid_ontology_oss/5                              --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid_ontology_oss__5.ttl
./tdbloader --graph https://pid.bayer.com/pid_ontology_oss/shacled/5.0                    --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid_ontology_oss__shacled__5.0.ttl
./tdbloader --graph https://pid.bayer.com/pid_ontology_oss/technical/5.0                  --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid_ontology_oss__technical__5.0.ttl
./tdbloader --graph https://pid.bayer.com/pid/mathematical_model_categories_taxonomy/1.0 --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid__metadata__mathematical_model_categories_taxonomy__1.0.ttl




echo "#####################################
Start uploading instance data graphs.
#####################################"
./tdbloader --graph https://pid.bayer.com/consumergroup/1.0         --loc /fuseki/databases/colid-dataset /staging/graphs/instances/consumergroup__1.0.ttl 
./tdbloader --graph https://pid.bayer.com/pid_uri_template/1.0      --loc /fuseki/databases/colid-dataset /staging/graphs/instances/pid_uri_template__1.0.ttl
./tdbloader --graph https://pid.bayer.com/extended_uri_template/1.0 --loc /fuseki/databases/colid-dataset /staging/graphs/instances/extended_uri_template__1.0.ttl
./tdbloader --graph https://pid.bayer.com/keyword/1.0               --loc /fuseki/databases/colid-dataset /staging/graphs/instances/keyword__1.0.ttl
./tdbloader --graph https://pid.bayer.com/resource/4.0              --loc /fuseki/databases/colid-dataset /staging/graphs/instances/resource__4.ttl
./tdbloader --graph https://pid.bayer.com/resource/historic         --loc /fuseki/databases/colid-dataset /staging/graphs/instances/resource_historic.ttl
