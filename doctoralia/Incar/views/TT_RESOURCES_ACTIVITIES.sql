USE [smart_homolog]
GO

/****** Object:  View [dbo].[TT_RESOURCES_ACTIVITIES]    Script Date: 11/05/2022 15:02:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[TT_RESOURCES_ACTIVITIES]
AS
SELECT DISTINCT 
PSV_COD AS RESOURCE_LID, 
SMK_COD AS ACTIVITY_LID, 
isnull(COALESCE(SMK_CRG_TEMPO_PADRAO, TCE_TEMPO),0) AS ACTIVITY_DURATION, 
0 AS ACTIVITY_PRICE
FROM PSV 
INNER JOIN HAB ON PSV_COD = HAB_MED
INNER JOIN HOR ON HAB_MED = HOR_MED AND HAB_TPCTF = HOR_TPCTF AND HAB_CTF = HOR_CTF
INNER JOIN SMK ON SMK_TIPO = HOR_TPCTF AND SMK_CTF = HOR_CTF
INNER JOIN CTF ON CTF_TIPO = SMK_TIPO AND CTF_COD = SMK_CTF
LEFT OUTER JOIN TCE ON TCE_PSV_COD = PSV_COD AND TCE_SMK_TIPO = SMK_TIPO AND TCE_SMK_COD = SMK_COD
WHERE SMK_STATUS = 'A'
AND SMK_AGD = 1
AND CTF_CATEG IN ('C','E')
GO

