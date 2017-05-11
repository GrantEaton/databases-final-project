/********************************************************
* This script creates the database named Forum
*********************************************************/

USE master
GO
IF DB_ID('Forum') IS NOT NULL
  DROP DATABASE Forum;
GO
  CREATE DATABASE Forum;
GO

------- Tables --------

USE Forum

CREATE TABLE Users (
   [UserID]       	INT PRIMARY KEY IDENTITY NOT NULL,
   [Username]     	VARCHAR(20) NOT NULL,
   [EmailAddress] 	VARCHAR(50) NOT NULL,
   [Biography]		  VARCHAR(MAX) NOT NULL,
   [Password]     	VARCHAR(20) NOT NULL,
   [DateCreated]  	DATETIME NOT NULL,
   [Deleted]      	BIT DEFAULT 0 NOT NULL
)

CREATE TABLE Topics (
   [TopicID]     	  INT PRIMARY KEY IDENTITY NOT NULL,
   [UserID]      	  INT REFERENCES Users(UserID) NOT NULL,
   [Name]        	  VARCHAR(30) NOT NULL,
   [Description] 	  VARCHAR(MAX) NOT NULL,
   [DateCreated] 	  DATETIME NOT NULL,
   [Deleted]		    BIT DEFAULT 0 NOT NULL
)

CREATE TABLE Posts (
   [PostID]  		    INT PRIMARY KEY IDENTITY NOT NULL,
   [TopicID] 		    INT REFERENCES Topics(TopicID) NOT NULL,
   [UserID]         INT REFERENCES Users(UserID) NOT NULL,
   [Title]   		    VARCHAR(100) NOT NULL,
   [Text]    		    VARCHAR(MAX) NOT NULL,
   [DateCreated]    DATETIME NOT NULL,
   [Stickied] 		  BIT DEFAULT 0 NOT NULL,
   [Deleted]        BIT DEFAULT 0 NOT NULL
)

CREATE TABLE Replies (
   [ReplyID]     	  INT PRIMARY KEY IDENTITY NOT NULL,
   [PostID]      	  INT REFERENCES Posts(PostID) NOT NULL,
   [UserID]      	  INT REFERENCES Users(UserID) NOT NULL,
   [Text]        	  VARCHAR(MAX) NOT NULL,
   [DateCreated] 	  DATETIME NOT NULL,
   [Deleted]		    BIT DEFAULT 0 NOT NULL
)

CREATE TABLE Messages (
   [MessageID]   	  INT PRIMARY KEY IDENTITY NOT NULL,
   [SenderID]    	  INT REFERENCES Users(UserID) NOT NULL,
   [RecipientID] 	  INT REFERENCES Users(UserID) NOT NULL,
   [Subject]     	  VARCHAR(100) NOT NULL,
   [Text]        	  VARCHAR(MAX) NOT NULL,
   [DateCreated] 	  DATETIME NOT NULL,
   [Deleted]		    BIT DEFAULT 0 NOT NULL
)


------- Stored Procedures --------

-- Users

GO

CREATE PROCEDURE spCreateUser
	@Username		varchar(20),
	@EmailAddress	varchar(50),
	@Password		varchar(20)

AS

SET NOCOUNT ON
IF NOT EXISTS(
	SELECT NULL
	FROM Users
	WHERE Username = @Username OR EmailAddress = @EmailAddress
) BEGIN
	INSERT INTO Users (Username, EmailAddress, Biography, Password, DateCreated)
	VALUES (@Username, @EmailAddress, '', @Password, GETDATE())
	SELECT UserID, Username, EmailAddress, Biography, DateCreated FROM Users WHERE UserID = @@IDENTITY
END ELSE BEGIN
	SELECT [Username] = '', [EmailAddress] = ''
END

GO

CREATE PROCEDURE spUpdateUser
	@userId		    int,
	@username		  varchar(20),
	@emailAddress	varchar(50),
	@biography		varchar(max)

AS

SET NOCOUNT ON
IF NOT EXISTS(
	SELECT NULL
	FROM Users
	WHERE UserID != @UserID AND (EmailAddress = @EmailAddress OR Username = @Username)
) BEGIN
	UPDATE Users
	SET Username = @Username, EmailAddress = @EmailAddress, Biography = @Biography
	WHERE UserID = @UserID
	SELECT UserID, Username, EmailAddress, Biography, DateCreated FROM Users WHERE UserID = @UserID
END

GO

CREATE PROCEDURE spDeleteUser
	@UserID		int

AS

SET NOCOUNT ON
IF EXISTS(
	SELECT NULL
	FROM Users
	WHERE UserID = @UserID
) BEGIN
	UPDATE Users
	SET Deleted = 1
	WHERE UserID = @UserID
	RETURN 1
END ELSE BEGIN
	RETURN 0
END

GO

CREATE PROCEDURE spUpdateUserPassword
	@UserID			int,
	@OldPassword	varchar(20),
	@NewPassword	varchar(20)

AS

SET NOCOUNT ON

IF EXISTS(
	SELECT NULL
	FROM Users
	WHERE UserID = @UserID AND Password = @OldPassword
) BEGIN
	UPDATE Users
	SET Password = @NewPassword
	WHERE UserID = @UserID
	RETURN 1
END ELSE BEGIN
	RETURN 0
END

GO

CREATE PROCEDURE spGetUsers

AS

SET NOCOUNT ON

BEGIN

	SELECT UserID, Username, Biography, DateCreated
	FROM Users
  WHERE Deleted = 0
  ORDER BY Username

END

GO

CREATE PROCEDURE spGetUserById
	@userId int

AS

SET NOCOUNT ON

BEGIN

	SELECT *
	FROM Users
	WHERE UserID = @userId AND Deleted = 0

END


-- Posts

GO

CREATE PROCEDURE spCreatePost
	@topicId int,
	@userId int,
	@title varchar(30),
	@text varchar(max)

AS

SET NOCOUNT ON
BEGIN
	INSERT INTO Posts (TopicID, UserID, Title, [Text], DateCreated)
	VALUES (@topicId, @userId, @title, @text, GETDATE())
	SELECT * FROM Posts WHERE PostID = @@IDENTITY
END

GO

CREATE PROCEDURE spUpdatePost
	@postID		int,
	@topicID	int,
	@title  	varchar(100),
	@text    	varchar(max),
	@stickied   bit

AS

SET NOCOUNT ON
IF EXISTS(
	SELECT NULL
	FROM Posts
	WHERE PostID = @postID
) BEGIN
	UPDATE Posts
	SET TopicID = @topicID, Title = @title, Text = @text, Stickied = @stickied
	WHERE PostID = @postID
	SELECT * FROM Posts WHERE PostID = @postID
END

GO

CREATE PROCEDURE spGetNewPosts
 @limit int
AS
SET NOCOUNT ON
BEGIN
 SELECT TOP(@limit) p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username
 FROM Posts p
  JOIN Topics t ON p.TopicID = t.TopicID
  JOIN Users u ON p.UserID = u.UserID
 WHERE p.Deleted = 0 AND t.Deleted = 0
 ORDER BY p.DateCreated DESC
END

GO

CREATE PROCEDURE spGetActivePosts
 @limit int
AS
SET NOCOUNT ON
BEGIN
 SELECT TOP(@limit) p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username, ReplyCount = COUNT(ReplyID), NewestReply = MAX(r.DateCreated)
 FROM Posts p
  JOIN Topics t ON p.TopicID = t.TopicID
  JOIN Users u ON p.UserID = u.UserID
  JOIN Replies r ON p.PostID = r.PostID
 WHERE p.Deleted = 0 AND t.Deleted = 0
 GROUP BY p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username
 ORDER BY NewestReply DESC
END

GO

CREATE PROCEDURE spDeletePost
	@PostID		int

AS

SET NOCOUNT ON
IF EXISTS(
	SELECT NULL
	FROM Posts
	WHERE PostID = @PostID
) BEGIN
	UPDATE Posts
	SET Deleted = 1
	WHERE PostID = @PostID
	RETURN 1
END ELSE BEGIN
	RETURN 0
END

-- Replies

GO

