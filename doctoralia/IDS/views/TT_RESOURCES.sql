USE [BKP_MEDICAL]
GO

/****** Object:  View [dbo].[TT_RESOURCES]    Script Date: 11/05/2022 08:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[TT_RESOURCES] AS	

/* MEDICOS */
SELECT DISTINCT
	CAST(MED.MEDICOID AS varchar)+'_'+CAST(LV.LIVROID AS varchar)+'E' AS RESOURCE_LID,
 CASE
    WHEN CHARINDEX(' ',LTRIM(RTRIM(NOME))) > 0  THEN LEFT(NOME, CHARINDEX(' ',LTRIM(RTRIM(NOME)))-1) 
    ELSE NOME 
END AS RESOURCE_FIRST_NAME,
CASE   
    WHEN CHARINDEX(' ',LTRIM(RTRIM(NOME))) > 0  THEN 
        LTRIM(RTRIM(SUBSTRING(NOME, CHARINDEX(' ',LTRIM(RTRIM(NOME))), (LEN(LTRIM(RTRIM(NOME)))+1 - CHARINDEX(' ',LTRIM(RTRIM(NOME))) )) ))
    ELSE ''
END AS RESOURCE_SECOND_NAME,
	TELEFONE1 AS RESOURCE_MOBILE_PHONE,
	EMAIL AS RESOURCE_EMAIL,
	CPF AS RESOURCE_ID_NUMBER,
	U.UNIDADEID AS LOCATION_LID,
	1 AS WEB_ENABLED,
	' 'AVAILABILITIES_STEP

FROM 
	MEDICOS MED
LEFT JOIN LIVROSINTERVALOS L ON L.MEDREAID = MED.MEDICOID
INNER JOIN LIVROS LV ON 
	LV.LIVROID = L.LIVROID
INNER JOIN LIVROSPROCEDIMENTOS LP ON
	LP.LIVROID = L.LIVROID
INNER JOIN UNIDADES U ON
	U.UNIDADEID = LV.UNIDADEID
--INNER JOIN EQUIPAMENTOS E ON E.EQUIPAMENTOID = L.EQUIPAMENTOID


WHERE 
	MED.TIPO ='A' AND
	MED.SUSPENSO ='F' 
--	AND MED.MEDICOID= 2757


	UNION ALL

/*LIVROS*/

	SELECT DISTINCT
	--CAST(E.EQUIPAMENTOID AS varchar) + '_'+ 
	CAST(LV.LIVROID AS varchar)+'E'  AS RESOURCE_LID,
	E.DESCRICAO AS RESOURCE_FIRST_NAME,
	E.DESCRICAO AS RESOURCE_SECOND_NAME,
	'' AS RESOURCE_ID_NUMBER,
	'' AS RESOURCE_MOBILE_PHONE,
	'' AS RESOURCE_EMAIL,
	U.UNIDADEID AS LOCATION_LID,
	1 AS WEB_ENABLED,
	' 'AVAILABILITIES_STEP

	FROM EQUIPAMENTOS E
	INNER JOIN LIVROSINTERVALOS L ON L.EQUIPAMENTOID = E.EQUIPAMENTOID
	INNER JOIN LIVROS LV ON LV.LIVROID = L.LIVROID
	LEFT JOIN UNIDADES U ON U.UNIDADEID = LV.UNIDADEID
	WHERE 
	E.ATIVO ='T'








GO

