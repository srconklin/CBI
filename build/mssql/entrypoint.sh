#!/bin/bash
# Run Microsoft SQl Server and initialization script (at the same time)
echo "running db intialization...." 
./run-initialization.sh & /opt/mssql/bin/sqlservr 