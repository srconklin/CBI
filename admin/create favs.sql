USE [dp_cat]
GO

/****** Object:  Table [dbo].[userFavorites]    Script Date: 9/26/2024 5:59:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[userFavorites](
	[pno] [int] NOT NULL,
	[itemno] [int] NOT NULL,
 CONSTRAINT [PK_userFavorites] PRIMARY KEY CLUSTERED 
(
	[pno] ASC,
	[itemno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




USE [dp_cat]
GO

/****** Object:  StoredProcedure [dbo].[setUserFavorites]    Script Date: 9/26/2024 5:58:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[setUserFavorites]
	
     @itemno int,
	 @pno int,
	 @isFavorite bit = 0
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	/* 1 =  make it a favorite */
	IF @isFavorite = 1
	BEGIN 

		 /* if already a favorite do nothing */
		IF NOT exists(select 1 from userFavorites where itemno = @itemno and pno = @pno) 
		BEGIN
		 INSERT INTO userFavorites (pno, itemno)	 values (@pno, @itemno)
		END
			
	END

	/* 0 =  remove it as a favorite */
	ELSE
		
	BEGIN
		DELETE FROM userFavorites where itemno = @itemno and pno = @pno 
	END
	

    
END
GO


