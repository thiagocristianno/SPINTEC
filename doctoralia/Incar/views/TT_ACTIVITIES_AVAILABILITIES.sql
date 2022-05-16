USE [smart_homolog]
GO

/****** Object:  View [dbo].[TT_ACTIVITIES_AVAILABILITIES]    Script Date: 11/05/2022 15:00:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TT_ACTIVITIES_AVAILABILITIES] AS
SELECT 
CAST(GH.HOR_MED AS VARCHAR)+'_'+CAST(GH.HOR_CTF AS VARCHAR)+'_'+CAST(GH.HOR_LOC AS VARCHAR)+'_'+CAST(CAST(GH.DATA AS INT) AS VARCHAR) +'_' +GH.HORARIO_INICIO AS  AVAILABILITY_LID
,SMK.SMK_COD AS ACTIVITY_LID
FROM EX_GRADE_HORARIA GH
INNER JOIN CTF ON 
CTF.CTF_COD=GH.HOR_CTF 
--AND CTF.CTF_CTF_TIPO=GH.HOR_TPCTF
INNER JOIN SMK ON 
SMK.SMK_TIPO = CTF.CTF_TIPO AND SMK.SMK_CTF = CTF.CTF_COD
WHERE 
GH.SITUACAO='DISPONIVEL'
AND SMK.SMK_STATUS = 'A'
AND SMK.SMK_AGD = 1

--AND CTF_CATEG IN ('C','E')
GO

