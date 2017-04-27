



CREATE PROCEDURE spDeleteUser
    @UserID        int

AS

SET NOCOUNT ON

IF NOT EXISTS(
                SELECT NULL
                FROM Users
                WHERE UserID = @UserID AND Deleted != 0
            ) BEGIN

    UPDATE Users
    SET Deleted = 1
    WHERE UserID = @UserID
    
    RETURN 1

    END

ELSE BEGIN

RETURN 0

END

GO

CREATE PROCEDURE spUpdateUser
    @UserID            int,
    @UserName        varchar(20),
    @EmailAddress    varchar(50)

AS

SET NOCOUNT ON

IF NOT EXISTS(    
                SELECT NULL
                FROM Users
                WHERE UserID != @UserID AND (EmailAddress = @EmailAddress OR UserName = @UserName)
            ) BEGIN

    UPDATE Users
    SET UserName = @UserName, EmailAddress = @EmailAddress
    WHERE UserID = @UserID
    END

    SELECT * FROM Users WHERE UserID = @UserID

GO

CREATE PROCEDURE spCreateUser
    @UserName        varchar(20),
    @EmailAddress    varchar(50),
    @Password        varchar(20)

AS

SET NOCOUNT ON

IF NOT EXISTS(    
                SELECT NULL
                FROM Users
                WHERE UserName = @UserName OR EmailAddress = @EmailAddress

            ) BEGIN

    INSERT INTO Users (UserName, EmailAddress, Password, DateCreated, LastLogin)
    VALUES(@UserName, @EmailAddress, @Password, GETDATE(), GETDATE())

    SELECT UserName, EmailAddress
    FROM Users
    WHERE UserID = @@IDENTITY

    END

ELSE BEGIN

    SELECT [UserName] = '', [EmailAddress] = ''

END

GO

CREATE PROCEDURE spUpdateUserLastLogin
    @UserID        int

AS
SET NOCOUNT ON

IF EXISTS(    SELECT NULL
            FROM Users
            WHERE UserID = @UserID
            ) BEGIN

    UPDATE Users
    SET LastLogin = GETDATE()
    WHERE UserID = @UserID

    SELECT UserName, EmailAddress
    FROM Users
    WHERE UserID = @UserID

END

GO

CREATE PROCEDURE spUpdateUserPassword
    @UserID        int,
    @Password    varchar(20)

AS
SET NOCOUNT ON

IF EXISTS(    SELECT NULL
            FROM Users
            WHERE UserID = @UserID
            ) BEGIN

    UPDATE Users
    SET Password = @Password
    WHERE UserID = @UserID

    RETURN 1
END

ELSE BEGIN
RETURN 0
END

GO

CREATE PROCEDURE spUpdatePost
    @postID            int,
@topicID   int,
@userID    int,
    @title      varchar(100),
    @text    text,
@stickied   bit
AS
SET NOCOUNT ON
IF EXISTS(    
                SELECT NULL
                FROM Posts
                WHERE PostID = @postID
    AND EXISTS(SELECT NULL FROM Users WHERE UserID = @userID)
    AND EXISTS(SELECT NULL FROM Topics WHERE TopicID = @topicID)
            )
    BEGIN
    UPDATE Posts
    SET Title = @title, Text = @text, Stickied = @stickied, UserID = @userID, TopicID = @topicID
WHERE PostID = @postID
    END
    SELECT * FROM Posts WHERE PostID = @postID

GO

CREATE PROCEDURE spDeletePost
    @PostID        int
AS
SET NOCOUNT ON
IF NOT EXISTS(
                SELECT NULL
                FROM Posts
                WHERE PostID = @PostID AND Hidden = 1
            ) BEGIN
    UPDATE Posts
    SET Hidden = TRUE
    WHERE PostID = @PostID
    
    RETURN 1
    END
ELSE BEGIN
RETURN 0
END

GO


CREATE PROCEDURE spCreateReply
    @PostID      int,
    @UserID        int,
@Text   text,
@DateCreated date,
@Hidden   bit
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
            )
BEGIN
    INSERT INTO Replies (PostID, UserID, Text, DateCreated, Hidden)
    VALUES(@PostID, @UserID, @Text, GETDATE(), 0)
    SELECT *
    FROM Users
    WHERE UserID = @@IDENTITY
    END
ELSE BEGIN
    SELECT [error] = 'Could not add user, check foreign keys'
END

GO

CREATE PROCEDURE spCreateReply
    @PostID      int,
    @UserID        int,
@Text   text,
@DateCreated date,
@Hidden   bit
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
            )
BEGIN
    INSERT INTO Replies (PostID, UserID, Text, DateCreated, Hidden)
    VALUES(@PostID, @UserID, @Text, GETDATE(), 0)
    SELECT *
    FROM Users
    WHERE UserID = @@IDENTITY
    END
ELSE BEGIN
    SELECT [error] = 'Could not add user, check foreign keys'
END
