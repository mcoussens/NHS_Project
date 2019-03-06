/********************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************
CLEANING THE DATA
*********************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************/
use Project
go
/**************************************************
Drop new tables if they exist
**************************************************/
IF OBJECT_ID('Unbundled_prices_17_18') IS NOT NULL
	DROP TABLE [Unbundled_prices_17_18] 
GO

IF OBJECT_ID('Unbundled_prices_18_19') IS NOT NULL
	DROP TABLE [Unbundled_prices_18_19] 
GO

IF OBJECT_ID('A_and_E_17_18') IS NOT NULL
	DROP TABLE [A_and_E_17_18]
GO

IF OBJECT_ID('A_and_E_18_19') IS NOT NULL
	DROP TABLE [A_and_E_18_19]
GO

IF OBJECT_ID('APC_OPROC_17_18') IS NOT NULL
	DROP TABLE [APC_OPROC_17_18]
GO

IF OBJECT_ID('APC_OPROC_18_19') IS NOT NULL
	DROP TABLE [APC_OPROC_18_19]
GO

IF OBJECT_ID('Unbundled_HRG_List') IS NOT NULL
	DROP TABLE [Unbundled_HRG_List]
GO

IF OBJECT_ID('Outpatients_17_18') IS NOT NULL
	DROP TABLE [Outpatients_17_18]
GO

IF OBJECT_ID('Outpatients_18_19') IS NOT NULL
	DROP TABLE [Outpatients_18_19] 
GO
/********************************************************************************************************************************************************************
Cleaning Tariff Tables
*********************************************************************************************************************************************************************/
-- [stage].[4b Unbundled prices 17.18]
CREATE TABLE dbo.[Unbundled_prices_17_18]
(
	 HRG_Code varchar(5)
	,HRG_Name varchar(50)
	,Tariff money
	,Reporting money
)

INSERT INTO dbo.[Unbundled_prices_17_18]
(
	 HRG_Code
	,HRG_Name
	,Tariff
	,Reporting
)
(SELECT
	 cast([HRG code] as varchar(5))
	,cast([HRG name] as varchar(50))
	,cast([Tariff (including cost of reporting) (£)] as money)
	,cast([Cost of reporting_(£)] as money)
FROM stage.[4b Unbundled prices 17.18])

-- [stage].[4c Unbundled prices 18.19]
CREATE TABLE dbo.[Unbundled_prices_18_19]
(
	 HRG_Code varchar(5)
	,HRG_Name varchar(50)
	,Tariff money
	,Reporting money
)

INSERT INTO dbo.[Unbundled_prices_18_19]
(
	 HRG_Code
	,HRG_Name
	,Tariff
	,Reporting
)
(SELECT
	 cast([HRG code] as varchar(5))
	,cast([HRG name] as varchar(50))
	,cast([Tariff (including cost of reporting) (£)] as money)
	,cast([Cost of reporting_(£)] as money)
FROM stage.[4c Unbundled prices 18.19])

-- [stage].[A&E_17-18]
CREATE TABLE dbo.[A_and_E_17_18]
(
	 HRG_Code varchar(5)
	,HRG_Name varchar(50)
	,Tariff_Type_1_and_2_Departments money
	,Tariff_Type_3_Departments money
)

INSERT INTO dbo.[A_and_E_17_18]
(
	 HRG_Code
	,HRG_Name
	,Tariff_Type_1_and_2_Departments
	,Tariff_Type_3_Departments
)
(SELECT
	 cast([HRG code] as varchar(5))
	,cast([HRG name] as varchar(50))
	,cast([Type 1 and 2 Departments] as money)
	,cast([Type 3 Departments] as money)
FROM stage.[A&E_17-18])

-- [stage].[A&E_18-19]
CREATE TABLE dbo.[A_and_E_18_19]
(
	 HRG_Code varchar(5)
	,HRG_Name varchar(50)
	,Tariff_Type_1_and_2_Departments money
	,Tariff_Type_3_Departments money
)
INSERT INTO dbo.[A_and_E_18_19]
(
	 HRG_Code
	,HRG_Name
	,Tariff_Type_1_and_2_Departments
	,Tariff_Type_3_Departments
)
(SELECT
	 cast([HRG code] as varchar(5))
	,cast([HRG name] as varchar(50))
	,cast([Type 1 and 2 Departments] as money)
	,cast([Type 3 Departments] as money)
FROM stage.[A&E_18-19])

