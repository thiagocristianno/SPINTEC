USE [smart_homolog]
GO

/****** Object:  View [dbo].[TT_INSURANCES]    Script Date: 11/05/2022 15:01:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TT_INSURANCES]
AS
SELECT 
CNV_COD AS INSURANCE_LID, 
CNV_NOME AS INSURANCE_NAME, 
'1' AS WEB_ENABLED
FROM CNV 
WHERE CNV_STAT = 'A'
GO

