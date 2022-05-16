USE [smart_homolog]
GO

/****** Object:  View [dbo].[TT_INSURANCES_RESOURCES]    Script Date: 11/05/2022 15:01:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[TT_INSURANCES_RESOURCES] as 	
/*
	select * from psv where psv_tipo in ('m') and psv_cod <> 0
	select * from cnv 
	select * from HOR 
*/
	SELECT
		CAST(P.PSV_COD AS VARCHAR) AS RESOURCE_LID,
		CAST(C.CNV_COD AS VARCHAR) AS INSURANCE_LID
	FROM PSV P
	INNER JOIN CNV C 
	ON CAST(C.CNV_COD AS VARCHAR) != '0' AND 
	CAST(C.CNV_COD AS VARCHAR) IS NOT NULL
	--Horarios do medico
	INNER JOIN HOR H ON 
	H.HOR_MED = P.PSV_COD
	WHERE P.PSV_TIPO IN ('M')
	AND P.PSV_COD <> 0

	GROUP BY P.PSV_COD,C.CNV_COD
GO