-- [stage].[APC_OPROC_17-18]
CREATE TABLE dbo.[APC_OPROC_17_18]
(
	 HRG_Code varchar(5)
	,HRG_Name varchar(50)
	,Outpatient_Procedure_Tariff money
	,Day_Case_Spell_Tariff money
	,Ordinary_Elective_Spell_Tariff money
	,Nonelective_Spell_Tariff money
	,Nonelective_longstay_trim_point int
	,Elective_longstay_trim_point int
	,Long_Stay_Payment money
	,Reduced_Shortstay_Emergency_Tariff money
)

INSERT INTO dbo.[APC_OPROC_17_18]
(
	 HRG_Code
	,HRG_Name
	,Outpatient_Procedure_Tariff
	,Day_Case_Spell_Tariff
	,Ordinary_Elective_Spell_Tariff
	,Nonelective_Spell_Tariff
	,Nonelective_longstay_trim_point
	,Elective_longstay_trim_point
	,Long_Stay_Payment
	,Reduced_Shortstay_Emergency_Tariff
)
(SELECT
	 cast([HRG code] as varchar(5))
	,cast([HRG name] as varchar(50))
	,cast(REPLACE(REPLACE([Outpatient procedure tariff (£)],'-','0'),',','') as money)
	,
	case
		when[Day case spell tariff (£)] like '-' or [Day case spell tariff (£)] is null then cast(REPLACE(REPLACE([Combined day case / ordinary elective spell tariff (£)],'-','0'),',','')as money)
		else cast(REPLACE(REPLACE([Day case spell tariff (£)],'-','0'),',','')as money)
	end
	
	
	,
	case
		when[Ordinary elective spell tariff (£)] like '-' or [Ordinary elective spell tariff (£)] is null then cast(REPLACE(REPLACE([Combined day case / ordinary elective spell tariff (£)],'-','0'),',','')as money)
		else cast(REPLACE(REPLACE([Ordinary elective spell tariff (£)],'-','0'),',','')as money)
	end
	
	
	,cast(REPLACE(REPLACE([Non-elective spell tariff (£)],'-','0'),',','') as money)
	,cast([Non-elective long stay trim point (days)] as int)
	,cast([Ordinary elective long stay trim point (days)]as int)
	,cast(REPLACE(REPLACE([Per day long stay payment (for days exceeding trim point) (£)],'-','0'),',','') as money)
	,cast(REPLACE(REPLACE([Reduced short stay emergency tariff (£)],'-','0'),',','') as money)
FROM stage.[APC_OPROC_17-18])

-- [stage].[APC_OPROC_18-19]
CREATE TABLE dbo.[APC_OPROC_18_19]
(
	 HRG_Code varchar(5)
	,HRG_Name varchar(50)
	,Outpatient_Procedure_Tariff money
	,Day_Case_Spell_Tariff money
	,Ordinary_Elective_Spell_Tariff money
	,Nonelective_Spell_Tariff money
	,Nonelective_longstay_trim_point int
	,Elective_longstay_trim_point int
	,Long_Stay_Payment money
	,Reduced_Shortstay_Emergency_Tariff money
)

INSERT INTO dbo.[APC_OPROC_18_19]
(
	 HRG_Code
	,HRG_Name
	,Outpatient_Procedure_Tariff
	,Day_Case_Spell_Tariff
	,Ordinary_Elective_Spell_Tariff
	,Nonelective_Spell_Tariff
	,Nonelective_longstay_trim_point
	,Elective_longstay_trim_point
	,Long_Stay_Payment
	,Reduced_Shortstay_Emergency_Tariff
)
(SELECT
	 cast([HRG code] as varchar(5))
	,cast([HRG name] as varchar(50))
	,cast(REPLACE(REPLACE([Outpatient procedure tariff (£)],'-','0'),',','') as money)
	,
	case
		when[Day case spell tariff (£)] like '-' or [Day case spell tariff (£)] is null then cast(REPLACE(REPLACE([Combined day case / ordinary elective spell tariff (£)],'-','0'),',','')as money)
		else cast(REPLACE(REPLACE([Day case spell tariff (£)],'-','0'),',','')as money)
	end
	
	
	,
	case
		when[Ordinary elective spell tariff (£)] like '-' or [Ordinary elective spell tariff (£)] is null then cast(REPLACE(REPLACE([Combined day case / ordinary elective spell tariff (£)],'-','0'),',','')as money)
		else cast(REPLACE(REPLACE([Ordinary elective spell tariff (£)],'-','0'),',','')as money)
	end
	
	
	,cast(REPLACE(REPLACE([Non-elective spell tariff (£)],'-','0'),',','') as money)
	,cast([Non-elective long stay trim point (days)] as int)
	,cast([Ordinary elective long stay trim point (days)]as int)
	,cast(REPLACE(REPLACE([Per day long stay payment (for days exceeding trim point) (£)],'-','0'),',','') as money)
	,cast(REPLACE(REPLACE([Reduced short stay emergency tariff (£)],'-','0'),',','') as money)
FROM stage.[APC_OPROC_18-19])

