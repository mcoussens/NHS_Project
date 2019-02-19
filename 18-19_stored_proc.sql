USE Project
GO
-- Dropping procedure if it already exists.
IF OBJECT_ID('calc_18_to_19') IS NOT NULL
	DROP PROCEDURE calc_18_to_19 
GO
-- Creating prcedure that returns costs from dummy data
CREATE PROCEDURE [calc_18_to_19] @ID nvarchar(50)
AS
SELECT
-- Calculating whether the outpatient procedure tarrif is applicable
	 CASE
	 	 WHEN a.CLASSPAT <> 1 AND a.EPIDUR = 1 THEN a.opt
	 	 ELSE 0
	 END AS OPT
-- Calculating combined day case/ordinary elective spell tariff
	,CASE
		WHEN a.ADMIMETH LIKE '1%' THEN a.cdc_oest
		ELSE 0
	 END AS CDC_OEST
-- Calculating day case spell tarrif
	,CASE
		WHEN a.ADMIMETH LIKE '1%' and a.CLASSPAT = 2 THEN a.dcst
		ELSE 0
	 END AS DCST
-- Calculating ordinary elective spell tarriff
	,CASE
		WHEN a.ADMIMETH LIKE '1%' AND a.CLASSPAT = 2 THEN a.cdc_oest
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

FROM
--Joining all data required for calculation together and nesting it so that it can be called in the calculation
(SELECT 
	 a.ADMIMETH as ADMIMETH
	,a.EPIDUR as EPIDUR
	,a.FCE_HRG as HRG_CODE
	,a.CLASSPAT as CLASSPAT
	,b.[Outpatient procedure tariff (£)] as opt
	,b.[Combined day case / ordinary elective spell tariff (£)] as cdc_oest
	,b.[Day case spell tariff (£)] as dcst
	,b.[Ordinary elective spell tariff (£)] as oest
	,b.[Ordinary elective long stay trim point (days)] as oelstp
	,b.[Non-elective spell tariff (£)] as nest
	,b.[Non-elective long stay trim point (days)] as nelstp
	,b.[Per day long stay payment (for days exceeding trim point) (£)] as pdlsp
	,b.[Reduced short stay emergency tariff _applicable?]
	,b.[% applied in calculation of reduced short stay emergency tariff ]
	,b.[Reduced short stay emergency tariff (£)]
	,b.[ BPT applies to HRG or sub-HRG level]
	,b.[Area BPT Name applies (see also tab "07#BPTs")]
	,b.[Where BPT applies:_NE = Non-elective spell tariff_DC/EL = Day ca]
	,b.[SUS will automate which BPT price (BPT or non-BPT price)]
	,b.[The price automated by SUS]
	,b.[BPT Flag]
FROM stage.test_hrg a
inner join stage.[APC_OPROC_18-19] b
	on a.FCE_HRG = b.[HRG code]
where PROVSPNO = @ID) a
GO

EXEC calc_18_to_19 '1004597459'