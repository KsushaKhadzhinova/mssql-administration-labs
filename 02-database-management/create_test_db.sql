CREATE DATABASE [Test]
 ON PRIMARY 
( NAME = N'testdata_a', FILENAME = N'/var/opt/mssql/data/testdata_a.mdf' , SIZE = 4096KB , MAXSIZE = 10240KB , FILEGROWTH = 2048KB )
 LOG ON 
( NAME = N'Test_log', FILENAME = N'/var/opt/mssql/data/Test_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB );
GO

ALTER DATABASE [Test] ADD FILEGROUP [TestFileGroup];
GO

ALTER DATABASE [Test] ADD FILE 
( NAME = N'testdata_b', FILENAME = N'/var/opt/mssql/data/testdata_b.ndf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 2048KB ) 
TO FILEGROUP [TestFileGroup];
GO
