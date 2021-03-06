USE [Xclinic_HML]
GO

/****** Object:  View [dbo].[TT_INSURANCE_AVAILABILITIES]    Script Date: 11/05/2022 15:17:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[TT_INSURANCE_AVAILABILITIES]
AS
SELECT  
CAST(CAST(H.DATA AS INT) AS VARCHAR) + '_' + CAST(CAST(H.LIVROID AS varchar) + '_' + CAST(CAST(H.HORA AS INT) AS VARCHAR) + '_' + ' ' + '_' + CAST(LIV.UNIDADEID AS VARCHAR) AS varchar) AS  AVAILABILITY_LID,
CONVERT(VARCHAR(50), CX.CONVENIOID) + '_' + CONVERT(VARCHAR(50),CX.CONVENIOCOD) + '_' + CONVERT(VARCHAR(50),P.PLANOID) AS INSURANCE_LID
/*
,LIM.QTDLIMITE,
H.DATA
,
(SELECT COUNT(*) FROM TT_RESERVATIONS RE WHERE CONVERT(datetime,RE.APP_DATE,103)=CAST(H.DATA AS date) ) AS QTD_RESERVAS
*/
FROM HORARIOS H WITH(NOLOCK)

INNER JOIN LIVROS LIV  WITH(NOLOCK) ON 
H.LIVROID = LIV.LIVROID

INNER JOIN LIVROSCONVENIOS LC  WITH(NOLOCK) ON
LC.LIVROID=LIV.LIVROID

INNER JOIN CONVENIOS CX  WITH(NOLOCK) ON
CX.CONVENIOID=LC.CONVENIOID 

INNER JOIN CONVENIOSPLANOS P  WITH(NOLOCK) ON
P.CONVENIOID = CX.CONVENIOID
AND CX.PLANOID=P.PLANOID

LEFT JOIN LIVINTLIMCONVENIOS LIM  WITH(NOLOCK) ON 
LIM.LIVROID=H.LIVROID AND LIM.DATAINI>=H.DATA AND LIM.DATAFIM<=H.DATA
AND LIM.CONVENIOID=CX.CONVENIOID

WHERE 
/*
H.DATA='2021-12-13 00:00:00.000'
AND CX.CONVENIOID=191
AND H.LIVROID=20
AND
*/
 H.STATUS = 'L' AND
(SELECT COUNT(*) 
FROM TT_RESERVATIONS RE  WITH(NOLOCK)
WHERE 
CONVERT(datetime,RE.APP_DATE,103)=CAST(H.DATA AS date) 
AND PARSENAME(replace(RE.INSURANCE_LID, '_','.'), 3)=CX.CONVENIOID
AND PARSENAME(replace(RE.RESOURCE_LID, '_','.'), 1)=H.LIVROID
)<CASE WHEN LIM.QTDLIMITE>0 THEN LIM.QTDLIMITE ELSE 10000 END




GO

