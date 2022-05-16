USE [smart_homolog]
GO

/****** Object:  Trigger [dbo].[TT_RESERVATIONS_TMP_INSERT]    Script Date: 11/05/2022 14:59:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER TRIGGER [dbo].[TT_RESERVATIONS_TMP_INSERT]
   ON  [dbo].[TT_RESERVATIONS_TMP] 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	declare 
	@USER_EXIST INT,
	@APP_LID nvarchar(50),
	@APP_TID nvarchar(50),
	@APP_ACTION nchar(10),
	@APP_DATE nchar(10),
	@APP_START_TIME nchar(5),
	@APP_END_TIME nchar(5),
	@APP_PRICE nvarchar(20),
	@USER_LID varchar(50), -- Paciente Id
	@USER_ID_NUMBER varchar(50), -- Paciente CPF
	@USER_DATE_OF_BIRTH Date, -- Paciente Data Aniversario
	@USER_TID nvarchar(50),
	@USER_FIRST_NAME NVARCHAR(50),
	@USER_SECOND_NAME NVARCHAR(50),
	@USER_THIRD_NAME nvarchar(50),
	@USERNAME nvarchar(150),
	@USER_LANDLINE_PHONE nvarchar(50),
	@USER_MOBILE_PHONE nvarchar(50),
	@USER_EMAIL nvarchar(50),
	@USER_GENDER nvarchar(50),
	@USER_ZIP_CODE nvarchar(50),
	@USER_STREET nvarchar(50),
	@USER_STREET_NUMBER nvarchar(50),
	@USER_CITY nvarchar(50),
	@USER_PROVINCE nvarchar(50),
	@USER_REGION nvarchar(50),
	@USER_COUNTRY nvarchar(50),
	@USER_WORK_PHONE nvarchar(50),
	@USER_NOTES nvarchar(50),
	@USER_LANGUAGE nvarchar(50),
	@RESOURCE_LID nvarchar(50),
	@ACTIVITY_LID nvarchar(50),
	@INSURANCE_LID nvarchar(50),
	@LOCATION_LID nvarchar(50),
	@STATUS nvarchar(50),
	@NOTES nvarchar(500),
	@APP_OWNER_LID nvarchar(50),
	@APP_OWNER_TID nvarchar(50),
	@APP_OWNER_NAME nvarchar(50),
	@STATUS_TRIGGER nvarchar(4000),
	@INSERT_TIME datetime,
	@APP_CUSTOM_0 nvarchar(500),
	@APP_CUSTOM_1 nvarchar(500),
	@APP_CUSTOM_2 nvarchar(500),
	@APP_CUSTOM_3 nvarchar(500),
	@APP_CUSTOM_4 nvarchar(500),
	@STATUS_AGENDA INT,
	@PACIENTEID INT,
	@TPSMK nvarchar(2),
	@DATAINICIO DateTime,
	@DATAFIM DateTime
	;
		
	select 
	@APP_LID = APP_LID, 
	@APP_TID = APP_TID, 
	@APP_ACTION = APP_ACTION, 
	@APP_DATE = APP_DATE, 
	@APP_START_TIME = APP_START_TIME, 
	@APP_END_TIME = APP_END_TIME, 
	@APP_PRICE = APP_PRICE, 
	@USER_LID = USER_LID,
	@USER_ID_NUMBER = USER_ID_NUMBER, 
	@USER_DATE_OF_BIRTH  = CONVERT(DATE, USER_DATE_OF_BIRTH, 103),
	@USER_TID = USER_TID,
	@USER_FIRST_NAME = USER_FIRST_NAME,
	@USER_SECOND_NAME = USER_SECOND_NAME,
	@USER_THIRD_NAME = USER_THIRD_NAME,
	@USERNAME = USER_FIRST_NAME + ' ' + USER_SECOND_NAME + ' ' + USER_THIRD_NAME,
	@USER_LANDLINE_PHONE = USER_LANDLINE_PHONE,
	@USER_MOBILE_PHONE = USER_MOBILE_PHONE,
	@USER_EMAIL = USER_EMAIL,
	@USER_GENDER = USER_GENDER,
	@USER_ZIP_CODE = USER_ZIP_CODE,
	@USER_STREET = USER_STREET,
	@USER_STREET_NUMBER = USER_STREET_NUMBER,
	@USER_CITY = USER_CITY,
	@USER_PROVINCE = USER_PROVINCE,
	@USER_REGION = 
	case 
				when LEN(USER_REGION) = 2 then USER_REGION 
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
	@USER_COUNTRY = USER_COUNTRY,
	@USER_WORK_PHONE = USER_WORK_PHONE,
	@USER_NOTES = USER_NOTES,
	@USER_LANGUAGE = USER_LANGUAGE,
	@INSURANCE_LID = INSURANCE_LID,
	@RESOURCE_LID  = RESOURCE_LID,
	@ACTIVITY_LID  = ACTIVITY_LID,
	@LOCATION_LID  = LOCATION_LID,
	@STATUS  = STATUS,
	@NOTES  =  NOTES,
	@APP_OWNER_LID  = APP_OWNER_LID,
	@APP_OWNER_TID  = APP_OWNER_TID,
	@APP_OWNER_NAME = APP_OWNER_NAME,
	@STATUS_TRIGGER = STATUS_TRIGGER,
	@INSERT_TIME    = INSERT_TIME,
	@APP_CUSTOM_0   = APP_CUSTOM_0,
	@APP_CUSTOM_1   = APP_CUSTOM_1,
	@APP_CUSTOM_2   = APP_CUSTOM_2,
	@APP_CUSTOM_3   = APP_CUSTOM_3,
	@APP_CUSTOM_4   = APP_CUSTOM_4,
	@USER_EXIST = 0,
	@DATAINICIO = cast(CONVERT(DATE, @APP_DATE, 103) as varchar) + ' ' + @APP_START_TIME,
	@DATAFIM = cast(CONVERT(DATE, @APP_DATE, 103) as varchar) + ' ' + @APP_END_TIME

	from inserted;


	IF (@USER_LID <> 0)
		SELECT @USER_EXIST = COUNT(1) FROM PAC WHERE PAC_REG = @USER_LID;
	
	IF (@USER_EXIST = 0)
		select @USER_EXIST = COUNT(1) from PAC pac where pac.PAC_NUMCPF = @USER_ID_NUMBER and pac.PAC_NASC = @USER_DATE_OF_BIRTH;

	print 'Quantidade de Usuarios: ' + cast(@USER_EXIST as varchar)

	IF (@USER_EXIST = 0)
	BEGIN -- INICIO CADASTRO PACIENTE
		SELECT @USER_LID = CNT_NUM+1 FROM CNT WHERE CNT_TIPO = 'PAC'
	print 'Criar novo paciente.' 
		--select * from PAC order by PAC_REG desc

		INSERT INTO [dbo].[PAC]
           ([PAC_REG]
           ,[PAC_DREG]
           ,[PAC_PRONT]
           ,[PAC_NOME]
           ,[PAC_SEXO]
           ,[PAC_NASC]
           ,[PAC_FONE]
           ,[PAC_CNV]
           ,[PAC_MCNV]
           ,[PAC_TIT]
           ,[PAC_PESO]
           ,[PAC_ALT]
           ,[PAC_DULT]
           ,[PAC_FALTA]
           ,[PAC_END]
           ,[PAC_COMP]
           ,[PAC_CEP]
           ,[PAC_CID]
           ,[PAC_UF]
           ,[PAC_CNV_COD]
           ,[PAC_PLN_COD]
           ,[PAC_DT_ULT_FALTA]
           ,[PAC_EST_CIVIL]
           ,[PAC_NOME_MAE]
           ,[PAC_ABORH]
           ,[PAC_PAC_REG]
           ,[PAC_LOTACAO]
           ,[PAC_DTCNV_PAG]
           ,[PAC_DTCNV_VAL]
           ,[PAC_COD_DEPCNV]
           ,[PAC_CNV2]
           ,[PAC_MCNV2]
           ,[PAC_CNV2_COD]
           ,[PAC_PLN2_COD]
           ,[PAC_PRO_COD]
           ,[PAC_NUMRG]
           ,[PAC_NUMCPF]
           ,[PAC_COD_FON]
           ,[PAC_DT_VALID]
           ,[PAC_VALID]
           ,[PAC_CDE_COD]
           ,[PAC_FONE2]
           ,[PAC_RAMAL]
           ,[PAC_MEDICO]
           ,[PAC_DIAG_CID]
           ,[PAC_DIAG_TPCID]
           ,[PAC_PESSOA]
           ,[PAC_PRONT_STATUS]
           ,[PAC_TIT2]
           ,[PAC_LTA_COD]
           ,[PAC_MATR_EMP]
           ,[PAC_PRO_COD_OCUP]
           ,[PAC_NUMRG_ORG]
           ,[PAC_NUMRG_UF]
           ,[PAC_END_NUM]
           ,[PAC_ZONA]
           ,[PAC_EMAIL]
           ,[PAC_USR_LOGIN_CAD]
           ,[PAC_COD_FON_B]
           ,[PAC_PRONT_LOC]
           ,[PAC_CLE_COD]
           ,[PAC_DT_OBITO]
           ,[PAC_TRAT]
           ,[PAC_CELULAR]
           ,[PAC_GFC_NUM]
           ,[PAC_CCE_NUM]
           ,[PAC_SO_CRIT_CONV]
           ,[PAC_SO_DT_ADM]
           ,[PAC_SO_DT_INI_FUNC]
           ,[PAC_SO_MES_PER]
           ,[PAC_SO_CNV_COD]
           ,[PAC_SO_STATUS]
           ,[PAC_DT_VALID2]
           ,[PAC_CIMP_PRIORIDADE]
           ,[PAC_REG_EXTERNO1]
           ,[PAC_REG_EXTERNO2]
           ,[PAC_REG_EXTERNO3]
           ,[PAC_PRONT_EXTERNO]
           ,[PAC_CTPS]
           ,[PAC_NIT]
           ,[PAC_REG_EXTERNO4]
           ,[PAC_W_LOGIN]
           ,[PAC_W_SENHA]
           ,[PAC_COD_DEPCNV2]
           ,[PAC_MATR_EMP2]
           ,[PAC_CONTATO_DIA]
           ,[PAC_CONTATO_TURNO]
           ,[PAC_CONTATO_OBS]
           ,[PAC_SO_STATUS_MOTIVO]
           ,[PAC_OBS]
           ,[PAC_PRONT_DTHR]
           ,[PAC_PRONT_USR_LOGIN]
           ,[PAC_PRONT_IND_GERA]
           ,[PAC_SO_BRPDH]
           ,[PAC_OBS2]
           ,[PAC_CARTAO_SUS]
           ,[PAC_NUMRG_DTEXP]
           ,[PAC_ALERTA]
           ,[PAC_ALERTA_USR_LOGIN]
           ,[PAC_ALERTA_DTHR]
           ,[PAC_IMG_COD_FOTO]
           ,[PAC_SUS_SISCEL]
           ,[PAC_CNES_ORIGEM]
           ,[PAC_OCUP_VINC]
           ,[PAC_LGR_COD]
           ,[PAC_COMP_EXTRA]
           ,[PAC_LTA_COD2]
           ,[PAC_QUIMIO_PRESC_ACESSO]
           ,[PAC_IND_SIGILOSO]
           ,[PAC_IND_CPF_PROPRIO]
           ,[PAC_IND_ACEITA_SMS]
           ,[PAC_BLANK_CPF_JUSTIFIC]
           ,[PAC_CARTAO_MAGNETICO]
           ,[PAC_CARTAO_MAGNETICO_DTHR]
           ,[PAC_CARGO]
           ,[PAC_CNV_CARTAO_TRILHA1]
           ,[PAC_CNV_CARTAO_TRILHA2]
           ,[PAC_CTPS_SERIE]
           ,[PAC_CTPS_UF]
           ,[PAC_CTPS_DT_EMISSAO]
           ,[PAC_END_CEP_TIT]
           ,[PAC_ALT_UNID]
           ,[PAC_PESO_UNID]
           ,[PAC_REG_STR_COD]
           ,[PAC_IND_CNS_PROPRIO]
           ,[PAC_IND_VIP]
           ,[PAC_NUM_DNV]
           ,[PAC_BLOQ_FMS]
           ,[PAC_DAYH_FREQ_ESCOLA]
           ,[PAC_DAYH_RENDA_FAMILIAR]
           ,[pac_id_anom]
           ,[pac_cep_ind_generico]
           ,[pac_cnv_cartao_trilha_unica]
           ,[pac_ind_whatsapp]
           ,[pac_mcnv_antiga]
           ,[pac_nome_social]
           ,[pac_flag_social]
           ,[pac_dthr_social]
           ,[pac_reg_xclinic]
           ,[pac_categ]
           ,[pac_insc_est]
           ,[pac_prod_rural]
           ,[pac_reg_korus]
           ,[pac_reg_old]
           ,[pac_dthr_clariped]
           ,[pac_ind_aceite_termo]
           ,[pac_token_hash]
           ,[pac_token_hora]
           ,[pac_exporta_resultado_aso]
           ,[pac_pro_cod_old])
     VALUES
           (@USER_LID --<PAC_REG, int,>
           ,GETDATE() --<PAC_DREG, datetime,>
           ,NULL --<PAC_PRONT, int, Numero do Prontuario >
           ,@USER_FIRST_NAME +' '+ @USER_SECOND_NAME +' '+ @USER_THIRD_NAME --<PAC_NOME, varchar(100),>
           ,@USER_GENDER --<PAC_SEXO, char(1),>
           ,@USER_DATE_OF_BIRTH --<PAC_NASC, datetime,>
           ,@USER_LANDLINE_PHONE --<PAC_FONE, char(14),>
           ,@INSURANCE_LID --<PAC_CNV, char(3),>
           ,NULL --<PAC_MCNV, varchar(30),>
           ,NULL --@USER_TID --<PAC_TIT, varchar(100),>
           ,NULL --<PAC_PESO, numeric(6,3),>
           ,NULL --<PAC_ALT, numeric(4,2),>
           ,NULL --<PAC_DULT, datetime,>
           ,NULL --<PAC_FALTA, smallint,>
           ,@USER_STREET +', ' + @USER_STREET_NUMBER --<PAC_END, varchar(100),>
           ,@USER_REGION --<PAC_COMP, char(40),>
           ,@USER_STREET_NUMBER --<PAC_CEP, char(9),>
           ,NULL --<PAC_CID, varchar(30),>
           ,@USER_REGION --<PAC_UF, char(2),>
           ,NULL --<PAC_CNV_COD, char(3),>
           ,NULL --<PAC_PLN_COD, char(3),>
           ,NULL --<PAC_DT_ULT_FALTA, datetime,>
           ,NULL --<PAC_EST_CIVIL, char(1),>
           ,NULL --<PAC_NOME_MAE, varchar(100),>
           ,NULL --<PAC_ABORH, char(3),>
           ,NULL --<PAC_PAC_REG, int,>
           ,NULL --<PAC_LOTACAO, char(8),>
           ,NULL --<PAC_DTCNV_PAG, datetime,>
           ,NULL --<PAC_DTCNV_VAL, datetime,>
           ,NULL --<PAC_COD_DEPCNV, char(2),>
           ,NULL --<PAC_CNV2, char(3),>
           ,NULL --<PAC_MCNV2, varchar(30),>
           ,NULL --<PAC_CNV2_COD, char(3),>
           ,NULL --<PAC_PLN2_COD, char(3),>
           ,NULL --<PAC_PRO_COD, numeric(6,0),>
           ,NULL --<PAC_NUMRG, char(15),>
           ,@USER_ID_NUMBER --<PAC_NUMCPF, char(12),>
           ,NULL --<PAC_COD_FON, char(15),>
           ,NULL --<PAC_DT_VALID, datetime,>
           ,NULL --<PAC_VALID, char(15),>
           ,NULL --<PAC_CDE_COD, numeric(6,0),>
           ,NULL --<PAC_FONE2, char(14),>
           ,NULL --<PAC_RAMAL, char(5),>
           ,NULL --<PAC_MEDICO, int,>
           ,NULL --<PAC_DIAG_CID, char(8),>
           ,NULL --<PAC_DIAG_TPCID, char(1),>
           ,NULL --<PAC_PESSOA, char(1),>
           ,NULL --<PAC_PRONT_STATUS, char(1),>
           ,NULL --<PAC_TIT2, varchar(50),>
           ,NULL --<PAC_LTA_COD, char(8),>
           ,NULL --<PAC_MATR_EMP, varchar(20),>
           ,NULL --<PAC_PRO_COD_OCUP, numeric(6,0),>
           ,NULL --<PAC_NUMRG_ORG, char(5),>
           ,NULL --<PAC_NUMRG_UF, char(2),>
           ,NULL --<PAC_END_NUM, numeric(10,0),>
           ,NULL --<PAC_ZONA, char(1),>
           ,@USER_EMAIL --<PAC_EMAIL, varchar(100),>
           ,NULL --<PAC_USR_LOGIN_CAD, char(10),>
           ,NULL --<PAC_COD_FON_B, varchar(15),>
           ,NULL --<PAC_PRONT_LOC, char(3),>
           ,NULL --<PAC_CLE_COD, char(3),>
           ,NULL --<PAC_DT_OBITO, datetime,>
           ,NULL --<PAC_TRAT, varchar(10),>
           ,@USER_MOBILE_PHONE --<PAC_CELULAR, varchar(14),>
           ,NULL --<PAC_GFC_NUM, int,>
           ,NULL --<PAC_CCE_NUM, int,>
           ,NULL --<PAC_SO_CRIT_CONV, char(3),>
           ,NULL --<PAC_SO_DT_ADM, datetime,>
           ,NULL --<PAC_SO_DT_INI_FUNC, datetime,>
           ,NULL --<PAC_SO_MES_PER, numeric(2,0),>
           ,NULL --<PAC_SO_CNV_COD, char(3),>
           ,NULL --<PAC_SO_STATUS, char(1),>
           ,NULL --<PAC_DT_VALID2, datetime,>
           ,NULL --<PAC_CIMP_PRIORIDADE, numeric(2,0),>
           ,NULL --<PAC_REG_EXTERNO1, int,>
           ,NULL --<PAC_REG_EXTERNO2, int,>
           ,NULL --<PAC_REG_EXTERNO3, int,>
           ,NULL --<PAC_PRONT_EXTERNO, int,>
           ,NULL --<PAC_CTPS, varchar(20),>
           ,NULL --<PAC_NIT, varchar(20),>
           ,NULL --<PAC_REG_EXTERNO4, int,>
           ,NULL --<PAC_W_LOGIN, varchar(30),>
           ,NULL --<PAC_W_SENHA, varchar(30),>
           ,NULL --<PAC_COD_DEPCNV2, char(2),>
           ,NULL --<PAC_MATR_EMP2, varchar(20),>
           ,NULL --<PAC_CONTATO_DIA, varchar(7),>
           ,NULL --<PAC_CONTATO_TURNO, varchar(2),>
           ,NULL --<PAC_CONTATO_OBS, varchar(100),>
           ,NULL --<PAC_SO_STATUS_MOTIVO, varchar(30),>
           ,NULL --<PAC_OBS, varchar(255),>
           ,NULL --<PAC_PRONT_DTHR, datetime,>
           ,NULL --<PAC_PRONT_USR_LOGIN, char(10),>
           ,NULL --<PAC_PRONT_IND_GERA, char(1),>
           ,NULL --<PAC_SO_BRPDH, varchar(20),>
           ,NULL --<PAC_OBS2, varchar(255),>
           ,NULL --<PAC_CARTAO_SUS, varchar(20),>
           ,NULL --<PAC_NUMRG_DTEXP, datetime,>
           ,NULL --<PAC_ALERTA, text,>
           ,NULL --<PAC_ALERTA_USR_LOGIN, char(10),>
           ,NULL --<PAC_ALERTA_DTHR, datetime,>
           ,NULL --<PAC_IMG_COD_FOTO, numeric(8,0),>
           ,NULL --<PAC_SUS_SISCEL, varchar(20),>
           ,NULL --<PAC_CNES_ORIGEM, varchar(30),>
           ,NULL --<PAC_OCUP_VINC, char(3),>
           ,NULL --<PAC_LGR_COD, int,>
           ,NULL --<PAC_COMP_EXTRA, varchar(255),>
           ,NULL --<PAC_LTA_COD2, char(8),>
           ,NULL --<PAC_QUIMIO_PRESC_ACESSO, varchar(50),>
           ,NULL --<PAC_IND_SIGILOSO, char(1),>
           ,NULL --<PAC_IND_CPF_PROPRIO, char(1),>
           ,NULL --<PAC_IND_ACEITA_SMS, char(1),>
           ,NULL --<PAC_BLANK_CPF_JUSTIFIC, varchar(255),>
           ,NULL --<PAC_CARTAO_MAGNETICO, char(255),>
           ,NULL --<PAC_CARTAO_MAGNETICO_DTHR, datetime,>
           ,NULL --<PAC_CARGO, varchar(150),>
           ,NULL --<PAC_CNV_CARTAO_TRILHA1, varchar(150),>
           ,NULL --<PAC_CNV_CARTAO_TRILHA2, varchar(150),>
           ,NULL --<PAC_CTPS_SERIE, varchar(10),>
           ,NULL --<PAC_CTPS_UF, char(2),>
           ,NULL --<PAC_CTPS_DT_EMISSAO, datetime,>
           ,NULL --<PAC_END_CEP_TIT, char(3),>
           ,NULL --<PAC_ALT_UNID, varchar(5),>
           ,NULL --<PAC_PESO_UNID, varchar(5),>
           ,NULL --<PAC_REG_STR_COD, char(3),>
           ,NULL --<PAC_IND_CNS_PROPRIO, char(1),>
           ,NULL --<PAC_IND_VIP, char(1),>
           ,NULL --<PAC_NUM_DNV, varchar(30),>
           ,NULL --<PAC_BLOQ_FMS, varchar(1),>
           ,NULL --<PAC_DAYH_FREQ_ESCOLA, char(1),>
           ,NULL --<PAC_DAYH_RENDA_FAMILIAR, char(1),>
           ,NULL --<pac_id_anom, int,>
           ,NULL --<pac_cep_ind_generico, char(1),>
           ,NULL --<pac_cnv_cartao_trilha_unica, varchar(255),>
           ,NULL --<pac_ind_whatsapp, char(1),>
           ,NULL --<pac_mcnv_antiga, varchar(30),>
           ,NULL --<pac_nome_social, varchar(100),>
           ,NULL --<pac_flag_social, varchar(1),>
           ,NULL --<pac_dthr_social, datetime,>
           ,NULL --<pac_reg_xclinic, int,>
           ,NULL --<pac_categ, varchar(10),>
           ,NULL --<pac_insc_est, varchar(20),>
           ,NULL --<pac_prod_rural, char(1),>
           ,NULL --<pac_reg_korus, int,>
           ,NULL --<pac_reg_old, int,>
           ,NULL --<pac_dthr_clariped, datetime,>
           ,NULL --<pac_ind_aceite_termo, char(1),>
           ,NULL --<pac_token_hash, varchar(32),>
           ,NULL --<pac_token_hora, datetime,>
           ,NULL --<pac_exporta_resultado_aso, char(1),>
           ,NULL --<pac_pro_cod_old, int,>
		   )
		print 'Criado novo Paciente.' 
	END; --FIM CADASTRO PACIENTE

IF @APP_ACTION = 'add'	
BEGIN
	
	--print '@DATAINICIO: ' + cast(@DATAINICIO as varchar)
	--print '@DATAFIM: ' + cast(@DATAFIM as varchar)

	set @STATUS_AGENDA = (select COUNT(*) from TT_AVAILABILITIES where AVAILABILITY_LID = @APP_LID and R_START_DAY = @APP_DATE and RESOURCE_LID = @RESOURCE_LID);
	set @PACIENTEID = (select top 1 PAC_REG from PAC where CONVERT(DATE, PAC_NASC, 103) = @USER_DATE_OF_BIRTH and PAC_NUMCPF = @USER_ID_NUMBER);
	print 'adcionando.' 
	IF @STATUS_AGENDA <> 0
		print 'Horario existe, adcionando na agenda.' 
		INSERT INTO [dbo].[AGM]
           ([AGM_MED]
           ,[AGM_AUX]
           ,[AGM_LOC]
           ,[AGM_HINI]
           ,[AGM_HFIM]
           ,[AGM_PAC]
           ,[AGM_TPSMK]
           ,[AGM_SMK]
           ,[AGM_REC]
           ,[AGM_STAT]
           ,[AGM_EXT]
           ,[AGM_CTF]
           ,[AGM_DTMRC]
           ,[AGM_ATEND]
           ,[AGM_PAC_NOME]
           ,[AGM_STR_COD]
           ,[AGM_OBS]
           ,[AGM_NUM]
           ,[AGM_CONFIRM_STAT]
           ,[AGM_CONFIRM_USR]
           ,[AGM_CONFIRM_OBS]
           ,[AGM_CONFIRM_DTHR]
           ,[AGM_CONFIRM_MOC]
           ,[AGM_VALOR]
           ,[AGM_CIR_QT_BOLSA_SANGUE]
           ,[AGM_CIR_IND_UTI]
           ,[AGM_PSV_SOLIC]
           ,[AGM_CIR_TIPO_BOLSA]
           ,[AGM_CONF_F_USR]
           ,[AGM_CONF_F_OBS]
           ,[AGM_CONF_F_DTHR]
           ,[AGM_CONF_F_MOC]
           ,[AGM_EMAIL_USR_LOGIN]
           ,[AGM_EMAIL_DTHR]
           ,[AGM_CONTATO_HOR_INI]
           ,[AGM_CONTATO_HOR_FIM]
           ,[AGM_CONTATO_DIA_PREF]
           ,[AGM_IND_OLHO]
           ,[AGM_CNV_COD]
           ,[AGM_USR_LOGIN]
           ,[AGM_CANC_USR_LOGIN]
           ,[AGM_CANC_DTHR]
           ,[AGM_DTHR_GRUPO]
           ,[AGM_HON_SEQ]
           ,[AGM_MAQUINA]
           ,[AGM_CANC_MAQUINA]
           ,[AGM_OBS_CLINICA]
           ,[AGM_OSM_SERIE]
           ,[AGM_OSM_NUM]
           ,[AGM_SMM_NUM]
           ,[AGM_APQ_QST_COD]
           ,[AGM_APQ_COD]
           ,[AGM_ID]
           ,[AGM_GRADE_MARC]
           ,[AGM_GRADE_CANC]
           ,[AGM_BLQ_PSV_COD]
           ,[AGM_BLQ_DTHR_INI]
           ,[AGM_GRADE_BLOQ]
           ,[AGM_CANC_MOT_TIPO]
           ,[AGM_CANC_MOT_COD]
           ,[AGM_PROC]
           ,[AGM_CANC_OBS]
           ,[AGM_IND_COMPROMISSO]
           ,[AGM_FLE_DTHR_CHEGADA]
           ,[AGM_FLE_STR_COD]
           ,[AGM_GR_SES_ID]
           ,[AGM_IND_OPME]
           ,[AGM_IND_SMS]
           ,[AGM_AGM_PRX_ID]
           ,[AGM_ADP_TIPO]
           ,[AGM_ADP_COD]
           ,[AGM_TRAK_PASSAGEM]
           ,[AGM_QUIMIO_LIB_STAT]
           ,[AGM_QUIMIO_LIB_USR]
           ,[AGM_QUIMIO_LIB_DTHR]
           ,[AGM_QUIMIO_OBS]
           ,[AGM_CAP_NUM]
           ,[AGM_BAI_CDE_COD]
           ,[AGM_BAI_COD]
           ,[AGM_CANC_PROTOCOLO_ID]
           ,[AGM_COD_EXTERNO]
           ,[AGM_IND_ENVIO_AOL]
           ,[AGM_OBS2]
           ,[agm_agm_qst_id]
           ,[agm_cep]
           ,[agm_ind_urg]
           ,[agm_usr_externo]
           ,[agm_pln]
           ,[agm_med_pref]
           ,[agm_orp_num]
           ,[agm_ind_chegada]
           ,[agm_bloq_obs]
           ,[agm_ind_teleconsulta]
           ,[agm_asv_id]
           ,[agm_apg_cod]
           ,[agm_ind_doc_valid]
           ,[agm_payload_id]
           ,[agm_ind_aceite_termo]
           ,[agm_email_dthr_asv]
           ,[agm_pac_old]
           ,[agm_aceite_termo_ip]
           ,[agm_aceite_termo_data]
           ,[agm_ind_aceite_termo_sala]
           ,[agm_aceite_termo_data_sala]
           ,[agm_aceite_termo_ip_sala]
           ,[agm_stat_domiciliar]
           ,[agm_cod_boaconsulta]
           ,[agm_coleta_domiciliar_endereco]
           ,[AGM_BCS_PRE_AGM_PROT]
           ,[AGM_BCS_PLATAFORMA]
           ,[agm_bcs_plataforma_sist_ope])
     VALUES
           ( @RESOURCE_LID --<AGM_MED, int,>
           , null --<AGM_AUX, int,>
           , @LOCATION_LID --<AGM_LOC, char(3),>
           , @DATAINICIO --<AGM_HINI, datetime,>
           , @DATAFIM --<AGM_HFIM, datetime,>
           , @PACIENTEID -- @USER_LID --<AGM_PAC, int,>
           , (select SMK_TIPO from SMK where SMK_COD = @ACTIVITY_LID) --<AGM_TPSMK, char(1),>
           , @ACTIVITY_LID --<AGM_SMK, char(8),>
           , '0' -- Usuario ID --<AGM_REC, smallint,>
           , 'A' --Agendado --<AGM_STAT, char(1),>
           , '' -- Marcação extra --<AGM_EXT, char(3),>
           , (select SMK_CTF from smk where smk_cod = @ACTIVITY_LID) -- Classe do Serviço --<AGM_CTF, char(5),>
           , GETDATE() -- Data Marcada --<AGM_DTMRC, datetime,>
           , 'ASS' -- Tipo Atendimento --<AGM_ATEND, char(3),>
		   
           , @USERNAME --<AGM_PAC_NOME, varchar(50),>
           , null --<AGM_STR_COD, char(3),>
           , null --<AGM_OBS, varchar(255),>
           , '0' -- Numero da Marcação --<AGM_NUM, numeric(10,0),>
           , null --<AGM_CONFIRM_STAT, char(1),>
           , null --<AGM_CONFIRM_USR, char(10),>
           , null --<AGM_CONFIRM_OBS, varchar(255),>
           , null --<AGM_CONFIRM_DTHR, datetime,>
           , null --<AGM_CONFIRM_MOC, char(3),>
           , null --<AGM_VALOR, numeric(14,4),>
           , null --<AGM_CIR_QT_BOLSA_SANGUE, numeric(6,0),>
           , null --<AGM_CIR_IND_UTI, char(1),>
           , null --<AGM_PSV_SOLIC, int,>
           , null --<AGM_CIR_TIPO_BOLSA, char(5),>
           , null --<AGM_CONF_F_USR, char(10),>
           , null --<AGM_CONF_F_OBS, varchar(255),>
           , null --<AGM_CONF_F_DTHR, datetime,>
           , null --<AGM_CONF_F_MOC, char(3),>
           , null --<AGM_EMAIL_USR_LOGIN, char(10),>
           , null --<AGM_EMAIL_DTHR, datetime,>
           , null --<AGM_CONTATO_HOR_INI, char(5),>
           , null --<AGM_CONTATO_HOR_FIM, char(5),>
           , null --<AGM_CONTATO_DIA_PREF, char(5),>
           , null --<AGM_IND_OLHO, char(2),>
           , null --<AGM_CNV_COD, char(3),>
           , 'ADM' -- Usuario responsavel marcacao --<AGM_USR_LOGIN, char(10),>
           , 'ADM' -- Usuario Resp. Cancel. Marc. --<AGM_CANC_USR_LOGIN, char(10),>
           , null -- Data Canc. Marc. --<AGM_CANC_DTHR, datetime,>
           , null --<AGM_DTHR_GRUPO, datetime,>
           , null --<AGM_HON_SEQ, numeric(8,0),>
           , null --<AGM_MAQUINA, varchar(50),>
           , null --<AGM_CANC_MAQUINA, varchar(50),>
           , null --<AGM_OBS_CLINICA, varchar(255),>
           , null --<AGM_OSM_SERIE, smallint,>
           , null --<AGM_OSM_NUM, int,>
           , null --<AGM_SMM_NUM, int,>
           , null --<AGM_APQ_QST_COD, numeric(6,0),>
           , null --<AGM_APQ_COD, numeric(6,0),>
           , null --<AGM_ID, int,>
           , null --<AGM_GRADE_MARC, varchar(168),>
           , null --<AGM_GRADE_CANC, varchar(168),>
           , null --<AGM_BLQ_PSV_COD, int,>
           , null --<AGM_BLQ_DTHR_INI, datetime,>
           , null --<AGM_GRADE_BLOQ, varchar(168),>
           , null --<AGM_CANC_MOT_TIPO, char(3),>
           , null --<AGM_CANC_MOT_COD, char(5),>
           , null --<AGM_PROC, varchar(5),>
           , '' -- Obs Canc. Agenda --<AGM_CANC_OBS, varchar(255),>
           , 'N' -- Indicador Compromisso Medico --<AGM_IND_COMPROMISSO, char(1),>
           , null --<AGM_FLE_DTHR_CHEGADA, datetime,>
           , null --<AGM_FLE_STR_COD, char(3),>
           , '0' -- Sessao do registro marcação --<AGM_GR_SES_ID, int,>
           , 'N' -- Indicação necessidade OPME --<AGM_IND_OPME, char(1),>
           , null --<AGM_IND_SMS, char(1),>
           , null -- Id Lista Pre Requisitos --<AGM_AGM_PRX_ID, int,>
           , null --<AGM_ADP_TIPO, char(1),>
           , null --<AGM_ADP_COD, char(8),>
           , null --<AGM_TRAK_PASSAGEM, varchar(100),>
           , null --<AGM_QUIMIO_LIB_STAT, char(1),>
           , null --<AGM_QUIMIO_LIB_USR, char(10),>
           , null --<AGM_QUIMIO_LIB_DTHR, datetime,>
           , null --<AGM_QUIMIO_OBS, varchar(255),>
           , null --<AGM_CAP_NUM, int,>
           , null --<AGM_BAI_CDE_COD, numeric(6,0),>
           , null --<AGM_BAI_COD, numeric(6,0),>
           , null --<AGM_CANC_PROTOCOLO_ID, int,>
           , null --<AGM_COD_EXTERNO, varchar(100),>
           , null --<AGM_IND_ENVIO_AOL, char(1),>
           , null --<AGM_OBS2, text,>
           , null --<agm_agm_qst_id, int,>
           , null --<agm_cep, varchar(10),>
           , null --<agm_ind_urg, char(1),>
           , null --<agm_usr_externo, varchar(50),>
           , null --<agm_pln, char(3),>
           , null --<agm_med_pref, int,>
           , null --<agm_orp_num, int,>
           , null --<agm_ind_chegada, varchar(5),>
           , null --<agm_bloq_obs, varchar(255),>
           , null --<agm_ind_teleconsulta, char(1),>
           , null --<agm_asv_id, int,>
           , null --<agm_apg_cod, int,>
           , null --<agm_ind_doc_valid, char(1),>
           , null --<agm_payload_id, int,>
           , null --<agm_ind_aceite_termo, char(1),>
           , null --<agm_email_dthr_asv, datetime,>
           , null --<agm_pac_old, int,>
           , null --<agm_aceite_termo_ip, char(15),>
           , null --<agm_aceite_termo_data, datetime,>
           , null --<agm_ind_aceite_termo_sala, char(1),>
           , null --<agm_aceite_termo_data_sala, datetime,>
           , null --<agm_aceite_termo_ip_sala, char(15),>
           , null --<agm_stat_domiciliar, char(10),>
           , null --<agm_cod_boaconsulta, varchar(255),>
           , null --<agm_coleta_domiciliar_endereco, varchar(255),>
           , null --<AGM_BCS_PRE_AGM_PROT, numeric(10,0),>
           , null --<AGM_BCS_PLATAFORMA, char(100),>
           , null --<agm_bcs_plataforma_sist_ope, varchar(100),>
		   )
		   print 'adcionado na agenda.' 
	END;


IF @APP_ACTION = 'delete'
BEGIN
	print 'Inicio Delete'

	select @PACIENTEID = PAC_REG from PAC where PAC_NUMCPF = @USER_ID_NUMBER and PAC_NASC = @USER_DATE_OF_BIRTH;

	print 'ID DO PACIENTE: ' + cast(@PACIENTEID as varchar)

UPDATE [dbo].[AGM]
   SET --[AGM_MED] = null -- <AGM_MED, int,>
      --,[AGM_AUX] = null -- <AGM_AUX, int,>
      --,[AGM_LOC] = null -- <AGM_LOC, char(3),>
      --,[AGM_HINI] = null -- <AGM_HINI, datetime,>
      --,[AGM_HFIM] = null -- <AGM_HFIM, datetime,>
      --,[AGM_PAC] = null -- <AGM_PAC, int,>
      --,[AGM_TPSMK] = null -- <AGM_TPSMK, char(1),>
      --,[AGM_SMK] = null -- <AGM_SMK, char(8),>
      --,[AGM_REC] = null -- <AGM_REC, smallint,>
      [AGM_STAT] = 'C' -- <AGM_STAT, char(1),>
      --,[AGM_EXT] = null -- <AGM_EXT, char(3),>
      --,[AGM_CTF] = null -- <AGM_CTF, char(5),>
      --,[AGM_DTMRC] = null -- <AGM_DTMRC, datetime,>
      --,[AGM_ATEND] = null -- <AGM_ATEND, char(3),>
      --,[AGM_PAC_NOME] = null -- <AGM_PAC_NOME, varchar(50),>
      --,[AGM_STR_COD] = null -- <AGM_STR_COD, char(3),>
      --,[AGM_OBS] = null -- <AGM_OBS, varchar(255),>
      --,[AGM_NUM] = null -- <AGM_NUM, numeric(10,0),>
      --,[AGM_CONFIRM_STAT] = null -- <AGM_CONFIRM_STAT, char(1),>
      --,[AGM_CONFIRM_USR] = null -- <AGM_CONFIRM_USR, char(10),>
      --,[AGM_CONFIRM_OBS] = null -- <AGM_CONFIRM_OBS, varchar(255),>
      --,[AGM_CONFIRM_DTHR] = null -- <AGM_CONFIRM_DTHR, datetime,>
      --,[AGM_CONFIRM_MOC] = null -- <AGM_CONFIRM_MOC, char(3),>
      --,[AGM_VALOR] = null -- <AGM_VALOR, numeric(14,4),>
      --,[AGM_CIR_QT_BOLSA_SANGUE] = null -- <AGM_CIR_QT_BOLSA_SANGUE, numeric(6,0),>
      --,[AGM_CIR_IND_UTI] = null -- <AGM_CIR_IND_UTI, char(1),>
      --,[AGM_PSV_SOLIC] = null -- <AGM_PSV_SOLIC, int,>
      --,[AGM_CIR_TIPO_BOLSA] = null -- <AGM_CIR_TIPO_BOLSA, char(5),>
      --,[AGM_CONF_F_USR] = null -- <AGM_CONF_F_USR, char(10),>
      --,[AGM_CONF_F_OBS] = null -- <AGM_CONF_F_OBS, varchar(255),>
      --,[AGM_CONF_F_DTHR] = null -- <AGM_CONF_F_DTHR, datetime,>
      --,[AGM_CONF_F_MOC] = null -- <AGM_CONF_F_MOC, char(3),>
      --,[AGM_EMAIL_USR_LOGIN] = null -- <AGM_EMAIL_USR_LOGIN, char(10),>
      --,[AGM_EMAIL_DTHR] = null -- <AGM_EMAIL_DTHR, datetime,>
      --,[AGM_CONTATO_HOR_INI] = null -- <AGM_CONTATO_HOR_INI, char(5),>
      --,[AGM_CONTATO_HOR_FIM] = null -- <AGM_CONTATO_HOR_FIM, char(5),>
      --,[AGM_CONTATO_DIA_PREF] = null -- <AGM_CONTATO_DIA_PREF, char(5),>
      --,[AGM_IND_OLHO] = null -- <AGM_IND_OLHO, char(2),>
      --,[AGM_CNV_COD] = null -- <AGM_CNV_COD, char(3),>
      --,[AGM_USR_LOGIN] = null -- <AGM_USR_LOGIN, char(10),>
      --,[AGM_CANC_USR_LOGIN] = null -- <AGM_CANC_USR_LOGIN, char(10),>
      --,[AGM_CANC_DTHR] = null -- <AGM_CANC_DTHR, datetime,>
      --,[AGM_DTHR_GRUPO] = null -- <AGM_DTHR_GRUPO, datetime,>
      --,[AGM_HON_SEQ] = null -- <AGM_HON_SEQ, numeric(8,0),>
      --,[AGM_MAQUINA] = null -- <AGM_MAQUINA, varchar(50),>
      --,[AGM_CANC_MAQUINA] = null -- <AGM_CANC_MAQUINA, varchar(50),>
      --,[AGM_OBS_CLINICA] = null -- <AGM_OBS_CLINICA, varchar(255),>
      --,[AGM_OSM_SERIE] = null -- <AGM_OSM_SERIE, smallint,>
      --,[AGM_OSM_NUM] = null -- <AGM_OSM_NUM, int,>
      --,[AGM_SMM_NUM] = null -- <AGM_SMM_NUM, int,>
      --,[AGM_APQ_QST_COD] = null -- <AGM_APQ_QST_COD, numeric(6,0),>
      --,[AGM_APQ_COD] = null -- <AGM_APQ_COD, numeric(6,0),>
      --,[AGM_ID] = null -- <AGM_ID, int,>
      --,[AGM_GRADE_MARC] = null -- <AGM_GRADE_MARC, varchar(168),>
      --,[AGM_GRADE_CANC] = null -- <AGM_GRADE_CANC, varchar(168),>
      --,[AGM_BLQ_PSV_COD] = null -- <AGM_BLQ_PSV_COD, int,>
      --,[AGM_BLQ_DTHR_INI] = null -- <AGM_BLQ_DTHR_INI, datetime,>
      --,[AGM_GRADE_BLOQ] = null -- <AGM_GRADE_BLOQ, varchar(168),>
      --,[AGM_CANC_MOT_TIPO] = null -- <AGM_CANC_MOT_TIPO, char(3),>
      --,[AGM_CANC_MOT_COD] = null -- <AGM_CANC_MOT_COD, char(5),>
      --,[AGM_PROC] = null -- <AGM_PROC, varchar(5),>
      --,[AGM_CANC_OBS] = null -- <AGM_CANC_OBS, varchar(255),>
      --,[AGM_IND_COMPROMISSO] = null -- <AGM_IND_COMPROMISSO, char(1),>
      --,[AGM_FLE_DTHR_CHEGADA] = null -- <AGM_FLE_DTHR_CHEGADA, datetime,>
      --,[AGM_FLE_STR_COD] = null -- <AGM_FLE_STR_COD, char(3),>
      --,[AGM_GR_SES_ID] = null -- <AGM_GR_SES_ID, int,>
      --,[AGM_IND_OPME] = null -- <AGM_IND_OPME, char(1),>
      --,[AGM_IND_SMS] = null -- <AGM_IND_SMS, char(1),>
      --,[AGM_AGM_PRX_ID] = null -- <AGM_AGM_PRX_ID, int,>
      --,[AGM_ADP_TIPO] = null -- <AGM_ADP_TIPO, char(1),>
      --,[AGM_ADP_COD] = null -- <AGM_ADP_COD, char(8),>
      --,[AGM_TRAK_PASSAGEM] = null -- <AGM_TRAK_PASSAGEM, varchar(100),>
      --,[AGM_QUIMIO_LIB_STAT] = null -- <AGM_QUIMIO_LIB_STAT, char(1),>
      --,[AGM_QUIMIO_LIB_USR] = null -- <AGM_QUIMIO_LIB_USR, char(10),>
      --,[AGM_QUIMIO_LIB_DTHR] = null -- <AGM_QUIMIO_LIB_DTHR, datetime,>
      --,[AGM_QUIMIO_OBS] = null -- <AGM_QUIMIO_OBS, varchar(255),>
      --,[AGM_CAP_NUM] = null -- <AGM_CAP_NUM, int,>
      --,[AGM_BAI_CDE_COD] = null -- <AGM_BAI_CDE_COD, numeric(6,0),>
      --,[AGM_BAI_COD] = null -- <AGM_BAI_COD, numeric(6,0),>
      --,[AGM_CANC_PROTOCOLO_ID] = null -- <AGM_CANC_PROTOCOLO_ID, int,>
      --,[AGM_COD_EXTERNO] = null -- <AGM_COD_EXTERNO, varchar(100),>
      --,[AGM_IND_ENVIO_AOL] = null -- <AGM_IND_ENVIO_AOL, char(1),>
      --,[AGM_OBS2] = null -- <AGM_OBS2, text,>
      --,[agm_agm_qst_id] = null -- <agm_agm_qst_id, int,>
      --,[agm_cep] = null -- <agm_cep, varchar(10),>
      --,[agm_ind_urg] = null -- <agm_ind_urg, char(1),>
      --,[agm_usr_externo] = null -- <agm_usr_externo, varchar(50),>
      --,[agm_pln] = null -- <agm_pln, char(3),>
      --,[agm_med_pref] = null -- <agm_med_pref, int,>
      --,[agm_orp_num] = null -- <agm_orp_num, int,>
      --,[agm_ind_chegada] = null -- <agm_ind_chegada, varchar(5),>
      --,[agm_bloq_obs] = null -- <agm_bloq_obs, varchar(255),>
      --,[agm_ind_teleconsulta] = null -- <agm_ind_teleconsulta, char(1),>
      --,[agm_asv_id] = null -- <agm_asv_id, int,>
      --,[agm_apg_cod] = null -- <agm_apg_cod, int,>
      --,[agm_ind_doc_valid] = null -- <agm_ind_doc_valid, char(1),>
      --,[agm_payload_id] = null -- <agm_payload_id, int,>
      --,[agm_ind_aceite_termo] = null -- <agm_ind_aceite_termo, char(1),>
      --,[agm_email_dthr_asv] = null -- <agm_email_dthr_asv, datetime,>
      --,[agm_pac_old] = null -- <agm_pac_old, int,>
      --,[agm_aceite_termo_ip] = null -- <agm_aceite_termo_ip, char(15),>
      --,[agm_aceite_termo_data] = null -- <agm_aceite_termo_data, datetime,>
      --,[agm_ind_aceite_termo_sala] = null -- <agm_ind_aceite_termo_sala, char(1),>
      --,[agm_aceite_termo_data_sala] = null -- <agm_aceite_termo_data_sala, datetime,>
      --,[agm_aceite_termo_ip_sala] = null -- <agm_aceite_termo_ip_sala, char(15),>
      --,[agm_stat_domiciliar] = null -- <agm_stat_domiciliar, char(10),>
      --,[agm_cod_boaconsulta] = null -- <agm_cod_boaconsulta, varchar(255),>
      --,[agm_coleta_domiciliar_endereco] = null -- <agm_coleta_domiciliar_endereco, varchar(255),>
      --,[AGM_BCS_PRE_AGM_PROT] = null -- <AGM_BCS_PRE_AGM_PROT, numeric(10,0),>
      --,[AGM_BCS_PLATAFORMA] = null -- <AGM_BCS_PLATAFORMA, char(100),>
      --,[agm_bcs_plataforma_sist_ope] = null -- <agm_bcs_plataforma_sist_ope, varchar(100),>
 WHERE 
 AGM_HINI = @DATAINICIO
 and AGM_HFIM = @DATAFIM
 and AGM_MED = @RESOURCE_LID
 and AGM_LOC = @LOCATION_LID
 and AGM_PAC = @PACIENTEID

	 print 'Fim delete.'
END;

END

-- select top 100 * from agm  order by AGM_DTMRC desc 
GO

