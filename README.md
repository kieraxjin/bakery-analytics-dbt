# Bakery Analytics: dbt Project Documentation

# Project Overview

This project builds a data pipeline to track recipe performance, ingredient costs, and baking trial success rates for a professional bakery.

## Phase 1: Infrastructure & Data Loading

The goal of this phase is to establish the physical storage and move raw data into the cloud.

1. Snowflake Environment Setup
   We established the "Kitchen" by creating the following objects in Snowflake:
   Warehouse (TRANSFORMING): The computational engine used to process SQL queries.
   Database (BAKERY_RAW): The storage area for "untouched" source data.
   Database (BAKERY_ANALYTICS): The storage area for cleaned and modeled data.
   Schema (DBT_KJIN): A dedicated workspace for dbt to build tables.
2. Data Ingestion (Seeds)
   Raw CSV files were imported into the dbt seeds/ folder and pushed to Snowflake using the dbt seed command.
   recipes.csv: Contains static recipe information (ID, Name, Category, URL).
   recipe_trials.csv: Contains logs of every bake attempt (ID, Result, Rating, Time spent).

## Phase 2: Data Transformation (dbt Modeling)

The goal of this phase is to use SQL logic to clean, rename, and join data for reporting.

1. Staging Layer (stg\_ models)
   Instead of editing raw data, we created a "Staging" layer to standardize it.
   Location: models/stg_trials.sql
   Key Logic: Used CASE statements and ILIKE patterns to fix manual data entry typos (e.g., converting "Sucsess" to "Success").
   Command: dbt run --select stg_trials
2. Marts/Reporting Layer (fct\_ models)
   This layer "joins" different tables together to create a finished product for the analytics team.
   Logic: Joined recipes (Dimensions) with stg_trials (Facts) using recipe_id.
   Output: A single table showing the Recipe Name alongside its Average Rating and Success Rate.

## Phase 3: Quality Control & Automation

Ensuring the data is accurate and the pipeline is reliable.
Data Lineage: Using the dbt Lineage Graph to visualize how data flows from a CSV file to a final report.
Testing: Using dbt test to ensure that critical fields (like recipe_id) are never empty and that ratings stay within a 1–5 scale.
