USE [Xclinic_HML]
GO

/****** Object:  View [dbo].[TT_AVAILABILITIES]    Script Date: 11/05/2022 15:17:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER VIEW [dbo].[TT_AVAILABILITIES] AS

SELECT DISTINCT
  --CAST(CAST(H.LIVROID AS varchar) + '_'   + CAST(CAST(H.HORA AS INT) AS VARCHAR) + '_' + CAST(L.UNIDADEID AS VARCHAR)   + '_' + CAST(CAST(H.DATA AS INT) AS VARCHAR)  AS varchar) AS  AVAILABILITY_LID,
   CAST(CAST(H.DATA AS INT) AS VARCHAR) + '_' + CAST(CAST(H.LIVROID AS varchar) + '_' + CAST(CAST(H.HORA AS INT) AS VARCHAR) + '_' + ' ' + '_' + CAST(L.UNIDADEID AS VARCHAR) AS varchar) AS  AVAILABILITY_LID,
 DATEPART(WEEKDAY, H.DATA) AS R_WORKING_DAY,
 H.HORA AS R_START_TIME,
 --H.HORAFIM AS R_END_TIME,
 CONVERT(VARCHAR, H.DATA,103 )AS R_START_DAY,
 CONVERT(VARCHAR, H.DATA,103 )AS R_END_DAY,
 CASE WHEN H.MEDREAID IS NOT NULL THEN CAST(H.MEDREAID AS varchar) ELSE CAST(L.LIVROID  AS VARCHAR)+'E' END RESOURCE_LID, 
 --ISNULL(CAST(H.MEDREAID AS varchar), '') + '_' + ISNULL(CAST(L.LIVROID  AS VARCHAR), '') AS RESOURCE_LID,
 L.UNIDADEID AS LOCATION_LID

FROM HORARIOS H
INNER JOIN LIVROS L ON L.LIVROID = H.LIVROID
WHERE 
  --H.DATA  >= GETDATE()  AND 
  H.STATUS = 'L' 





GO