CREATE PROCEDURE spCreateReply
	@PostID	  int,
	@UserID		int,
	@Text   	varchar(max)

AS

SET NOCOUNT ON
IF EXISTS(
	SELECT NULL
	FROM Posts
	WHERE PostID = @PostID
) AND EXISTS (
	SELECT NULL
	FROM Users
	WHERE UserID = @UserID
) BEGIN
	INSERT INTO Replies (PostID, UserID, Text, DateCreated)
	VALUES (@PostID, @UserID, @Text, GETDATE())
	SELECT * FROM Replies WHERE ReplyID = @@IDENTITY
END ELSE BEGIN
	SELECT [error] = 'Could not add user, check foreign keys'
END

GO
CREATE PROCEDURE spUpdateReply
	@replyID		int,
	@text			varchar(max)

AS
SET NOCOUNT ON

IF NOT EXISTS(	SELECT NULL
				FROM Replies
				WHERE ReplyID = @replyID AND Text = @text
) BEGIN
		UPDATE Replies
		SET Text = @text
		WHERE ReplyID = @replyID
		SELECT Text FROM Replies WHERE ReplyID = @replyID
END



GO

CREATE PROCEDURE spDeleteReply
	@replyId int

AS

SET NOCOUNT ON
IF EXISTS(
	SELECT NULL
	FROM Replies
	WHERE ReplyID = @replyId
) BEGIN
	UPDATE Replies
	SET Deleted = 1
	WHERE ReplyID = @replyId
	RETURN 1
END ELSE BEGIN
	RETURN 0
END


-- Messages

GO

CREATE PROCEDURE spCreateMessage
	@senderId int,
	@recipientId int,
	@subject varchar(30),
	@text varchar(max)

AS

SET NOCOUNT ON
BEGIN
	INSERT INTO Messages (SenderID, RecipientID, Subject, Text, DateCreated)
	VALUES (@senderId, @recipientId, @subject, @text, GETDATE())
	SELECT * FROM Messages WHERE MessageID = @@IDENTITY
END

GO

CREATE PROCEDURE spDeleteMessage
	@messageId int

AS

SET NOCOUNT ON
IF EXISTS(
	SELECT NULL
	FROM Messages
	WHERE MessageID = @messageId
) BEGIN
	UPDATE Messages
	SET Deleted = 1
	WHERE MessageID = @messageId
	RETURN 1
END ELSE BEGIN
	RETURN 0
END

-- Reads

GO

CREATE PROCEDURE spCreateTopic
	@userID			int,
	@name			varchar(30),
	@description	varchar(max)
AS

SET NOCOUNT ON
BEGIN
	INSERT INTO Topics (UserID, Name, Description, DateCreated)
	VALUES (@userID, @name, @description, GETDATE())
	SELECT * FROM Topics WHERE TopicID = @@IDENTITY
END

GO

CREATE PROCEDURE spGetTopicsByUser
	@userId int,
	@limit int

AS

SET NOCOUNT ON

BEGIN

	SELECT TOP(@limit) *
	FROM Topics
	WHERE UserID = @userId AND Deleted = 0

END



GO

CREATE PROCEDURE spUpdateTopic
	@topicId			int,
	@name				varchar(30),
	@description		varchar(max)
AS

SET NOCOUNT ON
BEGIN
	UPDATE Topics
	SET Name = @name, Description = @description
	WHERE TopicID = @topicId AND Deleted = 0
	SELECT * FROM Topics WHERE TopicID = @topicId
END

GO

CREATE PROCEDURE spGetTopics

AS

SET NOCOUNT ON
BEGIN
	SELECT *
	FROM Topics
  WHERE Deleted = 0
	ORDER BY Name
END

GO

CREATE PROCEDURE spGetTopicById
  @topicId int

AS

SET NOCOUNT ON
BEGIN
	SELECT t.TopicID, t.Name, t.Description, t.DateCreated, u.UserID, u.Username
	FROM Topics t
    JOIN Users u ON t.UserID = u.UserID
	WHERE TopicID = @topicId
END

GO

CREATE PROCEDURE spDeleteTopic
	@topicID		int

AS

SET NOCOUNT ON
IF EXISTS(
  SELECT NULL
  FROM Topics
  WHERE TopicID = @topicID
) BEGIN
	UPDATE Topics
	SET Deleted = 1
	WHERE TopicID = @TopicID
	RETURN 1
END ELSE BEGIN
  RETURN 0
END

GO

CREATE PROCEDURE spGetNewTopics
	@limit int

AS

SET NOCOUNT ON

BEGIN

	SELECT TOP(@limit) *
	FROM Topics
  WHERE Deleted = 0
	ORDER BY DateCreated DESC

END

GO

CREATE PROCEDURE spGetPostById
	@PostID int

AS

SET NOCOUNT ON

BEGIN

  SELECT p.PostID, p.Title, p.Text, p.Stickied, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username
  FROM Posts p
   JOIN Topics t ON p.TopicID = t.TopicID
   JOIN Users u ON p.UserID = u.UserID
  WHERE PostID = @PostID AND p.Deleted = 0

END


GO

CREATE PROCEDURE spGetPostsByTopic
	@topicId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
  SELECT TOP(@limit) p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username, ReplyCount = COUNT(ReplyID)
  FROM Posts p
   JOIN Topics t ON p.TopicID = t.TopicID
   JOIN Users u ON p.UserID = u.UserID
   LEFT JOIN Replies r ON p.PostID = r.PostID
  WHERE t.TopicID = @topicId AND p.Deleted = 0 AND p.Stickied = 0
  GROUP BY p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username
  ORDER BY p.DateCreated DESC
END

GO

CREATE PROCEDURE spGetStickiedPostsByTopic
	@topicId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
  SELECT TOP(@limit) p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username, ReplyCount = COUNT(ReplyID)
  FROM Posts p
   JOIN Topics t ON p.TopicID = t.TopicID
   JOIN Users u ON p.UserID = u.UserID
   JOIN Replies r ON p.PostID = r.PostID
  WHERE t.TopicID = @topicId AND p.Deleted = 0 AND p.Stickied = 1
  GROUP BY p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username
  ORDER BY p.DateCreated DESC
END

GO

CREATE PROCEDURE spGetPostsByUser
	@userId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
	SELECT TOP(@limit) p.PostID, p.Title, p.Text, p.DateCreated, t.TopicID, t.Name, u.UserID, u.Username
	FROM Users u
		Join Posts p
			ON u.UserID = p.UserID
		JOIN Topics t
			ON t.TopicID = p.TopicID
	WHERE p.Deleted = 0 AND t.Deleted = 0 AND u.UserID = @userID
	ORDER BY DateCreated DESC
END

GO

CREATE PROCEDURE spGetRepliesByUser
	@userId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
	SELECT TOP(@limit) r.ReplyID, r.PostID, r.Text, r.DateCreated, u.UserID, u.Username
	FROM Replies r
		JOIN Users u
			ON r.UserID = u.UserID
	WHERE r.UserID = @userId AND r.Deleted = 0
ORDER BY DateCreated DESC
END



GO

CREATE PROCEDURE spGetRepliesByPost
	@postId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
	SELECT TOP(@limit) r.ReplyID, r.PostID, r.Text, r.DateCreated, u.UserID, u.Username
  FROM Replies r
		JOIN Users u
			ON r.UserID = u.UserID
	WHERE PostId = @postId AND r.Deleted = 0
	ORDER BY DateCreated DESC
END

GO

CREATE PROCEDURE spGetMessagesReceivedByUser
	@userId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
	SELECT TOP(@limit) m.MessageID, m.Subject, m.Text, m.DateCreated, SenderID = s.UserID,
    SenderUsername = s.Username, RecipientID = r.UserID, RecipientUsername = r.Username
	FROM Messages m
		JOIN Users r
			ON r.UserID = RecipientID
		JOIN Users s
			ON s.UserID = SenderID
	WHERE m.RecipientID = @userId AND m.Deleted = 0
	ORDER BY m.DateCreated DESC
END

GO

