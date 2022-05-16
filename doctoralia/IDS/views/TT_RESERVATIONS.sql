USE [BKP_MEDICAL]
GO

/****** Object:  View [dbo].[TT_RESERVATIONS]    Script Date: 11/05/2022 08:23:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















/*
SELECT * FROM LIVROS WHERE LIVROID=8
SELECT * FROM LIVROSINTERVALOS WHERE LIVROID=8
SELECT * FROM LIVROSGRUPOS
select * from LIVROSINTERVALOSCONVENIOS
select * from LIVROSINTERVALOSEXAMES
SELECT * FROM PACIENTETELEFONES WHERE PACIENTEID=93939 ORDER BY PACIENTEID

SELECT * FROM UNIDADES
SELECT * FROM MEDICOS  WHERE MEDICOID='2757'
SELECT * FROM PACIENTE WHERE NOME LIKE '%ALCANTA OUZA%'
SELECT  * FROM VW_AGENDA WHERE DATA = '2021-11-10 00:00:00.000' AND LIVROID ='13' 
SELECT * FROM HORARIOS  WHERE  DATA = '2021-05-27 00:00:00.000' AND LIVROID ='8' 
SELECT * FROM PROCEDIMENTOS

select A.compareceu, A.STATUS, A.CONFIRMADO, * FROM vw_agenda A WHERE A.DATA > '2021-11-10 00:00:00.000' AND A.LIVROID = 13 ORDER BY A.STATUS

*/
ALTER VIEW [dbo].[TT_RESERVATIONS] AS 

SELECT
U.UNIDADEID,
CAST(V.LIVROID AS varchar) +  '_'  + CAST(V.HORA AS varchar) + '_' + CAST(V.HORREQID AS varchar) + '_' + CAST(U.UNIDADEID AS VARCHAR)+CASE WHEN EX.PROCID IS NULL THEN '' ELSE '_'+CAST(EX.PROCID AS varchar) END  APP_LID,
'' AS APP_TIME,
 CONVERT(VARCHAR,V.DATA, 105) AS APP_DATE,
 V.HORA AS APP_START_TIME,
 V.HORAFIM AS APP_END_TIME,
 '' AS APP_PRICE,
 CASE 
	WHEN V.COMPARECEU = 'T' THEN 1 
	WHEN V.COMPARECEU = 'F' THEN 0
	ELSE ' ' END AS APP_SHOW,
 CONVERT(VARCHAR, V.DATAAGENDAMENTO, 105) AS APP_CREATED,
 CONVERT(VARCHAR,V.DATAULTIMAATUALIZACAO, 105) AS APP_MODIFIED,
 CAST(P.PACIENTEID AS varchar(50)) AS USER_LID,
 '' AS USER_TIME,
SUBSTRING(LTRIM(P.NOME),1,CHARINDEX(' ',LTRIM(RTRIM(P.NOME)))) AS USER_FIRST_NAME,
/*
CASE
    WHEN CHARINDEX('',LTRIM(RTRIM(P.NOME))) > 0  THEN 
	LEFT(P.NOME, CHARINDEX('',LTRIM(RTRIM(P.NOME)))-1) 
    ELSE P.NOME 
END AS USER_FIRST_NAME,
*/
SUBSTRING(LTRIM(P.NOME),CHARINDEX(' ',LTRIM(RTRIM(P.NOME)))+1,LEN(P.NOME)) AS USER_SECOND_NAME,
/*
CASE   
    WHEN CHARINDEX(' ',LTRIM(RTRIM(P.NOME))) > 0  THEN 
        LTRIM(RTRIM(SUBSTRING(P.NOME, CHARINDEX(' ',LTRIM(RTRIM(P.NOME))), (LEN(LTRIM(RTRIM(P.NOME)))+1 - CHARINDEX(' ',LTRIM(RTRIM(P.NOME))) )) ))
    ELSE ''
END AS USER_SECOND_NAME,
*/
 '' AS USER_THIRD_NAME,
 CASE WHEN LEN(RTRIM(REPLACE(REPLACE(P.CONFIGURAVEL2,'.',''),'-','')))=11 THEN RTRIM(REPLACE(REPLACE(P.CONFIGURAVEL2,'.',''),'-','')) ELSE '' END USER_ID_NUMBER,

 case when P.TIPOTELEFONEID IN ('5') THEN ISNULL(RTRIM(P.DDD),'')+ISNULL(RTRIM(P.TELEFONE),'') ELSE  (SELECT TOP 1 ISNULL(RTRIM(FONE.DDD),'')+ISNULL(RTRIM(FONE.TELEFONE),'')  FROM PACIENTETELEFONES FONE WHERE FONE.TIPO IN ('Residencial','RESIDENCIAL','') AND FONE.PACIENTEID = P.PACIENTEID)  END USER_LANDLINE_PHONE,
 
 case when P.TIPOTELEFONEID IN ('2') THEN ISNULL(RTRIM(P.DDD),'')+ISNULL(RTRIM(P.TELEFONE),'') ELSE  (SELECT TOP 1 ISNULL(RTRIM(FONE.DDD),'')+ISNULL(RTRIM(FONE.TELEFONE),'')  FROM PACIENTETELEFONES FONE WHERE FONE.TIPO IN ('Comercial','COMERCIAL','') AND FONE.PACIENTEID = P.PACIENTEID)  END USER_WORK_PHONE,

 RTRIM(P.EMAIL) AS USER_EMAIL,
 P.DATANASC AS USER_DATE_OF_BIRTH,
 '' AS USER_PLACE_OF_BIRTH,
 CAST(P.SEXO AS VARCHAR(10)) AS USER_GENDER,
 CAST(P.CEP  AS VARCHAR) AS USER_ZIP_CODE,
 case when P.TIPOTELEFONEID IN ('1') THEN ISNULL(RTRIM(P.DDD),'')+ISNULL(RTRIM(P.TELEFONE),'') ELSE  (SELECT TOP 1 ISNULL(RTRIM(FONE.DDD),'')+ISNULL(RTRIM(FONE.TELEFONE),'') FROM PACIENTETELEFONES FONE WHERE FONE.TIPO IN ('Celular','CELULAR') AND FONE.PACIENTEID = P.PACIENTEID)  END USER_MOBILE_PHONE,
 '' AS USER_LANGUAGE,
 '' AS USER_PRIVACY,
 '' AS USER_PRIVACY_PROMOTIONS,
 '' AS COMMUNICATION_PREFERENCES,
 ISNULL(CAST(V.MEDREAID AS varchar)+'_'+CAST(V.LIVROID AS varchar)+'E', ISNULL(CAST(V.LIVROID  AS VARCHAR), '')+'E') AS RESOURCE_LID, 
 CAST(PR.PROCID AS varchar) + '_' + CAST(PR.MNEMONICO AS varchar) AS ACTIVITY_LID,
 CONVERT(VARCHAR(50), C.CONVENIOID) + '_' + CONVERT(VARCHAR(50),C.CONVENIOCOD)  + '_'  + CONVERT(VARCHAR(50),PL.PLANOID) AS INSURANCE_LID,
 U.UNIDADEID AS LOCATION_LID,
