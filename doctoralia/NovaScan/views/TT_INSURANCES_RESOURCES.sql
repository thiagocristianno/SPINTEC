USE [Xclinic_HML]
GO

/****** Object:  View [dbo].[TT_INSURANCES_RESOURCES]    Script Date: 11/05/2022 15:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TT_INSURANCES_RESOURCES]  AS
SELECT DISTINCT
L.INSURANCE_LID,
L.RESOURCE_LID+'E'  AS RESOURCE_LID
FROM EXVW_LIVROSCONVENIOS L

UNION ALL

SELECT DISTINCT
M.INSURANCE_LID,
ISNULL(M.RESOURCE_LID+'','') AS RESOURCE_LID

FROM EXVW_MEDICOSCONVENIOS M

--INNER JOIN EXVW_LIVROSCONVENIOS L ON
--L.INSURANCE_LID=M.INSURANCE_LID
/*
WHERE 
M.RESOURCE_LID IN (SELECT HORARIOS.LIVROID FROM HORARIOS WHERE HORARIOS.MEDREAID=M.RESOURCE_LID AND HORARIOS.DATA>=GETDATE() GROUP BY HORARIOS.LIVROID)
*/

GO