CREATE PROCEDURE spGetMessagesSentByUser
	@userId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
  SELECT TOP(@limit) m.MessageID, m.Subject, m.Text, m.DateCreated, SenderID = s.UserID,
    SenderUsername = s.Username, RecipientID = r.UserID, RecipientUsername = r.Username
  FROM Messages m
    JOIN Users r
      ON r.UserID = RecipientID
    JOIN Users s
      ON s.UserID = SenderID
  WHERE m.SenderID = @userId
  ORDER BY m.DateCreated DESC
END

GO

CREATE PROCEDURE spGetMessagesDeletedByUser
	@userId int,
	@limit int

AS

SET NOCOUNT ON
BEGIN
	SELECT TOP(@limit) m.MessageID, m.Subject, m.Text, m.DateCreated, SenderID = s.UserID,
    SenderUsername = s.Username, RecipientID = r.UserID, RecipientUsername = r.Username
	FROM Messages m
		JOIN Users r
			ON r.UserID = RecipientID
		JOIN Users s
			ON s.UserID = SenderID
	WHERE m.RecipientID = @userId AND m.Deleted = 1
	ORDER BY m.DateCreated DESC
END

GO

CREATE PROCEDURE spGetNewUsers
	@limit int

AS

SET NOCOUNT ON
BEGIN
	SELECT TOP(@limit) UserID, Username, EmailAddress, Biography, DateCreated
	FROM Users
  WHERE Deleted = 0
	ORDER BY DateCreated DESC
END

GO

CREATE PROCEDURE spCreateLoginAttempt
	@username varchar(20),
	@password varchar(20)

AS

SET NOCOUNT ON
BEGIN
  SELECT UserID, Username, EmailAddress, Biography, DateCreated
  FROM Users
  WHERE Username = @username AND Password = @password AND Deleted = 0
END


-- Inserts

GO

USE Forum

