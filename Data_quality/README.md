# Course outline
----------------------------
ETL/ELT and Database testing 
-----------------------------------
- provide data quality assurance throughout the entire data lifecycle
- ETL/ELT testing
  - transformations mapping
  - table relationships
  - source-target testing
- database testing
  - schema
  - table
  - attribute

Data quality dimensions:
- DAMA-DMBOK
- set of data quality rules and criteria
- provides a basis for measuring data quality performance


      - Completeness
      - Uniqueness
      - Timeliness
      - validity
      - Accuracy
      - Consistency

- Here completeness means no null records should be there.
- here Uniqueness means no duplicates records in the datasets
- Accuracy refers to the degree to which data correctly describes the real-world object, event, or value it is intended to represent.
- Timeliness = Right data + At the right time + Up-to-date
- Validity: refers to the degree to which data values conform to the defined business rules, formats, or constraints.
- Consistency refers to the degree to which data values are the same across different data stores, systems, or datasets, and do not contradict each other.


# data quality components
-------------------------------
1. data profiling
2. data quality analysis
   - validations
3. data cleansing
   - matching
   - eliminate errors, duplicates, inconsistencies, etc
4. data quality monitoring
   - reporting and monitoring


  # Data profiling
  -----------------
  * metadata discovery
    - datatypes, length, precision, nullable
    - keywords
    - tags
    - relationships(pk, fk)
  * descriptive methods
    - count
    - mean, max, min
* validations level
    - schema, entity, attribute


# Excercise 1
-----------------------------------------------------------------------------------------
Data requirements- data completeness
1. Customers - record cannot contains empty fields
2. managers - records cannot contains empty fields
3. orders - records cannot contains empty fields
4. returns - records cannot contain empty fields
5. products - records cannot contain empty fields


# Exercise 2
-----------------------------------------------------------------------------------------
Data requirements - data uniqueness
1. customers - each customer(name) should be unique
2. managers - there should only be one manager assigned for each region, therefore each manager should be unique
3. orders - each orders should have a unique order id
4. returns - an order can only be returned once, therefore each return has a unique orderID
5. products - each product name should be unique


# Exercise 3
----------------------------------------------------------------------------------------------
data requirements - data validity
orders table
 validations checks:
   ship_date >= order_date
   order_quantity>0
   order_date > [defined-date]
   discount >=0 and discount<1
   shippingcost >0
   unitprice > 0
   sales >0
   orderID> 1
   rowID> 1

# Exercise 4
-------------------------------------------------------------------------------------------------
data requirements - data consistency
1. customers - province, region, customerSegment
2. managers - region
3. orders - orderPriority, shipmode, 
4. returns - status
5. products - productcategory, productSubcategory

# Exercise 5
-------------------------------------------------------------------------------------------------
data requirements - data integrity
validate the integrity of data source-target mapping between DM and stg tables
- stg_order
- stg_customers
- dm_customerRegionalSales

# Exercise 6
-------------------------------------------------------------------------------------------------
Data requiremnets - data profiling
- include the following metadata validations
  - count records
  - datatype checks
  - length checks
  - precision checks
  - nullable checks



