--Identify and handle missing data: PAN numbers may have missing values. 
--These missing values need to be handled appropriately, either by 
--removing rows or imputing values (depending on the context).


-- missing values
SELECT pan_number from pancard_schema.govt_id 
where pan_number is null;

--duplicate values
select pan_number, count(*) from pancard_schema.govt_id 
group by pan_number
having count(*) >1 or pan_number is null;

-- remove null values 
delete from pancard_schema.govt_id 
where pan_number is null;

-- analyze the duplicate and distinct values
select count(*) from pancard_schema.govt_id;
select count(pan_number) from pancard_schema.govt_id ;
select count(distinct pan_number) from pancard_schema.govt_id ;


-- delete duplicate values or null values
delete from pancard_schema.govt_id  
where pan_number in (
 select pan_number, count(*) from pancard_schema.govt_id 
group by pan_number
having count(*) >1 or pan_number is null);

-- remove trailing spaces and ensure every letters should be in upper letter case
select UPPER(TRIM(pan_number)) as pan_number from 
pancard_schema.govt_id;

--- pan format validation
  -- it should 10 character long. 
  select UPPER(TRIM(pan_number)) as pan_number from 
     pancard_schema.govt_id 
     where LEN(UPPER(TRIM(pan_number))) = 10;

  -- first 5 characters should be alphabetic and it should be in upper case




  --format

select * , ROW_NUMBER() OVER( PARTITION BY pan_number order by pan_number) as flag_count 
from pancard_schema.govt_id
where 
pan_number is not null
and 
len(pan_number) =10 and 
pan_number  like '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]' AND 
--adjacent characters cannot be same


--AND
(ASCII(SUBSTRING(pan_number,1,1)) + 1 != ASCII(SUBSTRING(pan_number,2,1)) AND
    ASCII(SUBSTRING(pan_number,2,1)) + 1 != ASCII(SUBSTRING(pan_number,3,1)) AND
    ASCII(SUBSTRING(pan_number,3,1)) + 1 != ASCII(SUBSTRING(pan_number,4,1)) AND
    ASCII(SUBSTRING(pan_number,4,1)) + 1 != ASCII(SUBSTRING(pan_number,5,1))
    )
    AND 
    (ASCII(SUBSTRING(pan_number,1,1)) != ASCII(SUBSTRING(pan_number,2,1)) AND
    ASCII(SUBSTRING(pan_number,2,1)) != ASCII(SUBSTRING(pan_number,3,1)) AND
    ASCII(SUBSTRING(pan_number,3,1)) != ASCII(SUBSTRING(pan_number,4,1)) AND
    ASCII(SUBSTRING(pan_number,4,1)) != ASCII(SUBSTRING(pan_number,5,1))
    )

 AND 
 ASCII(SUBSTRING(pan_number,6,1)) + 1 != ASCII(SUBSTRING(pan_number,7,1)) AND
    ASCII(SUBSTRING(pan_number,7,1)) + 1 != ASCII(SUBSTRING(pan_number,8,1)) AND
    ASCII(SUBSTRING(pan_number,8,1)) + 1 != ASCII(SUBSTRING(pan_number,9,1))
    and 
    CAST(SUBSTRING(pan_number,6,1) AS INT) != CAST(SUBSTRING(pan_number,7,1) AS INT)
    and 
        CAST(SUBSTRING(pan_number,7,1) AS INT) != CAST(SUBSTRING(pan_number,8,1) AS INT)
        and
            CAST(SUBSTRING(pan_number,8,1) AS INT) != CAST(SUBSTRING(pan_number,9,1) AS INT)  --2295
   and 
       CAST(SUBSTRING(pan_number,6,1) AS INT) +1 != CAST(SUBSTRING(pan_number,7,1) AS INT)
    and 
        CAST(SUBSTRING(pan_number,7,1) AS INT) + 1 != CAST(SUBSTRING(pan_number,8,1) AS INT)
        and
            CAST(SUBSTRING(pan_number,8,1) AS INT) + 1 != CAST(SUBSTRING(pan_number,9,1) AS INT)

group by pan_number;
     

--CORRECT RESULT-3186
select pan_number from pancard_schema.transformed_govt_id
where pan_number is not null or pan_number = ''; -- 7025

select count(pan_number) from pancard_schema.transformed_govt_id;