-- [stage].[Outpatients_17-18]
CREATE TABLE dbo.[Outpatients_17_18]
(
	 Treatment_Function_Code varchar(5)
	,Treatment_Function_Description varchar(50)
	,FirstAttendance_SingleProfessional_Tariff money
	,FirstAttendance_MultiProfessional_Tariff money
	,FollowUpAttendance_SingleProfessional_Tariff money
	,FollowUpAttendance_MultiProfessional_Tariff money
)
INSERT INTO dbo.[Outpatients_17_18]
(
	 Treatment_Function_Code
	,Treatment_Function_Description
	,FirstAttendance_SingleProfessional_Tariff
	,FirstAttendance_MultiProfessional_Tariff
	,FollowUpAttendance_SingleProfessional_Tariff
	,FollowUpAttendance_MultiProfessional_Tariff
)
(SELECT
	 cast([Treatment function code] as varchar(5))
	,cast([Treatment function description ] as varchar (50))
	,cast([WF01B_First Attendance - Single Professional] as money)
	,cast([WF02B_First Attendance - Multi Professional] as money)
	,cast([WF01A_Follow Up Attendance - Single Professional] as money)
	,cast([WF02A_Follow Up Attendance - Multi Professional] as money)
FROM stage.[Outpatients_17-18])

-- [stage].[Outpatients_18-19]
CREATE TABLE dbo.[Outpatients_18_19]
(
	 Treatment_Function_Code varchar(5)
	,Treatment_Function_Description varchar(50)
	,FirstAttendance_SingleProfessional_Tariff money
	,FirstAttendance_MultiProfessional_Tariff money
	,FollowUpAttendance_SingleProfessional_Tariff money
	,FollowUpAttendance_MultiProfessional_Tariff money
)
INSERT INTO dbo.[Outpatients_18_19]
(
	 Treatment_Function_Code
	,Treatment_Function_Description
	,FirstAttendance_SingleProfessional_Tariff
	,FirstAttendance_MultiProfessional_Tariff
	,FollowUpAttendance_SingleProfessional_Tariff
	,FollowUpAttendance_MultiProfessional_Tariff
)
(SELECT
	 cast([Treatment function code] as varchar(5))
	,cast([Treatment function description ] as varchar (50))
	,cast([WF01B_First Attendance - Single Professional] as money)
	,cast([WF02B_First Attendance - Multi Professional] as money)
	,cast([WF01A_Follow Up Attendance - Single Professional] as money)
	,cast([WF02A_Follow Up Attendance - Multi Professional] as money)
FROM stage.[Outpatients_18-19])
go
/********************************************************************************************************************************************************************
Cleaning Input HES Data
*********************************************************************************************************************************************************************/
IF OBJECT_ID('HES_Records') IS NOT NULL
	DROP TABLE [HES_Records] 
GO

