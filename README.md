# Mastering data warehouse, Dimensional modelling and ETL process:
---------------------------------------------------------------------------

- Why do we need data warehouse?
  ------------------------------------
==>> two purposes:
      1. operational data keeping( OLTP-online transaction processing)
	    2. analytical decision making( online analytical processing)
	  
	  
 Yes , we have a lot of data but we don't use it.
 our data is very complicated and difficult to analyze.
 Its spread all over the diffrent systems and difficult to access it.
 I just want to see what is relevant.
 we need to access data quick and easily.
 we want to make fact-based decisions.
 
 
 DWH is there to address those analytical data needs.
 
 Simple definiton of DWH: a database which is used and optimized for reporting and data analysis.
     - should be user friendly
		 - fast query performance
		 - enabling data analysis
		 
		 
		 
- Goals of a data warehouse:
  - centralised and consistent location for data
  - data must be accessible fast(query performance)
  - user-friendly(easy to understand)
  - must load data consistently and repeatedly(ETL)
  - reporting and data visualization built on top
  
  
##We create a data warehouse for business intelligence.

Data lake and data warehouse are both used as CENTRALIZED DATA STORAGE.


In data lake , data is stored in raw form. but in data warehouse it is stored in processed form.
thats why bigdata technology are used in data lake.but in case of warehouse, database technology are used.
in data lake, data is unstructured format. but in warehouse, it is in structured format.
in case of usage, it is not defined yet.but in warehouse , it is specific and readdy to use.
Data lake requires high understanding thats why only data scientist deals with that. but in data warehouse, only business user and reporting person use it.

NOTE: A report usually needs to have structured data from tables and ideally they have a fast query performance to
visualize the data quickly and a high user-friendliness.therefore, a data warehouse is good fit.



#### Data warehouse architecture:
------------------------------------------------

Data warehouse layers:
---------------------------
data source ---> ETL---->> data warehouse


To understand the architecture of data warehousing, we need to understand the source data as well.
We use ETL tools to extract data from data source into staging area which is kind of first layer of data warehouse.
Its kind of raw data in tables in terms of staging.Here we don't perform any transformations. We leave data untouched as much as possible.
we can combine tables to put similar tables in one table in staging area.

then we usually perform transformations on tables in staging area and then load those tables into core layer which is called data warehouse.


So the question here is why do we need staging area in warehousing?
-- Staging probably creates redundancy.Instead of loading data into staging, we could perform same task in data source. then why?
    --reason is pretty simple, we don't want operational tools to be slow down. If something wrong happens, it would cause problem in running system.

  Thats why we need staging area in order to avoid performance issue.
  --another reason is to move data into relational database to apply transformations.
  -- from staging area, we can start applying transformations.  


Suppose we a have table in source system and we want to read data from that table and move into staging area,and from there we can apply our transformations, and can load data into data warehouse.
What happens if after sometime there is additional data present in the source system table?
One more thing is, we usually truncate staging area after every cycle.
So now we have to look what are the new data present in the source table?

So to identify new records in source table, we should have a delta logic in place.So we have to identify delta column which will tell us the new data in table.
Usually date column is preferablly our delta column.


Conclusion :
 -Staging layer is the landing zone of extracted data.
 -Data in tables and on a separate database.
 -as little "touching" as possible.
 -we don't change the source system.
 -two types of staging layers:
      -Temporary staging layer
	  -Persistent layer
	  
	  
Sometimes core layer/data warehouse layer also called access layer.
Sometimes on business demands , there is another layer added on top of core layer called data marts.


Datamarts:
-subset of DWH
-dimensional modelling
-can be further aggregated

Specialised technology for fast query performance:
Power BI : in-memory databases
in some cases dimensional cubes

In-memory databases:
 - highly optimized for query performance
 - good for analytics/ high query volume
 - usually used for data marts
 - relational and non-relational
 
Lets understand why in-memory databases are helpful?
--using in-memory databases we can remove response time which is coming from memory in traditional databases.

There is a problem with in-memory databases. Durability is an issue. will lose all information when devices loses power or is reset.
but durability is added through snapshots/images.
it is kind of costly.
thats why we always go for data marts only when required.

Some example of in-memory databases:
SAP HANA
MS SQL Server in-memory tables
oracle in-memory
Amazon memoryDB

There is more traditional way to increase query performance in data marts.So these are so called CUBES


CUBES:
------------
--Traditionl DWH based on relational DBMS(ROLAP)
--data is organised non-relational in cube (MOLAP)cube= Multi-dimensional datasets
-- Array instead of tables
-- Main reason to use: fast query performance
-- works well with BI tools

