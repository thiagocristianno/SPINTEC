USE [Xclinic_HML]
GO
/****** Object:  Trigger [dbo].[TT_RESERVATIONS_TMP_INSERT]    Script Date: 16/05/2022 15:22:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER TRIGGER [dbo].[TT_RESERVATIONS_TMP_INSERT] 
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
	  
      @user_street NVARCHAR (500),
      @user_street_number NVARCHAR (50),
      @user_city NVARCHAR (100),
      @user_provincy NVARCHAR (100),
      @user_region NVARCHAR (50),
      @user_country NVARCHAR (50),
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
	 @PACIENTEID INT,
	 @tempo_exec_proc INT,
	 @tempo_exec_med INT,
	 @tempo_exec INT,
	 @hora_intervalo AS VARCHAR(10),
	 @intervalo_horario INT,
	 @intervalo_agendamento INT,
	 @tempoMedPadrao varchar(1)

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
	  @user_street= USER_STREET,
	  @user_street_number= USER_STREET_NUMBER,
	  @user_city= USER_CITY,
	  @user_provincy= USER_PROVINCE,
	  @user_region= 
				case 
					when LEN(USER_REGION) = 2 
					then USER_REGION 
				else
					case USER_REGION
						when 'Acre' then 'AC' 
						when 'Alagoas' then 'AL'
						when 'Amapa' then 'AP'
						when 'Amazonas' then 'AM'
						when 'Bahia' then 'BA'
						when 'Ceara' then 'CE'
						when 'Espirito Santo' then 'ES'
						when 'Goias' then 'GO'
						when 'Maranhao' then 'MA'
						when 'Mato Grosso' then 'MT'
						when 'Mato Grosso do Sul' then 'MS'
						when 'Minas Gerais' then 'MG'
						when 'Para' then 'PA'
						when 'Paraiba' then 'PB'
						when 'Parana' then 'PR'
						when 'Pernambuco' then 'PE'
						when 'Piaui' then 'PI'
						when 'Rio de Janeiro' then 'RJ'
						when 'Rio Grande do Norte' then 'RN'
						when 'Rio Grande do Sul' then 'RS'
						when 'Rondonia' then 'RO'
						when 'Roraima' then 'RR'
						when 'Santa Catarina' then 'SC'
						when 'Sao Paulo' then 'SP'
						when 'Sergipe' then 'SE'
						when 'Tocantins' then 'TO'
						when 'Distrito Federal' then 'DF'
					else 'XX' end 
				end,
	  @user_country= USER_COUNTRY,

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



--pega o proximo id  de agendamentos
set @HORREQID = (SELECT VALOR+1 FROM SEQUENCIAS WHERE TABELA='HORARIOSREQUISICAO');
exec dbo.SP_SEQUENCIA 'HORARIOSREQUISICAO',@HORREQID;

--verifica se o paciente existe
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


--Caso o paciente não exista, irá inserir um novo paciente.
IF @user_exist = 0	
BEGIN

     --pega o próximo id
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
		, @user_date_of_birth
		,NULL--<IDADE, int,>
		,@user_gender--<SEXO, varchar(1),>
		,@user_id_number --<DOCUMENTO, varchar(40),>
		,NULL--<ESTADOCIVIL, varchar(10),>
		,'1900-01-01 00:00:00.000'--<DUM, datetime,>
		,@app_custom_0--<PESO, float,>
		,@app_custom_1--<ALTURA, float,>
		,substring(@user_street,0,60)--<ENDERECO, varchar(60),>
		,substring(@user_street_number,0,6)--<NUMERO, varchar(6),>
		,NULL--<COMPLEMENTO, varchar(30),>
		,substring(@user_provincy,0,30)--<BAIRRO, varchar(30),>
		,substring(@user_city,0,30)--<CIDADE, varchar(30),>
		,substring(@user_region,0,30)--<ESTADO, varchar(2),> 
		,@user_zip_code--  <CEP, varchar(9),>
		,@app_custom_2 --<CONFIGURAVEL1, char(255),>
		,'' --<CONFIGURAVEL2, char(255),>
		,'04'--<CONFIGURAVEL3, char(255),>
		,@user_email--<EMAIL, varchar(100),>
		,PARSENAME(replace(cast(@insurance_lid  as varchar), '_','.'), 3)  --<CONVENIOID, int,>
		,@user_first_name + ' '+ @user_second_name --<TITULAR, varchar(60),>
		,'666666'--<MATRICULA, varchar(30),>
		,GETDATE() --<DATACADASTRO, datetime,>
		,GETDATE() --<DATAATUALIZADO, datetime,>
		,CAST(PARSENAME(replace(CAST(@insurance_lid AS VARCHAR), '_','.'), 1)AS varchar) --<PLANOID, int,>
		,SUBSTRING(@user_mobile_phone,1,2) --<DDD, varchar(5),>
		,@user_mobile_phone --@user_landline_phone --<TELEFONE, varchar(20),>
		,'L' --<TELEFONETIPO, varchar(10),>
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
		,1--<TIPODOCID, int,>
		,'F'--<GESTANTE, char(1),>
		,'A'--<STATUS, char(1),>
		,'0X20'--<FOTO, image,>
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



IF @app_action='add'
BEGIN 
			
--IF @user_exist = 1 

-- Inicio verificação de Tempo de Execução
	-- Boleano de tempo padrao do Medico.
	set @tempoMedPadrao = (select TEMPOPADRAO from MEDICOSPROCEDIMENTOS where 
		procid = PARSENAME(replace(@activity_lid, '_','.'), 2) and 
		medicoid = CASE WHEN CHARINDEX('E', @resource_lid) = 0 THEN CAST(replace(@resource_lid, '_','.') AS int)  ELSE NULL END);

	--Selects para pegar os valores de tempo de execução.
	--Verificar se o boleano de tempo Padrao não interfere na ordem
	
	--Tempo de Execução dos Procedimentos.
	set @tempo_exec_proc = (select coalesce(TEMPOEXECUCAO,0) from procedimentos where procid = PARSENAME(replace(@activity_lid, '_','.'), 2));
	set @tempo_exec_proc = coalesce(@tempo_exec_proc,0);

	--Tempo de Execução dos Medicos.
	set @tempo_exec_med = (select coalesce(TEMPOEXECMED,0) from MEDICOSPROCEDIMENTOS where 
		procid = PARSENAME(replace(@activity_lid, '_','.'), 2) and 
		medicoid = CASE WHEN CHARINDEX('E', @resource_lid) = 0 THEN CAST(replace(@resource_lid, '_','.') AS int)  ELSE NULL END);
	set @tempo_exec_med = coalesce(@tempo_exec_med,0);

	if (@tempo_exec_med > @tempo_exec_proc)
		set @tempo_exec = @tempo_exec_med 
	else
		set @tempo_exec = @tempo_exec_proc
	end;


	SET @intervalo_horario = (SELECT INTERVALO FROM HORARIOS WITH(NOLOCK) WHERE 		
		LIVROID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4) AND
		DATA = @app_date AND
		HORA = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3))

	set @intervalo_agendamento=@intervalo_horario

while @intervalo_agendamento <= @tempo_exec
BEGIN
set @hora_intervalo =  (SELECT top 1 HORA FROM HORARIOS WITH(NOLOCK) WHERE 		
		LIVROID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4) AND
		DATA = @app_date AND
		cast(HORA as int) >= cast(PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3) as int)
		and HORREQID is null
		order by cast(HORA as int) asc)

		print '@hora_intervalo'
		print @hora_intervalo


SET @STATUS_AGENDA = (SELECT  TOP 1 A.STATUS FROM HORARIOS A WHERE  
A.HORA = @hora_intervalo --PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3) 
AND DATA =  @app_date AND A.LIVROID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4))
SET @PACIENTEID = (SELECT TOP 1 PACIENTEID FROM PACIENTE WHERE   DATANASC  = @user_date_of_birth AND DOCUMENTO = @user_id_number AND EMAIL = @user_email)	

/*
print 'data_nascimento'
print @user_date_of_birth
print @user_id_number 
print @user_email
*/

