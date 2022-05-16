USE [BKP_MEDICAL]
GO

/****** Object:  Trigger [dbo].[TT_RESERVATIONS_TMP_INSERT_NEW2]    Script Date: 19/04/2022 10:28:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER TRIGGER [dbo].[TT_RESERVATIONS_TMP_INSERT_NEW2] 
ON [dbo].[TT_RESERVATIONS_TMP]
AFTER INSERT
AS
BEGIN -- INICIO TRIGGER 

DECLARE
      @app_TMP_id NVARCHAR (50),
      @app_lid NVARCHAR (50),
      @app_tid NVARCHAR(50), 
      @app_action NVARCHAR(50), 
      @app_date DATETIME,
      @app_start_time DATETIME,
      @app_end_time DATETIME,
      @app_price NVARCHAR (20),

      @user_exist INT,
      @user_lid NVARCHAR (20),
      @user_lid_new NVARCHAR (20),
      @user_lid_int INT,
      @user_tid NVARCHAR (20),
      @user_first_name NVARCHAR (50),
      @user_second_name NVARCHAR (50),
      @user_third_name NVARCHAR (50),
      @user_id_number NVARCHAR (50),
      @user_landline_phone NVARCHAR (50),
      @user_work_phone NVARCHAR (50),
      @user_mobile_phone NVARCHAR (50),
      @user_email NVARCHAR (50),
      @user_date_of_birth NVARCHAR (10),
      @user_date_of_birth_datetime DATETIME,
      @user_gender NVARCHAR (10),
      @user_language NVARCHAR (10),
      @user_zip_code NVARCHAR (10),
      @app_owner_lid NVARCHAR (50),
      @app_owner_tid NVARCHAR (50),
      @app_owner_name NVARCHAR (50),
      @insert_time DATETIME,
      @insurance_lid NVARCHAR(20),
      @activity_lid NVARCHAR(20),
      @resource_lid NVARCHAR(20),
      @location_lid NVARCHAR (20),
      @status NVARCHAR (50),
      @status_trigger NVARCHAR (4000),
      @notes NVARCHAR (20),
	  @HORREQID INT,
	  @APP_LID_NEW VARCHAR(30),
	  @HORREQID_OLD INT,
	  @APP_LID_OLD VARCHAR (30),
	  @STATUS_AGENDA VARCHAR(1),
	  @LIVRO AS VARCHAR(5),
	  @HORA AS VARCHAR(10),
	  @UNIDADE AS VARCHAR(5),
	  @DATA AS VARCHAR(10),

	  @LIVROUPDATE AS VARCHAR(5),
	  
	 
	 @app_custom_0 varchar(500),
	 @app_custom_1 varchar(500),
	 @app_custom_2 varchar(500),
	 @app_custom_1_old varchar(500),
	 @app_custom_2_old VARCHAR(500),
	 @PACIENTEID INT

	  ,@LIVRO_OLD VARCHAR(50)
	  ,@HORA_OLD VARCHAR(50)
	  ,@UNIDADE_OLD VARCHAR(50)
	  ,@DATA_OLD DATETIME,
	  @APP_DATE_OLD DATETIME;


	  
SELECT
      @app_TMP_id = APP_TMP_ID,
      @app_lid = APP_LID,
      @app_action = APP_ACTION,
      @app_tid = APP_TID ,
      @app_date = CONVERT(DATE,APP_DATE, 103),
	  @app_start_time = APP_START_TIME,
      @app_end_time = APP_END_TIME,
      @app_price = APP_PRICE,
      @status = STATUS,
      @notes = NOTES,
      @user_lid = USER_LID,
      @user_tid = USER_TID,
      @user_first_name= USER_FIRST_NAME,
      @user_second_name= USER_SECOND_NAME,
      @user_third_name = USER_THIRD_NAME,
      @user_id_number= dbo.formatarCNPJCPF(USER_ID_NUMBER),
      @user_landline_phone= USER_LANDLINE_PHONE,
      @user_mobile_phone = USER_MOBILE_PHONE,
      @user_email = USER_EMAIL,
      @user_date_of_birth = CONVERT(DATE, USER_DATE_OF_BIRTH, 103),
      @user_gender = USER_GENDER,
      @user_zip_code= USER_ZIP_CODE,
      @user_language= USER_LANGUAGE,
      @activity_lid = ACTIVITY_LID,
      @resource_lid = RESOURCE_LID,
      @location_lid = LOCATION_LID,
      @insurance_lid = INSURANCE_LID,
      @app_owner_lid = APP_OWNER_LID,
      @app_owner_tid = APP_OWNER_TID,
      @app_owner_name= APP_OWNER_NAME,
      @status_trigger= STATUS_TRIGGER,
      @insert_time= INSERT_TIME,  
	  @app_custom_0 = app_custom_0,
	  @app_custom_1 = app_custom_1,
	  @app_custom_2 = app_custom_2

	 
FROM INSERTED;
set @HORREQID = (SELECT VALOR+1 FROM SEQUENCIAS WHERE TABELA='HORARIOSREQUISICAO');
exec dbo.SP_SEQUENCIA 'HORARIOSREQUISICAO',@HORREQID;

SET @user_lid_int = CAST (@user_lid AS INT) 

SELECT @user_exist = count (1) 
FROM PACIENTE 
WHERE PACIENTEID = @user_lid_int

IF @user_exist = 0


--BEGIN

SELECT @user_exist = COUNT(1) 
FROM PACIENTE
WHERE 	  	
      DATANASC  = @user_date_of_birth AND
	  DOCUMENTO = @user_id_number



IF @user_exist = 0	
BEGIN

     
	 set @user_lid_int = (SELECT VALOR+1 FROM SEQUENCIAS WHERE TABELA='PACIENTE');
	 exec dbo.SP_SEQUENCIA 'PACIENTE',@user_lid_int;

	  SET @user_lid_new = CAST(@user_lid_int AS VARCHAR(20))



print @user_lid_int
print @user_lid_new
print 'pacienteidd'

INSERT INTO PACIENTE(
		 [UNIDADEID]
		,[PACIENTEID]
		,[NOME]
		,[CONTROLE]
		,[DATANASC]
		,[IDADE]
		,[SEXO]
		,[DOCUMENTO]
		,[ESTADOCIVIL]
		,[DUM]
		,[PESO]
		,[ALTURA]
		,[ENDERECO]
		,[NUMERO]
		,[COMPLEMENTO]
		,[BAIRRO]
		,[CIDADE]
		,[ESTADO]
		,[CEP]
		,[CONFIGURAVEL1]
		,[CONFIGURAVEL2]
		,[CONFIGURAVEL3]
		,[EMAIL]
		,[CONVENIOID]
		,[TITULAR]
		,[MATRICULA]
		,[DATACADASTRO]
		,[DATAATUALIZADO]
		,[PLANOID]
		,[DDD]
		,[TELEFONE]
		,[TELEFONETIPO]
		,[NOME_FONETICO]
		,[MATRICULA_ASSOCIADO]
		,[CONVENIOASSOCIADOID]
		,[FRANQUIA_ASSOCIADOID]
		,[EXCLUIDO]
		,[USERDELID]
		,[USERCOMPUDEL]
		,[DATADEL]
		,[INTERNET]
		,[VENC_CARTEIRINHA]
		,[RECEPCIONADO]
		,[TIPODOCID]
		,[GESTANTE]
		,[STATUS]
		,[FOTO]
		,[OBSERVACAO]
		,[CONFIGURAVEL4]
		,[CONFIGURAVEL5]
		,[CONFIGURAVEL6]
		,[CONFIGURAVEL7]
		,[OBSID]
		,[OBSDEL]
		,[PACIENTEDAAGENDA]
		,[NOME1]
		,[NOME2]
		,[NOME3]
		,[INTERNET_MEDICO]
		,[TIPOTELEFONEID]
		,[NOME_SOCIAL]		
)
VALUES
(
		 0 --UNIDADEID, int,>
		,@user_lid_int--<PACIENTEID, int,>
		,@user_first_name + ' '+ @user_second_name --<NOME, varchar(0),>
		,NULL--<CONTROLE, varchar(20),
		,@user_date_of_birth --[DATANASC]
		,NULL--<IDADE, int,>
		,@user_gender--<SEXO, varchar(1),>
		,@user_id_number --<DOCUMENTO, varchar(40),>
		,NULL --<ESTADOCIVIL, varchar(10),>
		,NULL --<DUM, datetime,>
		,0--<PESO, float,>
		,0--<ALTURA, float,>
		,NULL--<ENDERECO, varchar(60),>
		,NULL--<NUMERO, varchar(6),>
		,NULL--<COMPLEMENTO, varchar(30),>
		,NULL--<BAIRRO, varchar(30),>
		,NULL--<CIDADE, varchar(30),>
		,NULL--<ESTADO, varchar(2),>
		,@user_zip_code--  <CEP, varchar(9),>
		,' '--<CONFIGURAVEL1, char(255),>
		,@user_landline_phone --<CONFIGURAVEL2, char(255),>
		,'04'--<CONFIGURAVEL3, char(255),>
		,@user_email--<EMAIL, varchar(100),>
		,PARSENAME(replace(cast(@insurance_lid  as varchar), '_','.'), 3)  --<CONVENIOID, int,>
		,@user_first_name + ' '+ @user_second_name --<TITULAR, varchar(60),>
		,''--<MATRICULA, varchar(30),>
		,GETDATE() --<DATACADASTRO, datetime,>
		,GETDATE() --<DATAATUALIZADO, datetime,>
		,CAST(PARSENAME(replace(CAST(@insurance_lid AS VARCHAR), '_','.'), 1)AS varchar) --<PLANOID, int,>
		,SUBSTRING(@user_mobile_phone,1,2) --<DDD, varchar(5),>
		,SUBSTRING(@user_mobile_phone,3,20) --<TELEFONE, varchar(20),>
		,'R' --<TELEFONETIPO, varchar(10),>
		,NULL--<NOME_FONETICO, varchar(60),>
		,' '--<MATRICULA_ASSOCIADO, varchar(30),>
		,NULL--<CONVENIOASSOCIADOID, int,>
		,NULL--<FRANQUIA_ASSOCIADOID, int,>
		,'F' --<EXCLUIDO, varchar(1),>
		,NULL--<USERDELID, int,>
		,NULL--<USERCOMPUDEL, varchar(15),>
		,NULL--<DATADEL, datetime,>
		,'T'--<INTERNET, varchar(1),>
		,' '--<VENC_CARTEIRINHA, datetime,>
		,NULL--<RECEPCIONADO, char(1),>
		,2--<TIPODOCID, int,>
		,'F'--<GESTANTE, char(1),>
		,'A'--<STATUS, char(1),>
		,''--<FOTO, image,>
		,NULL--<OBSERVACAO, text,>
		,NULL--<CONFIGURAVEL4, char(255),>
		,NULL--<CONFIGURAVEL5, char(255),>
		,NULL--<CONFIGURAVEL6, char(255),>
		,NULL--<CONFIGURAVEL7, char(255),>
		,0 --<OBSID, int,>
		,' '--<OBSDEL, text,>
		,'F'--<PACIENTEDAAGENDA, char(1),>
		,NULL--<NOME1, varchar(30),>
		,NULL--<NOME2, varchar(30),>
		,NULL--<NOME3, varchar(30),>
		,'T'--<INTERNET_MEDICO, char(1),>
		,1--<TIPOTELEFONEID, int,>
		,NULL--<NOME_SOCIAL, varchar(60),>
      
)
END -- FIM CADASTRO DE PACIENTTE

IF @user_exist != 0	
BEGIN

UPDATE PACIENTE SET 
		 NOME = @user_first_name + ' '+ @user_second_name --<NOME, varchar(0),>
		,DATANASC= @user_date_of_birth --[DATANASC]
		,SEXO = @user_gender--<SEXO, varchar(1),>
		,DOCUMENTO = @user_id_number --<DOCUMENTO, varchar(40),>
		,CEP = @user_zip_code--  <CEP, varchar(9),>
		,CONFIGURAVEL2 = @user_landline_phone --<CONFIGURAVEL2, char(255),>
		,EMAIL = @user_email--<EMAIL, varchar(100),>
		--,CONVENIOID = PARSENAME(replace(cast(@insurance_lid  as varchar), '_','.'), 3)  --<CONVENIOID, int,>
		,TITULAR = @user_first_name + ' '+ @user_second_name --<TITULAR, varchar(60),>
		,DATAATUALIZADO = GETDATE() --<DATAATUALIZADO, datetime,>
		--,PLANOID = CAST(PARSENAME(replace(CAST(@insurance_lid AS VARCHAR), '_','.'), 1)AS varchar) --<PLANOID, int,>
		,DDD = SUBSTRING(@user_mobile_phone,1,2) --<DDD, varchar(5),>
		,TELEFONE = SUBSTRING(@user_mobile_phone,3,20) --<TELEFONE, varchar(20),>
		,TELEFONETIPO = 'R' --<TELEFONETIPO, varchar(10),>
WHERE PACIENTEID=(SELECT TOP 1 PACIENTEID FROM PACIENTE WHERE DATANASC  = @user_date_of_birth AND DOCUMENTO = @user_id_number AND EMAIL = @user_email);

END



IF @app_action='add'

BEGIN 
			
--IF @user_exist = 1 

SET @STATUS_AGENDA = (SELECT  TOP 1 A.STATUS FROM HORARIOS A WHERE  A.HORA = dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.') AND DATA =  @app_date AND A.LIVROID = dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.'));
SET @PACIENTEID = (SELECT TOP 1 PACIENTEID FROM PACIENTE WHERE   DATANASC  = @user_date_of_birth AND DOCUMENTO = @user_id_number AND EMAIL = @user_email)	


print 'data_nascimento'
print @user_date_of_birth
print @user_id_number 
print @user_email


IF @STATUS_AGENDA = 'L'


UPDATE HORARIOS SET			
		  [LIVROID]	= dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.')--(SELECT TOP 1 AUX.COL1 AS LIVRO FROM ##AUX_2 AUX INNER JOIN TT_RESERVATIONS_TMP T ON AUX.APP_LID = T.APP_LID)--@app_lid --(<LIVROID int > -- VERIFICAR COMO NA TT_RESERVATION VAMOS PEGAR SÓ O LIVRO
		 ,[DATA]	= @app_date --<DATA datetime >
		 ,[HORA]	=   dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.')--(SELECT TOP 1 AUX.COL2 AS LIVRO FROM ##AUX_2 AUX INNER JOIN TT_RESERVATIONS_TMP T ON AUX.APP_LID = T.APP_LID) --@APP_LID --cast(@app_start_time as INT) --<HORA int >
		 ,[CONTADOR]	= 0--<CONTADOR int >
		 ,[MEDREAID]	= CASE WHEN CHARINDEX('E', @resource_lid) = 0 THEN CAST(replace(@resource_lid, '_','.') AS int)  ELSE NULL END--<MEDREAID int >
		 ,[HORREQID]	= @HORREQID--(SELECT TOP 1 AUX.COL3 AS LIVRO FROM ##AUX_2 AUX INNER JOIN TT_RESERVATIONS_TMP T ON AUX.APP_LID = T.APP_LID) --CAST(@app_lid AS int)--<HORREQID int >
		 ,[ENCAIXE]	= 'F'--<ENCAIXE varchar(1) >
		 ,[COMPARECEU]= 'F'--<COMPARECEU varchar(1) >
		 --,[PREFAGEID]= '19'--<PREFAGEID int >
		 ,[STATUS] = 'O'--<STATUS varchar(1) >
		 ,[MOTIVOBLOQUEIO] = ''--<MOTIVOBLOQUEIO varchar(60) >
		 ,[MASTERHORA] =	 NULL--<MASTERHORA int >
		 ,[DUPLICAR]	= 'T'--<DUPLICAR varchar(1) >
		 ,[RESHORA]	= GETDATE()--<RESHORA datetime >
		 ,[RESUSUARIO] = 'tuotempo'--<RESUSUARIO varchar(60) >
		 ,[USUARIO] = 482--<USUARIO int >
		 ,[CONFIRMADO] = 'F'--<CONFIRMADO varchar(1) >
		 ,[ULTIMO_USUARIO] = 482--<ULTIMO_USUARIO int >
		 ,[CONFIRMOU_USUARIO] = NULL--<CONFIRMOU_USUARIO int >
		 --,[EQUIPAMENTOID] = @location_lid--<EQUIPAMENTOID int >
		 ,[HORACHEGOU] = NULL--<HORACHEGOU int >
		 ,[REALIZADO] = 'F'--<REALIZADO varchar(1) >
		 ,[CONFIRMOU_DATA] = NULL--<CONFIRMOU_DATA datetime >
		 ,[CONFIRMOU_HORA]= NULL--<CONFIRMOU_HORA int >
		 ,[USUARIO_BLOQUEOU]	= NULL--<USUARIO_BLOQUEOU int >
		 ,[USUARIO_DESBLOQUEOU]	= NULL--<USUARIO_DESBLOQUEOU int >
		 ,[DATAULTIMAATUALIZACAO] = GETDATE()--<DATAULTIMAATUALIZACAO datetime >
		 ,[HORAULTIMAATUALIZACAO] = ' ' -- VERIFICAR CONVERSAO @insert_time--<HORAULTIMAATUALIZACAO int >
		 ,[observbloq] = 'insert'--<observbloq text >
		 ,[obsid] =  NULL--<obsid int >
		 ,[medintervalo]	= NULL--<medintervalo int >
		 ,[ANTECIPAR] =  'F'--<ANTECIPAR char(1) >
		 ,[CONTADOR_INTERVALO] = 123--<CONTADOR_INTERVALO int >
		 ,[INTERVALO] = 20--<INTERVALO int >
		 from inserted I
WHERE 
		
		LIVROID =  dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.') AND
		DATA = @app_date AND
		HORA =  dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.')
	    --I.STATUS = 'L'


PRINT 'LIVRO HORARIOS' PRINT  dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.')

print 'app_lid HORARIOS'
PRINT @APP_LID

		
INSERT INTO [dbo].[HORARIOSREQUISICAO]
           ([UNIDADEID]
           ,[HORREQID]
           ,[DATAAGENDAMENTO]
           ,[HORAAGENDAMENTO]
           ,[PACIENTEID]
           ,[DDD]
           ,[FONE]
           ,[FONETIPO]
           ,[FAX]
           ,[COMPLEMENTOID]
           ,[GUIA]
           ,[SENHAEXAME]
           ,[MEDSOLID]
           ,[UNIDADEPACIENTEID])
     VALUES(
         @location_lid, -- UNIDADEID 
		 @HORREQID, -- (SELECT MAX(HORREQID)+ 1 FROM HORARIOSREQUISICAO),-- PARSENAME(replace(@APP_LID, '_','.'), 1), --HORREQID
		 GETDATE(), -- DATAAGENDAMENTO
		 dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.'), --HORAAGENDAMENTO 
		 @PACIENTEID, --PACIENTEID 
		 SUBSTRING(@user_mobile_phone,1,2), --DDD
		 SUBSTRING(@user_mobile_phone,3,20), --FONE =
		NULL, -- FONETIPO 
		NULL, -- FAX
		2,--COMPLEMENTOID 
		' ', --GUIA 
		' ', --SENHAEXAME
		0, --MEDSOLID 
		0 -- UNIDADEPACIENTEID 
		
		)


		INSERT INTO [dbo].[HORARIOSCLASSAGE]
           ([LIVROID]
			,[HORARIOID]
           ,[DATA]
           ,[HORA]
           ,[CONTADOR]
           ,[CLAGEID])
     VALUES
           (
		    dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.')--<LIVROID, int,>
           ,@HORREQID
		   ,@APP_DATE --<DATA, datetime,>
           ,dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.')--<HORA, int,>
           ,0--<CONTADOR, int,>
           ,3--<EXAMEINDICE, int,>
		   )

	
PRINT 'pacienteid'
PRINT @PACIENTEID
PRINT dbo.GetStringParts(replace(@APP_LID, '_','.'),3,'.')

SET @APP_LID_OLD = @APP_LID

PRINT 'APP_LID_OLD E APP_LID'
PRINT @APP_LID_OLD
PRINT @APP_LID

UPDATE 
TT_RESERVATIONS_TMP SET APP_LID = 
(SELECT TOP 1
CAST(H.LIVROID AS varchar)  + '_' +  CAST(H.HORA AS varchar) + '_' +  CAST(@HORREQID AS varchar)+ '_' + CAST(HR.UNIDADEID AS varchar)
FROM HORARIOS H
	INNER JOIN HORARIOSREQUISICAO HR ON HR.HORREQID =@HORREQID
WHERE 
		H.LIVROID = dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.') AND
		HR.UNIDADEID = dbo.GetStringParts(replace(@APP_LID, '_','.'),5,'.') AND
		H.HORA = dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.')
)
WHERE APP_LID = @APP_LID_OLD

PRINT 'UPDATE'
PRINT @HORREQID
PRINT dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.') --LIVRO
PRINT dbo.GetStringParts(replace(@APP_LID, '_','.'),5,'.')  -- UNIDADE
PRINT dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.')  -- HORA
PRINT @APP_LID_OLD
PRINT @APP_LID




--END -- FIM VALIDACAO PACIENTE  44510_13_71400_ _8 ----13_71400_668798_8
	

SET @APP_LID_NEW = (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),4,'.') = @HORREQID)
SET @LIVRO =       (SELECT TOP 1 SUBSTRING(APP_LID, 0,3) FROM  TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),3,'.') =  dbo.GetStringParts(replace(@APP_LID_NEW, '_','.'),3,'.'))
SET @HORA =        (SELECT TOP 1 SUBSTRING(APP_LID, 4,5) FROM  TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),3,'.') =  dbo.GetStringParts(replace(@APP_LID_NEW, '_','.'),3,'.'))
SET @UNIDADE =     (SELECT TOP 1 SUBSTRING(APP_LID, 17,2) FROM  TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),3,'.') =  dbo.GetStringParts(replace(@APP_LID_NEW, '_','.'),3,'.'))
SET @DATA =        (SELECT TOP 1 LEFT(@APP_LID_OLD, 5)) 

PRINT @APP_LID_NEW
print 'new'

--(SELECT TOP 1 APP_LID FROM TT_RESERVATIONS_TMP WHERE @HORREQID =PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 2))



-- INSERINDO OBSERVACAO DO AGENDAMENTO	
INSERT INTO [dbo].[HORARIOSDADOS]
           ([LIVROID]
           ,[DATA]
           ,[HORA]
           ,[CONTADOR]
           ,[MEDSOLID]
           ,[CONVENIOID]
           ,[PLANOID]
           ,[PROCEDENCIAID]
           ,[OBS]
           ,[OBSID]
           ,[CONVENIOASSOCIADOID]
           ,[FRANQUIAID])
     VALUES
           (
		   dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.') --<LIVROID, int,>
           ,@APP_DATE --<DATA, datetime,>
           ,dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.') --<HORA, int,>
           ,0--<CONTADOR, int,>
           ,0--<MEDSOLID, int,>
           ,PARSENAME(replace(@insurance_lid, '_','.'), 3)--<CONVENIOID, int,>
           ,PARSENAME(replace(@insurance_lid, '_','.'), 1)--<PLANOID, int,>
           ,11--<PROCEDENCIAID, int,>
           ,'AGENDADO PELO TUOTEMPO'--<OBS, text,>
           ,1--<OBSID, int,>
           ,0--<CONVENIOASSOCIADOID, int,>
           ,0--<FRANQUIAID, int,>
		   )




-- INSERINDO EXAME X HORARIOS

INSERT INTO [dbo].[HORARIOSEXAMES]
           ([LIVROID]
           ,[DATA]
           ,[HORA]
           ,[CONTADOR]
           ,[EXAMEINDICE]
           ,[PROCID]
           ,[GUIA]
           ,[SENHA])
     VALUES
           (
		   dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.')--<LIVROID, int,>
           ,@APP_DATE --<DATA, datetime,>
           ,dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.')--<HORA, int,>
           ,0--<CONTADOR, int,>
           ,0--<EXAMEINDICE, int,>
           ,@activity_lid--<PROCID, int,>
           ,' '--<GUIA, varchar(30),>
           ,' '--<SENHA, varchar(20),>
		   )





set @app_custom_1_old = dbo.GetStringParts(replace(@APP_LID, '_','.'),3,'.')
SET @app_custom_2_old = dbo.GetStringParts(replace(@APP_LID, '_','.'),3,'.')
set @app_custom_1_old = (SELECT TOP 1 HORA FROM HORARIOS WHERE HORREQID = dbo.GetStringParts(replace(@APP_LID, '_','.'),4,'.') AND LIVROID = dbo.GetStringParts(replace(@APP_LID, '_','.'),2,'.')  ORDER BY DATAULTIMAATUALIZACAO);


print @app_lid
print @app_lid_new
print @app_lid_old

END


BEGIN
IF @STATUS_AGENDA <> 'L'
ROLLBACK 


END

IF @app_action='UPDATE'
IF @status = 'CONFIRMED'
BEGIN





SET @APP_LID_NEW = (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),4,'.') = @HORREQID)
SET @LIVRO =       (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),4,'.') = @HORREQID)--(SELECT TOP 1 SUBSTRING(APP_LID, 0,3) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID,0,16), '_','.'), 1))
SET @HORA =        (SELECT TOP 1 SUBSTRING(APP_LID, 4,5) FROM  TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),1,'.') =  dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.'))
SET @UNIDADE =     (SELECT TOP 1 SUBSTRING(APP_LID, 17,2) FROM  TT_RESERVATIONS_TMP WHERE dbo.GetStringParts(replace(APP_LID, '_','.'),1,'.') =  dbo.GetStringParts(replace(@APP_LID, '_','.'),1,'.'))
SET @DATA =        (SELECT TOP 1 LEFT(@APP_LID_OLD, 5)) 


SET @HORREQID = PARSENAME(SUBSTRING(replace(@app_lid, '_','.'), 1,50), 2);
PRINT 'HORREQID'
PRINT @HORREQID;



SET @LIVRO_OLD =       (SELECT 
						TOP 1 PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 4) FROM  
						TT_RESERVATIONS_TMP 
						WHERE 
						PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 2)=@HORREQID AND (PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 3)!=@HORA OR  CONVERT(DATE,APP_DATE, 103)!=@app_date )
						ORDER BY INSERT_TIME DESC
					)
SET @HORA_OLD =        (SELECT 
						TOP 1 PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 3) FROM  
						TT_RESERVATIONS_TMP 
						WHERE 
						PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 2)=@HORREQID AND (PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 3)!=@HORA OR  CONVERT(DATE,APP_DATE, 103)!=@app_date )
						ORDER BY INSERT_TIME DESC)
						
						
SET @UNIDADE_OLD =     (SELECT TOP 1 PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 1) FROM  
						TT_RESERVATIONS_TMP 
						WHERE 
						PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 2)=@HORREQID AND (PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 3)!=@HORA OR  CONVERT(DATE,APP_DATE, 103)!=@app_date )  --AND APP_LID!=@app_lid
						ORDER BY INSERT_TIME DESC)

SET @DATA_OLD = (SELECT TOP 1 CONVERT(DATE,APP_DATE, 103) FROM  
						TT_RESERVATIONS_TMP 
						WHERE 
						PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 2)=@HORREQID AND (PARSENAME(SUBSTRING(replace(APP_LID, '_','.'), 1,50), 3)!=@HORA OR  CONVERT(DATE,APP_DATE, 103)!=@app_date )
						ORDER BY INSERT_TIME DESC)


SET @APP_LID_NEW = (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) = @HORREQID-1)




/*RESERVAR HORARIO NOVO*/
UPDATE [dbo].[HORARIOS] SET

		 [CONFIRMADO] = 'T'--<CONFIRMADO varchar(1) >