Here in MOLAP , data is not organised in the tables with columns and rows but into array.

OLAP Cubes:
This is an alternative method to further increase the performance of data marts and it is quite a established technology.
 
ODS(Operational data storage)
-------------------------------------
-- similar to data warehouse 
-- only used for making operational decision making

-- no need for long history
-- needs to be very current or real-time
-- thats the reason we have update logic in place during ETL processing


ODS-Sequential
-----------------------
Its a kind of ETL on top of ODS database in order to store current records in DWH.

Getting less relevant these days because of following reasons:
-- better performance of ETL/DBs
-- big data technology (very fast/real-time)


Summary of DWH architecture:

Staging:
   - Landing zone
   - minimal transformations
   - "stage" the data in tables
   
Core:
   - Always there
   - Business logic & single point of truth
   - can be sometimes the access layers

Mart:
   - Access layer
   - Specific to one use-case
   - optimized for performance
-------------------------------------------------------------------------------------------------------------

DIMENSIONAL MODELING:
-----------------------------
-method of organizing data(in a data warehouse)

In dimensional modeling, all of the data are either is organised in facts or dimensions.

A fact can be something that usually measures(like profit).
while dimensions give additional context to those measurements like category or period.

From the facts we can convert it into meaningfull insights using dimensions like profit by year.

In real time, we have multiple dimensions clustered around the facts.so that we can use all diffrent dimensions to analyze our data
to measure in fact tables.


Dimensional modeling:
---------------------------------
-Unique technique of structuring data
-commonly used in DWH
-optimized for faster data retrieval
-oriented around performance and usability
-designed reporting/OLAP

why dimensional modeling?
------------------------------
Goal: fast data retrieval
oriented around performance and usability


---------------------------------------------------------------------
Lets understand what are facts and fact tables in data warehouse.

Fact table is the foundation of DWH.
It contains key measurements.
Usually facts are additive(aggregatable(numerical values)).
usually consists of event or transactional data.

Fact table: usually consists of PK, FK & Facts.
Grain: Most atomic level facts are defined.

Dimensions:
----------------------
It categorize the facts.(meaningful context of our measurements)
supportive and descriptive
filtering, grouping and leveling

Some of the common characters of dimension tables:
--non-aggregatable
--more static

Dimension table: PK, Dimesion(FK)
People, products, places, time
-------------------------------------------------------------------------------

STAR SCHEMA:
---------------------
Most important schema in DWH. Especially in Data mart.

Dimension to fact : 1:n (one to many)
Fact to dimension : many to 1

In this, we have data redundancy(denormalised).
(Reducing the data redundancy is called normalisation).


Normalisation is good in some cases but not ideal in some cases like where optimisation requires to get data out.
Query performance (read ) better in case of data redundancy.


Normalisation:
 technique to avoid redundancy
 minimises the storage.
 performance(write/update)
 many tables
 many joins necessary
 

Here in STAR SCHEMA, we have data stored in denormalised form to a certain degree in order to achieve BU goals.

Summary:
 Most common schema in data Mart
 Simplest form
 work best for specific needs(simple set of queries vs complex queries)
 usablity + performance for specific (read) use-case
 
 
------------------------------------------------------------------------------------------------

SNOWFLAKE SCHEMA:
-------------------------
It uses normalisation in order to reduce redundancy.


Advantages:
 - Less space(storage cost)
 - no redundant data(easier to maintain/update, less risk of corrupted data)
 - solves write slow downs
 
Disadvantages:
 - more complex
 - more joins( more complex sql queries)
 - less performance data marts/ cubes
 
Thats the reason snowflake schema is not used in data marts.

Summary:
In our data marts, we prefer star schema.
In the core, we also use star schema but in some cases we might use snowflake schema.

-------------------------------------------------------------------------------------------------------------

Assignment 1:
---------------------
Project description:

You are assigned to create a data warehouse as the responsible BI Consulatant.

The source data is coming directly from the project management tool that is used in your company.

The structure of the output table is as follows:
ProjectLogs:
  -Log_id
  -Update_date
  -Hours_logged
  -Project_ID
  -Project_Name
  -Project_Priority
  -Employee_ID
  -Employee_name
  -Division
  -Head_of_division


Requirements:

The project managers and the division managers need to be able to analyze how many hours where logged by different attributes. They would also like to be able 
to analyze the hours by Month, Quarter and Year. You are free to create an additional table for that if necessary.

Your job:

As a first step you should identify dimensions and facts - and define what dimension tables and fact tables you would create.

You can use PowerPoint or other tools (or just pen and paper) and upload the image - or just write it in text:

-------------------------------------------------------------
Answer to assignment 1:

One possible answer:

Fact table:
logs (Log_id(pk), Project_ID(fk), Employee_ID(fk),division_id(fk), date_id(fk), hours_logged)

Dimension tables:
dim_employee(Employee_ID(pk), Employee_name)
dim_project(Project_ID(pk), Project_Name, Project_Priority)
dim_date(date_id(pk), update_date, month, quarter, year)
dim_division(division_id(pk), division, Head_of_division)

-------------------------------------------------------------------------------------------------------------------------------------

Assignment 2:
-----------------
You are assigned to create a data warehouse as the responsible BI Consulatant.

The source data is coming directly from the sales system that is used in your company.

The structure of the output table is as follows:
SalesTransactions:
 -TransactionID
 -Date
 -Quantity
 -TransactionAmount
 -Item_ID
 -Item_Name
 -Brand_Name
 -Category_Name
 -Location_ID
 -Country
 -State
 -City
 -Location_Manager
 
Requirements:

The responsible managers need to be able to analyze how many sales quantity as well as the transaction amounts.

They would also like to be able to analyze the hours by Month, Quarter and Year. You are free to create an additional table for that if necessary.

Your job:

As a first step you should identify dimensions and facts - and define what dimension tables and fact tables you would create.

--------------------------------------------------------------------------------------------
Answer to Assignment 2:
one possible answer is:

fact table:
Sales(TransactionID,Quantity,Item_ID(fk),Location_ID(fk),Date_id(fk),TransactionAmount)

Dimension table:
dim_date(Date_id(pk),month, quarter, year)
dim_item(Item_ID(pk),Item_Name,Brand_Name,Category_Name)
dim_location(Location_ID(pk), country, State, City, Location_Manager)
----------------------------------------------------------------------------------------------------------------------


Lets dig deeper about Facts:
--------------------------------------
usually facts are numerical values.

Additivity in facts:

Three types:
  1. Additive:
      -can be added across all dimensions
	  -most flexible andd useful
	  -most facts are fully additive.
  
  2. Semi-additve:
      -can be added across a few dimensions
	  -used carefully and less flexible
	  -averaging might be an alternative
	  - example- account balance(it is not possible to add across date dimension.)
	  
	  
  
  3. Non-additive:
      -cannot be added across any dimensions
	  - typical examples are price, percentages and ratios. we can't add them.
	  -limited analytical values
	  - can store underlying values
	  

--------------------------
What happens if we have Nulls in our facts?

as we know that null values can be dealt easily.

Take a little bit of discipline while handling null values. Sometimes it would be misleading.Therefore in some numeric columns values, it would be 
easier to replace null values with zero.

Another thing to be careful about null values in foreign key.
If we have null value in foreign key, we can create dummy value in order to avoid mess.

-------------------------------------------------------
Year-to-date facts:
-often requested by business users
-tempted to store them in columns
-month-to-date,quarter-to-date,fiscal-to-date etc
-better store the underlying values in defined grains
- instead calculate all the to-date variations in BI tools

--------------------------------------------------------------
Types of fact tables:
-transactional 
-periodic snapshots
-Accumulating snapshots


TRANSACTIONAL FACT TABLES:
-most fundamental fact table
- 1 row=measurement of 1 event/ transaction
- taken place at a specific time
- one transaction defines the lowest grain


 characteristics:
  - most common and very flexible
  - typically additive
  - tend to have a lot of dimensions(multiple FKs associated with fact table)
  - can be enormous in size
  

PERIODIC SNAPSHOT FACT TABLE:
-1 row = summarizes measure of many events/transactions
-summarized of standard period(e.g. 1 day, 1 week etc)
-lowest period defines the grain


   characteristics:
    - tend to be not as enormous in size
	- typically additive
	- tend to have a lots of facts and fewer dimensions associated.
	- no events= null or 0
	
	
	
ACCUMULATION SNAPSHOT FACT TABLE:
- 1 row = summarizes measure of many events/ transactions
- summarized of lifespan of 1 process(e.g. order fullfillment)
- definite beginning & definite ending(& steps in between)

    characteristics:
	 - least common
	 - workflow or process analysis (in such case like order fullfillment)
	 - multiple date/time foreign keys(for each process step)
	 -  date/time keys associated with role-playing dimensions
	 
	 
-----------------------------------------------------------
As we learned the diffrence between fact table and facts. 
Fact table can contain multiple facts.

FACTLESS FACT TABLE:
--------------------------
-Facts are usually numeric.
- Sometimes only dimensionals aspects of an event are recorded.