-- [stage].[HRG_and_HSe]
CREATE TABLE dbo.[HES_Records]
(
	 ID int identity Primary Key
	,[spell] int
    ,[episode] int
    ,[epistart] date
    ,[epiend] date
    ,[epitype] varchar(5)
    ,[sex] varchar(5)
    ,[bedyear] int
    ,[epidur] int
    ,[epistat] varchar (5)
    ,[spellbgin] varchar(5)
    ,[activage] int
    ,[admiage] int
    ,[admincat] varchar(5)
    ,[admincatst] varchar(5)
    ,[category] varchar(5)
    ,[dob] date
    ,[endage] int
    ,[ethnos] varchar(5)
    ,[hesid] varchar(15)
    ,[leglcat] varchar (5)
    ,[lopatid] varchar(15)
    ,[newnhsno] varchar(15)
    ,[newnhsno_check] varchar(5)
    ,[startage] int
    ,[admistart] date
    ,[admimeth] varchar(5)
    ,[admisorc] varchar(5)
    ,[elecdate] date
    ,[elecdur] int
    ,[elecdur_calc] int
    ,[classpat] varchar(5)
    ,[diag_01] varchar(10)
    ,[numepisodesinspell] int
    ,[HRG_code] varchar(5)
)
INSERT INTO dbo.[HES_Records]
(
	 [spell]
    ,[episode]
    ,[epistart]
    ,[epiend]
    ,[epitype]
    ,[sex]
    ,[bedyear]
    ,[epidur]
    ,[epistat]
    ,[spellbgin]
    ,[activage]
    ,[admiage]
    ,[admincat]
    ,[admincatst]
    ,[category]
    ,[dob]
    ,[endage]
    ,[ethnos]
    ,[hesid]
    ,[leglcat]
    ,[lopatid]
    ,[newnhsno]
    ,[newnhsno_check]
    ,[startage]
    ,[admistart]
    ,[admimeth]
    ,[admisorc]
    ,[elecdate]
    ,[elecdur]
    ,[elecdur_calc]
    ,[classpat]
    ,[diag_01]
    ,[numepisodesinspell]
    ,[HRG_code]
)
(SELECT
	 CAST([spell] as int)
    ,CAST([episode] as int)
    ,CAST([epistart] as date)
    ,CAST([epiend] as date)
    ,CAST([epitype] as varchar(5))
    ,CAST([sex] as varchar(5))
    ,CAST([bedyear] as int)
    ,CAST([epidur] as int)
    ,CAST([epistat] as varchar (5))
    ,CAST([spellbgin] as varchar(5))
    ,CAST([activage] as int)
    ,CAST([admiage] as int)
    ,CAST([admincat] as varchar(5))
    ,CAST([admincatst] as varchar(5))
    ,CAST([category] as varchar(5))
    ,CAST([dob] as date)
    ,CAST([endage] as int)
    ,CAST([ethnos] as varchar(5))
    ,CAST([hesid] as varchar(15))
    ,CAST([leglcat] as varchar (5))
    ,CAST([lopatid] as varchar(15))
    ,CAST([newnhsno] as varchar(15))
    ,CAST([newnhsno_check] as varchar(5))
    ,CAST([startage] as int)
    ,CAST([admistart] as date)
    ,CAST([admimeth] as varchar(5))
    ,CAST([admisorc] as varchar(5))
    ,CAST([elecdate] as date)
    ,CAST([elecdur] as int)
    ,CAST([elecdur_calc] as int)
    ,CAST([classpat] as varchar(5))
    ,CAST([diag_01] as varchar(10))
    ,CAST([numepisodesinspell] as int)
    ,CAST([HRG_code] as varchar(5))
FROM stage.[HRG_and_HSe])
go
/********************************************************************************************************************************************************************
Cleaning HRG Chapter and Subchapter Info and combinging for a fact table
*********************************************************************************************************************************************************************/
-- create fact table
IF OBJECT_ID('Fact_HRG') IS NOT NULL
	DROP TABLE [Fact_HRG] 
GO

CREATE TABLE dbo.[Fact_HRG]
(
	 HRG_Code varchar(10)
	,HRG_Description varchar (200)
	,HRG_Subchapter varchar(10)
	,Subchapter_Description varchar(200)
	,HRG_Chapter varchar(10)
	,Chapter_Description varchar(200)
)



-- join other tables and add them to HRG fact table.

INSERT INTO dbo.Fact_HRG 
(
	 HRG_Code
	,HRG_Description
	,HRG_Subchapter
	,Subchapter_Description
	,HRG_Chapter
	,Chapter_Description
)
(SELECT
	 id.HRG
	,id.[HRG Description - Including Split]
	,sc.[HRG Subchapter]
	,sc.[HRG Subchapter Description]
	,c.[HRG Chapter]
	,c.[HRG Chapter Description]
FROM stage.[HRG_codes] id
LEFT JOIN stage.HRG_Subchapter sc
	ON left(id.HRG,2) = sc.[HRG Subchapter]
LEFT JOIN stage.HRG_Chapter c
	ON  left(id.HRG,1) = c.[HRG Chapter]
)

/********************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************
PART 1 -  creation of stored procedures and functions for each of the years of tariff (last 2 years) to calculate the tariff chargeable for the episode.
*********************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************/

