CREATE DATABASE IF NOT EXISTS dtolab_keys;

USE dtolab_keys;
/* ............................. TABELA .................................... */
CREATE TABLE IF NOT EXISTS dtolab_keys.general_keys(
	idkey INT(11) NOT NULL AUTO_INCREMENT,
	keycontent VARCHAR(29) NOT NULL,
 	serialcontent VARCHAR(30) NOT NULL,
	keystate INT(1) NOT NULL,
	bancada VARCHAR(2) NOT NULL,
    log_bloqued DATETIME,
    log_actived DATETIME,
	PRIMARY KEY (idkey)
);

DESCRIBE general_keys;

SELECT * FROM general_keys;

/* ............................. STORED PROCEDURE getKeyFromDb .................................... */

DELIMITER $$
CREATE PROCEDURE `getKeyFromDb`(IN bancadauser VARCHAR(2))
BEGIN
	DECLARE idkeyaux INT;
	SELECT @idkeyaux:=idkey, keycontent FROM general_keys WHERE keystate=0 LIMIT 1;
    UPDATE general_keys SET keystate=1,bancada=bancadauser WHERE idkey=@idkeyaux;
END $$
DELIMITER ;

DROP PROCEDURE keyFromActived;

CALL getKeyFromDb("b1");

/* ............................. STORED PROCEDURE keyFromBloqued .................................... */

DELIMITER $$
CREATE PROCEDURE `keyFromBloqued`(IN idkeyclient INT)
BEGIN
	UPDATE general_keys SET keystate=2,log_bloqued=NOW() WHERE idkey=idkeyclient;
END $$
DELIMITER ;

CALL keyFromBloqued(6);

/* ............................. STORED PROCEDURE keyFromActived .................................... */

DELIMITER $$
CREATE PROCEDURE `keyFromActived`(IN idkeyclient INT,IN serialcontentclient VARCHAR(30))
BEGIN
	UPDATE general_keys SET keystate=3,serialcontent=serialcontentclient,log_actived=NOW() WHERE idkey=idkeyclient;
END $$
DELIMITER ;

CALL keyFromActived(5,'PE09GTMM');