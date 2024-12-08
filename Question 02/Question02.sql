USE [MyDataBase]
GO 

DROP TABLE IF EXISTS [dbo].[Jokes]

SET ANSI_NULLS
ON 

SET QUOTED_IDENTIFIER 
ON 

CREATE TABLE [dbo].[Jokes] (
    [JokeId] [INT] IDENTITY(1000,1) NOT NULL,
    [category] [VARCHAR](50) NULL,
    [type] [VARCHAR](50) NULL,
    [joke_or_setup] [VARCHAR](500) NULL,
    [nsfw] [BIT] NULL,
    [political] [BIT] NULL,
    [sexist] [BIT] NULL,
    [safe] [BIT] NULL,
    [lang] [VARCHAR](50) NULL,
    CONSTRAINT [PK_Jokes__JokeId]
    PRIMARY KEY CLUSTERED ([JokeId] ASC)
) ON [PRIMARY]
GO


SELECT [JokeId]
    ,[category]
    ,[type]
    ,[joke_or_setup]
    ,[nsfw]
    ,[political]
    ,[sexist]
    ,[safe]
    ,[lang]
FROM [dbo].[Jokes]