/********************************************************************************
17/18 function
********************************************************************************/
USE Project
GO
-- Dropping procedure if it already exists.
IF OBJECT_ID('dbo.[FN_17_to_18]') IS NOT NULL
	DROP FUNCTION dbo.[FN_17_to_18] 
GO				
-- Creating prcedure that returns costs from dummy data
CREATE FUNCTION dbo.[FN_17_to_18] (@ID nvarchar(50))
RETURNS money
as
BEGIN
DECLARE @total money

SELECT @total = CASE
					WHEN b.RSET = 0 THEN b.OPT + b.DCST + b.OEST + b.NEST + b.LSP
				ELSE  b.RSET
				END
FROM	(SELECT
			-- Calculating whether the outpatient procedure tarrif is applicable
				 CASE
	 				 WHEN a.CLASSPAT <> 1 AND a.EPIDUR = 1 THEN a.opt
	 				 ELSE 0
				 END AS OPT
			-- Calculating day case spell tarrif
				,CASE
					WHEN a.ADMIMETH LIKE '1%' and a.CLASSPAT = 2 THEN a.dcst
					ELSE 0
				 END AS DCST
			-- Calculating ordinary elective spell tarriff
				,CASE
					WHEN a.ADMIMETH LIKE '1%' AND a.CLASSPAT = 1 THEN a.oest
					ELSE 0
				 END AS OEST
			-- Calculating non elective spell tarrif
				,CASE
					WHEN a.ADMIMETH LIKE '2%' THEN a.nest
					ELSE 0
				 END AS NEST
			-- Calculating long stay payment
				,CASE
					WHEN a.ADMIMETH LIKE '1%' AND a.EPIDUR > a.oelstp THEN (a.EPIDUR - a.oelstp) * a.pdlsp
					WHEN a.ADMIMETH LIKE '2%' and a.EPIDUR > a.nelstp THEN (a.EPIDUR - a.nelstp) * a.pdlsp
					ELSE 0
				 END AS LSP
			-- Calculating the reduced short stay emergency tariff
				,CASE 
					WHEN a.ADMIAGE>18 and a.EPIDUR <2 and a.rset>0 and a.ADMIMETH like '2%' THEN a.rset	
					else 0
				END AS RSET --calculates if the reduced tarriff applies, if not, set to 0

			FROM
			--Joining all data required for calculation together and nesting it so that it can be called in the calculation
							(SELECT 
								 a.ADMIMETH as ADMIMETH
								,a.EPIDUR as EPIDUR
								,a.HRG_code as HRG_CODE
								,a.CLASSPAT as CLASSPAT
								,a.admiage as ADMIAGE
								,b.[Outpatient_Procedure_Tariff] as opt
								,b.[Day_Case_Spell_Tariff] as dcst
								,b.[Ordinary_Elective_Spell_Tariff] as oest
								,b.[Elective_longstay_trim_point] as oelstp
								,b.[Nonelective_Spell_Tariff] as nest
								,b.[Nonelective_longstay_trim_point] as nelstp
								,b.[Long_Stay_Payment] as pdlsp
								,b.Reduced_Shortstay_Emergency_Tariff as rset
							FROM dbo.HES_Records a
							inner join dbo.APC_OPROC_17_18 b
								on a.HRG_code = b.HRG_Code
							where ID = @ID) as a
							) b
return @total

END


GO

/********************************************************************************
18/19 function
********************************************************************************/
USE Project
GO
-- Dropping procedure if it already exists.
IF OBJECT_ID('dbo.[FN_18_to_19]') IS NOT NULL
	DROP FUNCTION dbo.[FN_18_to_19] 
GO				
-- Creating prcedure that returns costs from dummy data
CREATE FUNCTION dbo.[FN_18_to_19] (@ID nvarchar(50))
RETURNS money
as
BEGIN
DECLARE @total money

SELECT @total = CASE
					WHEN b.RSET = 0 THEN b.OPT + b.DCST + b.OEST + b.NEST + b.LSP
				ELSE  b.RSET
				END
