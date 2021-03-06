-- Indexes for primary keys have been explicitly created.

------------ Table for validation queries from the connection pool. ----------

DROP TABLE PingTable;
CREATE TABLE PingTable (foo CHAR(1));


------ DROP TABLE queries in order to respect foreign key integrity -----------

DROP TABLE OrderLine;
DROP TABLE Ord;
DROP TABLE UserProfile;
DROP TABLE Product;
DROP TABLE Category;

-------------------------------- UserProfile ----------------------------------

CREATE TABLE UserProfile (
	usrId BIGINT NOT NULL AUTO_INCREMENT,
	loginName VARCHAR(30) COLLATE latin1_bin NOT NULL,
	enPassword VARCHAR(13) NOT NULL, 
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR(40) NOT NULL, 
	email VARCHAR(60) NOT NULL,
	street VARCHAR(70) NOT NULL,
	num INT NOT NULL,
	door VARCHAR(10) NOT NULL,
	zipCode BIGINT NOT NULL, 
	version BIGINT NOT NULL,
	CONSTRAINT UserProfile_PK PRIMARY KEY (usrId),
	CONSTRAINT LoginNameUniqueKey UNIQUE (loginName)) 
	ENGINE = InnoDB;

CREATE INDEX UserProfileIndexByUsrId ON UserProfile (usrId);
CREATE INDEX UserProfileIndexByLoginName ON UserProfile (loginName);

-------------------------------- Category -------------------------------------

CREATE TABLE Category (
	categoryId BIGINT NOT NULL AUTO_INCREMENT,
	name VARCHAR(15) NOT NULL,
	CONSTRAINT Category_PK PRIMARY KEY (categoryId),
	CONSTRAINT CategoryNameUnique UNIQUE(name))
	ENGINE = InnoDB;

CREATE INDEX CategoryIndexByCategoryId ON Category(categoryId);
CREATE INDEX CategoryIndexByName ON Category(name);	

-------------------------------- Product --------------------------------------

CREATE TABLE Product (
	productId BIGINT NOT NULL AUTO_INCREMENT,
    	categoryId BIGINT NOT NULL,
	name VARCHAR(30) NOT NULL,
	price DOUBLE PRECISION NOT NULL,
	imageURL VARCHAR(300) DEFAULT 'http://riseofthecasualgamers.files.wordpress.com/2012/01/homer-simpson-error-404.gif?w=627',
	numSells BIGINT DEFAULT 0,
	version BIGINT NOT NULL,
	CONSTRAINT Product_PK PRIMARY KEY (productId),
	CONSTRAINT Product_FK FOREIGN KEY(categoryId)
        	REFERENCES Category(categoryId) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ProductNameUnique UNIQUE (name))
    	ENGINE = InnoDB;

CREATE INDEX ProductIndexByProductId ON Product(productId);
CREATE INDEX ProductIndexByName ON Product(name);



-------------------------------- Order ----------------------------------------

CREATE TABLE Ord (
	orderId BIGINT NOT NULL AUTO_INCREMENT,
	userProfileId BIGINT NOT NULL,
	date TIMESTAMP NOT NULL,
	CONSTRAINT Order_PK PRIMARY KEY (orderId),
	CONSTRAINT Order_FK FOREIGN KEY(userProfileId)
        	REFERENCES UserProfile(usrId) ON DELETE NO ACTION ON UPDATE NO ACTION)
	ENGINE = InnoDB;	

CREATE INDEX OrderIndexByOrderId ON Ord(orderId);

-------------------------------- OrderLine ------------------------------------

CREATE TABLE OrderLine (
	orderLineId BIGINT NOT NULL AUTO_INCREMENT,
	productId BIGINT NOT NULL,
	orderId BIGINT NOT NULL,
	amount INT NOT NULL,
	price DOUBLE PRECISION NOT NULL,
	CONSTRAINT OrderLine_PK PRIMARY KEY (orderLineId),
	CONSTRAINT OrderLineProduct_FK FOREIGN KEY (productId) REFERENCES Product(productId) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT OrderLineOrder_FK FOREIGN KEY (orderId) REFERENCES Ord(orderId) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT validAmount CHECK ( amount > 0 ))
	ENGINE = InnoDB;


CREATE INDEX OrderLineIndexByOrderLineId ON OrderLine(orderLineId);
