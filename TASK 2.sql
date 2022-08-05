CREATE DATABASE TASK
USE TASK

CREATE TABLE POSTS(
 Id INT PRIMARY KEY IDENTITY Not null,
 UserId int REFERENCES USERS(Id),
 Content Nvarchar(200) Not null,
 PostDate date Default getdate() Not Null,
 PostLikeCount	 int ,
 PostIsDeleted bit Default 0
)
INSERT INTO POSTS (UserId ,Content, PostLikeCount)
VALUES
(1, 'Medeniyyet',5)
INSERT INTO POSTS (UserId ,Content, PostLikeCount)
VALUES
(2, 'Code',1215),
(3, 'SQL',4150),
(4, 'C#',515),
(5, 'JS',1565),
(6, 'HTML',155)

CREATE TABLE USERS(
Id INT PRIMARY KEY IDENTITY Not null,
PersonId INT REFERENCES PEOPLE(Id),
Password varchar(20) Not null,
Email varchar (30)  UNIQUE Not null,
Login  varchar (30)  UNIQUE Not null
)


 INSERT INTO USERS
 VALUES
(1, 'xxxx', 'asli@gmail.com', 'AsliG'),
(2, 'xxxx', 'ruhulla@gmail.com', 'RuhullaG'),
(3, 'xxxx', 'yusif@gmail.com', 'YusifG'),
(4, 'xxxx', 'ulker@gmail.com', 'UlkerF'),
(5, 'xxxx', 'zehra@gmail.com', 'ZehraA'),
(6, 'xxxx', 'elmira@gmail.com', 'ElmiraF')

CREATE TABLE COMMENTS(
Id INT PRIMARY KEY IDENTITY Not null,
UserId INT REFERENCES USERS(Id) ,
PostId INT References POSTS(Id) Unique ,
CommentLikeCount int,
CommentIsDeleted bit Default 0
) 
INSERT INTO COMMENTS (UserId,PostId,CommentLikeCount)
VALUES
(1, 2, 56),
(2, 3, 67),
(4, 4,52),
(5, 5,64),
(2, 6, 98)

CREATE TABLE PEOPLE(
Id INT PRIMARY KEY IDENTITY Not null,
Name nvarchar(20) Not null,
Surname nvarchar(20) Not null,
Age int Not null
)
INSERT INTO PEOPLE
VALUES
('Asli','Akhmedova', 27),
('Ruhulla', 'Gadirov', 30),
('Yusif', 'Gadirov', 19),
('Ulker', 'Faridova', 21),
('Zehra', 'Alishanli',42),
('Elmira', 'Abbasova', 18)



--1) Postlara gələn comment sayların göstərin (Group by)
SELECT * FROM POSTS
SELECT * FROM COMMENTS

SELECT p.Id as 'Post ID', COUNT(c.Id) as 'Posta gelen comment sayi' FROM COMMENTS as c
inner JOIN POSTS as p
ON  c.PostId=p.Id
Group BY c.Id , p.Id

--2) Bütün dataları göstərən relation qurun, Viewda saxlayın
Create View  FullPostsInfoView
as
SELECT pe.Id AS 'Person ID', pe.Name, pe.Age , u.Id as 'User ID', p.Id  as 'Post ID', c.Id 'Comment ID'  FROM COMMENTS as c
Join POSTS as p
On p.Id=c.PostId
Join USERS as u
On p.UserId =u.Id
Join PEOPLE as pe
On u.PersonId=pe.Id

Select * from FullPostsInfoView



 
 --3) Rəyi və ya paylaşımı silən zaman silinməsi əvəzinə IsDeleted dəyəri true olsun

 CREATE TRIGGER UpdateInsteadOfDelete
 ON POSTS
 INSTEAD OF DELETE 
 AS 
 BEGIN
      DECLARE @Id int
	  SELECT top 1 @Id=Id from deleted
 UPDATE POSTS SET PostIsDeleted = 1 WHERE @Id=Id
 END
 Delete POSTS
 WHERE Id=18


 --4) LikePost proseduru yaradın, PostId-sini daxil  etdikdə uyğun olaraq həmin postun like sayı 1 vahid artsın

 
CREATE PROCEDURE LikePost (
    @Id INT
   )
   as
	BEGIN
       UPDATE Posts
    SET PostLikeCount = PostLikeCount  + 1
    WHERE @Id = Posts.Id
    END 
    EXEC LikePost @Id=31
	select * from POSTS


	--5)ResetPassword proseduru yaradın. İstifadəçi Mail və Login dəyərini (2-sindən birini) və yeni parolu parametr olaraq göndərir, 
	--uyğun istifadəçinin parolu dəyişsin.

	select * from users

	CREATE PROCEDURE ResetPassword  (
    @Login varchar(20),
	@NewPassword varchar (40)
   )
   as
	BEGIN
       UPDATE USERS
    SET Password = @NewPassword
    WHERE @Login = Login
    END 
    EXEC ResetPassword @Login='AsliG', @NewPassword='asli1'