FROM	(SELECT
			-- Calculating whether the outpatient procedure tarrif is applicable
				 CASE
	 				 WHEN a.CLASSPAT <> 1 AND a.EPIDUR = 1 THEN a.opt
	 				 ELSE 0
				 END AS OPT
			-- Calculating day case spell tarrif
				,CASE
					WHEN a.ADMIMETH LIKE '1%' and a.CLASSPAT = 2 THEN a.dcst
					ELSE 0
				 END AS DCST
			-- Calculating ordinary elective spell tarriff
				,CASE
					WHEN a.ADMIMETH LIKE '1%' AND a.CLASSPAT = 1 THEN a.oest
					ELSE 0
				 END AS OEST
			-- Calculating non elective spell tarrif
				,CASE
					WHEN a.ADMIMETH LIKE '2%' THEN a.nest
					ELSE 0
				 END AS NEST
			-- Calculating long stay payment
				,CASE
					WHEN a.ADMIMETH LIKE '1%' AND a.EPIDUR > a.oelstp THEN (a.EPIDUR - a.oelstp) * a.pdlsp
					WHEN a.ADMIMETH LIKE '2%' and a.EPIDUR > a.nelstp THEN (a.EPIDUR - a.nelstp) * a.pdlsp
					ELSE 0
				 END AS LSP
			-- Calculating the reduced short stay emergency tariff
				,CASE 
					WHEN a.ADMIAGE>18 and a.EPIDUR <2 and a.rset>0 and a.ADMIMETH like '2%' THEN a.rset	
					else 0
				END AS RSET --calculates if the reduced tarriff applies, if not, set to 0

			FROM
			--Joining all data required for calculation together and nesting it so that it can be called in the calculation
							(SELECT 
								 a.ADMIMETH as ADMIMETH
								,a.EPIDUR as EPIDUR
								,a.HRG_code as HRG_CODE
								,a.CLASSPAT as CLASSPAT
								,a.admiage as ADMIAGE
								,b.[Outpatient_Procedure_Tariff] as opt
								,b.[Day_Case_Spell_Tariff] as dcst
								,b.[Ordinary_Elective_Spell_Tariff] as oest
								,b.[Elective_longstay_trim_point] as oelstp
								,b.[Nonelective_Spell_Tariff] as nest
								,b.[Nonelective_longstay_trim_point] as nelstp
								,b.[Long_Stay_Payment] as pdlsp
								,b.Reduced_Shortstay_Emergency_Tariff as rset
							FROM dbo.HES_Records a
							inner join dbo.APC_OPROC_18_19 b
								on a.HRG_code = b.HRG_Code
							where ID = @ID) as a
							) b
return @total

END


GO

/********************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************
Part 2 - Analysis of HRG change by last 2 tariff years using Admitted Patient and Outpatient.
*********************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************/

use Project
go
/********************************************************************************************************************************************************************
Dropping the tables and views created in this code if they already exist
********************************************************************************************************************************************************************/
--18-19 table
IF OBJECT_ID('fact_18_19') IS NOT NULL
	DROP Table dbo.fact_18_19
GO
--17-18 table
IF OBJECT_ID('fact_17_18') IS NOT NULL
	DROP Table dbo.fact_17_18
GO
IF OBJECT_ID('vw_pricechange') IS NOT NULL
	DROP VIEW dbo.vw_pricechange
GO
/********************************************************************************************************************************************************************
18-19 Table
********************************************************************************************************************************************************************/
--adding the results of the unioned tables into one big table
SELECT 
	 *
