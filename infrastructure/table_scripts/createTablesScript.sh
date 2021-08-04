#!/bin/bash

hive -f create_databases,hql
hive -f create_tables.hql
