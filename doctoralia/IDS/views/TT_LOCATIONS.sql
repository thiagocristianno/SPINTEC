USE [BKP_MEDICAL]
GO

/****** Object:  View [dbo].[TT_LOCATIONS]    Script Date: 11/05/2022 08:22:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[TT_LOCATIONS] AS
SELECT 


UNIDADEID AS LOCATION_LID,
DESCRICAO AS LOCATION_NAME,
'' AS LOCATION_NOTICE,
ENDERECO AS LOCATION_ADDRESS,
'' AS LOCATION_ZIP_CODE,
'' AS LOCATION_CITY,
'' AS LOCATION_PROVINCE,
'' AS LOCATION_REGION,
'' AS LOCATION_COUNTRY,
1 AS WEB_ENABLED

FROM
	UNIDADES 
WHERE ATIVA = 'T'







GO