INTO dbo.fact_18_19
FROM
(--4c Unbundled prices 18.19
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Tariff' as [Cost Type]
	,[Tariff] as [Price]
FROM dbo.Unbundled_prices_18_19
WHERE HRG_Code <= 'RN51Z'
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Cost of Reporting' as [Cost Type]
	,[Reporting] as [Price]
FROM dbo.Unbundled_prices_18_19
WHERE HRG_Code <= 'RN51Z'

--3b A&E 18.19
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Type 3 Department Tariff' as [Cost Type]
	,[Tariff_Type_3_Departments] as [Price]
FROM [dbo].[A_and_E_18_19]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Type 1 and 2 Department Tariff' as [Cost Type]
	,[Tariff_Type_1_and_2_Departments] as [Price] 
FROM [dbo].[A_and_E_18_19]
--2b Outpatients 18.19 COMMENTED OUT AS INITIAL ANALYSIS SHOWS THAT THERE IS NO CHANGE IN ANY OF THESE COSTS
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'First Attendance Single Professional' as [Cost Type]
--	,[WF01B_First Attendance - Single Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter] 
--FROM stage.[Outpatients_18-19]
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'First Attendance Multi Professional' as [Cost Type]
--	,[WF02B_First Attendance - Multi Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter] 
--FROM stage.[Outpatients_18-19]
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'Follow Up Attendance Single Professional' as [Cost Type]
--	,[WF01A_Follow Up Attendance - Single Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter]
--FROM stage.[Outpatients_18-19]
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'Follow Up Attendance Multi Professional' as [Cost Type]
--	,[WF02A_Follow Up Attendance - Multi Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter] 
--FROM stage.[Outpatients_18-19]
--1b APC & OPROC 18.19
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Outpatient Procedure Tariff' as [Cost Type]
	,[Outpatient_Procedure_Tariff] as [Price]
FROM [dbo].[APC_OPROC_18_19]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Day case spell tariff' as [Cost Type]
	,[Day_Case_Spell_Tariff] as [Price]
FROM [dbo].[APC_OPROC_18_19]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Ordinary elective spell tariff' as [Cost Type]
	,[Ordinary_Elective_Spell_Tariff] as [Price]
FROM [dbo].[APC_OPROC_18_19]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Non-elective spell tariff' as [Cost Type]
	,[Nonelective_Spell_Tariff] as [Price]
FROM [dbo].[APC_OPROC_18_19]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Per day long stay payment' as [Cost Type]
	,[Long_Stay_Payment] as [Price]
FROM [dbo].[APC_OPROC_18_19]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Reduced short stay emergency tariff' as [Cost Type]
	,[Reduced_Shortstay_Emergency_Tariff] as [Price]
FROM [dbo].[APC_OPROC_18_19]) a
ORDER BY a.[HRG/Treatment Function Code]
go
/********************************************************************************************************************************************************************
17-18 Table
********************************************************************************************************************************************************************/
--adding the results of the unioned tables into one big table

SELECT 
	 *
INTO dbo.fact_17_18
FROM
(--4c Unbundled prices 17.18
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Tariff' as [Cost Type]
	,[Tariff] as [Price]
FROM dbo.Unbundled_prices_17_18
WHERE HRG_Code <= 'RN51Z'
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Cost of Reporting' as [Cost Type]
	,[Reporting] as [Price]
FROM dbo.Unbundled_prices_17_18
WHERE HRG_Code <= 'RN51Z'

--3b A&E 17.18
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Type 3 Department Tariff' as [Cost Type]
	,[Tariff_Type_3_Departments] as [Price]
FROM [dbo].[A_and_E_17_18]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Type 1 and 2 Department Tariff' as [Cost Type]
	,[Tariff_Type_1_and_2_Departments] as [Price] 
FROM [dbo].[A_and_E_17_18]
--2b Outpatients 17.18 COMMENTED OUT AS INITIAL ANALYSIS SHOWS THAT THERE IS NO CHANGE IN ANY OF THESE COSTS
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'First Attendance Single Professional' as [Cost Type]
--	,[WF01B_First Attendance - Single Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter] 
--FROM stage.[Outpatients_18-19]
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'First Attendance Multi Professional' as [Cost Type]
--	,[WF02B_First Attendance - Multi Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter] 
--FROM stage.[Outpatients_18-19]
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'Follow Up Attendance Single Professional' as [Cost Type]
--	,[WF01A_Follow Up Attendance - Single Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter]
--FROM stage.[Outpatients_18-19]
--UNION ALL
--SELECT
--	 cast([Treatment function code] as NVARCHAR(50)) as [HRG/Treatment Function Code]
--	,'Follow Up Attendance Multi Professional' as [Cost Type]
--	,[WF02A_Follow Up Attendance - Multi Professional] as [Price]
--	,LEFT(HRG_Code,1) as [HRG Chapter]
--	,LEFT(HRG_Code, 2) as [HRG Subchapter] 
--FROM stage.[Outpatients_18-19]
--1b APC & OPROC 17.18
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Outpatient Procedure Tariff' as [Cost Type]
	,[Outpatient_Procedure_Tariff] as [Price]
FROM [dbo].[APC_OPROC_17_18]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Day case spell tariff' as [Cost Type]
	,[Day_Case_Spell_Tariff] as [Price]
FROM [dbo].[APC_OPROC_17_18]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Ordinary elective spell tariff' as [Cost Type]
	,[Ordinary_Elective_Spell_Tariff] as [Price]
FROM [dbo].[APC_OPROC_17_18]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Non-elective spell tariff' as [Cost Type]
	,[Nonelective_Spell_Tariff] as [Price]
FROM [dbo].[APC_OPROC_17_18]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Per day long stay payment' as [Cost Type]
	,[Long_Stay_Payment] as [Price]
FROM [dbo].[APC_OPROC_17_18]
UNION ALL
SELECT
	 HRG_Code as [HRG/Treatment Function Code]
	,'Reduced short stay emergency tariff' as [Cost Type]
	,[Reduced_Shortstay_Emergency_Tariff] as [Price]
FROM [dbo].[APC_OPROC_17_18]) a
ORDER BY a.[HRG/Treatment Function Code]
go
/********************************************************************************************************************************************************************
Adding matching unique IDs to both tables so that they can be joined in the future.
********************************************************************************************************************************************************************/
--18-19 table
alter table dbo.fact_18_19
add ID int identity(1,1)

