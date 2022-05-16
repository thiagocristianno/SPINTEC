USE [Xclinic_HML]
GO

/****** Object:  Table [dbo].[TT_CHECKIN_TMP]    Script Date: 11/05/2022 15:21:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TT_CHECKIN_TMP](
	[APP_LID] [varchar](50) NOT NULL,
	[CHECKIN_COD] [varchar](50) NOT NULL,
	[CHECKIN_DATE] [varchar](20) NOT NULL,
	[STATUS_TRIGGER] [varchar](200) NULL,
	[ACCEPTANCE_LID] [varchar](20) NULL,
	[CHECKIN_INFO] [varchar](500) NULL
) ON [PRIMARY]
GO