IF @STATUS_AGENDA = 'L'

UPDATE HORARIOS SET			
		  [LIVROID]	=PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4)--(SELECT TOP 1 AUX.COL1 AS LIVRO FROM ##AUX_2 AUX INNER JOIN TT_RESERVATIONS_TMP T ON AUX.APP_LID = T.APP_LID)--@app_lid --(<LIVROID int > -- VERIFICAR COMO NA TT_RESERVATION VAMOS PEGAR SÓ O LIVRO
		 ,[DATA]	= @app_date --<DATA datetime >
		 ,[HORA]	=  @hora_intervalo --PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)--(SELECT TOP 1 AUX.COL2 AS LIVRO FROM ##AUX_2 AUX INNER JOIN TT_RESERVATIONS_TMP T ON AUX.APP_LID = T.APP_LID) --@APP_LID --cast(@app_start_time as INT) --<HORA int >
		 ,[CONTADOR]	= 0--<CONTADOR int >
		 ,[MEDREAID]	= CASE WHEN CHARINDEX('E', @resource_lid) = 0 THEN CAST(replace(@resource_lid, '_','.') AS int)  ELSE NULL END--<MEDREAID int >--<MEDREAID int >
		 ,[HORREQID]	= @HORREQID--(SELECT TOP 1 AUX.COL3 AS LIVRO FROM ##AUX_2 AUX INNER JOIN TT_RESERVATIONS_TMP T ON AUX.APP_LID = T.APP_LID) --CAST(@app_lid AS int)--<HORREQID int >
		 ,[ENCAIXE]	= 'F'--<ENCAIXE varchar(1) >
		 ,[COMPARECEU]= 'F'--<COMPARECEU varchar(1) >
		 ,[PREFAGEID]= '19'--<PREFAGEID int >
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
		 ,[INTERVALO] = @intervalo_horario --<INTERVALO int >
		 from inserted I
WHERE 
		
		LIVROID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4) AND
		DATA = @app_date AND
		HORA = @hora_intervalo --PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)
	    --I.STATUS = 'L'