CASE WHEN (SELECT TOP 1 V2.CONFIRMADO FROM VW_AGENDA V2 WHERE V2.LIVROID  = V.LIVROID AND V2.HORA = V.HORA AND V2.HORREQID = V.HORREQID ) = 'F'  AND V.STATUS = 'O' AND V.COMPARECEU = 'F'THEN 'APPROVED' 
	 WHEN (SELECT TOP 1 V2.CONFIRMADO FROM VW_AGENDA V2 WHERE V2.LIVROID  = V.LIVROID AND V2.HORA = V.HORA AND V2.HORREQID = V.HORREQID ) = 'T'  AND V.STATUS = 'O' AND V.COMPARECEU = 'F'THEN 'CONFIRMED'
	 WHEN (SELECT TOP 1 V2.CONFIRMADO FROM VW_AGENDA V2 WHERE V2.LIVROID  = V.LIVROID AND V2.HORA = V.HORA AND V2.HORREQID = V.HORREQID ) = 'T'  AND V.STATUS = 'O' AND V.COMPARECEU = 'T'THEN 'CHECK-OUT'
	 WHEN (SELECT TOP 1 V2.CONFIRMADO FROM VW_AGENDA V2 WHERE V2.LIVROID  = V.LIVROID AND V2.HORA = V.HORA AND V2.HORREQID = V.HORREQID ) = 'F'  AND V.STATUS = 'O' AND V.COMPARECEU = 'T'THEN 'CHECK-OUT'
	 ELSE 'NO-SHOW'
END  AS STATUS,
 '' AS NOTES,
 V.USUARIO AS APP_OWNER_LID,
 '' AS APP_OWNER_TID,
 '' AS APP_OWNER_NAME


FROM VW_AGENDA V
--LEFT JOIN HORARIOS H ON H.LIVROID = V.LIVROID
LEFT JOIN PACIENTE P ON P.PACIENTEID = V.PACIENTEID

LEFT JOIN HORARIOSEXAMES EX  ON
EX.DATA=V.DATA AND EX.HORA=V.HORA AND EX.CONTADOR=V.CONTADOR AND EX.LIVROID=V.LIVROID

LEFT JOIN PROCEDIMENTOS PR ON PR.PROCID = EX.PROCID

LEFT JOIN CONVENIOS C ON V.CONVENIOID = C.CONVENIOID 

LEFT JOIN CONVENIOSPLANOS PL ON PL.PLANOID = C.PLANOID

LEFT JOIN LIVROS L ON L.LIVROID = V.LIVROID 

inner JOIN UNIDADES U ON U.UNIDADEID = L.UNIDADEID

WHERE  V.DATA > dateadd(DAY,-6,GETDATE())

and 
(--CONVERT(VARCHAR, V.DATAAGENDAMENTO, 105) is null or 
(CONVERT(VARCHAR, V.DATAAGENDAMENTO, 105) is not null and EX.PROCID is not null))

--AND V.LIVROID ='8' 
/*AND 
((PR.PROCID IS NULL AND P.PACIENTEID IS NULL) OR
(PR.PROCID IS NOT NULL AND P.PACIENTEID IS NOT NULL))
*/



















GO
