USE [dp_cat]
GO

ALTER TABLE [dbo].[securityHashes] DROP CONSTRAINT [DF_securityHashes_verifyVerified]
GO

ALTER TABLE [dbo].[securityHashes] DROP CONSTRAINT [DF_securityHashes_pwdVerified]
GO

/****** Object:  Table [dbo].[securityHashes]    Script Date: 6/19/2023 4:20:16 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[securityHashes]') AND type in (N'U'))
DROP TABLE [dbo].[securityHashes]
GO

/****** Object:  Table [dbo].[securityHashes]    Script Date: 6/19/2023 4:20:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[securityHashes](
	[email] [varchar](50) NOT NULL,
	[pwdGuid] [varchar](50) NULL,
	[pwdHash] [varchar](128) NULL,
	[pwdDateTime] [datetime] NULL,
	[pwdVerified] [bit] NULL,
	[verifyGuid] [varchar](50) NULL,
	[verifyHash] [varchar](128) NULL,
	[verifyDateTime] [datetime] NULL,
	[verifyVerified] [bit] NULL,
 CONSTRAINT [PK_securityHashes] PRIMARY KEY CLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[securityHashes] ADD  CONSTRAINT [DF_securityHashes_pwdVerified]  DEFAULT ((0)) FOR [pwdVerified]
GO

ALTER TABLE [dbo].[securityHashes] ADD  CONSTRAINT [DF_securityHashes_verifyVerified]  DEFAULT ((0)) FOR [verifyVerified]
GO