-Example- Employee registration
Employee_Registration(reg_id(pk), entry_date(fk), dept_id(fk), region_id(fk), manager_id(fk),pos_id(fk))

using above factless fact table, we can answer like how many emplyees have been registered last month?

In the above table, no metrics involved.
 How many employess have been registered in a certain region?
 
 
------------------------------------------------------------------------------------------------
STEPS IN DESIGNING FACT TABLES:
--------------------------------
What are the key decisions we need to take during the design?

1) Identify business process for analysis
   examples:
    Sales,
	Order processing
2) declare the grain
   meaning the level of details in our table.
   Example: transaction, order, orderline, daily, daily+location
3) identify dimensions that are relevant
    what, when , where, how and why
	example -time, locations, products, customers etc.
	
	Gives filtering and grouping in our data. Basically entry point for data analysis.
	
	
	
4) identify facts for measurements
   defined by the grain & not by specific use-case.
   
   
Natural keys - comes out of the source system
Surrogate keys- Artificial keys (created by database or etl)

Benefits of using surrogate key:
-improve performance(less storage/better joins)
- handle dummy values(nulls/missing values)
-integrate multiple source systems
-easier administrate/ update
- sometimes there are even no natural keys

Practical guidelines:
-Always use surrogate keys in table as main PK and FK
-both for facts & dimensions(except date dimensions)
-optionally keep the natural keys


CASE STUDY: e-Commerce(design fact table)
-----------------------------
suppose you are working in e-commerce company and they are selling 1000s of products on three diffrent websites.
Each website operates independently and managed by multiple departments

goal:
-logistics in warehouse
- maximizing profits

STEP 1: identify business process
Business process for first DWH?
-most critical for business 
-data availability, data quality

Here in our case, we mainly focus on sales transactions as per business demand.
Here we can analyze like:
 -which products sold
 -what is sales profit
 -sales of each website
 -performance on diffrent dates
 -sales over time
 
Since business process is defined, we can go for next step.

STEP 2: declare the grain
What level of details?
Basically we want to find out what should be in the row of facts table.
  --most analytical value with atomic grain
  --highest dimensionality
  
  
STEP 3: define the dimension
-descriptive aspects of measures
-naturally derived after grain defined


STEP 4: identify the facts in fact table
here basically try to find out the relevant facts which are required for our analytical measurements.
-must comply with the grain.
-------------------------------------------------------------------------------------------------------------------------------------------------------


DIMENSION TABLE:
--------------------------
-slice and dice our data
-always has a primary key(pk)
-use surrogate key instead of pk
-usually what we do is ,we create a lookup table where surrogate key refer to natural key.(using join)
-relatively few rows/many columns with descriptive attributes
-group and filter ("slice & dice")


Date dimensions:
---------------
-One of the most common and most important dimensions
-contains date related features
  -Year, month(name & numbers), day , quarter, week
- meaningful surrogate key YYYYMMDD
-extra row for no date/null(source)
-TIme is usually a separate dimension
-can be populated in advance(eg for next five or 10 years)

Date features:
 - numbers and text(eg January, 1)
 - long and abreviated(January, Jan)
 - combinations of attributes(Q1, 2022-Q1)
 - Fiscal dates(Fiscal year etc)
 - Flags(Weekend, Company holidays)
 
Nulls in dimensions:
What we have learnt so far as per fact table perspective:
-null must be avoided in FKs
-nulls in fks break referential integrity
-they don't appear in joins
-nulls can be present in facts(eg when store is closed)

If we have nulls in dimension table,
- replace nulls with descriptive values
    - more understandable for business users
    - values appear in aggregation in BI tools


Hierarchies in dimensions:
-------------------------------
Often we have hierarchies in dimension table.
-also called normalised tables
-pointing towards snowflake schema(should be avoided)

Some professionals have habit of normalising data which causes bad experience of reading of data.

NOTE: usually try to denormalise/flattened the data which will give you higher visibility.

------------------------
CONFORMED DIMENSIONS:
--------------------
-Conformed dimension is a dimension that is shared by multiple fact tables/ stars.
-used to compare facts across diffrent fact tables.(usually called drill across)


DEGENERATE DIMENSION:
--------------------------
Degenarate dimension the dimension key without an associated dimension.

-occuring mostly in transactional facts


JUNK DIMENSION:
--------------------
sometimes in our transactional fact table we can have a lot of indicators or flags that are actually dimensions but they don't actually 
fit in given dimensions. therefore, we should create a junk dimension.

Lets take a closer look when these junk dimension could appear and how we should deal with that.

