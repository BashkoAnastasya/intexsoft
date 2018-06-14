drop table Abonents;
drop table Abonent_cards;

CREATE TABLE Abonents
  (
    account_id NUMBER NOT NULL,
    MSISDN     NUMBER(15) NOT NULL,
    first_name VARCHAR2(254),
    last_name  VARCHAR2(254),
    email      VARCHAR2(40)  
  );
CREATE TABLE Abonent_cards
  (
    card_id    NUMBER NOT NULL,
    account_id NUMBER NOT NULL,
    PAN        NUMBER(15) NOT NULL,
    EXPIRE     DATE NOT NULL   
  );
create index IXPK_account_id on Abonents(account_id) ;
create index IXPK_card_id on Abonent_cards(card_id);
    
alter table Abonents
add constraint PK_account_id primary key (account_id) using index IXPK_account_id;

alter table Abonent_cards
add constraint PK_card_id primary key (card_id) using index IXPK_card_id
add constraint  fk_account_id foreign key (account_id)
references  Abonents(account_id);

CREATE TABLE Abonents
  (
    account_id NUMBER NOT NULL,
    MSISDN     NUMBER(15) NOT NULL,
    first_name VARCHAR2(254),
    last_name  VARCHAR2(254),
    email      VARCHAR2(40),
    PRIMARY KEY (account_id)
  );
CREATE TABLE Abonent_cards
  (
    card_id    NUMBER NOT NULL,
    account_id NUMBER NOT NULL,
    PAN        NUMBER(15) NOT NULL,
    EXPIRE     DATE NOT NULL,
    PRIMARY KEY (card_id)
  );
create index IXPK_account_id on Abonents(account_id) ;
create index IXPK_card_id on Abonent_cards(card_id);
  
  
alter table Abonents
add constraint PK_account_id primary key (account_id) using index IXPK_account_id;

alter table Abonent_cards
add constraint PK_card_id primary key (card_id) using index IXPK_card_id
add constraint  fk_account_id foreign key (account_id)
references  Abonents(account_id);

INSERT INTO Abonents VALUES
  (1,145,'Иван','Иванович','ivan@mail.ru') ;
INSERT INTO Abonents VALUES
  (2,269,'Сергей','Сидоров','ivan1@mail.ru') ;
INSERT INTO Abonents VALUES
  (3,785,'Петр','Петров','ivan2@mail.ru') ;
INSERT INTO Abonents VALUES
  (4,148,'Николай','Дунаев','ivan3@mail.ru');
INSERT INTO Abonents VALUES
  (5,1423,'Дмитрий','Муравьев','ivan4@mail.ru');
INSERT INTO Abonents VALUES
  (6,159,'Никита','Литвинов','ivan5@mail.ru');
INSERT INTO Abonent_cards VALUES
  (1,1,4545,'01.01.2012');
INSERT INTO Abonent_cards VALUES
  (2,1,45641,'01.01.2015' );
INSERT INTO Abonent_cards VALUES
  (3,1,4549,'01.01.2014');
INSERT INTO Abonent_cards VALUES
  (4,2,454149,'01.01.2011');
INSERT INTO Abonent_cards VALUES
  (5,2,455549,'01.01.2016');
INSERT INTO Abonent_cards VALUES
  (6,3,454339,'01.01.2015');
CREATE OR REPLACE FUNCTION getcountcards
  (
    p_MSISDN IN NUMBER
  )
  RETURN NUMBER
IS
  RESULT NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO RESULT
  FROM Abonent_cards abc
  WHERE abc.account_id=
    (SELECT account_id FROM Abonents ab WHERE ab.MSISDN=p_MSISDN
    ) ;
  RETURN(RESULT);
END getcountcards;
CREATE OR REPLACE PACKAGE body pa
IS
  FUNCTION getcard_info(
      p_MSISDN NUMBER DEFAULT NULL)
    RETURN card_info pipelined
  IS
  BEGIN
    FOR curr IN
    (SELECT ab.MSISDN,
      abc.PAN,
      abc.EXPIRE
    FROM Abonent_cards abc,
      Abonents ab
    WHERE abc.account_id=ab.account_id
    AND ab.MSISD        = NVL(p_MSISDN, ab.MSISD)
    )
    LOOP
      pipe row (curr);
    END LOOP;
    RETURN;
  END getcard_info;
END pa;



SELECT * FROM TABLE (PA.GETCARD_INFO(145));
SELECT ab.*, getcountcards(ab.MSISDN) FROM abonents ab;