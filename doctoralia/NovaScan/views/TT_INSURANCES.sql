USE [Xclinic_HML]
GO

/****** Object:  View [dbo].[TT_INSURANCES]    Script Date: 11/05/2022 15:18:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TT_INSURANCES] AS
	SELECT 
		CONVERT(VARCHAR(50), C.CONVENIOID) + '_' + CONVERT(VARCHAR(50),C.CONVENIOCOD) + '_' + CONVERT(VARCHAR(50),ISNULL(P.PLANOID,C.CONVENIOID)) AS INSURANCE_LID,
		CONVERT(VARCHAR(50), C.DESCRICAO + ' - ' + P.PLANODESCRICAO,50) AS INSURANCE_NAME,		
		CASE WHEN DESCRICAO LIKE '%PARTICULAR%' THEN '1' ELSE '2' END INSURANCE_TYPE
		
	FROM CONVENIOS C
		LEFT JOIN CONVENIOSPLANOS P ON
		P.CONVENIOID = C.CONVENIOID
		AND P.SUSPENSO = 'F' 
		--AND P.PLANOID=C.PLANOID
	WHERE 
		C.SUSPENSO = 'F' 
		AND C.DESCRICAO IS NOT NULL
		--AND C.CONVENIOCOD LIKE '00%' 
		AND C.DESCRICAO NOT LIKE '%EXCLUIDO%'
		AND P.PLANODESCRICAO NOT LIKE '%EXCLUIDO%'



GO

