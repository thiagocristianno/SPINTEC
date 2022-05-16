USE [smart_homolog]
GO

/****** Object:  View [dbo].[TT_ACTIVITIES]    Script Date: 11/05/2022 15:00:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TT_ACTIVITIES]
AS
SELECT 
SMK_COD AS ACTIVITY_LID, 
SMK_NOME AS ACTIVITY_NAME, 
CTF_NOME AS ACTIVITY_GROUP_NAME, 
CTF_COD AS ACTIVITY_GROUP_LID, 
SMK_CRG_TEMPO_PADRAO AS ACTIVITY_DURATION, 
0 AS ACTIVITY_PRICE, 
isnull(smk_inst_operador,'') AS ACTIVITY_NOTICE,
isnull(SMK_INST,'') AS ACTIVITY_PREPARATION, 
1 AS WEB_ENABLED
FROM SMK 
INNER JOIN CTF ON SMK_TIPO = CTF_TIPO AND SMK_CTF = CTF_COD
WHERE SMK_STATUS = 'A'
AND SMK_AGD = 1
AND CTF_CATEG IN ('C','E')
GO