As a data modeller, we can eliminate those columns if they are not relevant.
What if they are relevant?
-Leave them as they are in the fact.
    what if they are long text values or bulky in size?
	
 what is junk dimension?
 - Dimension with various flags/indicators with low cardinality.
 - like a box where we store items we need  but have no separate storing location.
  
 NOTE: We call it "junk dimension" usually only internally. Talking to business users we can refer it as "transactional indicator/flag dimension".
 
 Extract only available combinations of fact table in order to avoid all possible combinations.
 
 
 ROLE-PLAYING DIMENSION:
 -------------------------
 - dimension that is referenced multiple times by a fact.
 - mainly date dimension
 
 suppose we have production fact table;
 production(order_id(pk),prod_start_date(pk),prod_delivery_date(fk),unit,cost)
 
 here in above fact table, we have two date for which we might have to create two date dimensions. so in-order to avoid that, we can use single date_dim and allow to other role.
 
 ------------------------------------------------
 CASE STUDY: Date dimension
 ------------------------------
 We have learnt that date dimension is probably the most important dimension. 
 Execute the attached queries.
 
 
SLOWLY CHANGING DIMENSION:
------------------------------
Till now we have pretended dimensions never change.
indeed they are rather static usually.
but surprise...they do change in the real world.

Develop a strategy to handle changes in dimensions.

1. Be proactive : ask about potential changes
2. business users + IT
3. strategy for each changing attributes

Kimball introduced SCD in 1995 and distinguished between diffrent types(1,2,3...).


Type 0: Retain original
------------------------------------
There won't be any changes.
Date table(usually static table)
very simple and easy to maintain/update


Type 1: Overwrite
------------------------------------
old attributes are just overwritten.
only current state is reflected.
very simple
no fact table needs to be modified.

  Problem:
  - history is lost
  - insignificant changes
  - might affect/break existing queries
  
  
Type 2: New row
-------------------------------------
Most powerful SCD.
Problem with type 1: no history of dimensions

perfectly partitions history.
changes are reflected with history.

Therefore, whenever we are expecting common changes in our dimensions, this is the default strategy that we can go to and it is so powerful 
that it can partition our history.
here how we gonna find out the currently added products in dim table?


Administrate Type 2 SCD:
-------------------------------
we need to include effective date as well as expiration date.
Period in which values are valid.
Necessary also in ETL to use correct FK
Requires surrogate key instead of natural key.


Type 3: Additional attributes
---------------------------------------
Type 2- default strategy to maintain reflect history
type 1- static
type 3- in-between: switching back and forth between versions
  -instead of adding a row- we add a column
  -typically used for significant changes at a time(e.g. restructuring in organisation)
  
  

DELTA LOAD EXAMPLE:
---------------------------
Delta load is usually done for fact table not for dimension table.

--sometimes we have to load data from source system to destination system based on newly added data.

to do this, we need to find max value of product id which was loaded initially. based on that, we need to add newly added rows from source.

to find max product id, we have to assign this in variable. for this we have, set variable transformation.

then to get those variables, we need to use get variable.


-----------------------------------------
Transformations:
---------------------
Main goal:
create a consolidated view of all data for analysis purposes.
 
  1.Consolidate (from multiple systems)
  2.Reshape (analysis purpose)
  
Basic transformations:
 1.Deduplication:
     sometimes we have duplicate values in table because of integrating data from diffrent source systems. so to remove duplicate from consolidated table is called deduplication.
	 
 2.Filtering rows:
     filter out irrelevant rows.
	 
 3.Cleaning and mapping:
    mapping diffrent values.
	  e.g. gender def in one table(M or F)
	       gener def in another table (MALE or FEMALE)
		   
 4.Value standardization:
    mapping diffrent values
	
 5.Key generation:
    e.g. surrogate key


Advanced transformations:
-------------------------------
  1.joining:
  2.splitting
  3.Aggregation
  
  
Demo: Plan of attack:
-----------------------
1.look at the problem and plan
2.set up table and schema
3.output staging table(+ truncate)
4.Transform and load:
   * reading data from staging
   * transformations(clean and extract)
   * update/insert
   
What if we have no new data rows in the staging? 
=>staging will be empty afterwards & before the next run.

  Empty staging=>max(product_id)==null => Full Load

in order to avoid full load, what we can do is, we can apply max(product_id) logic(set variable) in core layer rather than staging layer.



CASE STUDY: Set up a complete ETL workflow
-------------------------------------------
-------------------------------------------
Plan of attack:
1.Look at the problem and plan
2.Set up tables and schema
3.staging
4.core(dimension table)
5.core (fact table)
6.set up job and testing