/*
PRINT 'LIVRO HORARIOS' PRINT PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4)
print 'app_lid HORARIOS'
PRINT @APP_LID
*/


PRINT 'pacienteid'
PRINT @PACIENTEID
PRINT PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)

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
		H.LIVROID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4) AND
		HR.UNIDADEID =PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 1)AND
		H.HORA = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)
)
WHERE APP_LID = @APP_LID_OLD
PRINT 'multiplos horarios'

print(@intervalo_agendamento)
print(@intervalo_horario)


IF (@intervalo_horario=@intervalo_agendamento)
BEGIN
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
		 PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3), --HORAAGENDAMENTO 
		 @PACIENTEID, --PACIENTEID 
		 NULL, --DDD
		 NULL, --FONE =
		NULL, -- FONETIPO 
		NULL, -- FAX
		2,--COMPLEMENTOID 
		' ', --GUIA 
		' ', --SENHAEXAME
		0, --MEDSOLID 
		0 -- UNIDADEPACIENTEID 		
		)

/*
PRINT 'UPDATE'
PRINT @HORREQID
PRINT PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4) --LIVRO
PRINT PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 1) -- UNIDADE
PRINT PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3) -- HORA
PRINT @APP_LID_OLD
PRINT @APP_LID
*/



--END -- FIM VALIDACAO PACIENTE  44510_13_71400_ _8 ----13_71400_668798_8
	