FROM HORARIOS 		
WHERE 

LIVROID = PARSENAME(replace(@APP_LID, '_','.'), 4)  AND HORA = PARSENAME(replace(@APP_LID, '_','.'), 3) AND DATA = @APP_DATE
END




IF @app_action='delete'
BEGIN

/*LIBERANDO HORARIO*/
UPDATE [dbo].[HORARIOS] SET
 [CONTADOR]	= 0--<CONTADOR int >
,[MEDREAID]	= CASE WHEN CHARINDEX('E', @resource_lid) = 0 THEN CAST(replace(@resource_lid, '_','.') AS int) ELSE CAST(replace(@resource_lid, 'E','.') AS int) END--<MEDREAID int >
,[HORREQID]	= NULL--<HORREQID int >
,[ENCAIXE]	= 'F'--<ENCAIXE varchar(1) >
,[COMPARECEU]= 'F'--<COMPARECEU varchar(1) >
--,[PREFAGEID]= NULL--<PREFAGEID int >
,[STATUS] = 'L'--<STATUS varchar(1) >
,[MOTIVOBLOQUEIO] = ''--<MOTIVOBLOQUEIO varchar(60) >
,[MASTERHORA] = NULL--<MASTERHORA int >
,[DUPLICAR]	= 'T'--<DUPLICAR varchar(1) >
,[RESHORA]	= NULL--<RESHORA datetime >
,[RESUSUARIO] = NULL--<RESUSUARIO varchar(60) >
,[USUARIO] = NULL--<USUARIO int >
,[CONFIRMADO] = 'F'--<CONFIRMADO varchar(1) >
,[ULTIMO_USUARIO] = NULL--<ULTIMO_USUARIO int >
,[CONFIRMOU_USUARIO] = NULL--<CONFIRMOU_USUARIO int >
,[EQUIPAMENTOID] = @location_lid--<EQUIPAMENTOID int >
,[HORACHEGOU] = NULL--<HORACHEGOU int >
,[REALIZADO] = 'F'--<REALIZADO varchar(1) >
,[CONFIRMOU_DATA] = NULL--<CONFIRMOU_DATA datetime >
,[CONFIRMOU_HORA]= NULL--<CONFIRMOU_HORA int >
,[USUARIO_BLOQUEOU]	= NULL--<USUARIO_BLOQUEOU int >
,[USUARIO_DESBLOQUEOU]	= NULL--<USUARIO_DESBLOQUEOU int >
,[DATAULTIMAATUALIZACAO] = NULL--<DATAULTIMAATUALIZACAO datetime >
,[HORAULTIMAATUALIZACAO] = ' ' -- VERIFICAR CONVERSAO @insert_time--<HORAULTIMAATUALIZACAO int >
,[observbloq] = 'HORARIO ALTERADO'--<observbloq text >
,[obsid] =  NULL--<obsid int >
,[medintervalo]	= NULL--<medintervalo int >
,[ANTECIPAR] =  NULL--<ANTECIPAR char(1) >
,[CONTADOR_INTERVALO] = 121--<CONTADOR_INTERVALO int >
,[INTERVALO] = 20--<INTERVALO int >
FROM HORARIOS

WHERE 
LIVROID = PARSENAME(replace(@APP_LID, '_','.'), 4) AND HORA = PARSENAME(replace(@APP_LID, '_','.'), 3) AND DATA = @app_datE AND HORREQID = PARSENAME(replace(@APP_LID, '_','.'), 2)


PRINT @RESOURCE_LID

/* DELETANDO HORARIOSREQUISICAO */

delete from horariosrequisicao where horreqid=PARSENAME(replace(@APP_LID, '_','.'), 2) and horaagendamento = PARSENAME(replace(@APP_LID, '_','.'), 3) AND UNIDADEID = @location_lid
DELETE FROM HORARIOSDADOS WHERE LIVROID = PARSENAME(replace(@APP_LID, '_','.'), 4) AND HORA = PARSENAME(replace(@APP_LID, '_','.'), 3) AND DATA = @APP_DATE 
DELETE FROM HORARIOSEXAMES WHERE LIVROID = PARSENAME(replace(@APP_LID, '_','.'), 4) AND HORA = PARSENAME(replace(@APP_LID, '_','.'), 3) AND DATA = @APP_DATE 
END

END





GO


