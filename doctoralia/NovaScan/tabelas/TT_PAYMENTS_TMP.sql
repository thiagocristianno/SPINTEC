USE [Xclinic_HML]
GO

/****** Object:  Table [dbo].[TT_PAYMENTS_TMP]    Script Date: 11/05/2022 15:22:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TT_PAYMENTS_TMP](
	[APP_LID] [varchar](50) NULL,
	[PAYMENT_ACTION] [varchar](10) NOT NULL,
	[APP_AMOUNT] [varchar](10) NOT NULL,
	[APP_AMOUNT_FULLPRICE] [varchar](10) NOT NULL,
	[EXT_ID] [varchar](50) NULL,
	[APP_PRICE] [varchar](20) NULL,
	[PAYED] [varchar](20) NULL,
	[STATUS_TRIGGER] [varchar](200) NULL,
	[DOCUMENT_LID] [varchar](1) NULL
) ON [PRIMARY]
GO