SET @APP_LID_NEW = (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) = @HORREQID)
SET @LIVRO =       (SELECT TOP 1 SUBSTRING(APP_LID, 0,3) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID_NEW,0,16), '_','.'), 1))
SET @HORA =        (SELECT TOP 1 SUBSTRING(APP_LID, 4,5) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID_NEW,0,16), '_','.'), 1))
SET @UNIDADE =     (SELECT TOP 1 SUBSTRING(APP_LID, 17,2) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID_NEW,0,16), '_','.'), 1))
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
		   PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4)--<LIVROID, int,>
           ,@APP_DATE --<DATA, datetime,>
           ,PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)--<HORA, int,>
           ,0--<CONTADOR, int,>
           ,0--<MEDSOLID, int,>
           ,PARSENAME(replace(@insurance_lid, '_','.'), 3)--<CONVENIOID, int,>
           ,PARSENAME(replace(@insurance_lid, '_','.'), 1)--<PLANOID, int,>
           ,1--<PROCEDENCIAID, int,>
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
		   PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4)--<LIVROID, int,>
           ,@APP_DATE --<DATA, datetime,>
           ,PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)--<HORA, int,>
           ,0--<CONTADOR, int,>
           ,0--<EXAMEINDICE, int,>
           ,PARSENAME(replace(@activity_lid, '_','.'), 2)--<PROCID, int,>
           ,' '--<GUIA, varchar(30),>
           ,' '--<SENHA, varchar(20),>
		   )

set @app_custom_1_old = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 3)
SET @app_custom_2_old = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 2)
set @app_custom_1_old = (SELECT TOP 1 HORA FROM HORARIOS WHERE HORREQID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 2) AND LIVROID = PARSENAME(SUBSTRING(replace(@APP_LID, '_','.'), 7,20), 4) ORDER BY DATAULTIMAATUALIZACAO);


print @app_lid
print @app_lid_new
print @app_lid_old

END
END /*FIM IF AGENDA DISPONIVEL*/
set @intervalo_agendamento=@intervalo_agendamento+@intervalo_horario
END /* FIM WHILE INTERVALO*/

BEGIN

IF @STATUS_AGENDA <> 'L'
ROLLBACK 
END

/*
IF @app_action='UPDATE'
IF @status = 'CONFIRMED'
BEGIN

SET @APP_LID_NEW = (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) = @HORREQID)
SET @LIVRO =       (SELECT TOP 1 APP_LID  FROM TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 4) = @HORREQID)--(SELECT TOP 1 SUBSTRING(APP_LID, 0,3) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID,0,16), '_','.'), 1))
SET @HORA =        (SELECT TOP 1 SUBSTRING(APP_LID, 4,5) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID,0,16), '_','.'), 1))
SET @UNIDADE =     (SELECT TOP 1 SUBSTRING(APP_LID, 17,2) FROM  TT_RESERVATIONS_TMP WHERE PARSENAME(REPLACE(SUBSTRING(APP_LID,0,16), '_','.'), 1) =  PARSENAME(REPLACE(SUBSTRING(@APP_LID,0,16), '_','.'), 1))
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
*/



IF @app_action='delete'
BEGIN

/*LIBERANDO HORARIO*/
UPDATE [dbo].[HORARIOS] SET
 [CONTADOR]	= 0--<CONTADOR int >
,[MEDREAID]	= CASE WHEN CHARINDEX('E', @resource_lid) = 0 THEN CAST(replace(@resource_lid, '_','.') AS int)  ELSE NULL END--<MEDREAID int >
,[HORREQID]	= NULL--<HORREQID int >
,[ENCAIXE]	= 'F'--<ENCAIXE varchar(1) >
,[COMPARECEU]= 'F'--<COMPARECEU varchar(1) >
,[PREFAGEID]= NULL--<PREFAGEID int >
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

--PRINT @RESOURCE_LID

/* DELETANDO HORARIOSREQUISICAO */
delete from horariosrequisicao where horreqid=PARSENAME(replace(@APP_LID, '_','.'), 2) and horaagendamento = PARSENAME(replace(@APP_LID, '_','.'), 3) AND UNIDADEID = @location_lid
DELETE FROM HORARIOSDADOS WHERE LIVROID = PARSENAME(replace(@APP_LID, '_','.'), 4) AND HORA = PARSENAME(replace(@APP_LID, '_','.'), 3) AND DATA = @APP_DATE 
DELETE FROM HORARIOSEXAMES WHERE LIVROID = PARSENAME(replace(@APP_LID, '_','.'), 4) AND HORA = PARSENAME(replace(@APP_LID, '_','.'), 3) AND DATA = @APP_DATE 

END






