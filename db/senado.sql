/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.5.5-10.1.10-MariaDB-log : Database - srcidadao_senado
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`srcidadao_senado` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `srcidadao_senado`;

/*Table structure for table `senado_detalhemateria` */

DROP TABLE IF EXISTS `senado_detalhemateria`;

CREATE TABLE `senado_detalhemateria` (
  `CodigoMateria` int(11) NOT NULL,
  `codProcessamento` int(11) NOT NULL,
  `EmentaMateria` text,
  `ExplicacaoEmentaMateria` text,
  `IndexacaoMateria` text,
  `IndicadorComplementar` varchar(255) DEFAULT NULL,
  `DataApresentacao` date DEFAULT NULL,
  `DataLeitura` date DEFAULT NULL,
  `SiglaCasaLeitura` char(2) DEFAULT NULL,
  `NomeCasaLeitura` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CodigoMateria`),
  KEY `fk_senado_materia_senado_processamento1_idx` (`codProcessamento`),
  KEY `fk_senado_detalhemateria_senado_materia1_idx` (`CodigoMateria`),
  CONSTRAINT `fk_senado_detalhemateria_senado_materia1` FOREIGN KEY (`CodigoMateria`) REFERENCES `senado_materia` (`CodigoMateria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_senado_materia_senado_processamento10` FOREIGN KEY (`codProcessamento`) REFERENCES `senado_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `senado_logger` */

DROP TABLE IF EXISTS `senado_logger`;

CREATE TABLE `senado_logger` (
  `oidLogger` int(11) NOT NULL AUTO_INCREMENT,
  `codProcessamento` int(11) NOT NULL,
  `arquivo` varchar(255) NOT NULL,
  `linha` int(11) NOT NULL,
  `codigo` int(11) NOT NULL,
  `mensagem` varchar(500) NOT NULL,
  `trace` text NOT NULL,
  `flgSucesso` tinyint(4) NOT NULL DEFAULT '1',
  `flgTipoProcessamento` tinyint(4) DEFAULT '0' COMMENT '0 - Download\n1 - Processamento',
  `dataHoraInicio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dataHoraFim` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`oidLogger`),
  KEY `fk_codProcessamento_idx` (`codProcessamento`),
  CONSTRAINT `fk_codProcessamento_logger0` FOREIGN KEY (`codProcessamento`) REFERENCES `camara_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `senado_logger_arquivo` */

DROP TABLE IF EXISTS `senado_logger_arquivo`;

CREATE TABLE `senado_logger_arquivo` (
  `oidSenadoLoggerArquivo` int(11) NOT NULL AUTO_INCREMENT,
  `oidLogger` int(11) NOT NULL,
  `caminhoAbsoluto` varchar(500) NOT NULL,
  `caminhoRelativo` varchar(500) DEFAULT NULL,
  `dataHora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`oidSenadoLoggerArquivo`),
  KEY `fk_camara_logger_arquivo_camara_logger10_idx` (`oidLogger`),
  CONSTRAINT `fk_senado_logger_arquivo_senado_logger` FOREIGN KEY (`oidLogger`) REFERENCES `senado_logger` (`oidLogger`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `senado_materia` */

DROP TABLE IF EXISTS `senado_materia`;

CREATE TABLE `senado_materia` (
  `CodigoMateria` int(11) NOT NULL,
  `codProcessamento` int(11) NOT NULL,
  `SiglaCasaIdentificacaoMateria` char(2) DEFAULT NULL,
  `NomeCasaIdentificacaoMateria` varchar(255) DEFAULT NULL,
  `SiglaSubtipoMateria` varchar(255) DEFAULT NULL,
  `DescricaoSubtipoMateria` varchar(255) DEFAULT NULL,
  `NumeroMateria` int(11) DEFAULT NULL,
  `AnoMateria` int(11) DEFAULT NULL,
  `IndicadorTramitando` char(10) DEFAULT NULL,
  PRIMARY KEY (`CodigoMateria`),
  KEY `fk_senado_materia_senado_processamento1_idx` (`codProcessamento`),
  KEY `ix_descricao_subtipo` (`DescricaoSubtipoMateria`),
  CONSTRAINT `fk_senado_materia_senado_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `senado_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `senado_materiaassunto` */

DROP TABLE IF EXISTS `senado_materiaassunto`;

CREATE TABLE `senado_materiaassunto` (
  `CodigoMateria` int(11) NOT NULL,
  `Codigo` int(11) NOT NULL,
  `Descricao` varchar(255) NOT NULL,
  PRIMARY KEY (`CodigoMateria`),
  KEY `fk_senado_materiaassunto_senado_detalhemateria1_idx` (`CodigoMateria`),
  CONSTRAINT `fk_senado_materiaassunto_senado_detalhemateria1` FOREIGN KEY (`CodigoMateria`) REFERENCES `senado_detalhemateria` (`CodigoMateria`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `senado_processamento` */

DROP TABLE IF EXISTS `senado_processamento`;

CREATE TABLE `senado_processamento` (
  `codProcessamento` int(11) NOT NULL AUTO_INCREMENT,
  `dataHora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codProcessamento`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `senado_senador` */

DROP TABLE IF EXISTS `senado_senador`;

CREATE TABLE `senado_senador` (
  `CodigoParlamentar` int(11) NOT NULL,
  `codProcessamento` int(11) NOT NULL,
  `NomeParlamentar` varchar(255) NOT NULL,
  `NomeCompletoParlamentar` varchar(255) NOT NULL,
  `SexoParlamentar` varchar(20) DEFAULT NULL,
  `FormaTratamento` varchar(20) DEFAULT NULL,
  `UrlFotoParlamentar` varchar(255) DEFAULT NULL,
  `UrlPaginaParlamentar` varchar(255) DEFAULT NULL,
  `EmailParlamentar` varchar(255) DEFAULT NULL,
  `SiglaPartidoParlamentar` varchar(255) DEFAULT NULL,
  `UfParlamentar` char(2) DEFAULT NULL,
  PRIMARY KEY (`CodigoParlamentar`),
  KEY `fk_senado_senador_senado_processamento1_idx` (`codProcessamento`),
  CONSTRAINT `fk_senado_senador_senado_processamento1` FOREIGN KEY (`codProcessamento`) REFERENCES `senado_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `senado_votoparlamentar` */

DROP TABLE IF EXISTS `senado_votoparlamentar`;

CREATE TABLE `senado_votoparlamentar` (
  `CodigoParlamentar` int(11) NOT NULL,
  `CodigoMateria` int(11) NOT NULL,
  `codProcessamento` int(11) NOT NULL,
  `DescricaoVoto` varchar(255) DEFAULT NULL,
  `DataHoraSessao` timestamp NULL DEFAULT NULL,
  `DescricaoVotacao` text,
  PRIMARY KEY (`CodigoParlamentar`,`CodigoMateria`),
  KEY `fk_senado_senador_senado_processamento1_idx` (`codProcessamento`),
  KEY `fk_senado_votoparlamentar_senado_materia1_idx` (`CodigoMateria`),
  CONSTRAINT `fk_senado_senador_senado_processamento10` FOREIGN KEY (`codProcessamento`) REFERENCES `senado_processamento` (`codProcessamento`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_senado_votoparlamentar_senado_materia1` FOREIGN KEY (`CodigoMateria`) REFERENCES `senado_materia` (`CodigoMateria`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Procedure structure for procedure `obterMateriaPorID` */

/*!50003 DROP PROCEDURE IF EXISTS  `obterMateriaPorID` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `obterMateriaPorID`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN
	DECLARE contadorTag INT;
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/DetalheMateria/Materia/Assunto/AssuntoEspecifico)');
	INSERT IGNORE INTO senado_detalhemateria (CodigoMateria, codProcessamento, EmentaMateria, ExplicacaoEmentaMateria, IndexacaoMateria, 
		IndicadorComplementar, DataApresentacao, DataLeitura, SiglaCasaLeitura, NomeCasaLeitura)
	SELECT 
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/IdentificacaoMateria/CodigoMateria'),
		codProcessamento,
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/EmentaMateria'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/ExplicacaoEmentaMateria'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/IndexacaoMateria'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/IndicadorComplementar'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/DataApresentacao'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/DataLeitura'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/SiglaCasaLeitura'),
		EXTRACTVALUE(xml, '/DetalheMateria/Materia/DadosBasicosMateria/NomeCasaLeitura');
	
	IF contadorTag > 0 THEN 
		INSERT IGNORE INTO senado_materiaassunto (CodigoMateria, Codigo, Descricao)
		SELECT 
			EXTRACTVALUE(xml, '/DetalheMateria/Materia/IdentificacaoMateria/CodigoMateria'),
			EXTRACTVALUE(xml, '/DetalheMateria/Materia/Assunto/AssuntoEspecifico/Codigo'),
			EXTRACTVALUE(xml, '/DetalheMateria/Materia/Assunto/AssuntoEspecifico/Descricao');
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obterMaterias` */

/*!50003 DROP PROCEDURE IF EXISTS  `obterMaterias` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `obterMaterias`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN
	DECLARE contadorWhile INT DEFAULT 1;
	DECLARE contadorTag INT;
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/ListaMateriasLegislaturaAtual/Materias/Materia)');
	SELECT contadorTag;
	WHILE (contadorWhile <= contadorTag) DO 
		INSERT IGNORE INTO senado_materia (CodigoMateria, codProcessamento, SiglaCasaIdentificacaoMateria, 
		NomeCasaIdentificacaoMateria, SiglaSubtipoMateria, DescricaoSubtipoMateria, NumeroMateria, AnoMateria, 
		IndicadorTramitando)
		SELECT 
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/CodigoMateria'),
			codProcessamento,
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/SiglaCasaIdentificacaoMateria'),
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/NomeCasaIdentificacaoMateria'),
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/SiglaSubtipoMateria'),
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/DescricaoSubtipoMateria'),
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/NumeroMateria'),
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/AnoMateria'),
			EXTRACTVALUE(xml, '/ListaMateriasLegislaturaAtual/Materias/Materia[$contadorWhile]/IdentificacaoMateria/IndicadorTramitando');
		SET contadorWhile := contadorWhile + 1;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `obterSenadores` */

/*!50003 DROP PROCEDURE IF EXISTS  `obterSenadores` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `obterSenadores`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN
	DECLARE contadorWhile INT DEFAULT 1;
	DECLARE contadorTag INT;
	SET contadorTag := EXTRACTVALUE(xml, 'COUNT(/ListaParlamentarEmExercicio/Parlamentares/Parlamentar)');
	SELECT contadorTag;
	WHILE (contadorWhile <= contadorTag) DO 
		INSERT IGNORE INTO senado_senador (CodigoParlamentar, codProcessamento, NomeParlamentar, NomeCompletoParlamentar, 
			SexoParlamentar, FormaTratamento, UrlFotoParlamentar, UrlPaginaParlamentar, EmailParlamentar, 
			SiglaPartidoParlamentar, UfParlamentar)
		SELECT 
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/CodigoParlamentar'),
			codProcessamento,
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/NomeParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/NomeCompletoParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/SexoParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/FormaTratamento'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/UrlFotoParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/UrlPaginaParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/EmailParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/SiglaPartidoParlamentar'),
			EXTRACTVALUE(xml, '/ListaParlamentarEmExercicio/Parlamentares/Parlamentar[$contadorWhile]/IdentificacaoParlamentar/UfParlamentar');
		SET contadorWhile := contadorWhile + 1;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `senadoVotos` */

/*!50003 DROP PROCEDURE IF EXISTS  `senadoVotos` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `senadoVotos`(IN xml MEDIUMTEXT, IN codProcessamento INT)
BEGIN
	DECLARE contaVotos INT;
	DECLARE contador INT DEFAULT 1;
	DECLARE codigoMateria INT;
	DECLARE dataSessao DATE;
	DECLARE horaSessao TIME;
	
	SET contaVotos := EXTRACTVALUE(xml, 'COUNT(/VotacaoMateria/Materia/Votacoes/Votacao[1]/Votos/VotoParlamentar)');
	SET codigoMateria := EXTRACTVALUE(xml, '/VotacaoMateria/Materia/IdentificacaoMateria/CodigoMateria');
	SET dataSessao := EXTRACTVALUE(xml, '/VotacaoMateria/Materia/Votacoes/Votacao[1]/SessaoPlenaria/DataSessao');
	SET horaSessao := EXTRACTVALUE(xml, '/VotacaoMateria/Materia/Votacoes/Votacao[1]/SessaoPlenaria/HoraInicioSessao');
	WHILE (contador <= contaVotos) DO 
		INSERT IGNORE INTO senado_votoparlamentar (CodigoParlamentar, CodigoMateria, DescricaoVoto, codProcessamento, DataHoraSessao, DescricaoVotacao)
		SELECT 
			EXTRACTVALUE(xml, '/VotacaoMateria/Materia/Votacoes/Votacao[1]/Votos/VotoParlamentar[$contador]/IdentificacaoParlamentar/CodigoParlamentar'), 
			codigoMateria,
			EXTRACTVALUE(xml, '/VotacaoMateria/Materia/Votacoes/Votacao[1]/Votos/VotoParlamentar[$contador]/DescricaoVoto'), 
			codProcessamento,
			STR_TO_DATE(CONCAT(dataSessao, ' ', horaSessao), '%Y-%m-%d %H:%i:%s'),
			EXTRACTVALUE(xml, '/VotacaoMateria/Materia/Votacoes/Votacao[1]/DescricaoVotacao');
		SET contador := contador + 1;
	END WHILE;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
