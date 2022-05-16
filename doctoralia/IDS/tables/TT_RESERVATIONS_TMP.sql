USE [BKP_MEDICAL]
GO

/****** Object:  Table [dbo].[TT_RESERVATIONS_TMP]    Script Date: 11/05/2022 08:17:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TT_RESERVATIONS_TMP](
	[APP_TMP_ID] [varchar](50) NULL,
	[APP_LID] [nvarchar](50) NULL,
	[APP_TID] [nvarchar](50) NOT NULL,
	[APP_ACTION] [nchar](10) NOT NULL,
	[APP_DATE] [nchar](10) NOT NULL,
	[APP_START_TIME] [nchar](5) NOT NULL,
	[APP_END_TIME] [nchar](5) NULL,
	[APP_PRICE] [nvarchar](20) NULL,
	[USER_LID] [nvarchar](50) NULL,
	[USER_TID] [nvarchar](50) NULL,
	[USER_FIRST_NAME] [nvarchar](50) NULL,
	[USER_SECOND_NAME] [nvarchar](50) NULL,
	[USER_THIRD_NAME] [nvarchar](50) NULL,
	[USER_ID_NUMBER] [nvarchar](50) NULL,
	[USER_LANDLINE_PHONE] [nvarchar](50) NULL,
	[USER_MOBILE_PHONE] [nvarchar](50) NULL,
	[USER_EMAIL] [nvarchar](50) NULL,
	[USER_DATE_OF_BIRTH] [nchar](10) NULL,
	[USER_GENDER] [nchar](10) NULL,
	[USER_ZIP_CODE] [nchar](10) NULL,
	[USER_WORK_PHONE] [nvarchar](50) NULL,
	[USER_NOTES] [nvarchar](500) NULL,
	[USER_LANGUAGE] [nvarchar](10) NULL,
	[RESOURCE_LID] [nvarchar](50) NOT NULL,
	[ACTIVITY_LID] [nvarchar](50) NULL,
	[INSURANCE_LID] [nvarchar](50) NULL,
	[LOCATION_LID] [nvarchar](50) NULL,
	[STATUS] [nvarchar](50) NULL,
	[NOTES] [nvarchar](500) NULL,
	[APP_OWNER_LID] [nvarchar](50) NULL,
	[APP_OWNER_TID] [nvarchar](50) NULL,
	[APP_OWNER_NAME] [nvarchar](50) NULL,
	[STATUS_TRIGGER] [nvarchar](4000) NULL,
	[INSERT_TIME] [datetime] NOT NULL,
	[APP_CUSTOM_0] [nvarchar](500) NULL,
	[APP_CUSTOM_1] [nvarchar](500) NULL,
	[APP_CUSTOM_2] [nvarchar](500) NULL,
	[APP_CUSTOM_3] [nvarchar](500) NULL,
	[APP_CUSTOM_4] [nvarchar](500) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