--17-18 table
alter table dbo.fact_17_18
add ID int identity(1,1)
go
/********************************************************************************************************************************************************************
Joining tables together and adding a column to represent the percent change between the years. Results stored in a view.
********************************************************************************************************************************************************************/
CREATE VIEW dbo.vw_pricechange AS
SELECT
	 f1.[HRG/Treatment Function Code] as [HRG/Treatment Function Code]
	,c.HRG_Description
	,c.HRG_Subchapter
	,c.Subchapter_Description
	,c.HRG_Chapter
	,c.Chapter_Description
	,f1.[Cost Type] as [Cost Type]
	,f1.Price as [17/18 Price]
	,f2.Price as [18/19 Price]
	,((f2.Price / NULLIF(f1.Price,0)) - 1) * 100 as [Percent Change in Price]
FROM dbo.fact_17_18 f1
FULL OUTER JOIN dbo.fact_18_19 f2
	on f1.[HRG/Treatment Function Code] = f2.[HRG/Treatment Function Code] and f1.[Cost Type] = f2.[Cost Type]
LEFT OUTER JOIN dbo.Fact_HRG c
	on f1.[HRG/Treatment Function Code] = c.[HRG_Code]
where f1.[Cost Type] like 'Day case spell tariff' 
or f1.[Cost Type] like 'Non-elective spell tariff' 
or f1.[Cost Type] like 'Ordinary elective spell tariff' 
or f1.[Cost Type] like 'Outpatient procedure tariff' 
or f1.[Cost Type] like 'Per day long stay payment' 
or f1.[Cost Type] like 'Reduced short stay emergency tariff'
go


/********************************************************************************************************************************************************************************
*********************************************************************************************************************************************************************************
Part 3 -  Analysis of Tariff which would be chargeable for our dummy patient episodes based upon grouper output HRG codes.
*********************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************/

--use Project
--go

---- Add extra columns to the HES_Records table that will contain the tariffs.
--ALTER TABLE dbo.HES_Records
--	ADD Tariff_17_18 money,
--		Tariff_18_19 money
--go
---- Calculate the tariffs using the created functions and then insert them into the new functions.
--INSERT INTO dbo.HES_Records
--(
--	 Tariff_17_18
--	,Tariff_18_19
--)
--(
--Select
--	 dbo.FN_17_to_18(ID)
--	,dbo.FN_18_to_19(ID)
--from dbo.HES_Records
--)
---- Display the results of the calculations.
--select * from dbo.HES_Records
/*** Initial efforts were too add the tariffs into the table however this is more memory intensive and there is no need to save data that can be calculated so the calculations
for the 17/18 and 18/19 tariffs will be included alogside the data from the table as shown below. ***/

Create view dbo.vw_HES_With_Tariffs as 

SELECT [ID]
      ,[spell]
      ,[episode]
      ,[epistart]
      ,[epiend]
      ,[epitype]
      ,[sex]
      ,[bedyear]
      ,[epidur]
      ,[epistat]
      ,[spellbgin]
      ,[activage]
      ,[admiage]
      ,[admincat]
      ,[admincatst]
      ,[category]
      ,[dob]
      ,[endage]
      ,[ethnos]
      ,[hesid]
      ,[leglcat]
      ,[lopatid]
      ,[newnhsno]
      ,[newnhsno_check]
      ,[startage]
      ,[admistart]
      ,[admimeth]
      ,[admisorc]
      ,[elecdate]
      ,[elecdur]
      ,[elecdur_calc]
      ,[classpat]
      ,[diag_01]
      ,[numepisodesinspell]
      ,[HRG_code]
	  ,dbo.FN_17_to_18(ID) as [17/18 Tariff]
	  ,dbo.FN_18_to_19(ID) as [18/19 Tariff]
from dbo.HES_Records
go

select * from dbo.vw_HES_With_Tariffs