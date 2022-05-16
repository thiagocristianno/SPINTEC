USE [BKP_MEDICAL]
GO

/****** Object:  View [dbo].[TT_INSURANCES_RESOURCES]    Script Date: 11/05/2022 08:22:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[TT_INSURANCES_RESOURCES]  AS
/*
	select * from MEDICOS where medicoid in ( select RESOURCE_LID from EXVW_MEDICOSCONVENIOS )
	UNION ALL
	select * from MEDICOS where medicoid in ( select RESOURCE_LID from EXVW_LIVROSCONVENIOS )
	select * from EXVW_MEDICOSCONVENIOS
	select * from EXVW_LIVROSCONVENIOS
	select * from LIVROS WHERE LIVROID IN (
	select SUBSTRING(INSURANCE_LID, 0, CHARINDEX('_',INSURANCE_LID)) from EXVW_MEDICOSCONVENIOS)
*/
SELECT DISTINCT
L.INSURANCE_LID,
L.RESOURCE_LID+'E' AS RESOURCE_LID
FROM EXVW_LIVROSCONVENIOS L

UNION ALL

SELECT DISTINCT
M.INSURANCE_LID,
ISNULL(M.RESOURCE_LID+'','')+'_'+L.RESOURCE_LID+'E'  AS RESOURCE_LID

FROM EXVW_MEDICOSCONVENIOS M

INNER JOIN EXVW_LIVROSCONVENIOS L ON
L.INSURANCE_LID=M.INSURANCE_LID

WHERE
L.RESOURCE_LID IN
(SELECT HORARIOS.LIVROID FROM HORARIOS WHERE HORARIOS.MEDREAID=M.RESOURCE_LID AND HORARIOS.DATA>=GETDATE() GROUP BY HORARIOS.LIVROID)



GO

