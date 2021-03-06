USE [smart_homolog]
GO

/****** Object:  View [dbo].[TT_INSURANCES_ACTIVITIES]    Script Date: 11/05/2022 15:01:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TT_INSURANCES_ACTIVITIES]
AS
SELECT 
CNV_COD AS INSURANCE_LID, 
SMK_COD AS ACTIVITY_LID, 
isnull(PRE_VLR_P1,0) AS ACTIVITY_PRICE
FROM CNV INNER JOIN APT ON APT_CNV_COD = CNV_COD
INNER JOIN TAB ON APT_TAB_COD = TAB_COD
INNER JOIN PRE ON PRE_TAB_COD = TAB_COD
INNER JOIN SMK ON PRE_SMK_TIPO = SMK_TIPO AND PRE_SMK_COD = SMK_COD
INNER JOIN CTF ON CTF_TIPO = SMK_TIPO AND CTF_COD = SMK_CTF
WHERE CNV_STAT = 'A'
AND SMK_STATUS = 'A'
AND SMK_AGD = 1
AND CTF_CATEG IN ('C','E')
AND apt_dthr_vcto >= GETDATE()
GO