select distinct pan_number, left(pan_number,5) as first_five, SUBSTRING(pan_number, 6,4) as integer_char,
RIGHT(pan_number,1) as last_char from pancard_schema.transformed_govt_id
where 
PAN_NUMBER  LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]'  --4999
AND 
    (CAST(SUBSTRING(pan_number,6,1) AS INT) != CAST(SUBSTRING(pan_number,7,1) AS INT)
    and 
        CAST(SUBSTRING(pan_number,7,1) AS INT) != CAST(SUBSTRING(pan_number,8,1) AS INT)
        and
            CAST(SUBSTRING(pan_number,8,1) AS INT) != CAST(SUBSTRING(pan_number,9,1) AS INT) 
            )
 AND 
    (ASCII(SUBSTRING(pan_number,1,1)) != ASCII(SUBSTRING(pan_number,2,1)) AND
    ASCII(SUBSTRING(pan_number,2,1)) != ASCII(SUBSTRING(pan_number,3,1)) AND
    ASCII(SUBSTRING(pan_number,3,1)) != ASCII(SUBSTRING(pan_number,4,1)) AND
    ASCII(SUBSTRING(pan_number,4,1)) != ASCII(SUBSTRING(pan_number,5,1))
    )
    and 
    (ASCII(SUBSTRING(pan_number,1,1)) + 1 != ASCII(SUBSTRING(pan_number,2,1)) AND
    ASCII(SUBSTRING(pan_number,2,1)) + 1 != ASCII(SUBSTRING(pan_number,3,1)) AND
    ASCII(SUBSTRING(pan_number,3,1)) + 1 != ASCII(SUBSTRING(pan_number,4,1)) AND
    ASCII(SUBSTRING(pan_number,4,1)) + 1 != ASCII(SUBSTRING(pan_number,5,1))
    )
;
select pan_number from pancard_schema.transformed_govt_id
where 
 ASCII(SUBSTRING(pan_number,1,1)) + 1 != ASCII(SUBSTRING(pan_number,2,1)) AND
    ASCII(SUBSTRING(pan_number,2,1)) + 1 != ASCII(SUBSTRING(pan_number,3,1)) AND
    ASCII(SUBSTRING(pan_number,3,1)) + 1 != ASCII(SUBSTRING(pan_number,4,1)) AND
    ASCII(SUBSTRING(pan_number,4,1)) + 1 != ASCII(SUBSTRING(pan_number,5,1))
  

SELECT * FROM (  

SELECT pan_number,SUBSTRING(pan_number, 6,4) as integer_char,
       CASE 
            WHEN ASCII(SUBSTRING(pan_number,6,1)) + 1 = ASCII(SUBSTRING(pan_number,7,1))
             AND ASCII(SUBSTRING(pan_number,7,1)) + 1 = ASCII(SUBSTRING(pan_number,8,1))
             AND ASCII(SUBSTRING(pan_number,8,1)) + 1 = ASCII(SUBSTRING(pan_number,9,1))
            THEN 'SEQUENTIAL'
            ELSE 'NON-SEQUENTIAL'
            END AS IS_SEQUENTIAL
       ,
       CASE WHEN ASCII(SUBSTRING(pan_number,6,1)) != ASCII(SUBSTRING(pan_number,7,1)) AND
                    ASCII(SUBSTRING(pan_number,7,1)) != ASCII(SUBSTRING(pan_number,8,1)) AND
                    ASCII(SUBSTRING(pan_number,8,1)) != ASCII(SUBSTRING(pan_number,9,1))
                    THEN 'NO_REPEAT'
                    ELSE 'REPEATATIVE'
                    END AS IS_REPEATATIVE
        from pancard_schema.transformed_govt_id
        ) T
       
       WHERE IS_SEQUENTIAL = 'SEQUENTIAL' OR IS_REPEATATIVE = 'REPEATATIVE'
UNION
select * from (
SELECT pan_number,SUBSTRING(pan_number, 1,5) as five_char,
       CASE 
            WHEN ASCII(SUBSTRING(pan_number,1,1)) + 1 = ASCII(SUBSTRING(pan_number,2,1))
             AND ASCII(SUBSTRING(pan_number,2,1)) + 1 = ASCII(SUBSTRING(pan_number,3,1))
             AND ASCII(SUBSTRING(pan_number,3,1)) + 1 = ASCII(SUBSTRING(pan_number,4,1))
             AND ASCII(SUBSTRING(pan_number,4,1)) + 1 = ASCII(SUBSTRING(pan_number,5,1))
            THEN 'SEQUENTIAL'
            ELSE 'NON-SEQUENTIAL'
            END AS IS_SEQUENTIAL
       ,
       CASE WHEN ASCII(SUBSTRING(pan_number,1,1)) != ASCII(SUBSTRING(pan_number,2,1)) AND
                    ASCII(SUBSTRING(pan_number,2,1)) != ASCII(SUBSTRING(pan_number,3,1)) AND
                    ASCII(SUBSTRING(pan_number,3,1)) != ASCII(SUBSTRING(pan_number,4,1))
                    AND ASCII(SUBSTRING(pan_number,4,1)) != ASCII(SUBSTRING(pan_number,5,1))
                    THEN 'NO_REPEAT'
                    ELSE 'REPEATATIVE'
                    END AS IS_REPEATATIVE
        from pancard_schema.transformed_govt_id
        ) t
        where IS_SEQUENTIAL ='SEQUENTIAL' --
;

