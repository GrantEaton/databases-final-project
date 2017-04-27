-- Stored Procedures
USE Forum
GO

--DROP PROCEDURE getMessagesSentByUser
--DROP PROCEDURE getMessagesReceivedByUser
------------------------------


GO

CREATE PROCEDURE getMessagesReceivedByUser
    @userId int,
    @limit int

AS

SET NOCOUNT ON

    SELECT TOP(@limit) [To] = r.UserName, [From] = s.UserName, m.DateCreated, m.Subject, m.Text
    FROM Messages m
        JOIN Users r
            ON r.UserID = RecipientID
        JOIN Users s
            ON s.UserID = SenderID    
    WHERE m.RecipientID = @userId
    GROUP BY s.UserName, m.DateCreated, m.Subject, m.Text, r.UserName
    ORDER BY m.DateCreated DESC

-----------------------------------------------------------------------------    

GO

CREATE PROCEDURE getMessagesSentByUser
    @userId int,
    @limit int

AS

SET NOCOUNT ON

    SELECT TOP(@limit)  [From] = s.UserName, [To] = r.UserName, m.DateCreated, m.Subject, m.Text
    FROM Messages m
        JOIN Users s
            ON s.UserID = SenderID
        JOIN Users r
            ON r.UserID = RecipientID    
    WHERE m.SenderID = @userId
    GROUP BY r.UserName, m.DateCreated, m.Subject, m.Text, s.UserName
    ORDER BY m.DateCreated DESC

----------------------------------------------------------------------------------
GO

CREATE PROCEDURE getRepliesByUser
    @userId int,
    @limit int

AS

    SELECT TOP(5) u.UserName, p.Title, r.Text
    FROM Replies r, Users u, Posts p
    WHERE    r.UserID = u.UserID 
            AND p.PostID = r.PostID
    ORDER BY r.DateCreated DESC
--------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [createMessage]
    @senderId int,
    @recipientId int,
    @subject varchar(30),
    @text varchar(max)

AS

SET NOCOUNT ON

BEGIN
    INSERT INTO Messages(SenderID, RecipientID, [Subject], [Text], DateCreated)
    VALUES (@senderId, @recipientId, @subject, @text, GETDATE())
    SELECT [success] = @text
END


-----------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [createPost]
    @topicId int,
    @userId int,
    @title varchar(30),
    @text varchar(max)

AS

SET NOCOUNT ON

BEGIN
    INSERT INTO Posts(TopicID, UserID, Title, [Text], DateCreated)
    VALUES (@topicId, @userId, @title, @text, GETDATE())
    SELECT [success] = @text
END
-----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [deleteReply]
    @replyId int,
    @delete bit = 1

AS

SET NOCOUNT ON

    IF @delete = 1 BEGIN        --Delete existing reply
        DELETE FROM Replies WHERE ReplyID = @replyId
        SELECT [success] = 1

    END ELSE BEGIN
        SELECT [success] = 0
END

-----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [getRepliesByUser]
    @userId int,
    @limit int

AS

SET NOCOUNT ON

BEGIN

    SELECT TOP(@limit) *
    FROM Replies
    WHERE UserID = @userId AND [Hidden] = 0 
ORDER BY DateCreated DESC

END
--------------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [getRepliesByPost]
    @postId int,
    @limit int

AS

SET NOCOUNT ON

BEGIN

    SELECT TOP(@limit) *
    FROM Replies
    WHERE PostId = @postId AND [Hidden] = 0 
    ORDER BY DateCreated DESC

END
----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [deleteMessage]
    @messageId int,
    @delete bit = 1

AS

SET NOCOUNT ON

    IF @delete = 1 BEGIN        --Delete existing reply
        DELETE FROM [Messages] WHERE MessageID = @messageId
        SELECT [success] = 1

    END ELSE BEGIN
        SELECT [success] = 0
END

----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE getTopics
    @limit int

AS

BEGIN
    
    SELECT TOP(@limit) u.UserName, t.Name, t.Description, t.DateCreated
    FROM Topics t
            JOIN Users u
                ON t.CreatorID = u.UserID
    WHERE [Hidden] <> 1
    ORDER BY DateCreated DESC

END

----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE getPostsByTopic
    @TopicID int,
    @limit int

AS

BEGIN
    
    SELECT TOP(@limit) t.Name, u.UserName,  p.Title, p.Text, p.DateCreated
    FROM Posts p
            JOIN Topics t
                ON t.TopicID = p.TopicID
            Join Users u
                ON u.UserID = p.UserID
    WHERE [Hidden] <> 1 AND TopicID = @TopicID
    ORDER BY Stickied, DateCreated DESC

END

----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE getPostsByUser
    @UserID int,
    @limit int

AS

BEGIN
    
    SELECT TOP(@limit) u.UserName, t.Name, p.Title, p.Text, p.DateCreated
    FROM Posts p
            JOIN Topics t
                ON t.TopicID = p.TopicID
            Join Users u
                ON u.UserID = p.UserID
    WHERE [Hidden] <> 1 AND UserID = @UserID
    ORDER BY Sticked, DateCreated DESC

END