SET IDENTITY_INSERT Users ON
INSERT INTO Users (UserID, Username, EmailAddress, Biography, Password, DateCreated)
VALUES
	(1, 'cinggall0', 'srowson0@salon.com', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '9sZdBZRhU', '2015-12-02 19:46:09'),
	(2, 'ppetrie1', 'laberkirdo1@amazon.co.jp', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 'aSoVFJhz', '2016-01-06 15:41:44'),
	(3, 'pjakobsson2', 'rcicccitti2@craigslist.org', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'STay4JnhNr', '2015-12-13 18:30:33'),
	(4, 'zlongman3', 'lpinkstone3@elegantthemes.com', 'Sed ante.', 'fjv2fL', '2016-01-22 19:57:35'),
	(5, 'ieccleston4', 'tlill4@stanford.edu', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'g7f6emsm', '2015-06-04 21:48:28'),
	(6, 'epickburn5', 'ssinkin5@lycos.com', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 'FHG9Tm', '2015-06-09 14:44:51'),
	(7, 'rgitthouse6', 'wmurcott6@devhub.com', 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', 'CAUJXwIszP8', '2016-04-24 04:17:31'),
	(8, 'dbrewster7', 'kshegog7@e-recht24.de', 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 'GvmUFsCB', '2015-04-29 17:44:46'),
	(9, 'jmcgeever8', 'fguarnier8@squidoo.com', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'y9fv5DRB', '2015-04-28 09:21:58'),
	(10, 'xaleksich9', 'wissakov9@auda.org.au', 'Integer ac neque. Duis bibendum.', 'c797UzW', '2015-08-21 15:23:16'),
	(11, 'esheerana', 'rsoutherella@wikia.com', 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', 'XLQCGDF2', '2016-02-14 03:36:37'),
	(12, 'vsarneyb', 'nscarsbrookeb@apache.org', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Hg7a625Mhv', '2016-02-17 09:43:03'),
	(13, 'mfenkelc', 'sbalconc@exblog.jp', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '6vDyUZ2', '2015-10-06 10:18:01'),
	(14, 'eroskruged', 'tleveed@baidu.com', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'cuZQLEy8aVF', '2016-02-15 11:43:45'),
	(15, 'crobake', 'ryezafoviche@chicagotribune.com', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', 'Rd4rskwe', '2015-05-17 10:42:38'),
	(16, 'acraydonf', 'mkobkef@google.com.br', 'Duis ac nibh.', 'xR9QVBNFz', '2016-03-26 01:46:27'),
	(17, 'tconnichieg', 'ngittensg@yandex.ru', 'In hac habitasse platea dictumst.', 'naP3tXvC', '2015-11-08 17:06:38'),
	(18, 'anannonih', 'jcarayolh@dropbox.com', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti.', '7oynygld', '2015-09-29 20:31:21'),
	(19, 'akaplini', 'mmccrayi@vistaprint.com', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'lpemzB4DZfrU', '2016-02-14 11:39:24'),
	(20, 'bcrofthwaitej', 'dwaldenj@narod.ru', 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', 'INfVT970RivA', '2015-10-22 10:25:10'),
	(21, 'dhounshamk', 'spickringk@psu.edu', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '7htDoCTM', '2015-07-06 05:57:38'),
	(22, 'crobuchonl', 'jlemmonl@jugem.jp', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Ma9pnP', '2016-04-27 18:00:46'),
	(23, 'jmcmenamym', 'bgaffneym@taobao.com', 'Phasellus sit amet erat.', 'LKcyE53tKj1', '2015-11-20 04:58:04'),
	(24, 'fhorryn', 'rerien@jimdo.com', 'Nulla suscipit ligula in lacus.', 'ry3cTOxaLE', '2016-03-03 12:40:13'),
	(25, 'gcoulto', 'dgrieveso@who.int', 'Fusce consequat. Nulla nisl.', '5ID21q4', '2015-06-28 02:35:23'),
	(26, 'kdumingosp', 'eullyattp@ow.ly', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'IUHrNnvlIQy', '2015-08-17 22:36:00'),
	(27, 'eboffinq', 'jhearfieldq@google.nl', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti.', 'UAfMtJWW', '2016-04-24 06:31:20'),
	(28, 'jgurysr', 'lmustardr@wsj.com', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', 'hrDaDHoGKv', '2015-12-23 16:24:29'),
	(29, 'mwestwoods', 'ddurrams@oakley.com', 'Proin eu mi. Nulla ac enim.', 'sM67XU', '2016-01-13 08:32:29'),
	(30, 'cdoodneyt', 'saglionet@desdev.cn', 'Etiam pretium iaculis justo.', 'LkignzR7', '2015-08-17 05:16:04')
SET IDENTITY_INSERT Users OFF

SET IDENTITY_INSERT Topics ON
INSERT INTO Topics (TopicID, UserID, Name, Description, DateCreated) VALUES
	(1, 1, 'Electronics', 'Suspendisse potenti. Nullam porttitor lacus at turpis.', '2016-05-31 14:31:00'),
	(2, 2, 'Jewelery', 'Integer non velit.', '2016-06-01 14:30:31'),
	(3, 3, 'Shoes', 'Donec ut dolor.', '2016-05-07 06:49:58'),
	(4, 4, 'Garden', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', '2016-11-02 23:31:19'),
	(5, 15, 'Computers', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2016-09-08 17:22:26'),
	(6, 6, 'Health', 'Nullam varius.', '2016-05-16 19:53:11'),
	(7, 7, 'Sports', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2016-10-27 11:56:49'),
	(8, 8, 'Baby', 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-01-16 18:19:06'),
	(9, 9, 'Television', 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2016-12-05 09:23:14'),
	(10, 10, 'Games', 'Pellentesque viverra pede ac diam.', '2017-04-27 11:13:16')
SET IDENTITY_INSERT Topics OFF

SET IDENTITY_INSERT Posts ON
INSERT INTO Posts (PostID, TopicID, UserID, Title, Text, DateCreated) VALUES
	(1, 8, 19, 'Vision-oriented disintermediate protocol', 'Vivamus vestibulum sagittis sapien.', '2016-08-16 10:40:45'),
	(2, 9, 5, 'Cross-group object-oriented encryption', 'Curabitur in libero ut massa volutpat convallis.', '2017-04-15 06:47:27'),
	(3, 1, 13, 'Robust multimedia frame', 'Aliquam erat volutpat.', '2016-08-25 22:48:35'),
	(4, 9, 18, 'Organized contextually-based throughput', 'Curabitur gravida nisi at nibh.', '2016-12-14 09:17:26'),
	(5, 5, 27, 'Adaptive non-volatile ability', 'Donec quis orci eget orci vehicula condimentum.', '2016-11-07 11:21:39'),
	(6, 6, 20, 'Upgradable bottom-line neural-net', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2016-09-06 11:07:51'),
	(7, 9, 18, 'Proactive background Graphical User Interface', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2016-09-03 09:45:45'),
	(8, 1, 22, 'Mandatory tertiary protocol', 'Duis at velit eu est congue elementum.', '2016-11-30 14:48:39'),
	(9, 6, 7, 'Diverse human-resource success', 'Nam dui.', '2016-04-30 19:06:23'),
	(10, 8, 18, 'Synchronised neutral solution', 'Donec semper sapien a libero.', '2016-04-28 16:58:25'),
	(11, 3, 15, 'Realigned actuating neural-net', 'In hac habitasse platea dictumst.', '2016-08-22 03:21:16'),
	(12, 8, 27, 'Fully-configurable hybrid success', 'Morbi non lectus.', '2016-05-30 10:44:10'),
	(13, 2, 25, 'Extended system-worthy hardware', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2016-05-13 07:39:11'),
	(14, 7, 25, 'Reactive user-facing customer loyalty', 'Pellentesque at nulla.', '2016-09-27 01:14:03'),
	(15, 8, 20, 'Customizable dedicated internet solution', 'Phasellus in felis.', '2016-06-26 00:41:42'),
	(16, 9, 2, 'Vision-oriented homogeneous archive', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-03-15 02:32:38'),
	(17, 3, 19, 'Streamlined logistical functionalities', 'Nullam porttitor lacus at turpis.', '2016-05-01 03:15:22'),
	(18, 2, 4, 'Visionary responsive capability', 'Aliquam sit amet diam in magna bibendum imperdiet.', '2016-10-26 08:21:18'),
	(19, 3, 21, 'Adaptive leading edge software', 'Proin risus.', '2017-04-26 05:13:14'),
	(20, 8, 6, 'Intuitive systematic application', 'Maecenas pulvinar lobortis est.', '2016-10-28 15:36:18'),
	(21, 4, 9, 'Reactive empowering definition', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2016-11-21 16:21:50'),
	(22, 1, 28, 'Up-sized solution-oriented application', 'Maecenas tincidunt lacus at velit.', '2017-01-26 01:23:36'),
	(23, 6, 5, 'Adaptive neutral solution', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2017-04-02 02:59:11'),
	(24, 8, 29, 'Profit-focused background methodology', 'Nunc rhoncus dui vel sem.', '2016-08-15 02:11:36'),
	(25, 4, 1, 'Extended reciprocal orchestration', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2016-09-12 13:26:18'),
	(26, 3, 16, 'Face to face radical model', 'Aliquam sit amet diam in magna bibendum imperdiet.', '2016-11-28 17:57:01'),
	(27, 6, 5, 'Universal multi-tasking info-mediaries', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2016-12-15 21:17:29'),
	(28, 4, 27, 'Stand-alone methodical contingency', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2016-08-12 00:04:12'),
	(29, 8, 27, 'User-friendly 3rd generation moratorium', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2016-08-04 04:05:10'),
	(30, 3, 16, 'Extended object-oriented analyzer', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2016-08-22 06:25:30'),
	(31, 7, 13, 'Streamlined secondary implementation', 'Aliquam erat volutpat.', '2016-07-27 00:02:17'),
	(32, 1, 23, 'Open-source national strategy', 'Duis bibendum.', '2017-02-23 13:59:51'),
	(33, 4, 8, 'Optimized multimedia infrastructure', 'Suspendisse accumsan tortor quis turpis.', '2016-07-06 11:08:58'),
	(34, 6, 11, 'Stand-alone executive conglomeration', 'Nulla mollis molestie lorem.', '2016-07-13 14:44:06'),
	(35, 6, 18, 'Programmable discrete installation', 'Cras in purus eu magna vulputate luctus.', '2016-10-21 14:05:44'),
	(36, 2, 2, 'Front-line next generation infrastructure', 'Etiam faucibus cursus urna.', '2016-07-29 10:16:33'),
	(37, 10, 23, 'Advanced explicit orchestration', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2017-02-07 22:21:04'),
	(38, 5, 12, 'Organized non-volatile help-desk', 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2016-05-23 16:32:38'),
	(39, 5, 3, 'Adaptive bi-directional capacity', 'Curabitur at ipsum ac tellus semper interdum.', '2016-05-04 19:23:44'),
	(40, 8, 15, 'Persistent empowering implementation', 'In quis justo.', '2016-08-30 02:40:08'),
	(41, 7, 29, 'Exclusive interactive Graphic Interface', 'Cras pellentesque volutpat dui.', '2017-03-28 03:07:13'),
	(42, 10, 9, 'Public-key homogeneous toolset', 'Cras pellentesque volutpat dui.', '2016-10-30 08:28:23'),
	(43, 3, 28, 'Mandatory directional initiative', 'Praesent lectus.', '2016-07-27 10:45:43'),
	(44, 10, 16, 'Advanced logistical encoding', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2016-09-19 18:03:36'),
	(45, 3, 9, 'Cross-group fresh-thinking alliance', 'Praesent blandit.', '2016-07-13 14:11:21'),
	(46, 1, 3, 'Visionary 4th generation throughput', 'Aenean lectus.', '2016-05-10 19:17:10'),
	(47, 6, 21, 'Extended context-sensitive emulation', 'In hac habitasse platea dictumst.', '2016-06-13 16:07:31'),
	(48, 7, 23, 'Configurable 24/7 collaboration', 'Mauris lacinia sapien quis libero.', '2017-01-31 16:32:55'),
	(49, 6, 13, 'Multi-tiered non-volatile pricing structure', 'Duis consequat dui nec nisi volutpat eleifend.', '2017-03-03 19:38:17'),
	(50, 3, 30, 'Operative hybrid analyzer', 'Integer ac leo.', '2016-08-01 08:26:10'),
	(51, 10, 11, 'Programmable motivating open architecture', 'Sed ante.', '2016-11-22 02:14:56'),
	(52, 9, 15, 'Synchronised 6th generation process improvement', 'Curabitur in libero ut massa volutpat convallis.', '2016-09-04 12:13:50'),
	(53, 1, 1, 'Grass-roots bi-directional extranet', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2016-10-19 03:13:59'),
	(54, 4, 7, 'Multi-lateral attitude-oriented capability', 'Morbi vel lectus in quam fringilla rhoncus.', '2016-06-24 06:03:01'),
	(55, 4, 4, 'Organized 5th generation matrix', 'Morbi non quam nec dui luctus rutrum.', '2017-02-05 03:52:30'),
	(56, 1, 29, 'Organized 3rd generation website', 'Morbi ut odio.', '2016-05-10 09:52:35'),
	(57, 10, 15, 'Profit-focused attitude-oriented algorithm', 'Proin interdum mauris non ligula pellentesque ultrices.', '2016-09-14 17:38:34'),
	(58, 10, 18, 'Ameliorated well-modulated secured line', 'Praesent lectus.', '2016-09-29 18:06:22'),
	(59, 9, 21, 'Seamless methodical capability', 'Aenean sit amet justo.', '2017-01-24 16:20:58'),
	(60, 6, 21, 'Upgradable bottom-line archive', 'Nulla suscipit ligula in lacus.', '2016-06-04 05:51:36'),
	(61, 1, 22, 'Profound interactive open system', 'Pellentesque viverra pede ac diam.', '2016-09-01 05:55:36'),
	(62, 1, 26, 'Front-line optimal capability', 'Mauris sit amet eros.', '2017-01-03 09:50:23'),
	(63, 7, 10, 'Right-sized maximized Graphic Interface', 'Praesent blandit.', '2016-11-20 12:44:06'),
	(64, 2, 1, 'De-engineered 4th generation functionalities', 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2016-06-25 20:29:40'),
	(65, 10, 27, 'Team-oriented stable matrix', 'Integer non velit.', '2017-02-01 18:41:57'),
	(66, 9, 7, 'Devolved empowering standardization', 'Proin interdum mauris non ligula pellentesque ultrices.', '2017-02-07 06:04:20'),
	(67, 3, 20, 'Synchronised analyzing definition', 'In hac habitasse platea dictumst.', '2016-07-23 15:28:22'),
	(68, 2, 17, 'Polarised secondary monitoring', 'Donec posuere metus vitae ipsum.', '2016-10-15 04:55:05'),
	(69, 8, 1, 'Reduced analyzing implementation', 'Aenean sit amet justo.', '2016-08-17 11:47:26'),
	(70, 4, 14, 'Monitored local synergy', 'Donec quis orci eget orci vehicula condimentum.', '2016-05-19 23:36:10'),
	(71, 5, 9, 'Adaptive hybrid workforce', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2017-04-27 11:14:04'),
	(72, 8, 4, 'Self-enabling context-sensitive help-desk', 'Mauris ullamcorper purus sit amet nulla.', '2016-06-07 06:02:58'),
	(73, 5, 2, 'Grass-roots human-resource archive', 'Aliquam non mauris.', '2017-03-10 12:41:17'),
	(74, 2, 23, 'Centralized bottom-line budgetary management', 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2016-12-15 13:02:57'),
	(75, 7, 14, 'Team-oriented interactive Graphic Interface', 'Nulla justo.', '2016-05-29 02:02:15'),
	(76, 9, 5, 'Optimized intangible system engine', 'Morbi vel lectus in quam fringilla rhoncus.', '2016-06-27 23:06:20'),
	(77, 2, 18, 'Ergonomic attitude-oriented installation', 'Suspendisse potenti.', '2016-12-25 09:17:20'),
	(78, 10, 15, 'Cross-platform optimizing internet solution', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam.', '2017-01-24 17:22:28'),
	(79, 6, 20, 'Multi-lateral 4th generation service-desk', 'Curabitur gravida nisi at nibh.', '2016-09-12 18:02:13'),
	(80, 1, 29, 'Synergistic needs-based core', 'Donec quis orci eget orci vehicula condimentum.', '2016-06-14 08:44:03'),
	(81, 8, 4, 'User-friendly coherent Graphical User Interface', 'Nullam varius.', '2016-11-19 17:31:50'),
	(82, 6, 24, 'Reverse-engineered contextually-based data-warehouse', 'Vestibulum sed magna at nunc commodo placerat.', '2016-10-19 18:15:10'),
	(83, 10, 9, 'Devolved neutral collaboration', 'Morbi non quam nec dui luctus rutrum.', '2016-11-29 16:59:23'),
	(84, 6, 19, 'Automated real-time budgetary management', 'In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2016-12-03 08:40:02'),
	(85, 9, 26, 'Fully-configurable 24 hour standardization', 'Mauris sit amet eros.', '2016-07-26 20:22:28'),
	(86, 5, 21, 'Persistent human-resource alliance', 'Curabitur at ipsum ac tellus semper interdum.', '2016-09-28 06:20:38'),
	(87, 6, 9, 'Cloned mobile intranet', 'In congue.', '2016-05-02 07:05:51'),
	(88, 9, 5, 'Programmable responsive ability', 'Morbi non lectus.', '2016-08-27 13:40:35'),
	(89, 1, 15, 'Business-focused holistic contingency', 'Aliquam erat volutpat.', '2017-04-24 01:15:33'),
	(90, 4, 20, 'Customer-focused responsive budgetary management', 'Morbi vel lectus in quam fringilla rhoncus.', '2017-01-16 19:30:00'),
	(91, 8, 22, 'Compatible reciprocal portal', 'Integer tincidunt ante vel ipsum.', '2016-11-18 09:18:25'),
	(92, 4, 10, 'Cloned client-server paradigm', 'Aenean auctor gravida sem.', '2016-05-23 16:50:02'),
	(93, 7, 20, 'Universal zero tolerance workforce', 'Vestibulum rutrum rutrum neque.', '2016-07-01 17:22:42'),
	(94, 7, 16, 'Cloned empowering infrastructure', 'Sed accumsan felis.', '2017-02-26 05:26:24'),
	(95, 10, 23, 'Re-engineered upward-trending attitude', 'Vivamus in felis eu sapien cursus vestibulum.', '2017-02-02 18:38:41'),
	(96, 1, 6, 'Innovative clear-thinking Graphic Interface', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2016-11-28 11:19:38'),
	(97, 10, 23, 'Reactive human-resource collaboration', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2017-02-03 11:48:22'),
	(98, 9, 6, 'Business-focused coherent leverage', 'Mauris ullamcorper purus sit amet nulla.', '2016-09-06 17:36:18'),
	(99, 5, 7, 'Mandatory mobile encoding', 'Nulla justo.', '2016-05-06 00:54:17'),
	(100, 4, 24, 'User-friendly bifurcated parallelism', 'Etiam pretium iaculis justo.', '2016-06-11 07:53:21')


SET IDENTITY_INSERT Posts OFF

SET IDENTITY_INSERT Replies ON
INSERT INTO Replies (ReplyID, PostID, UserID, Text, DateCreated) VALUES
	(1, 60, 28, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2017-01-10 21:29:10'),
	(2, 96, 7, 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2016-09-14 03:20:47'),
	(3, 65, 21, 'Morbi a ipsum. Integer a nibh.', '2017-04-01 06:51:18'),
	(4, 40, 1, 'Nulla mollis molestie lorem.', '2017-04-16 17:05:50'),
	(5, 2, 16, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2016-09-18 10:05:30'),
	(6, 85, 16, 'Sed ante.', '2016-10-04 17:06:49'),
	(7, 17, 29, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2016-10-22 03:29:12'),
	(8, 22, 8, 'In sagittis dui vel nisl. Duis ac nibh.', '2016-08-01 17:47:06'),
	(9, 82, 13, 'Nullam varius.', '2016-12-31 19:52:43'),
	(10, 29, 12, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2017-02-21 17:34:06'),
	(11, 32, 3, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2017-03-07 14:06:52'),
	(12, 89, 24, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2016-09-07 04:30:01'),
	(13, 82, 24, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2016-12-16 09:07:15'),
	(14, 29, 9, 'Maecenas tincidunt lacus at velit.', '2017-01-23 23:14:32'),
	(15, 85, 11, 'Pellentesque at nulla.', '2016-11-25 04:01:52'),
	(16, 5, 25, 'Cras non velit nec nisi vulputate nonummy.', '2017-01-24 08:00:59'),
	(17, 70, 26, 'Sed ante. Vivamus tortor.', '2016-08-01 09:25:54'),
	(18, 52, 24, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2016-07-25 23:56:59'),
	(19, 23, 21, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2016-10-11 12:23:00'),
	(20, 26, 11, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2017-04-16 02:24:35'),
	(21, 36, 29, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2016-12-10 04:07:58'),
	(22, 82, 13, 'Integer a nibh.', '2016-07-13 08:25:21'),
	(23, 48, 12, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2017-01-21 08:36:01'),
	(24, 59, 7, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2016-10-14 05:52:03'),
	(25, 66, 21, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2016-12-15 03:23:27'),
	(26, 77, 26, 'Integer a nibh. In quis justo.', '2016-09-07 05:57:49'),
	(27, 84, 30, 'Mauris lacinia sapien quis libero.', '2016-12-23 13:48:28'),
	(28, 31, 5, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', '2016-06-05 04:58:31'),
	(29, 48, 14, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2016-11-23 15:29:33'),
	(30, 11, 19, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2016-05-22 01:17:30'),
	(31, 60, 20, 'Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2016-07-18 22:02:01'),
	(32, 89, 13, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2016-10-19 08:18:06'),
	(33, 42, 17, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-04-04 05:29:37'),
	(34, 89, 14, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2016-09-07 07:23:00'),
	(35, 39, 26, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2016-08-04 05:10:02'),
	(36, 52, 5, 'Aenean lectus.', '2016-12-31 10:02:40'),
	(37, 80, 28, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2016-08-31 22:10:21'),
	(38, 75, 14, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', '2017-01-10 12:56:48'),
	(39, 35, 20, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2017-03-11 16:47:21'),
	(40, 49, 27, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2016-08-20 05:56:02'),
	(41, 13, 22, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2016-06-18 03:13:39'),
	(42, 48, 12, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2017-02-19 04:57:49'),
	(43, 4, 1, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2016-07-09 05:58:51'),
	(44, 36, 27, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2016-12-27 05:44:03'),
	(45, 64, 2, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2017-02-07 00:46:49'),
	(46, 9, 8, 'Pellentesque eget nunc.', '2016-12-09 19:42:14'),
	(47, 4, 26, 'Etiam pretium iaculis justo.', '2017-01-10 04:24:58'),
	(48, 59, 23, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2016-06-13 03:02:30'),
	(49, 70, 3, 'Morbi a ipsum. Integer a nibh. In quis justo.', '2017-04-03 19:32:44'),
	(50, 41, 2, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2017-04-16 15:47:23'),
	(51, 31, 2, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2016-11-18 20:53:05'),
	(52, 61, 21, 'Nullam molestie nibh in lectus. Pellentesque at nulla.', '2016-10-03 15:00:41'),
	(53, 80, 29, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2017-04-15 11:51:48'),
	(54, 81, 2, 'Etiam vel augue. Vestibulum rutrum rutrum neque.', '2017-04-18 02:56:58'),
	(55, 93, 15, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2017-02-02 12:08:20'),
	(56, 90, 26, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2017-04-27 06:32:31'),
	(57, 1, 15, 'Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2016-05-14 23:40:17'),
	(58, 48, 12, 'Etiam vel augue. Vestibulum rutrum rutrum neque.', '2016-05-30 04:20:15'),
	(59, 11, 23, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2016-11-01 17:13:10'),
	(60, 68, 11, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2016-06-01 14:59:59'),
	(61, 59, 11, 'Suspendisse potenti.', '2016-06-28 18:19:42'),
	(62, 65, 27, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2016-06-06 06:15:31'),
	(63, 51, 21, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam.', '2016-09-09 11:34:57'),
	(64, 69, 5, 'Duis aliquam convallis nunc.', '2016-08-11 21:35:44'),
	(65, 14, 28, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2016-12-17 21:49:35'),
	(66, 55, 18, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2016-08-24 16:43:22'),
	(67, 38, 9, 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2017-03-20 17:31:13'),
	(68, 70, 8, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2017-04-14 03:02:03'),
	(69, 95, 2, 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2016-08-01 18:07:28'),
	(70, 56, 10, 'Praesent blandit. Nam nulla.', '2016-08-29 11:35:10'),
	(71, 9, 16, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2016-06-06 00:40:21'),
	(72, 77, 22, 'Vivamus vel nulla eget eros elementum pellentesque.', '2017-03-31 12:19:57'),
	(73, 13, 17, 'Vestibulum sed magna at nunc commodo placerat.', '2017-04-23 09:07:01'),
	(74, 27, 7, 'Nulla tellus. In sagittis dui vel nisl.', '2016-07-29 14:11:42'),
	(75, 65, 2, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2016-07-11 18:02:26'),
	(76, 19, 5, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.', '2017-01-14 10:20:26'),
	(77, 26, 12, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2016-06-14 22:45:40'),
	(78, 97, 17, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2017-03-30 04:34:18'),
	(79, 99, 3, 'Etiam faucibus cursus urna.', '2016-08-03 21:57:36'),
	(80, 95, 14, 'Donec semper sapien a libero. Nam dui.', '2016-10-26 14:47:56'),
	(81, 50, 2, 'Etiam pretium iaculis justo.', '2016-10-14 11:56:54'),
	(82, 39, 22, 'Vivamus vel nulla eget eros elementum pellentesque.', '2016-07-27 00:44:29'),
	(83, 51, 24, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2017-03-01 18:29:03'),
	(84, 50, 29, 'In quis justo.', '2017-02-02 11:35:43'),
	(85, 43, 15, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2016-07-28 20:38:04'),
	(86, 5, 20, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2016-05-17 08:50:07'),
	(87, 51, 6, 'Donec dapibus.', '2016-10-22 07:30:10'),
	(88, 18, 3, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2016-11-28 04:23:37'),
	(89, 89, 20, 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2017-02-23 03:11:45'),
	(90, 19, 14, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est.', '2016-05-12 00:45:37'),
	(91, 36, 17, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2016-12-09 19:39:36'),
	(92, 37, 27, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2017-03-16 03:01:48'),
	(93, 25, 20, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2016-09-14 02:38:36'),
	(94, 25, 10, 'Phasellus sit amet erat. Nulla tempus.', '2016-05-22 23:15:30'),
	(95, 85, 17, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2017-04-23 13:31:27'),
	(96, 14, 29, 'Fusce consequat.', '2016-09-01 05:40:48'),
	(97, 11, 22, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2016-08-29 10:38:48'),
	(98, 13, 24, 'Nullam molestie nibh in lectus.', '2016-08-26 21:07:42'),
	(99, 67, 18, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2016-10-10 00:29:49'),
	(100, 19, 19, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2016-11-04 13:32:58'),
	(101, 51, 2, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2017-02-11 21:57:39'),
	(102, 55, 28, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2017-01-26 16:46:21'),
	(103, 1, 23, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-03-12 05:35:32'),
	(104, 84, 24, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-03-11 07:19:20'),
	(105, 13, 1, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2017-04-06 03:29:54'),
	(106, 89, 17, 'In quis justo.', '2016-11-10 22:50:06'),
	(107, 92, 4, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2016-11-22 04:51:53'),
	(108, 3, 3, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2016-08-30 21:09:24'),
	(109, 40, 4, 'Integer tincidunt ante vel ipsum.', '2016-05-02 07:33:31'),
	(110, 35, 22, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2016-09-02 14:20:52'),
	(111, 58, 27, 'Pellentesque at nulla.', '2017-04-05 05:22:41'),
	(112, 48, 20, 'Nulla facilisi.', '2016-10-24 19:51:29'),
	(113, 11, 21, 'Aliquam erat volutpat. In congue. Etiam justo.', '2016-06-23 14:16:09'),
	(114, 5, 22, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2016-08-14 13:49:16'),
	(115, 56, 1, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2016-06-21 13:25:09'),
	(116, 100, 7, 'Proin risus. Praesent lectus.', '2016-06-27 12:54:38'),
	(117, 7, 7, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2017-04-21 14:16:31'),
	(118, 80, 8, 'In quis justo. Maecenas rhoncus aliquam lacus.', '2017-04-13 11:45:46'),
	(119, 84, 1, 'Morbi quis tortor id nulla ultrices aliquet.', '2016-10-09 15:16:04'),
	(120, 53, 29, 'Suspendisse potenti. Nullam porttitor lacus at turpis.', '2016-08-20 13:00:37'),
	(121, 78, 2, 'Pellentesque at nulla. Suspendisse potenti.', '2016-08-20 16:32:50'),
	(122, 21, 11, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2017-01-05 06:35:07'),
	(123, 34, 12, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2016-08-13 18:46:11'),
	(124, 73, 29, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2016-07-15 16:33:27'),
	(125, 24, 24, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2016-07-03 08:17:09'),
	(126, 18, 20, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2016-07-24 17:41:24'),
	(127, 67, 11, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2016-12-01 15:24:56'),
	(128, 20, 19, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2016-08-27 00:08:51'),
	(129, 36, 13, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '2017-01-07 11:15:51'),
	(130, 87, 6, 'Sed sagittis.', '2016-05-11 19:47:24'),
	(131, 99, 12, 'Pellentesque ultrices mattis odio.', '2016-06-14 04:44:01'),
	(132, 42, 27, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2016-05-25 18:43:45'),
	(133, 25, 24, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', '2016-08-22 11:41:24'),
	(134, 82, 29, 'Proin eu mi.', '2016-09-03 20:57:10'),
	(135, 92, 23, 'Donec ut dolor.', '2016-11-16 17:53:42'),
	(136, 10, 25, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2016-07-23 19:13:35'),
	(137, 62, 5, 'Sed vel enim sit amet nunc viverra dapibus.', '2016-05-11 18:23:35'),
	(138, 97, 1, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', '2017-04-22 03:01:35'),
	(139, 11, 29, 'Aliquam sit amet diam in magna bibendum imperdiet.', '2016-11-30 14:58:15'),
	(140, 21, 7, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '2017-03-22 21:04:21'),
	(141, 1, 23, 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2016-11-07 13:26:44'),
	(142, 67, 2, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2017-02-01 18:44:28'),
	(143, 28, 30, 'Curabitur convallis.', '2016-11-15 06:12:07'),
	(144, 93, 1, 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2016-11-20 10:26:18'),
	(145, 21, 7, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-01-16 07:49:16'),
	(146, 49, 1, 'Mauris lacinia sapien quis libero.', '2016-12-20 06:21:31'),
	(147, 93, 22, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', '2017-01-29 21:20:30'),
	(148, 55, 27, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2016-12-16 11:15:25'),
	(149, 97, 6, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2017-03-21 01:16:18'),
	(150, 98, 14, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2016-10-05 05:49:22'),
	(151, 19, 4, 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2017-02-13 14:36:48'),
	(152, 65, 25, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2017-03-08 11:34:51'),
	(153, 10, 6, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2017-03-08 19:43:26'),
	(154, 60, 22, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2017-01-20 14:44:35'),
	(155, 21, 25, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2016-10-11 22:38:22'),
	(156, 54, 18, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2016-08-30 05:05:16'),
	(157, 14, 17, 'Nullam molestie nibh in lectus.', '2017-02-03 14:21:48'),
	(158, 92, 19, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2016-05-18 23:04:44'),
	(159, 35, 12, 'Vivamus vel nulla eget eros elementum pellentesque.', '2016-11-08 15:32:42'),
	(160, 52, 2, 'In hac habitasse platea dictumst.', '2017-03-02 22:34:08'),
	(161, 63, 2, 'Suspendisse ornare consequat lectus.', '2016-07-02 13:58:52'),
	(162, 6, 4, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2017-02-18 15:54:41'),
	(163, 56, 26, 'Donec vitae nisi.', '2017-03-20 12:38:33'),
	(164, 87, 26, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2016-06-26 11:30:13'),
	(165, 10, 12, 'Integer ac neque.', '2016-10-11 05:21:29'),
	(166, 47, 10, 'Proin risus. Praesent lectus.', '2016-12-27 14:48:08'),
	(167, 85, 24, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-01-15 01:28:22'),
	(168, 94, 22, 'Curabitur gravida nisi at nibh.', '2016-08-26 13:49:36'),
	(169, 87, 25, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti.', '2016-11-21 01:45:46'),
	(170, 18, 29, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2016-05-11 11:52:56'),
	(171, 24, 8, 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2016-07-27 11:25:36'),
	(172, 64, 20, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-04-01 10:53:35'),
	(173, 77, 30, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2016-07-15 05:44:24'),
	(174, 54, 1, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2016-08-05 21:46:56'),
	(175, 74, 12, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2017-04-25 16:02:07'),
	(176, 84, 15, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2016-09-16 03:54:56'),
	(177, 50, 15, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2017-03-06 23:47:10'),
	(178, 8, 4, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2016-05-28 23:27:34'),
	(179, 65, 20, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2016-09-08 05:17:04'),
	(180, 55, 18, 'Pellentesque ultrices mattis odio.', '2016-10-17 21:03:22'),
	(181, 28, 10, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2016-07-19 04:28:38'),
	(182, 32, 12, 'Suspendisse potenti. In eleifend quam a odio.', '2017-02-01 02:06:07'),
	(183, 66, 17, 'Maecenas tincidunt lacus at velit.', '2016-12-20 23:41:43'),
	(184, 100, 21, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2017-02-19 12:36:59'),
	(185, 50, 27, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2016-11-19 08:59:14'),
	(186, 71, 2, 'Praesent blandit. Nam nulla.', '2016-09-07 23:30:33'),
	(187, 20, 26, 'Phasellus id sapien in sapien iaculis congue.', '2016-06-12 09:13:58'),
	(188, 5, 3, 'Mauris lacinia sapien quis libero.', '2016-11-14 09:48:39'),
	(189, 74, 24, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est.', '2016-06-18 05:05:41'),
	(190, 82, 21, 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2016-08-01 20:29:45'),
	(191, 83, 2, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2016-07-17 08:53:30'),
	(192, 2, 24, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2016-08-28 22:47:44'),
	(193, 90, 27, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2016-08-12 22:28:46'),
	(194, 63, 6, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2016-11-18 17:34:55'),
	(195, 55, 10, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', '2017-02-17 04:00:31'),
	(196, 20, 4, 'Donec dapibus.', '2017-03-21 20:49:50'),
	(197, 80, 24, 'Nunc rhoncus dui vel sem.', '2016-08-31 03:21:56'),
	(198, 41, 5, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2016-07-30 14:18:30'),
	(199, 24, 8, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2016-05-05 02:41:36'),
	(200, 18, 13, 'Morbi a ipsum. Integer a nibh. In quis justo.', '2017-02-19 11:37:29'),
	(201, 1, 21, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2017-02-18 04:31:03'),
	(202, 36, 26, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2016-06-17 02:59:35'),
	(203, 29, 12, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2016-09-30 19:14:10'),
	(204, 97, 4, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2017-01-22 02:14:28'),
	(205, 39, 8, 'Fusce consequat. Nulla nisl.', '2016-09-13 02:08:28'),
	(206, 92, 28, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '2016-12-12 07:41:13'),
	(207, 85, 15, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2017-01-22 06:43:11'),
	(208, 19, 13, 'Nulla tempus.', '2016-09-09 16:28:51'),
	(209, 79, 8, 'Nulla facilisi.', '2016-09-03 14:55:43'),
	(210, 51, 7, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2017-01-09 16:33:25'),
	(211, 14, 27, 'In hac habitasse platea dictumst.', '2016-06-28 07:05:18'),
	(212, 65, 26, 'Nulla ut erat id mauris vulputate elementum.', '2017-02-23 18:11:38'),
	(213, 63, 28, 'Integer ac neque. Duis bibendum.', '2016-10-29 17:33:20'),
	(214, 99, 27, 'Morbi non lectus.', '2017-03-21 09:42:48'),
	(215, 97, 10, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2016-05-05 13:13:52'),
	(216, 24, 19, 'In congue.', '2016-05-30 03:16:41'),
	(217, 37, 2, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est.', '2017-02-28 06:53:30'),
	(218, 49, 3, 'In congue. Etiam justo. Etiam pretium iaculis justo.', '2017-02-19 19:27:40'),
	(219, 84, 24, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2016-08-03 21:59:29'),
	(220, 11, 22, 'Duis at velit eu est congue elementum.', '2016-07-07 08:17:06'),
	(221, 42, 12, 'Praesent id massa id nisl venenatis lacinia.', '2017-04-09 10:55:05'),
	(222, 61, 30, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2016-09-04 17:46:53'),
	(223, 47, 2, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2016-09-15 13:06:13'),
	(224, 21, 29, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2016-09-07 01:09:57'),
	(225, 49, 29, 'Ut at dolor quis odio consequat varius. Integer ac leo.', '2016-08-13 18:13:53'),
	(226, 79, 17, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2016-12-31 01:01:45'),
	(227, 54, 16, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2016-08-02 10:50:16'),
	(228, 3, 14, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2016-05-31 06:19:22'),
	(229, 45, 26, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2016-10-07 10:38:47'),
	(230, 55, 20, 'Vestibulum ac est lacinia nisi venenatis tristique.', '2016-05-19 06:43:07'),
	(231, 84, 1, 'Nam dui.', '2016-06-01 06:39:06'),
	(232, 46, 14, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2016-09-12 06:52:37'),
	(233, 41, 20, 'Etiam pretium iaculis justo.', '2017-01-13 07:27:49'),
	(234, 68, 28, 'In hac habitasse platea dictumst.', '2017-03-16 08:57:43'),
	(235, 74, 8, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2017-02-12 11:30:10'),
	(236, 84, 6, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2016-05-29 11:52:01'),
	(237, 68, 27, 'Aenean auctor gravida sem.', '2016-08-12 15:57:53'),
	(238, 34, 21, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2017-03-25 07:46:06'),
	(239, 31, 16, 'In eleifend quam a odio.', '2016-06-01 16:25:45'),
	(240, 12, 30, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2017-02-21 03:26:26'),
	(241, 57, 16, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2016-11-01 16:59:04'),
	(242, 3, 21, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2017-02-19 21:30:39'),
	(243, 25, 5, 'Ut tellus.', '2017-03-01 17:43:15'),
	(244, 91, 28, 'Proin interdum mauris non ligula pellentesque ultrices.', '2016-09-09 07:22:30'),
	(245, 86, 11, 'Fusce consequat. Nulla nisl. Nunc nisl.', '2017-01-04 21:58:58'),
	(246, 73, 13, 'Proin at turpis a pede posuere nonummy.', '2016-09-30 08:01:16'),
	(247, 75, 14, 'Nulla tellus.', '2016-05-08 22:10:15'),
	(248, 86, 18, 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2016-07-31 07:29:36'),
	(249, 100, 18, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2016-07-24 04:13:13'),
	(250, 91, 25, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2016-08-22 21:24:56')
SET IDENTITY_INSERT Replies OFF

SET IDENTITY_INSERT Messages ON
INSERT INTO Messages (MessageID, SenderID, RecipientID, Subject, Text, DateCreated) VALUES
	(1, 13, 1, 'Fusce consequat.', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2016-07-14 22:26:31'),
	(2, 16, 13, 'Morbi quis tortor id nulla ultrices aliquet.', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', '2017-04-24 23:31:47'),
	(3, 15, 10, 'Mauris ullamcorper purus sit amet nulla.', 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2016-09-12 02:19:51'),
	(4, 22, 21, 'Suspendisse accumsan tortor quis turpis.', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2017-03-17 01:16:50'),
	(5, 5, 11, 'Quisque porta volutpat erat.', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2017-02-23 00:02:31'),
	(6, 29, 14, 'Nunc purus.', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2016-11-09 18:44:22'),
	(7, 11, 13, 'Mauris sit amet eros.', 'Sed sagittis.', '2017-02-28 15:41:10'),
	(8, 13, 13, 'Donec quis orci eget orci vehicula condimentum.', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2017-03-18 01:19:59'),
	(9, 2, 11, 'Aliquam erat volutpat.', 'In congue. Etiam justo.', '2016-10-26 03:35:55'),
	(10, 17, 23, 'Vestibulum ante ipsum primis in faucibus orci luctus faucibus accumsan odio.', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2016-09-11 16:20:12'),
	(11, 11, 7, 'Sed accumsan felis.', 'Duis bibendum.', '2016-06-21 04:17:25'),
	(12, 21, 28, 'Suspendisse ornare consequat lectus.', 'Pellentesque eget nunc.', '2017-04-27 09:57:30'),
	(13, 3, 16, 'In quis justo.', 'Proin eu mi.', '2017-03-02 22:26:21'),
	(14, 27, 7, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Vivamus tortor.', '2017-04-18 17:27:19'),
	(15, 5, 14, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2016-11-13 14:27:41'),
	(16, 14, 9, 'Suspendisse potenti.', 'Integer a nibh. In quis justo.', '2016-06-21 21:32:02'),
	(17, 22, 16, 'Morbi porttitor lorem id ligula.', 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2016-07-16 04:14:10'),
	(18, 10, 9, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Curabitur gravida nisi at nibh.', '2017-03-01 19:24:55'),
	(19, 21, 17, 'Morbi porttitor lorem id ligula.', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2016-08-06 00:25:46'),
	(20, 25, 16, 'Nam dui.', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2016-10-08 20:01:21'),
	(21, 4, 5, 'Etiam justo.', 'Nulla nisl.', '2017-01-10 01:52:44'),
	(22, 15, 23, 'Duis aliquam convallis nunc.', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2016-07-29 15:12:59'),
	(23, 4, 18, 'In hac habitasse platea dictumst.', 'Nulla ac enim.', '2016-09-24 16:45:25'),
	(24, 17, 27, 'Donec ut dolor.', 'Donec posuere metus vitae ipsum.', '2016-09-14 10:32:19'),
	(25, 18, 1, 'Praesent id massa id nisl venenatis lacinia.', 'Duis consequat dui nec nisi volutpat eleifend.', '2016-05-16 11:26:14'),
	(26, 24, 26, 'Curabitur gravida nisi at nibh.', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2016-08-10 07:44:28'),
	(27, 4, 16, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', 'Nunc purus. Phasellus in felis.', '2016-09-01 11:24:18'),
	(28, 29, 15, 'Fusce consequat.', 'Fusce posuere felis sed lacus.', '2016-10-11 20:24:59'),
	(29, 18, 2, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorperipit nulla elit ac nulla.', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2017-04-02 06:19:34'),
	(30, 16, 22, 'Vestibulum sed magna at nunc commodo placerat.', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2016-08-05 07:03:35'),
	(31, 15, 7, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2016-12-06 17:18:06'),
	(32, 13, 23, 'Suspendisse ornare consequat lectus.', 'Duis aliquam convallis nunc.', '2017-04-23 12:17:23'),
	(33, 14, 26, 'Quisque id justo sit amet sapien dignissim vestibulum.', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2016-06-01 05:59:05'),
	(34, 3, 3, 'Aenean auctor gravida sem.', 'Proin eu mi. Nulla ac enim.', '2017-04-10 15:32:52'),
	(35, 23, 7, 'Suspendisse potenti.', 'Praesent blandit lacinia erat.', '2017-01-26 04:40:33'),
	(36, 27, 15, 'Cras pellentesque volutpat dui.', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2016-06-30 18:49:31'),
	(37, 12, 17, 'Duis bibendum, felis sed interdum venenatis, turpis enim blanitor pede justo eu massa.', 'Suspendisse accumsan tortor quis turpis.', '2017-03-20 12:23:00'),
	(38, 6, 20, 'Nullam sit amet turpis elementum ligula vehicula consequat.', 'Suspendisse accumsan tortor quis turpis.', '2016-10-17 00:55:23'),
	(39, 22, 11, 'Sed ante.', 'Quisque porta volutpat erat.', '2017-04-07 22:15:16'),
	(40, 8, 1, 'Donec quis orci eget orci vehicula condimentum.', 'Pellentesque ultrices mattis odio.', '2016-05-15 05:34:06'),
	(41, 18, 28, 'Morbi non quam nec dui luctus rutrum.', 'Nam dui.', '2016-12-10 20:21:54'),
	(42, 29, 26, 'Aliquam quis turpis eget elit sodales scelerisque.', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2017-01-12 13:28:23'),
	(43, 28, 14, 'Quisque id justo sit amet sapien dignissim vestibulum.', 'Curabitur at ipsum ac tellus semper interdum.', '2017-01-24 10:31:53'),
	(44, 15, 9, 'Quisque ut erat.', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2016-05-20 20:41:16'),
	(45, 8, 12, 'Aliquam sit amet diam in magna bibendum imperdiet.', 'Aenean auctor gravida sem.', '2017-01-20 18:42:30'),
	(46, 2, 19, 'Fusce consequat.', 'Aliquam erat volutpat. In congue.', '2017-04-20 03:17:46'),
	(47, 10, 6, 'Suspendisse potenti.', 'Pellentesque eget nunc.', '2016-09-13 05:51:37'),
	(48, 10, 18, 'Duis mattis egestas metus.', 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2016-06-22 07:15:37'),
	(49, 11, 30, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2016-06-30 05:57:07'),
	(50, 23, 13, 'Nullam sit amet turpis elementum ligula vehicula consequat.', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2016-09-08 18:55:45')


SET IDENTITY_INSERT Messages OFF
