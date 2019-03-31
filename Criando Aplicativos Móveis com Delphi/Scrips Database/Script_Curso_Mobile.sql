-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: curso
-- ------------------------------------------------------
-- Server version	5.7.17-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cardapios`
--

DROP TABLE IF EXISTS `cardapios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cardapios` (
  `id` int(11) NOT NULL,
  `id_estabelecimento` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `ingredientes` varchar(200) DEFAULT NULL,
  `foto_item` blob,
  `preco` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ID_CATEGORIA_idx` (`id_categoria`),
  KEY `FK_ID_ESTABELECIMENTO_idx` (`id_estabelecimento`),
  KEY `FK_ID_ESTABELECIMENTO_CARD_idx` (`id_estabelecimento`),
  CONSTRAINT `FK_ID_CATEGORIA` FOREIGN KEY (`id_categoria`) REFERENCES `categoria_item` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ID_ESTABELECIMENTO_CARD` FOREIGN KEY (`id_estabelecimento`) REFERENCES `estabelecimentos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categoria_item`
--

DROP TABLE IF EXISTS `categoria_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categoria_item` (
  `id` int(11) NOT NULL,
  `descricao` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enderecos`
--

DROP TABLE IF EXISTS `enderecos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `enderecos` (
  `id` int(11) NOT NULL,
  `logradouro` varchar(200) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `complemento` varchar(50) DEFAULT NULL,
  `bairro` varchar(50) DEFAULT NULL,
  `cidade` varchar(50) DEFAULT NULL,
  `estado` varchar(2) DEFAULT NULL,
  `CEP` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estabelecimentos`
--

DROP TABLE IF EXISTS `estabelecimentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estabelecimentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fantasia` varchar(20) DEFAULT NULL,
  `razao_social` varchar(200) DEFAULT NULL,
  `foto_logotipo` blob,
  `id_endereco` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `horario_funcionamento`
--

DROP TABLE IF EXISTS `horario_funcionamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `horario_funcionamento` (
  `id` int(11) NOT NULL,
  `id_estabelecimento` int(11) DEFAULT NULL,
  `hora_inicio` datetime DEFAULT NULL,
  `hora_final` datetime DEFAULT NULL,
  `dia_semana` varchar(7) DEFAULT NULL,
  `aberto_fechado` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ID_ESTABELECIMENTO_HOR_idx` (`id_estabelecimento`),
  CONSTRAINT `FK_ID_ESTABELECIMENTO_HOR` FOREIGN KEY (`id_estabelecimento`) REFERENCES `estabelecimentos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itens_pedido`
--

DROP TABLE IF EXISTS `itens_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itens_pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) DEFAULT NULL,
  `qtde` int(11) DEFAULT NULL,
  `valor_unitario` decimal(10,2) DEFAULT NULL,
  `id_cardapio` int(11) DEFAULT NULL,
  `id_pedido_mobile` int(11) DEFAULT NULL,
  `id_item_pedido_mobile` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ID_CARDAPIO_idx` (`id_cardapio`),
  KEY `FK_ID_PEDIDO_idx` (`id_pedido`),
  CONSTRAINT `FK_ID_CARDAPIO` FOREIGN KEY (`id_cardapio`) REFERENCES `cardapios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ID_PEDIDO` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) DEFAULT NULL,
  `id_estabelecimento` int(11) DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL,
  `valor_pedido` decimal(10,2) DEFAULT NULL,
  `id_pedido_mobile` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ID_ESTABELECIMENTO_idx` (`id_estabelecimento`),
  KEY `FK_ID_USUARIO_idx` (`id_usuario`),
  CONSTRAINT `FK_ID_ESTABELECIMENTO` FOREIGN KEY (`id_estabelecimento`) REFERENCES `estabelecimentos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ID_USUARIO` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_endereco` int(11) DEFAULT NULL,
  `nome_completo` varchar(100) DEFAULT NULL,
  `nome_usuario` varchar(45) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `cpfcnpj` varchar(30) DEFAULT NULL,
  `senha` varchar(50) DEFAULT NULL,
  `foto` blob,
  `id_estabelecimento` int(11) DEFAULT NULL,
  `tipo` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'curso'
--

--
-- Dumping routines for database 'curso'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-29 16:50:59
