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
./tdbloader --graph https://pid.bayer.com/pid_ontology/12/OpenSource                     --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid_ontology_12__OpenSource.ttl
./tdbloader --graph https://pid.bayer.com/pid/metadata/mathematical_model_categories_taxonomy/1.0 --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/pid__metadata__mathematical_model_categories_taxonomy__1.0.ttl
./tdbloader --graph https://pid.bayer.com/kge/triplestores                               --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/triplestores.ttl
./tdbloader --graph https://pid.bayer.com/kge/triplestoreSystems                         --loc /fuseki/databases/colid-dataset /staging/graphs/metadata/triplestoreSystems.ttl




echo "#####################################
Start uploading instance data graphs.
#####################################"
./tdbloader --graph https://pid.bayer.com/consumergroup/1.2         --loc /fuseki/databases/colid-dataset /staging/graphs/instances/consumergroup__1.2.ttl 
./tdbloader --graph https://pid.bayer.com/piduritemplate/1.0      --loc /fuseki/databases/colid-dataset /staging/graphs/instances/pid_uri_template__1.0.ttl
./tdbloader --graph https://pid.bayer.com/extended_uri_template/1.0 --loc /fuseki/databases/colid-dataset /staging/graphs/instances/extended_uri_template__1.0.ttl
./tdbloader --graph https://pid.bayer.com/keywords/1.0               --loc /fuseki/databases/colid-dataset /staging/graphs/instances/keyword__1.0.ttl
./tdbloader --graph https://pid.bayer.com/resource/1.0              --loc /fuseki/databases/colid-dataset /staging/graphs/instances/resource__1.0.ttl
./tdbloader --graph https://pid.bayer.com/resource/1.0/Draft         --loc /fuseki/databases/colid-dataset /staging/graphs/instances/resource__1.0__Draft.ttl
./tdbloader --graph https://pid.bayer.com/resource/historic         --loc /fuseki/databases/colid-dataset /staging/graphs/instances/resource_historic.ttl
./tdbloader --graph https://pid.bayer.com/linkhistory               --loc /fuseki/databases/colid-dataset /staging/graphs/instances/linkhistory.ttl
./tdbloader --graph https://pid.bayer.com/categoryFilterGraph       --loc /fuseki/databases/colid-dataset /staging/graphs/instances/categoryFilterGraph.ttl
./tdbloader --graph https://pid.bayer.com/kos/19050#d8ce3654-776e-422a-a7a2-c4e420f65abaRev1_added       --loc /fuseki/databases/colid-dataset /staging/graphs/instances/first_resource_revision_graph.ttl
