-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: SchoolLibrary
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `author` (`author`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (9,'Daniel Nguyen'),(5,'David Rodriguez'),(2,'Emily Johnson'),(6,'Jessica Chen'),(1,'John Smith'),(3,'Michael Davis'),(8,'Olivia Patel'),(4,'Sarah Lee'),(10,'Sophia Wong'),(7,'William Kim');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_authors`
--

DROP TABLE IF EXISTS `book_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_authors` (
  `book_id` int NOT NULL,
  `author_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`author_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `book_authors_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`),
  CONSTRAINT `book_authors_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_authors`
--

LOCK TABLES `book_authors` WRITE;
/*!40000 ALTER TABLE `book_authors` DISABLE KEYS */;
INSERT INTO `book_authors` VALUES (1,1),(7,1),(14,1),(18,1),(24,1),(29,1),(32,1),(38,1),(44,1),(45,1),(47,1),(55,1),(56,1),(58,1),(64,1),(84,1),(96,1),(116,1),(122,1),(134,1),(139,1),(141,1),(160,1),(164,1),(169,1),(177,1),(1,2),(7,2),(11,2),(20,2),(23,2),(24,2),(31,2),(36,2),(45,2),(55,2),(58,2),(59,2),(62,2),(67,2),(69,2),(76,2),(80,2),(86,2),(92,2),(96,2),(98,2),(106,2),(109,2),(117,2),(120,2),(123,2),(137,2),(155,2),(192,2),(3,3),(7,3),(12,3),(16,3),(22,3),(25,3),(32,3),(33,3),(34,3),(38,3),(41,3),(49,3),(54,3),(56,3),(58,3),(64,3),(66,3),(83,3),(91,3),(95,3),(97,3),(100,3),(107,3),(119,3),(120,3),(122,3),(131,3),(139,3),(182,3),(188,3),(2,4),(5,4),(6,4),(12,4),(28,4),(42,4),(53,4),(57,4),(60,4),(66,4),(67,4),(70,4),(82,4),(87,4),(89,4),(99,4),(102,4),(124,4),(145,4),(150,4),(154,4),(163,4),(174,4),(186,4),(194,4),(198,4),(6,5),(10,5),(14,5),(23,5),(28,5),(32,5),(34,5),(37,5),(42,5),(52,5),(55,5),(61,5),(69,5),(70,5),(84,5),(86,5),(91,5),(97,5),(99,5),(119,5),(124,5),(140,5),(169,5),(170,5),(174,5),(177,5),(186,5),(195,5),(5,6),(8,6),(16,6),(22,6),(28,6),(31,6),(34,6),(39,6),(53,6),(57,6),(61,6),(67,6),(83,6),(84,6),(94,6),(96,6),(98,6),(101,6),(115,6),(116,6),(135,6),(164,6),(170,6),(183,6),(3,7),(4,7),(11,7),(22,7),(23,7),(27,7),(31,7),(33,7),(42,7),(44,7),(45,7),(47,7),(60,7),(62,7),(66,7),(72,7),(76,7),(89,7),(92,7),(100,7),(103,7),(117,7),(125,7),(138,7),(141,7),(182,7),(187,7),(198,7),(2,8),(8,8),(14,8),(18,8),(20,8),(26,8),(29,8),(36,8),(38,8),(54,8),(57,8),(70,8),(80,8),(86,8),(94,8),(97,8),(99,8),(100,8),(107,8),(113,8),(138,8),(150,8),(153,8),(155,8),(171,8),(195,8),(3,9),(4,9),(10,9),(12,9),(24,9),(25,9),(26,9),(27,9),(37,9),(41,9),(44,9),(52,9),(54,9),(59,9),(69,9),(89,9),(91,9),(95,9),(106,9),(109,9),(115,9),(123,9),(134,9),(145,9),(160,9),(178,9),(192,9),(194,9),(197,9),(4,10),(8,10),(10,10),(11,10),(16,10),(27,10),(29,10),(33,10),(37,10),(39,10),(41,10),(47,10),(49,10),(52,10),(56,10),(59,10),(63,10),(72,10),(82,10),(87,10),(94,10),(95,10),(98,10),(101,10),(103,10),(113,10),(125,10),(131,10),(137,10),(140,10),(153,10),(154,10),(163,10),(171,10),(183,10),(187,10),(188,10),(197,10);
/*!40000 ALTER TABLE `book_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_categories`
--

DROP TABLE IF EXISTS `book_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_categories` (
  `book_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `book_categories_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`),
  CONSTRAINT `book_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_categories`
--

LOCK TABLES `book_categories` WRITE;
/*!40000 ALTER TABLE `book_categories` DISABLE KEYS */;
INSERT INTO `book_categories` VALUES (2,1),(8,1),(10,1),(14,1),(16,1),(25,1),(26,1),(37,1),(41,1),(42,1),(49,1),(56,1),(60,1),(63,1),(67,1),(72,1),(83,1),(84,1),(92,1),(95,1),(99,1),(102,1),(106,1),(120,1),(125,1),(135,1),(139,1),(163,1),(170,1),(171,1),(182,1),(187,1),(198,1),(7,2),(10,2),(11,2),(20,2),(24,2),(25,2),(27,2),(29,2),(33,2),(36,2),(44,2),(47,2),(52,2),(56,2),(62,2),(67,2),(76,2),(82,2),(94,2),(98,2),(106,2),(115,2),(119,2),(122,2),(135,2),(137,2),(145,2),(153,2),(160,2),(169,2),(170,2),(171,2),(174,2),(178,2),(197,2),(5,3),(6,3),(11,3),(18,3),(20,3),(23,3),(28,3),(29,3),(32,3),(39,3),(44,3),(58,3),(59,3),(62,3),(84,3),(87,3),(91,3),(97,3),(99,3),(101,3),(103,3),(113,3),(117,3),(122,3),(131,3),(138,3),(153,3),(164,3),(183,3),(192,3),(1,4),(4,4),(14,4),(22,4),(31,4),(33,4),(34,4),(36,4),(37,4),(41,4),(47,4),(57,4),(58,4),(59,4),(66,4),(69,4),(72,4),(76,4),(83,4),(86,4),(94,4),(99,4),(100,4),(101,4),(107,4),(119,4),(134,4),(139,4),(141,4),(150,4),(154,4),(164,4),(188,4),(1,5),(4,5),(12,5),(16,5),(25,5),(31,5),(34,5),(39,5),(45,5),(47,5),(54,5),(59,5),(60,5),(64,5),(67,5),(70,5),(80,5),(86,5),(91,5),(96,5),(131,5),(138,5),(140,5),(150,5),(155,5),(163,5),(195,5),(2,6),(3,6),(8,6),(14,6),(20,6),(23,6),(24,6),(27,6),(31,6),(38,6),(42,6),(45,6),(53,6),(54,6),(55,6),(61,6),(63,6),(70,6),(76,6),(83,6),(95,6),(97,6),(109,6),(117,6),(124,6),(155,6),(183,6),(186,6),(3,7),(7,7),(11,7),(18,7),(26,7),(29,7),(34,7),(41,7),(42,7),(52,7),(53,7),(57,7),(61,7),(64,7),(70,7),(82,7),(84,7),(86,7),(96,7),(97,7),(98,7),(102,7),(109,7),(116,7),(120,7),(123,7),(134,7),(137,7),(174,7),(177,7),(178,7),(187,7),(195,7),(1,8),(5,8),(8,8),(12,8),(24,8),(32,8),(49,8),(53,8),(55,8),(60,8),(63,8),(69,8),(80,8),(82,8),(92,8),(94,8),(95,8),(100,8),(103,8),(115,8),(192,8),(6,9),(18,9),(23,9),(26,9),(28,9),(38,9),(45,9),(54,9),(58,9),(66,9),(89,9),(107,9),(113,9),(140,9),(160,9),(188,9),(198,9),(2,10),(5,10),(7,10),(16,10),(22,10),(28,10),(32,10),(33,10),(36,10),(37,10),(44,10),(55,10),(57,10),(61,10),(64,10),(69,10),(80,10),(87,10),(92,10),(96,10),(98,10),(116,10),(123,10),(125,10),(141,10),(145,10),(154,10),(169,10),(177,10),(182,10),(194,10),(197,10);
/*!40000 ALTER TABLE `book_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_instance`
--

DROP TABLE IF EXISTS `book_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_instance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `school_id` int NOT NULL,
  `copies` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `school_id` (`school_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `book_instance_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `school_unit` (`id`),
  CONSTRAINT `book_instance_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_instance`
--

LOCK TABLES `book_instance` WRITE;
/*!40000 ALTER TABLE `book_instance` DISABLE KEYS */;
INSERT INTO `book_instance` VALUES (1,1,1,1),(2,2,2,13),(3,3,3,13),(4,4,4,11),(5,5,5,0),(6,6,1,4),(7,7,2,12),(8,8,3,11),(10,10,5,4),(11,11,1,10),(12,12,2,5),(14,14,4,0),(16,16,1,0),(18,18,3,7),(20,20,5,1),(22,22,2,12),(23,23,3,7),(24,24,4,4),(25,25,5,4),(26,26,1,7),(27,27,2,12),(28,28,3,6),(29,29,4,2),(31,31,1,5),(32,32,2,6),(33,33,3,6),(34,34,4,5),(36,36,1,9),(37,37,2,4),(38,38,3,4),(39,39,4,6),(41,41,1,8),(42,42,2,13),(44,44,4,0),(45,45,5,14),(47,47,2,9),(49,49,4,3),(52,52,2,2),(53,53,3,11),(54,54,4,11),(55,55,5,9),(56,56,1,4),(57,57,2,3),(58,58,3,12),(59,59,4,8),(60,60,5,5),(61,61,1,6),(62,62,2,11),(63,63,3,11),(64,64,4,12),(66,66,1,1),(67,67,2,4),(69,69,4,6),(70,70,5,2),(72,72,2,6),(76,76,1,13),(80,80,5,12),(82,82,2,8),(83,83,3,10),(84,84,4,1),(86,86,1,10),(87,87,2,11),(89,89,4,0),(91,91,1,6),(92,92,2,7),(94,94,4,12),(95,95,5,15),(96,96,1,6),(97,97,2,6),(98,98,3,12),(99,99,4,9),(100,100,5,3),(101,101,1,11),(102,102,2,14),(103,103,3,10),(106,106,1,6),(107,107,2,14),(109,109,4,11),(113,113,3,3),(115,115,5,3),(116,116,1,9),(117,117,2,10),(119,119,4,13),(120,120,5,13),(122,122,2,10),(123,123,3,9),(124,124,4,4),(125,125,5,3),(131,131,1,1),(134,134,4,0),(135,135,5,0),(137,137,2,1),(138,138,3,10),(139,139,4,7),(140,140,5,13),(141,141,1,2),(145,145,5,10),(150,150,5,2),(153,153,3,3),(154,154,4,6),(155,155,5,14),(160,160,5,10),(163,163,3,5),(164,164,4,3),(169,169,4,10),(170,170,5,10),(171,171,1,6),(174,174,4,6),(177,177,2,3),(178,178,3,9),(182,182,2,14),(183,183,3,12),(186,186,1,8),(187,187,2,4),(188,188,3,10),(192,192,2,0),(194,194,4,2),(195,195,5,7),(197,197,2,1),(198,198,3,14),(201,1,1,7),(202,2,2,13),(203,3,3,12),(204,4,4,5),(205,5,5,4),(206,6,1,8),(207,7,2,8),(208,8,3,12),(210,10,5,1),(211,11,1,8),(212,12,2,15),(214,14,4,11),(216,16,1,5),(218,18,3,13),(220,20,5,3),(222,22,2,14),(223,23,3,6),(224,24,4,0),(225,25,5,7),(226,26,1,-3),(227,27,2,14),(228,28,3,12),(229,29,4,-4),(231,31,1,2),(232,32,2,1),(233,33,3,0),(234,34,4,2),(236,36,1,8),(237,37,2,10),(238,38,3,4),(239,39,4,2),(241,41,1,7),(242,42,2,14),(244,44,4,9),(245,45,5,15),(247,47,2,10),(249,49,4,6),(252,52,2,10),(253,53,3,13),(254,54,4,11),(255,55,5,-1),(256,56,1,1),(257,57,2,9),(258,58,3,14),(259,59,4,3),(260,60,5,6),(261,61,1,7),(262,62,2,11),(263,63,3,8),(264,64,4,4),(266,66,1,0),(267,67,2,14),(269,69,4,1),(270,70,5,15),(272,72,2,6),(276,76,1,1),(280,80,5,8),(282,82,2,10),(283,83,3,9),(284,84,4,13),(286,86,1,2),(287,87,2,6),(289,89,4,4),(291,91,1,11),(292,92,2,5),(294,94,4,12),(295,95,5,13),(296,96,1,8),(297,97,2,8),(298,98,3,15),(299,99,4,13),(300,100,5,8),(301,101,1,6),(302,102,2,15),(303,103,3,13),(306,106,1,10),(307,107,2,8),(309,109,4,14),(313,113,3,6),(315,115,5,13),(316,116,1,-1),(317,117,2,10),(319,119,4,4),(320,120,5,8),(322,122,2,0),(323,123,3,6),(324,124,4,13),(325,125,5,9),(331,131,1,10),(334,134,4,6),(335,135,5,5),(337,137,2,14),(338,138,3,2),(339,139,4,13),(340,140,5,9),(341,141,1,5),(345,145,5,13),(350,150,5,4),(353,153,3,8),(354,154,4,6),(355,155,5,5),(360,160,5,6),(363,163,3,8),(364,164,4,3),(369,169,4,8),(370,170,5,8),(371,171,1,11),(374,174,4,13),(377,177,2,3),(378,178,3,9),(382,182,2,4),(383,183,3,2),(386,186,1,12),(387,187,2,6),(388,188,3,5),(392,192,2,8),(394,194,4,12),(395,195,5,3),(397,197,2,8),(398,198,3,1),(401,1,1,5),(402,2,2,9),(403,3,3,12),(404,4,4,-2),(405,5,5,2),(406,6,1,11),(407,7,2,7),(408,8,3,6),(410,10,5,12),(411,11,1,1),(412,12,2,7),(414,14,4,9),(416,16,1,8),(418,18,3,6),(420,20,5,0),(422,22,2,9),(423,23,3,15),(424,24,4,6),(425,25,5,2),(426,26,1,2),(427,27,2,4),(428,28,3,2),(429,29,4,2),(431,31,1,14),(432,32,2,6),(433,33,3,8),(434,34,4,5),(436,36,1,10),(437,37,2,1),(438,38,3,7),(439,39,4,3),(441,41,1,7),(442,42,2,7),(444,44,4,13),(445,45,5,13),(447,47,2,9),(449,49,4,10),(452,52,2,14),(453,53,3,4),(454,54,4,9),(455,55,5,1),(456,56,1,10),(457,57,2,12),(458,58,3,10),(459,59,4,0),(460,60,5,11),(461,61,1,0),(462,62,2,6),(463,63,3,12),(464,64,4,10),(466,66,1,7),(467,67,2,4),(469,69,4,8),(470,70,5,9),(472,72,2,6),(476,76,1,0),(480,80,5,2),(482,82,2,11),(483,83,3,8),(484,84,4,5),(486,86,1,6),(487,87,2,3),(489,89,4,11),(491,91,1,3),(492,92,2,5),(494,94,4,2),(495,95,5,11),(496,96,1,5),(497,97,2,11),(498,98,3,15),(499,99,4,8),(500,100,5,13);
/*!40000 ALTER TABLE `book_instance` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `activateReservationOnInsert` BEFORE INSERT ON `book_instance` FOR EACH ROW BEGIN
	
	WHILE NEW.copies > 0 AND EXISTS (
		SELECT * FROM reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
	) DO
		
        UPDATE reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        SET reservation.status = 'active', reservation.reserve_date = CURRENT_DATE()
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        
        SET NEW.copies = NEW.copies-1;
    END WHILE;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `activateReservationOnUpdate` BEFORE UPDATE ON `book_instance` FOR EACH ROW BEGIN
	
	WHILE NEW.copies > 0
		AND NOT EXISTS (SELECT 1 FROM Disabled_Triggers where TriggerName = 'activateReservationOnUpdate')
		AND EXISTS (
		SELECT * FROM reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
	) DO
		
        UPDATE reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        SET reservation.status = 'active', reservation.reserve_date = CURRENT_DATE()
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        
        SET NEW.copies = NEW.copies-1;
    END WHILE;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `book_keywords`
--

DROP TABLE IF EXISTS `book_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_keywords` (
  `book_id` int NOT NULL,
  `keyword_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`keyword_id`),
  KEY `keyword_id` (`keyword_id`),
  CONSTRAINT `book_keywords_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`),
  CONSTRAINT `book_keywords_ibfk_2` FOREIGN KEY (`keyword_id`) REFERENCES `keywords` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_keywords`
--

LOCK TABLES `book_keywords` WRITE;
/*!40000 ALTER TABLE `book_keywords` DISABLE KEYS */;
INSERT INTO `book_keywords` VALUES (2,1),(4,1),(5,1),(18,1),(24,1),(27,1),(31,1),(34,1),(41,1),(42,1),(47,1),(54,1),(58,1),(63,1),(76,1),(83,1),(86,1),(89,1),(96,1),(100,1),(102,1),(119,1),(124,1),(125,1),(163,1),(178,1),(195,1),(5,2),(6,2),(10,2),(11,2),(14,2),(25,2),(28,2),(29,2),(33,2),(39,2),(44,2),(45,2),(56,2),(61,2),(69,2),(70,2),(72,2),(82,2),(83,2),(89,2),(99,2),(100,2),(113,2),(117,2),(122,2),(131,2),(139,2),(141,2),(155,2),(169,2),(186,2),(198,2),(2,3),(7,3),(18,3),(22,3),(23,3),(26,3),(36,3),(38,3),(42,3),(49,3),(53,3),(60,3),(62,3),(67,3),(69,3),(87,3),(92,3),(98,3),(106,3),(109,3),(115,3),(120,3),(134,3),(140,3),(145,3),(155,3),(160,3),(164,3),(169,3),(195,3),(2,4),(7,4),(12,4),(25,4),(27,4),(28,4),(34,4),(37,4),(39,4),(52,4),(55,4),(61,4),(70,4),(84,4),(86,4),(89,4),(95,4),(99,4),(103,4),(117,4),(153,4),(171,4),(178,4),(182,4),(192,4),(198,4),(1,5),(6,5),(8,5),(12,5),(16,5),(18,5),(24,5),(27,5),(28,5),(41,5),(44,5),(52,5),(54,5),(59,5),(64,5),(66,5),(84,5),(91,5),(94,5),(97,5),(106,5),(119,5),(131,5),(141,5),(160,5),(188,5),(192,5),(197,5),(3,6),(6,6),(14,6),(16,6),(22,6),(33,6),(36,6),(42,6),(45,6),(53,6),(59,6),(60,6),(62,6),(63,6),(67,6),(72,6),(76,6),(86,6),(92,6),(95,6),(98,6),(99,6),(103,6),(107,6),(116,6),(124,6),(140,6),(145,6),(153,6),(194,6),(3,7),(4,7),(10,7),(20,7),(23,7),(29,7),(31,7),(38,7),(45,7),(52,7),(56,7),(67,7),(80,7),(87,7),(91,7),(96,7),(109,7),(116,7),(123,7),(170,7),(174,7),(183,7),(186,7),(197,7),(8,8),(12,8),(14,8),(16,8),(32,8),(34,8),(36,8),(44,8),(55,8),(57,8),(60,8),(61,8),(69,8),(80,8),(115,8),(120,8),(125,8),(138,8),(139,8),(150,8),(154,8),(163,8),(164,8),(174,8),(177,8),(182,8),(194,8),(1,9),(5,9),(7,9),(11,9),(20,9),(26,9),(29,9),(31,9),(38,9),(39,9),(47,9),(54,9),(57,9),(58,9),(62,9),(63,9),(72,9),(83,9),(84,9),(87,9),(92,9),(94,9),(97,9),(98,9),(102,9),(107,9),(123,9),(138,9),(150,9),(154,9),(171,9),(183,9),(187,9),(1,10),(4,10),(10,10),(11,10),(23,10),(24,10),(26,10),(32,10),(33,10),(37,10),(41,10),(47,10),(49,10),(57,10),(58,10),(59,10),(64,10),(66,10),(82,10),(94,10),(95,10),(97,10),(101,10),(113,10),(122,10),(135,10),(137,10),(170,10),(177,10),(187,10),(188,10);
/*!40000 ALTER TABLE `book_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_title`
--

DROP TABLE IF EXISTS `book_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_title` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `publisher` varchar(100) NOT NULL,
  `isbn` char(17) NOT NULL,
  `pages` int NOT NULL,
  `summary` mediumtext NOT NULL,
  `image` varchar(200) DEFAULT NULL,
  `lang_id` char(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `isbn` (`isbn`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_title`
--

LOCK TABLES `book_title` WRITE;
/*!40000 ALTER TABLE `book_title` DISABLE KEYS */;
INSERT INTO `book_title` VALUES (1,'Book 9','Cambridge University Press','676629826-X',1179,'quis nostrud exercitation ullamco','https://picsum.photos/505/655','fr'),(2,'Book 0','Hachette Book Group','406339061-6',3556,'consectetur adipiscing elit','https://picsum.photos/539/067','ko'),(3,'Book 4','Simon & Schuster','553836104-7',2580,'consectetur adipiscing elit','https://picsum.photos/199/051','es'),(4,'Book 22','Hachette Book Group','454952830-3',1881,'sed do eiusmod tempor incididunt','https://picsum.photos/480/005','fr'),(5,'Book 108','Bloomsbury Publishing','906893687-5',3537,'consectetur adipiscing elit','https://picsum.photos/983/349','zh'),(6,'Book 3','Pearson Education','587651744-5',1067,'ut labore et dolore magna aliqua','https://picsum.photos/598/943','ko'),(7,'Book 98','Simon & Schuster','638399736-X',987,'Ut enim ad minim veniam','https://picsum.photos/932/909','en'),(8,'Book 7','Pearson Education','027123623-X',3271,'Lorem ipsum dolor sit amet','https://picsum.photos/046/396','ru'),(10,'Book 8','Penguin Random House','919150339-6',1469,'ut labore et dolore magna aliqua','https://picsum.photos/089/861','it'),(11,'Book 52','HarperCollins','860564192-4',1078,'Ut enim ad minim veniam','https://picsum.photos/898/476','es'),(12,'Book 68','Penguin Random House','891335763-1',1185,'sed do eiusmod tempor incididunt','https://picsum.photos/059/531','ru'),(14,'Book 93','Bloomsbury Publishing','413510635-8',3201,'Ut enim ad minim veniam','https://picsum.photos/613/673','ar'),(16,'Book 29','Oxford University Press','355180830-9',3953,'consectetur adipiscing elit','https://picsum.photos/584/398','ar'),(18,'Book 20','Scholastic Corporation','784343713-4',1086,'Lorem ipsum dolor sit amet','https://picsum.photos/356/502','ja'),(20,'Book 41','HarperCollins','004939679-X',2321,'sed do eiusmod tempor incididunt','https://picsum.photos/064/866','zh'),(22,'Book 432','HarperCollins','386866116-6',1524,'sed do eiusmod tempor incididunt','https://picsum.photos/455/122','de'),(23,'Book 19','Cambridge University Press','264630925-2',1868,'Lorem ipsum dolor sit amet','https://picsum.photos/753/867','es'),(24,'Book 1','Bloomsbury Publishing','536112866-X',1353,'consectetur adipiscing elit','https://picsum.photos/823/812','ar'),(25,'Book 12','Hachette Book Group','766046898-7',2885,'consectetur adipiscing elit','https://picsum.photos/658/320','en'),(26,'Book 301','Penguin Random House','964025563-7',1040,'consectetur adipiscing elit','https://picsum.photos/440/447','zh'),(27,'Book 78','Oxford University Press','846091671-5',3655,'sed do eiusmod tempor incididunt','https://picsum.photos/591/021','ar'),(28,'Book 873','Scholastic Corporation','541503415-3',2277,'consectetur adipiscing elit','https://picsum.photos/233/442','pt'),(29,'Book 64','HarperCollins','370308351-4',568,'quis nostrud exercitation ullamco','https://picsum.photos/015/383','ja'),(31,'Book 333','Scholastic Corporation','288512318-4',67,'Lorem ipsum dolor sit amet','https://picsum.photos/967/432','it'),(32,'Book 792','HarperCollins','963020590-4',1994,'Lorem ipsum dolor sit amet','https://picsum.photos/905/001','it'),(33,'Book 95','Penguin Random House','615884467-5',319,'Ut enim ad minim veniam','https://picsum.photos/190/951','en'),(34,'Book 73','Pearson Education','454006478-9',3758,'quis nostrud exercitation ullamco','https://picsum.photos/307/497','it'),(36,'Book 503','Oxford University Press','169278217-7',634,'consectetur adipiscing elit','https://picsum.photos/487/640','ar'),(37,'Book 823','HarperCollins','235661431-1',417,'sed do eiusmod tempor incididunt','https://picsum.photos/223/628','ja'),(38,'Book 131','Scholastic Corporation','224855909-7',3436,'Ut enim ad minim veniam','https://picsum.photos/532/484','ar'),(39,'Book 049','Oxford University Press','349248523-5',2904,'sed do eiusmod tempor incididunt','https://picsum.photos/780/423','ja'),(41,'Book 77','Macmillan Publishers','560028609-0',178,'Lorem ipsum dolor sit amet','https://picsum.photos/046/612','es'),(42,'Book 300','Simon & Schuster','382500394-9',637,'quis nostrud exercitation ullamco','https://picsum.photos/469/818','ja'),(44,'Book 226','Macmillan Publishers','696871009-9',1372,'quis nostrud exercitation ullamco','https://picsum.photos/574/529','ru'),(45,'Book 830','Simon & Schuster','505091710-7',190,'quis nostrud exercitation ullamco','https://picsum.photos/611/789','ja'),(47,'Book 40','HarperCollins','870060408-9',1765,'sed do eiusmod tempor incididunt','https://picsum.photos/995/641','pt'),(49,'Book 409','Cambridge University Press','197845086-9',669,'Ut enim ad minim veniam','https://picsum.photos/093/482','ru'),(52,'Book 69','Hachette Book Group','216739817-4',3994,'consectetur adipiscing elit','https://picsum.photos/666/839','ru'),(53,'Book 6','Penguin Random House','450641318-0',3527,'quis nostrud exercitation ullamco','https://picsum.photos/610/485','ru'),(54,'Book 657','Hachette Book Group','838647797-0',3524,'Lorem ipsum dolor sit amet','https://picsum.photos/538/175','pt'),(55,'Book 5','Macmillan Publishers','523869049-5',3280,'consectetur adipiscing elit','https://picsum.photos/218/461','ko'),(56,'Book 72','Hachette Book Group','578826861-3',3404,'Ut enim ad minim veniam','https://picsum.photos/214/531','es'),(57,'Book 13','HarperCollins','244315645-1',997,'Ut enim ad minim veniam','https://picsum.photos/673/561','ja'),(58,'Book 46','Pearson Education','456102355-0',1770,'sed do eiusmod tempor incididunt','https://picsum.photos/654/395','it'),(59,'Book 60','Hachette Book Group','187237808-0',3928,'sed do eiusmod tempor incididunt','https://picsum.photos/158/393','pt'),(60,'Book 84','Simon & Schuster','156242791-1',659,'Ut enim ad minim veniam','https://picsum.photos/826/409','fr'),(61,'Book 094','Simon & Schuster','615673431-7',657,'sed do eiusmod tempor incididunt','https://picsum.photos/387/049','ja'),(62,'Book 170','Simon & Schuster','747528361-5',2787,'Lorem ipsum dolor sit amet','https://picsum.photos/767/041','zh'),(63,'Book 61','Simon & Schuster','161256568-9',413,'quis nostrud exercitation ullamco','https://picsum.photos/680/519','ru'),(64,'Book 604','Cambridge University Press','035478310-6',1520,'sed do eiusmod tempor incididunt','https://picsum.photos/867/524','ar'),(66,'Book 862','HarperCollins','726999141-3',800,'sed do eiusmod tempor incididunt','https://picsum.photos/337/652','ru'),(67,'Book 56','Hachette Book Group','553922674-7',1668,'Lorem ipsum dolor sit amet','https://picsum.photos/031/794','ko'),(69,'Book 519','Cambridge University Press','496100570-3',452,'sed do eiusmod tempor incididunt','https://picsum.photos/930/001','es'),(70,'Book 120','Simon & Schuster','317515623-1',3806,'Lorem ipsum dolor sit amet','https://picsum.photos/160/647','zh'),(72,'Book 2','Penguin Random House','296499588-5',1317,'ut labore et dolore magna aliqua','https://picsum.photos/980/905','de'),(76,'Book 16','Penguin Random House','860466991-4',3413,'Lorem ipsum dolor sit amet','https://picsum.photos/627/502','pt'),(80,'Book 07','Oxford University Press','957385046-X',2597,'consectetur adipiscing elit','https://picsum.photos/262/152','de'),(82,'Book 02','HarperCollins','816051417-4',1201,'quis nostrud exercitation ullamco','https://picsum.photos/281/079','fr'),(83,'Book 11','Pearson Education','471911339-7',2074,'ut labore et dolore magna aliqua','https://picsum.photos/083/248','de'),(84,'Book 154','Scholastic Corporation','175978120-7',3049,'ut labore et dolore magna aliqua','https://picsum.photos/518/675','ja'),(86,'Book 30','Bloomsbury Publishing','217904495-X',2941,'Lorem ipsum dolor sit amet','https://picsum.photos/087/384','it'),(87,'Book 91','Hachette Book Group','014193819-6',2465,'Ut enim ad minim veniam','https://picsum.photos/634/490','ja'),(89,'Book 349','Scholastic Corporation','519944529-4',2813,'quis nostrud exercitation ullamco','https://picsum.photos/167/254','ja'),(91,'Book 711','HarperCollins','681525535-2',1098,'consectetur adipiscing elit','https://picsum.photos/744/870','es'),(92,'Book 33','Simon & Schuster','133160796-5',3472,'consectetur adipiscing elit','https://picsum.photos/554/690','en'),(94,'Book 310','Simon & Schuster','361455280-2',1859,'consectetur adipiscing elit','https://picsum.photos/304/786','es'),(95,'Book 44','Macmillan Publishers','481566759-4',3716,'Ut enim ad minim veniam','https://picsum.photos/999/045','zh'),(96,'Book 307','Macmillan Publishers','795778259-0',2427,'quis nostrud exercitation ullamco','https://picsum.photos/646/006','en'),(97,'Book 53','Oxford University Press','616077766-1',327,'Lorem ipsum dolor sit amet','https://picsum.photos/775/256','ar'),(98,'Book 06','Hachette Book Group','168617972-3',191,'quis nostrud exercitation ullamco','https://picsum.photos/745/991','ar'),(99,'Book 71','Macmillan Publishers','538125842-9',3103,'ut labore et dolore magna aliqua','https://picsum.photos/419/824','en'),(100,'Book 029','Bloomsbury Publishing','372419952-X',2999,'Ut enim ad minim veniam','https://picsum.photos/431/750','ar'),(101,'Book 59','Bloomsbury Publishing','166652473-5',3704,'quis nostrud exercitation ullamco','https://picsum.photos/756/888','ar'),(102,'Book 003','Scholastic Corporation','152267026-2',3156,'consectetur adipiscing elit','https://picsum.photos/122/677','ko'),(103,'Book 583','Cambridge University Press','705081520-9',218,'quis nostrud exercitation ullamco','https://picsum.photos/412/013','it'),(106,'Book 151','Penguin Random House','124026319-8',2613,'consectetur adipiscing elit','https://picsum.photos/741/036','fr'),(107,'Book 49','Simon & Schuster','111161253-6',1995,'quis nostrud exercitation ullamco','https://picsum.photos/814/160','ja'),(109,'Book 196','Macmillan Publishers','967893032-3',1042,'Ut enim ad minim veniam','https://picsum.photos/015/975','es'),(113,'Book 888','Cambridge University Press','196427544-X',3008,'Ut enim ad minim veniam','https://picsum.photos/700/588','it'),(115,'Book 23','Scholastic Corporation','489119678-5',2000,'ut labore et dolore magna aliqua','https://picsum.photos/748/740','ru'),(116,'Book 739','Hachette Book Group','175236291-8',1842,'quis nostrud exercitation ullamco','https://picsum.photos/146/319','ko'),(117,'Book 05','Scholastic Corporation','955556050-1',604,'Ut enim ad minim veniam','https://picsum.photos/039/350','de'),(119,'Book 35','Scholastic Corporation','272061189-1',694,'Lorem ipsum dolor sit amet','https://picsum.photos/422/682','it'),(120,'Book 814','Cambridge University Press','105619255-0',2787,'Lorem ipsum dolor sit amet','https://picsum.photos/668/427','ar'),(122,'Book 477','Penguin Random House','992849009-0',3748,'sed do eiusmod tempor incididunt','https://picsum.photos/515/503','ja'),(123,'Book 86','Cambridge University Press','846665447-X',2334,'ut labore et dolore magna aliqua','https://picsum.photos/971/272','pt'),(124,'Book 282','Simon & Schuster','700378748-2',3319,'ut labore et dolore magna aliqua','https://picsum.photos/005/059','ja'),(125,'Book 75','Penguin Random House','609667584-0',3360,'consectetur adipiscing elit','https://picsum.photos/538/255','ko'),(131,'Book 48','Scholastic Corporation','799423880-7',3993,'quis nostrud exercitation ullamco','https://picsum.photos/208/142','en'),(134,'Book 756','Pearson Education','615513357-3',1824,'consectetur adipiscing elit','https://picsum.photos/102/794','pt'),(135,'Book 483','HarperCollins','041256412-2',3523,'quis nostrud exercitation ullamco','https://picsum.photos/325/906','zh'),(137,'Book 152','HarperCollins','262358800-7',1360,'Lorem ipsum dolor sit amet','https://picsum.photos/196/072','ja'),(138,'Book 356','HarperCollins','895223292-5',2269,'Ut enim ad minim veniam','https://picsum.photos/472/114','pt'),(139,'Book 18','Scholastic Corporation','995192454-9',2872,'Ut enim ad minim veniam','https://picsum.photos/687/977','pt'),(140,'Book 680','Penguin Random House','881300303-X',1614,'consectetur adipiscing elit','https://picsum.photos/683/985','zh'),(141,'Book 345','Scholastic Corporation','912592345-5',758,'Lorem ipsum dolor sit amet','https://picsum.photos/680/831','ja'),(145,'Book 51','HarperCollins','020781332-9',3734,'sed do eiusmod tempor incididunt','https://picsum.photos/348/643','ru'),(150,'Book 384','Hachette Book Group','721433166-7',778,'Lorem ipsum dolor sit amet','https://picsum.photos/462/712','fr'),(153,'Book 348','Hachette Book Group','611839481-4',1041,'consectetur adipiscing elit','https://picsum.photos/951/627','ko'),(154,'Book 221','Simon & Schuster','748272145-2',1205,'sed do eiusmod tempor incididunt','https://picsum.photos/172/822','de'),(155,'Book 343','Penguin Random House','359438963-4',1690,'ut labore et dolore magna aliqua','https://picsum.photos/463/847','it'),(160,'Book 92','Hachette Book Group','326036380-7',3422,'Lorem ipsum dolor sit amet','https://picsum.photos/038/670','es'),(163,'Book 32','HarperCollins','351080571-2',1627,'Lorem ipsum dolor sit amet','https://picsum.photos/251/307','en'),(164,'Book 857','Hachette Book Group','858617938-8',3903,'sed do eiusmod tempor incididunt','https://picsum.photos/980/638','ja'),(169,'Book 922','Macmillan Publishers','627239243-5',966,'Ut enim ad minim veniam','https://picsum.photos/679/782','zh'),(170,'Book 212','Hachette Book Group','028355200-X',2401,'quis nostrud exercitation ullamco','https://picsum.photos/394/940','es'),(171,'Book 742','Penguin Random House','649546994-2',1109,'Ut enim ad minim veniam','https://picsum.photos/789/285','ru'),(174,'Book 510','Oxford University Press','954213583-1',231,'sed do eiusmod tempor incididunt','https://picsum.photos/589/417','zh'),(177,'Book 54','Hachette Book Group','579152945-7',1997,'Lorem ipsum dolor sit amet','https://picsum.photos/819/044','zh'),(178,'Book 47','Hachette Book Group','085386160-9',1111,'consectetur adipiscing elit','https://picsum.photos/235/151','it'),(182,'Book 87','Penguin Random House','225567284-7',3177,'quis nostrud exercitation ullamco','https://picsum.photos/886/142','es'),(183,'Book 08','Hachette Book Group','208395731-8',3067,'quis nostrud exercitation ullamco','https://picsum.photos/958/910','pt'),(186,'Book 513','Pearson Education','040073876-7',1568,'consectetur adipiscing elit','https://picsum.photos/334/930','zh'),(187,'Book 82','Cambridge University Press','892922875-5',1397,'quis nostrud exercitation ullamco','https://picsum.photos/640/636','it'),(188,'Book 972','Cambridge University Press','531262596-5',3088,'Lorem ipsum dolor sit amet','https://picsum.photos/395/068','fr'),(192,'Book 99','Pearson Education','643321530-0',3165,'ut labore et dolore magna aliqua','https://picsum.photos/575/749','pt'),(194,'Book 293','Hachette Book Group','085638836-X',1573,'sed do eiusmod tempor incididunt','https://picsum.photos/123/019','fr'),(195,'Book 675','Cambridge University Press','414818693-2',1222,'sed do eiusmod tempor incididunt','https://picsum.photos/873/329','en'),(197,'Book 264','Pearson Education','735307915-0',1356,'sed do eiusmod tempor incididunt','https://picsum.photos/928/087','ar'),(198,'Book 872','Bloomsbury Publishing','062750248-2',803,'Lorem ipsum dolor sit amet','https://picsum.photos/350/587','es');
/*!40000 ALTER TABLE `book_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrowing`
--

DROP TABLE IF EXISTS `borrowing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrowing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `status` enum('active','delayed','completed') NOT NULL,
  `manager_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  KEY `manager_id` (`manager_id`),
  CONSTRAINT `borrowing_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `borrowing_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`),
  CONSTRAINT `borrowing_ibfk_3` FOREIGN KEY (`manager_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrowing`
--

LOCK TABLES `borrowing` WRITE;
/*!40000 ALTER TABLE `borrowing` DISABLE KEYS */;
INSERT INTO `borrowing` VALUES (1,159,32,'completed',39,'2023-01-01','2023-01-14'),(2,36,44,'completed',100,'2023-01-01','2023-05-14'),(3,191,44,'completed',14,'2023-01-01','2023-02-13'),(4,172,183,'completed',25,'2023-01-02','2023-03-17'),(5,142,171,'completed',88,'2023-01-02','2023-04-14'),(6,84,100,'completed',195,'2023-01-02','2023-01-02'),(7,7,34,'completed',182,'2023-01-03','2023-04-22'),(8,175,33,'delayed',25,'2023-01-03',NULL),(9,138,61,'completed',163,'2023-01-03','2023-03-15'),(10,44,100,'completed',195,'2023-01-04','2023-01-05'),(11,186,59,'completed',38,'2023-01-04','2023-05-01'),(12,113,174,'completed',38,'2023-01-04','2023-01-04'),(13,200,39,'delayed',14,'2023-01-05',NULL),(14,79,12,'completed',125,'2023-01-05','2023-04-04'),(15,103,41,'completed',75,'2023-01-05','2023-01-23'),(16,55,76,'delayed',127,'2023-01-06',NULL),(17,41,87,'delayed',77,'2023-01-06',NULL),(18,82,76,'completed',163,'2023-01-06','2023-01-19'),(19,3,41,'completed',75,'2023-01-07','2023-02-03'),(20,68,66,'completed',177,'2023-01-07','2023-01-21'),(21,114,99,'delayed',38,'2023-01-07',NULL),(22,103,61,'completed',88,'2023-01-08','2023-01-30'),(23,196,106,'delayed',163,'2023-01-08',NULL),(24,80,82,'completed',29,'2023-01-08','2023-01-12'),(25,96,39,'completed',100,'2023-01-09','2023-03-01'),(26,140,20,'completed',62,'2023-01-09','2023-03-22'),(27,135,26,'delayed',75,'2023-01-09',NULL),(28,197,197,'completed',39,'2023-01-10','2023-02-12'),(29,117,96,'completed',162,'2023-01-10','2023-03-18'),(30,183,96,'delayed',189,'2023-01-11',NULL),(31,85,16,'delayed',177,'2023-01-11',NULL),(32,123,60,'delayed',198,'2023-01-13',NULL),(33,135,1,'completed',94,'2023-01-13','2023-02-23'),(34,171,47,'completed',93,'2023-01-13','2023-05-28'),(35,184,47,'delayed',166,'2023-01-14',NULL),(36,44,55,'delayed',15,'2023-01-14',NULL),(37,42,27,'delayed',49,'2023-01-15',NULL),(38,11,182,'delayed',125,'2023-01-15',NULL),(39,116,194,'delayed',149,'2023-01-15',NULL),(40,122,97,'completed',166,'2023-01-16','2023-01-26'),(41,118,62,'delayed',77,'2023-01-16',NULL),(42,181,61,'delayed',162,'2023-01-17',NULL),(43,106,101,'completed',162,'2023-01-17','2023-01-31'),(44,74,16,'delayed',94,'2023-01-17',NULL),(45,23,26,'completed',73,'2023-01-18','2023-01-20'),(46,97,83,'completed',158,'2023-01-19','2023-02-11'),(47,143,60,'delayed',195,'2023-01-19',NULL),(48,110,36,'completed',121,'2023-01-20','2023-02-18'),(49,118,137,'delayed',49,'2023-01-20',NULL),(50,199,26,'delayed',163,'2023-01-20',NULL),(51,6,186,'delayed',98,'2023-01-21',NULL),(52,65,14,'delayed',38,'2023-01-21',NULL),(53,52,2,'delayed',166,'2023-01-21',NULL),(54,159,52,'completed',176,'2023-01-22','2023-01-25'),(55,169,139,'completed',14,'2023-01-22','2023-04-09'),(56,132,138,'completed',188,'2023-01-22','2023-04-05'),(57,70,59,'completed',182,'2023-01-23','2023-02-07'),(58,54,145,'delayed',15,'2023-01-23',NULL),(59,32,169,'delayed',14,'2023-01-24',NULL),(60,60,87,'delayed',166,'2023-01-25',NULL),(61,80,82,'completed',166,'2023-01-25','2023-02-26'),(62,84,95,'completed',129,'2023-01-26','2023-03-04'),(63,37,106,'completed',98,'2023-01-26','2023-03-24'),(64,50,125,'completed',5,'2023-01-27','2023-04-10'),(65,92,64,'completed',38,'2023-01-28','2023-02-02'),(66,167,55,'delayed',198,'2023-01-29',NULL),(67,168,91,'delayed',98,'2023-01-29',NULL),(68,173,69,'completed',14,'2023-01-29','2023-05-08'),(69,159,177,'completed',176,'2023-01-30','2023-04-03'),(70,57,26,'delayed',189,'2023-01-31',NULL),(71,86,25,'completed',195,'2023-02-01','2023-02-10'),(72,109,5,'delayed',161,'2023-02-02',NULL),(73,147,139,'delayed',14,'2023-02-02',NULL),(74,126,97,'delayed',166,'2023-02-02',NULL),(75,59,11,'delayed',177,'2023-02-03',NULL),(76,147,49,'completed',14,'2023-02-04','2023-02-06'),(77,89,99,'delayed',38,'2023-02-04',NULL),(78,13,98,'completed',25,'2023-02-05','2023-02-05'),(79,28,92,'completed',27,'2023-02-05','2023-04-06'),(80,66,41,'delayed',162,'2023-02-06',NULL),(81,58,69,'completed',38,'2023-02-06','2023-02-20'),(82,154,117,'completed',27,'2023-02-07','2023-03-27'),(83,28,117,'delayed',77,'2023-02-07',NULL),(84,137,76,'completed',177,'2023-02-07','2023-06-01'),(85,179,117,'delayed',39,'2023-02-08',NULL),(86,91,100,'delayed',161,'2023-02-09',NULL),(87,63,60,'delayed',198,'2023-02-10',NULL),(88,153,115,'delayed',195,'2023-02-11',NULL),(89,145,34,'delayed',149,'2023-02-11',NULL),(90,90,134,'completed',38,'2023-02-13','2023-02-19'),(91,128,26,'completed',162,'2023-02-14','2023-03-28'),(92,76,22,'delayed',166,'2023-02-14',NULL),(93,165,80,'delayed',161,'2023-02-15',NULL),(94,8,192,'delayed',77,'2023-02-16',NULL),(95,17,99,'completed',100,'2023-02-16','2023-02-16'),(96,103,141,'delayed',73,'2023-02-17',NULL),(97,145,29,'delayed',14,'2023-02-17',NULL),(98,148,60,'delayed',15,'2023-02-18',NULL),(99,106,11,'completed',99,'2023-02-18','2023-03-12'),(100,105,59,'delayed',100,'2023-02-19',NULL),(101,64,72,'delayed',176,'2023-02-20',NULL),(102,193,16,'completed',127,'2023-02-21','2023-03-07'),(103,22,63,'delayed',188,'2023-02-22',NULL),(104,112,31,'delayed',177,'2023-02-23',NULL),(105,24,195,'completed',15,'2023-02-23','2023-03-19'),(106,115,44,'completed',100,'2023-02-24','2023-03-03'),(107,51,89,'delayed',149,'2023-02-25',NULL),(108,107,24,'delayed',100,'2023-02-26',NULL),(109,131,96,'delayed',88,'2023-02-27',NULL),(110,82,86,'completed',177,'2023-02-28','2023-05-12'),(111,80,117,'delayed',166,'2023-03-01',NULL),(112,34,86,'completed',99,'2023-03-02','2023-04-12'),(113,26,99,'completed',100,'2023-03-04','2023-05-17'),(114,157,39,'delayed',14,'2023-03-04',NULL),(115,86,100,'completed',129,'2023-03-05','2023-03-21'),(116,46,55,'completed',15,'2023-03-07','2023-03-30'),(117,33,72,'delayed',93,'2023-03-08',NULL),(118,194,4,'delayed',100,'2023-03-09',NULL),(119,110,86,'completed',121,'2023-03-09','2023-03-11'),(120,19,37,'delayed',39,'2023-03-10',NULL),(121,144,84,'delayed',149,'2023-03-10',NULL),(122,9,178,'completed',158,'2023-03-11','2023-04-25'),(123,122,47,'completed',125,'2023-03-12','2023-04-13'),(124,134,18,'delayed',158,'2023-03-13',NULL),(125,191,29,'delayed',14,'2023-03-13',NULL),(126,43,16,'delayed',121,'2023-03-14',NULL),(127,58,34,'delayed',182,'2023-03-14',NULL),(128,102,34,'delayed',38,'2023-03-16',NULL),(129,23,186,'delayed',121,'2023-03-17',NULL),(130,180,23,'completed',25,'2023-03-18','2023-05-09'),(131,110,131,'completed',99,'2023-03-18','2023-03-26'),(132,117,6,'delayed',73,'2023-03-19',NULL),(133,18,140,'delayed',129,'2023-03-20',NULL),(134,58,69,'completed',182,'2023-03-20','2023-04-28'),(135,24,80,'delayed',195,'2023-03-21',NULL),(136,120,10,'completed',62,'2023-03-22','2023-05-29'),(137,139,116,'delayed',98,'2023-03-23',NULL),(138,185,64,'delayed',149,'2023-03-24',NULL),(139,174,188,'completed',25,'2023-03-25','2023-04-18'),(140,3,116,'completed',121,'2023-03-25','2023-04-11'),(141,138,36,'delayed',73,'2023-03-25',NULL),(142,18,10,'delayed',161,'2023-03-26',NULL),(143,197,32,'delayed',166,'2023-03-29',NULL),(144,138,56,'delayed',99,'2023-03-31',NULL),(145,101,49,'delayed',182,'2023-03-31',NULL),(146,70,4,'delayed',100,'2023-04-02',NULL),(147,152,29,'delayed',149,'2023-04-02',NULL),(148,90,164,'delayed',100,'2023-04-03',NULL),(149,84,125,'completed',5,'2023-04-05','2023-04-23'),(150,90,134,'completed',149,'2023-04-09','2023-05-11'),(151,83,194,'completed',149,'2023-04-09','2023-04-26'),(152,136,103,'completed',188,'2023-04-10','2023-04-20'),(153,53,58,'delayed',25,'2023-04-10',NULL),(154,172,58,'completed',25,'2023-04-11','2023-05-26'),(155,12,57,'delayed',27,'2023-04-13',NULL),(156,72,97,'delayed',93,'2023-04-16',NULL),(157,2,183,'delayed',25,'2023-04-18',NULL),(158,79,122,'delayed',125,'2023-04-19',NULL),(159,160,178,'delayed',188,'2023-04-19',NULL),(160,140,135,'delayed',195,'2023-04-20',NULL),(161,130,41,'completed',99,'2023-04-22','2023-05-10'),(162,35,123,'delayed',188,'2023-04-23',NULL),(163,40,49,'delayed',38,'2023-04-24',NULL),(164,115,89,'delayed',14,'2023-04-25',NULL),(165,7,29,'delayed',100,'2023-04-27',NULL),(166,178,138,'delayed',158,'2023-04-27',NULL),(167,78,94,'completed',182,'2023-04-29','2023-05-16'),(168,31,20,'delayed',62,'2023-04-29',NULL),(169,84,25,'delayed',15,'2023-04-30',NULL),(170,83,94,'delayed',14,'2023-04-30',NULL),(171,169,49,'delayed',182,'2023-05-01',NULL),(172,71,29,'delayed',14,'2023-05-01',NULL),(173,61,89,'delayed',38,'2023-05-04',NULL),(174,110,66,'delayed',163,'2023-05-05',NULL),(175,97,178,'completed',25,'2023-05-06','2023-05-19'),(176,142,101,'delayed',98,'2023-05-08',NULL),(177,128,61,'delayed',163,'2023-05-09',NULL),(178,159,7,'delayed',77,'2023-05-10',NULL),(179,45,8,'delayed',25,'2023-05-12',NULL),(180,4,92,'delayed',176,'2023-05-13',NULL),(181,68,76,'delayed',88,'2023-05-14',NULL),(182,50,160,'delayed',161,'2023-05-15',NULL),(183,96,59,'delayed',149,'2023-05-15',NULL),(184,86,195,'delayed',15,'2023-05-17',NULL),(185,26,4,'delayed',182,'2023-05-18',NULL),(186,9,28,'delayed',25,'2023-05-19',NULL),(187,187,29,'delayed',149,'2023-05-20',NULL),(188,122,57,'delayed',27,'2023-05-20',NULL),(189,133,16,'delayed',177,'2023-05-21',NULL),(190,81,116,'delayed',73,'2023-05-24',NULL),(191,186,134,'active',182,'2023-05-25',NULL),(192,92,44,'active',149,'2023-05-26',NULL),(193,119,28,'active',188,'2023-05-26',NULL),(194,111,92,'active',49,'2023-05-27',NULL),(195,141,83,'active',158,'2023-05-27',NULL),(196,171,92,'active',166,'2023-05-31',NULL),(197,120,120,'active',198,'2023-06-01',NULL);
/*!40000 ALTER TABLE `borrowing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (9,'Biography'),(4,'Fantasy'),(7,'Historical Fiction'),(6,'Horror'),(8,'Memoir'),(1,'Mystery'),(2,'Romance'),(3,'Science Fiction'),(10,'Self-Help'),(5,'Thriller');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disabled_triggers`
--

DROP TABLE IF EXISTS `disabled_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disabled_triggers` (
  `TriggerName` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disabled_triggers`
--

LOCK TABLES `disabled_triggers` WRITE;
/*!40000 ALTER TABLE `disabled_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `disabled_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keywords`
--

DROP TABLE IF EXISTS `keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keywords` (
  `id` int NOT NULL AUTO_INCREMENT,
  `keyword` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword` (`keyword`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keywords`
--

LOCK TABLES `keywords` WRITE;
/*!40000 ALTER TABLE `keywords` DISABLE KEYS */;
INSERT INTO `keywords` VALUES (8,'biography'),(10,'cookbook'),(4,'fantasy'),(6,'historical fiction'),(1,'mystery'),(2,'romance'),(5,'sci-fi'),(7,'self-help'),(3,'thriller'),(9,'travel');
/*!40000 ALTER TABLE `keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `user_id` int NOT NULL,
  `status` enum('pending','active','expired') NOT NULL,
  `request_date` date NOT NULL,
  `reserve_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=229 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,98,45,'expired','2023-01-01','2023-01-01'),(2,20,20,'expired','2023-01-01','2023-01-01'),(3,91,3,'expired','2023-01-01','2023-01-01'),(4,91,139,'expired','2023-01-02','2023-01-02'),(5,31,85,'expired','2023-01-02','2023-01-02'),(6,101,131,'expired','2023-01-02','2023-01-02'),(7,87,60,'expired','2023-01-03','2023-01-03'),(8,67,79,'expired','2023-01-03','2023-01-03'),(9,86,66,'expired','2023-01-04','2023-01-04'),(10,96,142,'expired','2023-01-04','2023-01-04'),(11,80,54,'expired','2023-01-04','2023-01-04'),(12,66,137,'expired','2023-01-05','2023-01-05'),(13,69,173,'expired','2023-01-05','2023-01-05'),(14,54,61,'expired','2023-01-05','2023-01-05'),(15,91,128,'expired','2023-01-06','2023-01-06'),(16,154,96,'expired','2023-01-06','2023-01-06'),(17,106,74,'expired','2023-01-06','2023-01-06'),(18,96,193,'expired','2023-01-07','2023-01-07'),(19,54,124,'expired','2023-01-07','2023-01-07'),(20,26,139,'expired','2023-01-08','2023-01-08'),(21,70,54,'expired','2023-01-08','2023-01-08'),(22,16,57,'expired','2023-01-08','2023-01-08'),(23,84,89,'expired','2023-01-09','2023-01-09'),(24,153,9,'expired','2023-01-09','2023-01-09'),(25,54,51,'expired','2023-01-10','2023-01-10'),(26,26,103,'expired','2023-01-10','2023-01-10'),(27,16,196,'expired','2023-01-10','2023-01-10'),(28,84,147,'expired','2023-01-11','2023-01-11'),(29,6,59,'expired','2023-01-11','2023-01-11'),(30,100,63,'expired','2023-01-11','2023-01-11'),(31,188,9,'expired','2023-01-12','2023-01-12'),(32,95,167,'expired','2023-01-12','2023-01-12'),(33,116,128,'expired','2023-01-12','2023-01-12'),(34,54,194,'expired','2023-01-13','2023-01-13'),(35,61,130,'expired','2023-01-13','2023-01-13'),(36,41,131,'expired','2023-01-13','2023-01-13'),(37,61,139,'expired','2023-01-14','2023-01-14'),(38,55,44,'expired','2023-01-14','2023-01-14'),(39,174,115,'expired','2023-01-14','2023-01-14'),(40,82,184,'expired','2023-01-15','2023-01-15'),(41,164,187,'expired','2023-01-15','2023-01-15'),(42,154,144,'expired','2023-01-15','2023-01-15'),(43,170,31,'expired','2023-01-16','2023-01-16'),(44,20,44,'expired','2023-01-16','2023-01-16'),(45,137,111,'expired','2023-01-17','2023-01-17'),(46,54,47,'expired','2023-01-17','2023-01-17'),(47,14,185,'expired','2023-01-17','2023-01-17'),(48,120,148,'expired','2023-01-18','2023-01-18'),(49,5,46,'expired','2023-01-18','2023-01-18'),(50,1,43,'active','2023-01-19','2023-06-03'),(51,195,84,'expired','2023-01-19','2023-01-19'),(52,60,63,'expired','2023-01-19','2023-01-19'),(53,14,58,'expired','2023-01-20','2023-01-20'),(54,44,65,'active','2023-01-20','2023-06-03'),(55,34,87,'expired','2023-01-21','2023-01-21'),(56,32,80,'expired','2023-01-21','2023-01-21'),(57,106,128,'expired','2023-01-21','2023-01-21'),(58,7,60,'expired','2023-01-22','2023-01-22'),(59,32,154,'expired','2023-01-23','2023-01-23'),(60,56,193,'expired','2023-01-24','2023-01-24'),(61,87,179,'expired','2023-01-24','2023-01-24'),(62,36,23,'expired','2023-01-25','2023-01-25'),(63,38,155,'expired','2023-01-25','2023-01-25'),(64,41,131,'expired','2023-01-25','2023-01-25'),(65,124,104,'expired','2023-01-26','2023-01-26'),(66,45,86,'expired','2023-01-26','2023-01-26'),(67,119,83,'expired','2023-01-27','2023-01-27'),(68,1,34,'active','2023-01-27','2023-06-03'),(69,8,22,'expired','2023-01-28','2023-01-28'),(70,39,70,'expired','2023-01-29','2023-01-29'),(71,29,105,'expired','2023-01-29','2023-01-29'),(72,29,30,'expired','2023-01-30','2023-01-30'),(73,39,58,'expired','2023-01-30','2023-01-30'),(74,99,67,'expired','2023-01-30','2023-01-30'),(75,56,68,'expired','2023-01-31','2023-01-31'),(76,119,173,'expired','2023-01-31','2023-01-31'),(77,56,130,'expired','2023-02-01','2023-02-01'),(78,29,71,'expired','2023-02-01','2023-02-01'),(79,56,133,'expired','2023-02-01','2023-02-01'),(80,6,81,'expired','2023-02-02','2023-02-02'),(81,54,90,'expired','2023-02-02','2023-02-02'),(82,94,185,'expired','2023-02-02','2023-02-02'),(83,41,139,'expired','2023-02-03','2023-02-03'),(84,16,190,'expired','2023-02-03','2023-02-03'),(85,141,3,'expired','2023-02-04','2023-02-04'),(86,62,154,'expired','2023-02-04','2023-02-04'),(87,101,131,'expired','2023-02-05','2023-02-05'),(88,174,194,'expired','2023-02-05','2023-02-05'),(89,97,154,'expired','2023-02-05','2023-02-05'),(90,24,147,'expired','2023-02-07','2023-02-07'),(91,60,86,'expired','2023-02-07','2023-02-07'),(92,102,126,'expired','2023-02-08','2023-02-08'),(93,31,112,'expired','2023-02-08','2023-02-08'),(94,20,24,'expired','2023-02-08','2023-02-08'),(95,117,8,'expired','2023-02-09','2023-02-09'),(96,155,109,'expired','2023-02-09','2023-02-09'),(97,5,31,'active','2023-02-10','2023-06-03'),(98,177,76,'expired','2023-02-11','2023-02-11'),(99,119,115,'expired','2023-02-11','2023-02-11'),(100,122,179,'expired','2023-02-12','2023-02-12'),(101,39,58,'expired','2023-02-12','2023-02-12'),(102,64,16,'expired','2023-02-13','2023-02-13'),(103,2,33,'expired','2023-02-13','2023-02-13'),(104,12,197,'expired','2023-02-14','2023-02-14'),(105,11,106,'expired','2023-02-15','2023-02-15'),(106,101,81,'expired','2023-02-15','2023-02-15'),(107,24,87,'expired','2023-02-16','2023-02-16'),(108,29,115,'expired','2023-02-16','2023-02-16'),(109,31,193,'expired','2023-02-17','2023-02-17'),(110,47,64,'expired','2023-02-18','2023-02-18'),(111,1,23,'active','2023-02-18','2023-06-03'),(112,101,128,'expired','2023-02-18','2023-02-18'),(113,187,76,'expired','2023-02-19','2023-02-19'),(114,57,8,'expired','2023-02-19','2023-02-19'),(115,169,104,'expired','2023-02-19','2023-02-19'),(116,61,23,'expired','2023-02-20','2023-02-20'),(117,197,122,'expired','2023-02-21','2023-02-21'),(118,47,72,'expired','2023-02-22','2023-02-22'),(119,18,9,'expired','2023-02-22','2023-02-22'),(120,116,133,'expired','2023-02-23','2023-02-23'),(121,49,78,'expired','2023-02-24','2023-02-24'),(122,24,16,'expired','2023-02-24','2023-02-24'),(123,154,87,'expired','2023-02-24','2023-02-24'),(124,22,64,'expired','2023-02-25','2023-02-25'),(125,174,1,'expired','2023-02-26','2023-02-26'),(126,106,193,'expired','2023-02-27','2023-02-27'),(127,164,194,'expired','2023-02-28','2023-02-28'),(128,41,3,'expired','2023-02-28','2023-02-28'),(129,194,26,'expired','2023-03-01','2023-03-01'),(130,54,51,'expired','2023-03-01','2023-03-01'),(131,101,131,'expired','2023-03-02','2023-03-02'),(132,14,92,'active','2023-03-02','2023-06-03'),(133,44,70,'active','2023-03-03','2023-06-03'),(134,53,48,'expired','2023-03-04','2023-03-04'),(135,16,82,'active','2023-03-04','2023-06-03'),(136,54,17,'expired','2023-03-05','2023-03-05'),(137,182,4,'expired','2023-03-06','2023-03-06'),(138,54,144,'expired','2023-03-08','2023-03-08'),(139,11,68,'expired','2023-03-09','2023-03-09'),(140,23,13,'expired','2023-03-09','2023-03-09'),(141,120,151,'expired','2023-03-09','2023-03-09'),(142,47,33,'expired','2023-03-10','2023-03-10'),(143,24,78,'expired','2023-03-11','2023-03-11'),(144,198,95,'expired','2023-03-11','2023-03-11'),(145,44,30,'active','2023-03-12','2023-06-03'),(146,106,133,'expired','2023-03-14','2023-03-14'),(147,87,4,'expired','2023-03-15','2023-03-15'),(148,16,190,'active','2023-03-18','2023-06-03'),(149,91,3,'expired','2023-03-19','2023-03-19'),(150,89,187,'expired','2023-03-20','2023-03-20'),(151,97,111,'expired','2023-03-20','2023-03-20'),(152,49,70,'expired','2023-03-21','2023-03-21'),(153,89,83,'expired','2023-03-22','2023-03-22'),(154,24,104,'expired','2023-03-23','2023-03-23'),(155,134,113,'expired','2023-03-23','2023-03-23'),(156,154,30,'expired','2023-03-25','2023-03-25'),(157,36,37,'expired','2023-03-25','2023-03-25'),(158,69,101,'expired','2023-03-28','2023-03-28'),(159,8,13,'expired','2023-03-29','2023-03-29'),(160,31,3,'expired','2023-03-31','2023-03-31'),(161,67,154,'expired','2023-04-01','2023-04-01'),(162,100,86,'expired','2023-04-02','2023-04-02'),(163,109,17,'expired','2023-04-02','2023-04-02'),(164,83,56,'expired','2023-04-02','2023-04-02'),(165,169,47,'expired','2023-04-03','2023-04-03'),(166,64,104,'expired','2023-04-03','2023-04-03'),(167,18,136,'expired','2023-04-03','2023-04-03'),(168,94,40,'expired','2023-04-04','2023-04-04'),(169,36,193,'expired','2023-04-04','2023-04-04'),(170,16,133,'expired','2023-04-06','2023-06-03'),(171,69,92,'expired','2023-04-06','2023-04-06'),(172,5,146,'active','2023-04-08','2023-06-03'),(173,20,20,'expired','2023-04-08','2023-04-08'),(174,47,79,'expired','2023-04-09','2023-04-09'),(175,70,151,'expired','2023-04-10','2023-04-10'),(176,153,178,'expired','2023-04-10','2023-04-10'),(177,103,2,'expired','2023-04-11','2023-04-11'),(178,120,31,'expired','2023-04-11','2023-04-11'),(179,37,159,'expired','2023-04-12','2023-04-12'),(180,174,17,'expired','2023-04-13','2023-04-13'),(181,53,69,'expired','2023-04-13','2023-04-13'),(182,59,87,'expired','2023-04-17','2023-04-17'),(183,55,140,'expired','2023-04-18','2023-04-18'),(184,107,111,'expired','2023-04-18','2023-04-18'),(185,16,130,'active','2023-04-19','2023-06-03'),(186,195,46,'expired','2023-04-20','2023-04-20'),(187,41,81,'expired','2023-04-21','2023-04-21'),(188,66,68,'expired','2023-04-21','2023-04-21'),(189,24,7,'expired','2023-04-23','2023-04-23'),(190,18,192,'expired','2023-04-24','2023-04-24'),(191,120,151,'expired','2023-04-25','2023-04-25'),(192,141,128,'expired','2023-04-27','2023-04-27'),(193,28,178,'expired','2023-04-28','2023-04-28'),(194,86,81,'expired','2023-04-29','2023-04-29'),(195,164,108,'expired','2023-04-30','2023-04-30'),(196,98,69,'expired','2023-04-30','2023-04-30'),(197,107,111,'expired','2023-04-30','2023-04-30'),(198,41,3,'expired','2023-05-02','2023-05-02'),(199,26,68,'expired','2023-05-02','2023-05-02'),(200,195,46,'expired','2023-05-04','2023-05-04'),(201,96,37,'expired','2023-05-05','2023-05-05'),(202,58,9,'expired','2023-05-07','2023-05-07'),(203,99,92,'expired','2023-05-07','2023-05-07'),(204,92,111,'expired','2023-05-08','2023-05-08'),(205,61,110,'expired','2023-05-08','2023-05-08'),(206,153,119,'expired','2023-05-08','2023-05-08'),(207,69,108,'expired','2023-05-09','2023-05-09'),(208,87,159,'expired','2023-05-11','2023-05-11'),(209,141,34,'expired','2023-05-12','2023-05-12'),(210,109,113,'expired','2023-05-12','2023-05-12'),(211,4,96,'expired','2023-05-13','2023-05-13'),(212,109,87,'expired','2023-05-13','2023-05-13'),(213,113,132,'expired','2023-05-14','2023-05-14'),(214,56,130,'expired','2023-05-15','2023-05-15'),(215,119,96,'expired','2023-05-18','2023-05-18'),(216,106,193,'expired','2023-05-18','2023-05-18'),(217,109,16,'expired','2023-05-19','2023-05-19'),(218,99,67,'expired','2023-05-22','2023-05-22'),(219,58,136,'expired','2023-05-22','2023-05-22'),(220,31,190,'expired','2023-05-24','2023-05-24'),(221,6,106,'expired','2023-05-24','2023-05-24'),(222,26,82,'expired','2023-05-25','2023-05-25'),(223,26,130,'active','2023-05-27','2023-05-27'),(224,44,16,'active','2023-05-29','2023-06-03'),(225,44,47,'active','2023-05-29','2023-06-03'),(226,141,37,'active','2023-05-30','2023-05-30'),(227,24,104,'active','2023-05-31','2023-05-31'),(228,178,170,'active','2023-06-01','2023-06-01');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `opinion` text NOT NULL,
  `stars` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book_title` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=502 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,111,44,'The writing style was beautiful and poetic.',5,0),(3,68,150,'It was a bit slow in the beginning',4,1),(4,89,27,'I found the plot to be predictable.',1,0),(8,185,8,'This book wasn\'t really my cup of tea.',5,0),(9,55,95,'but it picked up towards the end.',2,1),(11,28,49,'I loved this book!',3,0),(13,164,47,'I loved this book!',2,1),(14,179,52,'This book wasn\'t really my cup of tea.',4,1),(15,69,188,'This book was a page-turner!',4,1),(17,10,2,'I couldn\'t put it down!',1,1),(18,65,1,'It was a bit slow in the beginning',4,1),(19,53,72,'I found the plot to be predictable.',2,0),(20,9,63,'This book was a page-turner!',3,1),(21,36,32,'The writing style was beautiful and poetic.',4,0),(22,60,58,'I was disappointed with the ending.',4,0),(24,98,182,'I would definitely recommend this book to others.',3,1),(25,80,14,'The writing style was beautiful and poetic.',5,1),(26,16,61,'I would definitely recommend this book to others.',1,1),(28,168,34,'This book was a page-turner!',5,0),(30,145,11,'This book was a page-turner!',1,1),(32,80,92,'It was a bit slow in the beginning',2,1),(33,30,45,'I couldn\'t put it down!',1,1),(34,48,84,'I couldn\'t put it down!',1,0),(35,131,101,'The characters were so well-developed.',3,0),(36,86,113,'The characters were so well-developed.',5,0),(38,165,116,'I was disappointed with the ending.',1,0),(39,125,124,'I loved this book!',4,1),(40,51,182,'but it picked up towards the end.',2,1),(42,199,8,'I would definitely recommend this book to others.',4,1),(43,152,67,'I would definitely recommend this book to others.',2,1),(46,14,38,'I was disappointed with the ending.',4,0),(47,40,153,'I would definitely recommend this book to others.',2,1),(49,163,14,'This book was a page-turner!',2,0),(50,179,42,'The writing style was beautiful and poetic.',1,0),(52,135,174,'The characters were so well-developed.',3,0),(53,144,42,'The writing style was beautiful and poetic.',5,0),(54,37,188,'The characters were so well-developed.',3,1),(55,71,41,'I loved this book!',1,0),(56,89,58,'The writing style was beautiful and poetic.',4,1),(57,69,125,'The writing style was beautiful and poetic.',3,0),(59,30,171,'I found the plot to be predictable.',1,0),(60,47,39,'I loved this book!',1,1),(62,72,76,'I was disappointed with the ending.',3,0),(63,186,92,'This book was a page-turner!',2,1),(64,13,183,'The characters were so well-developed.',1,1),(67,23,6,'I found the plot to be predictable.',4,0),(70,81,177,'The characters were so well-developed.',3,1),(71,53,64,'but it picked up towards the end.',5,1),(72,56,59,'The writing style was beautiful and poetic.',3,1),(73,187,66,'I couldn\'t put it down!',2,0),(75,80,27,'The characters were so well-developed.',4,0),(76,124,31,'This book wasn\'t really my cup of tea.',3,1),(77,98,67,'I couldn\'t put it down!',4,1),(78,134,188,'The writing style was beautiful and poetic.',4,0),(80,106,124,'I was disappointed with the ending.',3,1),(81,1,103,'I loved this book!',3,0),(82,65,89,'I was disappointed with the ending.',3,1),(83,20,137,'I loved this book!',4,0),(86,158,194,'I loved this book!',5,1),(90,182,171,'I would definitely recommend this book to others.',4,1),(92,156,20,'This book was a page-turner!',3,1),(94,151,42,'I couldn\'t put it down!',2,1),(95,192,125,'This book wasn\'t really my cup of tea.',5,1),(96,75,97,'I couldn\'t put it down!',3,0),(98,30,66,'I was disappointed with the ending.',2,0),(99,59,195,'I found the plot to be predictable.',1,1),(101,30,91,'This book was a page-turner!',1,0),(103,36,169,'I would definitely recommend this book to others.',1,1),(104,177,7,'The characters were so well-developed.',3,0),(106,118,24,'The characters were so well-developed.',3,1),(111,70,44,'I would definitely recommend this book to others.',4,1),(113,5,39,'I loved this book!',3,1),(114,77,106,'The writing style was beautiful and poetic.',4,1),(116,141,22,'but it picked up towards the end.',3,0),(118,9,178,'but it picked up towards the end.',3,1),(119,105,11,'The writing style was beautiful and poetic.',1,0),(120,19,8,'I was disappointed with the ending.',4,1),(122,150,34,'This book was a page-turner!',4,1),(124,50,107,'I would definitely recommend this book to others.',2,1),(125,81,120,'I found the plot to be predictable.',4,1),(127,198,29,'This book wasn\'t really my cup of tea.',1,1),(128,145,24,'The characters were so well-developed.',3,1),(129,188,58,'It was a bit slow in the beginning',4,1),(130,83,99,'but it picked up towards the end.',3,1),(133,90,139,'I would definitely recommend this book to others.',3,0),(134,104,102,'I was disappointed with the ending.',5,1),(135,23,84,'I found the plot to be predictable.',4,0),(137,87,174,'I couldn\'t put it down!',5,1),(139,44,109,'I was disappointed with the ending.',5,0),(140,69,198,'I loved this book!',1,0),(141,96,41,'This book was a page-turner!',4,0),(142,194,119,'but it picked up towards the end.',1,0),(146,5,107,'I found the plot to be predictable.',1,0),(147,160,125,'I was disappointed with the ending.',3,1),(148,136,177,'It was a bit slow in the beginning',3,0),(149,94,18,'I would definitely recommend this book to others.',3,1),(150,110,116,'I found the plot to be predictable.',3,0),(151,63,182,'It was a bit slow in the beginning',1,1),(154,194,124,'It was a bit slow in the beginning',3,0),(156,106,67,'The characters were so well-developed.',3,1),(161,67,14,'I was disappointed with the ending.',2,1),(162,172,92,'I loved this book!',1,1),(163,157,2,'I loved this book!',2,0),(164,44,33,'I loved this book!',3,1),(167,112,37,'I would definitely recommend this book to others.',1,0),(169,92,41,'It was a bit slow in the beginning',3,1),(170,43,96,'I was disappointed with the ending.',2,1),(171,182,131,'I couldn\'t put it down!',3,1),(173,177,55,'I loved this book!',1,1),(175,75,135,'The writing style was beautiful and poetic.',5,1),(176,9,76,'I loved this book!',5,1),(177,166,98,'I couldn\'t put it down!',4,0),(179,135,124,'This book was a page-turner!',1,1),(182,37,63,'I found the plot to be predictable.',5,0),(184,168,2,'It was a bit slow in the beginning',2,0),(186,66,58,'The writing style was beautiful and poetic.',1,1),(187,18,42,'I would definitely recommend this book to others.',5,0),(188,188,38,'I would definitely recommend this book to others.',4,0),(189,144,27,'This book was a page-turner!',4,1),(190,132,120,'I would definitely recommend this book to others.',5,1),(194,107,14,'I loved this book!',4,0),(195,185,87,'I would definitely recommend this book to others.',3,0),(196,25,22,'The writing style was beautiful and poetic.',4,1),(197,24,69,'but it picked up towards the end.',3,1),(199,119,67,'I loved this book!',2,0),(200,38,47,'I was disappointed with the ending.',1,1),(201,54,64,'The characters were so well-developed.',1,0),(202,167,52,'I couldn\'t put it down!',4,0),(203,59,24,'I found the plot to be predictable.',3,0),(204,183,7,'I couldn\'t put it down!',2,1),(205,190,188,'This book was a page-turner!',5,0),(207,117,120,'This book wasn\'t really my cup of tea.',1,1),(209,103,137,'It was a bit slow in the beginning',4,1),(210,171,187,'I loved this book!',3,0),(211,91,122,'but it picked up towards the end.',2,1),(212,79,139,'I loved this book!',4,1),(213,196,37,'The characters were so well-developed.',2,0),(214,106,192,'This book wasn\'t really my cup of tea.',3,1),(215,146,34,'I was disappointed with the ending.',1,1),(216,101,57,'I couldn\'t put it down!',4,0),(219,21,96,'I was disappointed with the ending.',2,0),(220,180,10,'I couldn\'t put it down!',3,0),(223,38,1,'The writing style was beautiful and poetic.',5,1),(224,110,28,'I couldn\'t put it down!',4,0),(226,17,139,'The characters were so well-developed.',2,1),(227,105,26,'This book wasn\'t really my cup of tea.',3,0),(228,174,22,'I couldn\'t put it down!',4,1),(232,106,154,'I was disappointed with the ending.',4,0),(234,156,66,'but it picked up towards the end.',5,0),(235,98,182,'This book wasn\'t really my cup of tea.',2,0),(237,86,6,'The writing style was beautiful and poetic.',4,1),(240,58,83,'This book was a page-turner!',3,1),(242,69,67,'I found the plot to be predictable.',1,1),(243,147,42,'I found the plot to be predictable.',2,1),(244,120,62,'The writing style was beautiful and poetic.',4,0),(245,100,122,'I found the plot to be predictable.',3,1),(248,70,14,'but it picked up towards the end.',1,0),(250,35,60,'I loved this book!',1,1),(251,150,95,'The writing style was beautiful and poetic.',2,0),(254,55,4,'The writing style was beautiful and poetic.',5,0),(256,54,195,'but it picked up towards the end.',3,0),(257,81,55,'but it picked up towards the end.',1,1),(259,177,2,'The characters were so well-developed.',4,1),(262,137,135,'The characters were so well-developed.',1,0),(267,155,96,'I loved this book!',3,1),(268,195,188,'It was a bit slow in the beginning',1,0),(269,126,182,'I found the plot to be predictable.',5,1),(270,104,1,'I would definitely recommend this book to others.',1,1),(271,194,76,'I would definitely recommend this book to others.',2,1),(272,120,6,'This book wasn\'t really my cup of tea.',4,1),(273,70,41,'I was disappointed with the ending.',4,0),(276,183,87,'I would definitely recommend this book to others.',4,1),(277,181,187,'I found the plot to be predictable.',1,1),(279,21,194,'The characters were so well-developed.',3,1),(280,130,14,'The writing style was beautiful and poetic.',3,0),(282,99,154,'It was a bit slow in the beginning',2,0),(284,19,52,'I couldn\'t put it down!',5,1),(285,87,76,'This book was a page-turner!',3,0),(287,94,86,'The characters were so well-developed.',2,0),(289,110,153,'The writing style was beautiful and poetic.',4,1),(290,196,178,'This book was a page-turner!',5,0),(291,139,97,'The characters were so well-developed.',1,1),(293,72,125,'I loved this book!',5,1),(294,81,26,'The writing style was beautiful and poetic.',3,1),(296,116,183,'I loved this book!',1,1),(298,175,163,'It was a bit slow in the beginning',5,0),(300,31,33,'This book was a page-turner!',4,0),(301,154,28,'I found the plot to be predictable.',5,0),(302,1,106,'The characters were so well-developed.',3,0),(303,90,109,'but it picked up towards the end.',3,1),(304,32,47,'I couldn\'t put it down!',4,0),(305,28,11,'The writing style was beautiful and poetic.',1,1),(306,138,150,'but it picked up towards the end.',5,1),(309,167,53,'It was a bit slow in the beginning',5,1),(310,75,145,'I loved this book!',4,1),(312,199,80,'This book wasn\'t really my cup of tea.',2,1),(313,184,198,'It was a bit slow in the beginning',4,1),(314,104,116,'This book was a page-turner!',5,0),(317,97,82,'It was a bit slow in the beginning',4,0),(319,192,131,'The writing style was beautiful and poetic.',1,0),(321,43,3,'The writing style was beautiful and poetic.',1,0),(323,92,169,'The writing style was beautiful and poetic.',5,1),(326,159,170,'I would definitely recommend this book to others.',5,1),(328,117,182,'The characters were so well-developed.',5,1),(331,165,55,'This book wasn\'t really my cup of tea.',2,1),(332,61,134,'This book wasn\'t really my cup of tea.',5,0),(333,162,135,'The characters were so well-developed.',5,1),(334,3,61,'I was disappointed with the ending.',2,0),(336,133,169,'I couldn\'t put it down!',1,0),(337,83,106,'but it picked up towards the end.',4,1),(341,29,54,'This book wasn\'t really my cup of tea.',2,0),(342,131,1,'I was disappointed with the ending.',4,0),(344,87,10,'I found the plot to be predictable.',1,1),(347,121,53,'I would definitely recommend this book to others.',4,0),(348,64,12,'I couldn\'t put it down!',4,0),(350,129,14,'but it picked up towards the end.',5,0),(352,121,155,'I was disappointed with the ending.',1,1),(355,108,122,'I couldn\'t put it down!',4,0),(358,114,28,'This book was a page-turner!',3,1),(359,120,83,'I would definitely recommend this book to others.',2,0),(360,122,64,'The writing style was beautiful and poetic.',1,0),(361,177,66,'This book was a page-turner!',2,0),(365,144,95,'I would definitely recommend this book to others.',1,1),(368,199,58,'The characters were so well-developed.',1,1),(369,81,56,'This book wasn\'t really my cup of tea.',5,1),(372,78,171,'It was a bit slow in the beginning',4,0),(373,191,54,'I was disappointed with the ending.',5,0),(378,3,10,'I loved this book!',3,0),(379,39,197,'I would definitely recommend this book to others.',3,1),(380,72,187,'I loved this book!',5,1),(381,38,60,'The writing style was beautiful and poetic.',4,0),(382,123,123,'I found the plot to be predictable.',2,0),(383,154,171,'I was disappointed with the ending.',4,1),(384,198,137,'but it picked up towards the end.',5,1),(385,159,101,'The characters were so well-developed.',1,0),(386,14,163,'This book was a page-turner!',4,1),(387,23,20,'The characters were so well-developed.',1,1),(388,176,182,'but it picked up towards the end.',4,0),(390,51,113,'I found the plot to be predictable.',3,0),(391,189,183,'I would definitely recommend this book to others.',2,0),(392,178,188,'I found the plot to be predictable.',4,1),(393,62,7,'I couldn\'t put it down!',1,0),(396,77,177,'I loved this book!',5,1),(397,96,141,'I was disappointed with the ending.',2,0),(399,5,23,'The writing style was beautiful and poetic.',4,0),(404,48,41,'I loved this book!',3,0),(407,199,164,'I would definitely recommend this book to others.',5,0),(408,113,107,'This book wasn\'t really my cup of tea.',1,0),(409,6,7,'but it picked up towards the end.',1,1),(410,101,177,'I loved this book!',1,0),(411,166,103,'This book was a page-turner!',2,1),(418,50,3,'The writing style was beautiful and poetic.',3,1),(419,84,155,'This book was a page-turner!',3,0),(420,118,44,'but it picked up towards the end.',5,1),(423,80,153,'I loved this book!',3,0),(426,119,97,'I couldn\'t put it down!',1,0),(428,160,52,'The writing style was beautiful and poetic.',5,1),(429,100,171,'I was disappointed with the ending.',1,1),(430,111,25,'I found the plot to be predictable.',2,1),(432,11,96,'I would definitely recommend this book to others.',1,1),(433,62,103,'I loved this book!',5,0),(437,88,134,'This book was a page-turner!',3,0),(440,135,94,'I was disappointed with the ending.',2,1),(441,187,39,'I couldn\'t put it down!',3,0),(442,98,101,'I couldn\'t put it down!',2,0),(444,144,123,'I loved this book!',3,1),(445,149,80,'I was disappointed with the ending.',2,1),(446,67,58,'The characters were so well-developed.',3,1),(447,109,138,'I found the plot to be predictable.',4,1),(448,30,140,'It was a bit slow in the beginning',1,1),(453,6,94,'I loved this book!',1,1),(454,13,197,'I was disappointed with the ending.',1,1),(455,22,16,'The characters were so well-developed.',4,0),(456,148,160,'It was a bit slow in the beginning',2,1),(457,186,59,'This book was a page-turner!',3,1),(459,4,109,'This book wasn\'t really my cup of tea.',2,1),(460,114,12,'I found the plot to be predictable.',3,0),(462,174,116,'The writing style was beautiful and poetic.',2,1),(463,1,25,'I would definitely recommend this book to others.',4,0),(465,104,145,'I was disappointed with the ending.',3,1),(467,29,66,'I loved this book!',5,1),(469,183,141,'I loved this book!',2,0),(470,78,164,'The characters were so well-developed.',5,1),(471,117,39,'The characters were so well-developed.',2,0),(472,9,37,'I was disappointed with the ending.',2,0),(473,129,174,'It was a bit slow in the beginning',3,1),(474,41,52,'It was a bit slow in the beginning',2,0),(475,134,150,'I couldn\'t put it down!',3,1),(478,75,103,'This book was a page-turner!',3,1),(479,25,7,'I couldn\'t put it down!',1,1),(481,115,38,'I would definitely recommend this book to others.',5,0),(482,163,36,'I found the plot to be predictable.',1,0),(483,109,106,'This book was a page-turner!',1,0),(486,110,26,'I couldn\'t put it down!',5,0),(488,111,97,'I couldn\'t put it down!',5,0),(489,45,195,'I would definitely recommend this book to others.',2,0),(490,78,10,'The writing style was beautiful and poetic.',5,1),(491,97,6,'I was disappointed with the ending.',4,1),(492,92,107,'This book was a page-turner!',3,0),(496,46,171,'I was disappointed with the ending.',4,0),(499,9,76,'This book was a page-turner!',2,1),(501,2,188,'vsaf',1,1);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_unit`
--

DROP TABLE IF EXISTS `school_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school_unit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `phone` char(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `principal_name` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_unit`
--

LOCK TABLES `school_unit` WRITE;
/*!40000 ALTER TABLE `school_unit` DISABLE KEYS */;
INSERT INTO `school_unit` VALUES (1,'Maplewood High School','3919 Loeprich Circle','Madaoua','1232131718','schudleigh0@google.com.au','Sayres Chudleigh',1),(2,'Oak Ridge Elementary School','06792 7th Drive','Montaneza','3108028115','azupo1@gizmodo.com','Alick Zupo',0),(3,'Willow Creek Middle School','75 Dunning Place','Touying','1519819352','zfawthorpe2@amazon.co.jp','Zia Fawthorpe',1),(4,'Pine Grove Academy','3 Forster Drive','Murzuq','7583515347','ccurgenuer3@dailymail.co.uk','Clayborn Curgenuer',0),(5,'Riverdale Preparatory School','8 Lindbergh Road','Gaozhuang','4733100346','fzucker4@seesaa.net','Frasco Zucker',0);
/*!40000 ALTER TABLE `school_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `role` enum('admin','manager','member-teacher','member-student') NOT NULL,
  `school_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `name` varchar(50) NOT NULL,
  `birth_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `school_id` (`school_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`school_id`) REFERENCES `school_unit` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'oorzaz77','$u%K-*5-##_','member-teacher',4,1,'Leontyne Kmieciak','1975-06-12'),(2,'rvmlrhcmc53','$i&+*-K$^&','member-teacher',3,1,'Francois Coldham','1995-04-03'),(3,'nfkrwwed58','+-$*','member-teacher',1,1,'Clarette Alvarado','1998-09-14'),(4,'hhbkznvclj17','*','member-student',2,1,'Dollie Pozzo','2000-01-07'),(5,'umsapy04','&^+*$','manager',5,1,'Foster Caso','1988-03-22'),(6,'ypqpaar90','33!&7','member-teacher',1,1,'Hale Towlson','1975-01-17'),(7,'vttlexndx26','!-%-^F-+@^!','member-teacher',4,1,'Anna-maria Ridewood','1997-10-16'),(8,'btdrzz45','$^-7','member-student',2,1,'Carmen Giannazzi','1980-06-17'),(9,'mejrhvt46','efu&$n!##!','member-student',3,1,'Lanny Japp','1979-02-28'),(10,'ydmrms07','&+=-$','member-student',3,1,'Augustus Trevascus','1985-04-02'),(11,'kpxtxqso52','A-_','member-student',2,1,'Wernher Perelli','1995-08-05'),(12,'bphyodtih42','!=^_-TI+_','member-student',2,1,'Andra Pickover','1983-11-28'),(13,'cduhdgxzsb41','+k9$+7#-@','member-teacher',3,1,'Rayshell Cassell','2001-02-12'),(14,'jiszng02','J=^wx','manager',4,1,'Raphaela Mark','1996-09-13'),(15,'hioyui71','_&!','manager',5,1,'Gris Randle','1994-08-12'),(16,'dejxtk09','#','member-student',4,1,'Antin Kilmurry','1991-02-04'),(17,'wxhzvn30','#!-$','member-teacher',4,1,'Chico Chafney','1996-01-27'),(18,'utguu25','=$$%+__','member-student',5,1,'Lorrie Yansons','1976-01-21'),(19,'veecq76','N&10$3','member-teacher',2,1,'Osmond Guierre','1986-05-24'),(20,'ohxdyapshc14','-_-#0b-=^%','member-student',5,1,'Maryjane de Castelain','1988-09-04'),(21,'ltwaskt52','-','member-student',3,1,'Isabelita Mariel','1989-05-13'),(22,'oyrzham45','=%l@','member-student',3,1,'Michele Goodhew','1997-05-30'),(23,'swtjesbwda31','=&&+q!**=@_','member-student',1,1,'Alfie Crummey','1984-11-29'),(24,'ovpwrcc03','_%%%','member-teacher',5,1,'Lacee Windous','1993-10-18'),(25,'nobuwwx72','t=M$-*-*-','manager',3,1,'Mignonne Isson','1986-04-15'),(26,'nasrv82','+%_','member-teacher',4,1,'Krystal Sidnell','1994-06-06'),(27,'juwojzbts65','-!%*&#','manager',2,1,'Gael Hinkensen','1978-11-14'),(28,'tqitisznan83','=$!kh&$i$*n_','member-student',2,1,'Maegan Reolfi','2000-12-30'),(29,'idfdylbzah03','9!@%','manager',2,1,'Clotilda Kelland','1988-10-24'),(30,'lqxswvas62','1i*@f=_-=','member-teacher',4,1,'Sidonia Ivers','1977-08-27'),(31,'uiehgh23','%','member-teacher',5,1,'Chandra O\'Codihie','1978-02-14'),(32,'urhefkdeui09','^%@@!&&^*_','member-student',4,1,'Wayland Murt','1983-01-17'),(33,'xtykqyt44','7u!+9$**!','member-student',2,1,'Hansiain Hopfer','1997-11-16'),(34,'nigpxkbbu89','652-+%*%','member-student',1,1,'Manya Fattori','1986-06-19'),(35,'gqhurji58','6+%-_f=','member-student',3,1,'Dolores Doyle','1987-07-30'),(36,'ucjafu62','m','member-student',4,1,'Dominga See','1983-11-23'),(37,'cckwxsy37','^!K$','member-teacher',1,1,'Susanne Le Marquand','1977-04-18'),(38,'oyltw19','_7+&','manager',4,1,'Jerald Docket','1997-11-28'),(39,'elvrvohxl55','^','manager',2,1,'Wilmer Silvermann','1999-04-30'),(40,'hyzjgpfi29','j@_&0*&@!%%','member-student',4,1,'Alvinia Buncombe','1990-03-29'),(41,'cnzpwfkcai05','*@^&^*-m^!','member-teacher',2,1,'Suzy Caps','1982-06-02'),(42,'ilbuenh77','k@%+@','member-teacher',2,1,'Petronille Brandon','1999-07-15'),(43,'dqdsazubw07','W&!&%$N','member-teacher',1,1,'Bat McCurt','1986-03-12'),(44,'vxmfes05','#%!#*&#@','member-student',5,1,'Biron Jedras','1988-01-14'),(45,'rplrrjyze85','!!+*==A&!+^','member-student',3,1,'Glen Cutajar','1992-10-03'),(46,'hpnubvji39','*%g#^D$','member-student',5,1,'Carolynn De Ferrari','1993-10-04'),(47,'okfpsb54','P&*!!^#@!','member-student',4,1,'Teri Fricke','1976-09-24'),(48,'ssdjogmiei37','-@!_#%%7','member-teacher',3,1,'Janot Normanville','2003-08-04'),(49,'qhdsvmdgcr40','9$$_$$@#','manager',2,1,'Jillene De Cruce','1978-10-07'),(50,'joelhw48','_#-4r&_GH-@','member-student',5,1,'Tania Priest','1977-10-13'),(51,'gcvpcyfer09','u!#&5!G','member-teacher',4,1,'Charmane Rama','1978-12-18'),(52,'mvfzxwlurj75','#_%t=#+Z^','member-student',2,1,'Doralia Wagon','2005-11-25'),(53,'cnocwlx93','#','member-teacher',3,1,'Konrad Blondel','1977-02-28'),(54,'arlocym07','^','member-student',5,1,'Sula Phillcox','1997-01-30'),(55,'ctprxoje48','!=_@','member-student',1,1,'Florette Atwel','1977-10-25'),(56,'mjznwmrt86','f_=n','member-student',3,1,'Elmer Kiggel','2002-01-03'),(57,'xkuvh49','@$%_','member-student',1,1,'Janos Cloutt','2004-08-05'),(58,'bykvy15','_=d&-^I!','member-student',4,1,'Bondy Fryman','2004-06-13'),(59,'amdxm32','@_','member-student',1,1,'Salomo Lammenga','1979-01-01'),(60,'uldzwlgo65','*-!&!@=!q','member-student',2,1,'Moise Kalvin','1999-05-22'),(61,'ncxhwbjk13','=','member-teacher',4,1,'Fan Markey','1990-10-23'),(62,'diqmge01','+#!##','manager',5,1,'Margret Hallan','1989-09-06'),(63,'kzwuyetz18','#%$#_E','member-student',5,1,'Carline Boldison','1987-01-18'),(64,'llxlb90','#','member-student',2,1,'Alethea Grombridge','1983-01-22'),(65,'hslwi74','#%#-','member-teacher',4,1,'Christabella Brotheridge','1996-08-13'),(66,'asjakpaudk11','=_&!%&q#-!','member-student',1,1,'Faustine Stansfield','1982-07-27'),(67,'hbmcqbfrzr27','Yt=$_@+%=-^@','member-teacher',4,1,'Paulette Deer','1999-02-04'),(68,'rysnp77','==&^@$f&-@','member-teacher',1,1,'Sherrie Barstow','2001-08-11'),(69,'wrdroa25','@=3z!','member-student',3,1,'Dorolisa Hugonet','1975-07-07'),(70,'npjlxc21','-!','member-teacher',4,1,'Job Giannoni','1975-02-22'),(71,'fiuim86','#0$j%$*#@=-','member-student',4,1,'Helyn Mattimoe','1996-05-11'),(72,'djzkspnm39','&=#@x+*','member-teacher',2,1,'Chicky Dymoke','2005-11-08'),(73,'purji16','#YF_$#-_A','manager',1,1,'Chariot Todarello','1996-05-04'),(74,'emfycde07','*#W+#+-%%-_','member-teacher',1,0,'Mohandas Everett','1998-07-03'),(75,'fehyknas19','!$0','manager',1,1,'Donaugh Dealy','1982-05-22'),(76,'prafgttoz70','#%#_^!9#2%@','member-student',2,1,'Tomasina Birtchnell','1996-10-27'),(77,'shgphlfsqu36','%-^^-=%&=_%','manager',2,1,'Merci Flanagan','1976-05-24'),(78,'tuljrclbom09','=u*-=+0','member-teacher',4,1,'Alleyn Olivo','1975-02-23'),(79,'fsjdvban29','!=6q@','member-teacher',2,1,'Niko Burdell','1978-12-05'),(80,'vkzpeocxn17','_*#E=3w!=@*$','member-teacher',2,1,'Cate Dudny','1985-09-20'),(81,'slpodjfau39','8%#q','member-teacher',1,0,'Pattin Austins','1998-07-01'),(82,'fegtzzmlws10','5h=%','member-teacher',1,1,'Saxe Edger','1981-01-29'),(83,'bzbvpvv04','-@%_!#%','member-student',4,1,'Rodie Alwood','1975-06-27'),(84,'xaclyfwrsi95','+r@@','member-teacher',5,1,'Lanna Duckels','1987-10-18'),(85,'gipbpcy99','=!E#+#$@!R','member-teacher',1,1,'Mariellen Beardwell','1988-01-30'),(86,'hhbytprg47','n+#@%!^@g_^','member-teacher',5,1,'Neda Grinyov','1989-09-10'),(87,'rcmuyke97','=*+&&','member-teacher',4,1,'Nevile Medley','1989-08-07'),(88,'nxkvqkbymp64','-%','manager',1,1,'Clo Lydall','1975-09-18'),(89,'uehuo23','@','member-student',4,1,'Petronille Jewar','1975-02-17'),(90,'qubvnwdq76','Y-+=8&!i%&','member-student',4,1,'Zorine Ortiger','1997-07-31'),(91,'hpuhls64','&&^sT%=','member-teacher',5,1,'Angelle Troker','1994-03-17'),(92,'jifbzs28','v+a9-','member-teacher',4,1,'Berny Ubee','1975-03-03'),(93,'nxebxwkxl43','e%_!@','manager',2,1,'Clarita Canwell','1988-01-06'),(94,'qvwwzlu58','=*^@O-W!','manager',1,1,'Niven McWaters','1989-01-27'),(95,'hopuakc51','#y!$!!@*b=','member-student',3,1,'Petrina Josh','1999-06-03'),(96,'dpqrpjly28','!E!1u^-&l3^!','member-student',4,1,'Cloris Males','1983-02-27'),(97,'rgfhew84','T*','member-teacher',3,1,'Lurette Lightbody','1977-04-20'),(98,'peikui46','^_*$gS!$-%','manager',1,1,'Flossy McCadden','1981-02-22'),(99,'rsprmnuc10','&#@7S@@','manager',1,1,'Valentina Schwander','1995-06-24'),(100,'ohjtf80','#_-##$0','manager',4,1,'Devin Lowndes','1991-12-11'),(101,'kfrvimuc28','+b0o%-','member-teacher',4,1,'Valentin Swadlinge','1990-08-06'),(102,'qtluehyid13','+#*_','member-teacher',4,1,'Izak Gundrey','1984-04-27'),(103,'yleqdvllw92','+','member-student',1,1,'Hammad Anlay','2005-11-30'),(104,'wmvscui23','*L!1g','member-teacher',4,1,'Nance Perotti','1986-08-15'),(105,'unlpreflxl40','*_t_Z+@_0^&','member-teacher',4,1,'Larina Handrik','1997-06-05'),(106,'jnzalxfuli38','-@S!___!=X^+','member-teacher',1,1,'Carmon Mockes','2001-08-17'),(107,'flrlbozi39','$2m&_$$^2*_','member-teacher',4,1,'Chrissy Liversage','2002-11-27'),(108,'zntqzkuomo88','QfYM&=&=%-','member-student',4,1,'Abigael Severy','1991-11-27'),(109,'vvutyzoz72','&!+','member-teacher',5,1,'Marni Kidby','1978-08-19'),(110,'aelzc30','-d&+*_','member-teacher',1,0,'Hoyt Notton','2004-02-24'),(111,'ifyzz57','+','member-teacher',2,1,'Brittany Zamora','1995-10-07'),(112,'upftnyhuef12','_+$$q@3^','member-student',1,1,'Gray Nias','2003-01-10'),(113,'mdfqfiuwm69','O!','member-teacher',4,1,'Marlow Coite','1990-04-29'),(114,'ugslhzv37','^&-&-_=1','member-student',4,1,'Darlene Chicotti','1992-08-02'),(115,'odcxl57','-#%_!!*v-','member-student',4,1,'Cosette Iacovo','1977-05-11'),(116,'bigam18','^=@+','member-student',4,1,'Stoddard Clapshaw','1993-05-19'),(117,'ceqsbdghn76','*','member-student',1,0,'Silva Bengough','1998-01-26'),(118,'xvfwkwbpx48','-','member-student',2,1,'Sonny Kneel','1993-11-03'),(119,'oouxr69','i#rg$^@!^@1^','member-teacher',3,1,'Marsha Voelker','2001-05-30'),(120,'rotsjb20','#%++','member-teacher',5,1,'Maurits Quirk','1998-11-15'),(121,'ygpdauj64','^&@=@&%8!#--','manager',1,1,'Kyle Tyas','1991-08-24'),(122,'jylpoo44','+=^&+=#*','member-teacher',2,1,'Sephira Elington','1992-04-13'),(123,'laqxkl45','y$=06-','member-student',5,1,'Celinka Rodden','1991-01-23'),(124,'rlorozux84','@p+=iV','member-student',4,1,'Caleb Pippin','1997-05-26'),(125,'povywlk45','l-!*$#X4_!$^','manager',2,1,'Ignazio Halstead','1998-11-30'),(126,'oebonhtlv30','O*!@=$NMQ-+','member-teacher',2,1,'Elwyn Pinnere','2001-08-21'),(127,'zcaqux41','=#_^&','manager',1,1,'Ninon Skeldon','2004-11-01'),(128,'mdlsxbe28','x%$-%+*+!!=','member-student',1,1,'Dorena Dulwitch','1981-09-27'),(129,'mmlsc62','^_#_!&^+7+','manager',5,1,'Crystie Pallaske','1995-01-04'),(130,'uxvpgkh96','$_#@#k','member-student',1,1,'Lesya Dericot','2005-07-29'),(131,'rspljpmtk41','!*H$8!','member-teacher',1,0,'Mohandas Dobbyn','1998-02-27'),(132,'kqrlxw98','@@','member-teacher',3,1,'Leia Battrick','1989-12-24'),(133,'icgzdpipw99','!44_','member-teacher',1,1,'Yorgos Mark','1976-08-16'),(134,'ttyzrgkdry29','*&','member-teacher',3,1,'Colleen Corbet','1990-01-07'),(135,'zrkhhynd49','f','member-student',1,1,'Conway Minget','1979-05-21'),(136,'wcyeckucpd37','+!$%x#--=','member-student',3,1,'Teddy Whittenbury','1990-05-02'),(137,'mowkf64','=#&+','member-student',1,1,'Corabel Ravelus','1999-04-28'),(138,'pxzkpkk27','&@#','member-student',1,0,'Husein Klaus','1976-11-20'),(139,'bgjbbv32','+&9!^8!^h','member-student',1,1,'Carlota Heinecke','2003-06-27'),(140,'msfvnedl27','p*3','member-teacher',5,1,'Eartha Bemment','1980-08-06'),(141,'mxgadorraw59','@2!*@$4$','member-student',3,1,'Estrellita Baddoe','1990-08-30'),(142,'fdequb98','+^+_i+','member-student',1,1,'Steve Barrick','1998-01-19'),(143,'bmopcxzyn06','^%%^&+92','member-student',5,1,'Nikolos Surtees','1988-08-27'),(144,'ronnnhys19','zE','member-student',4,1,'Dede Collinwood','1990-12-22'),(145,'jsqvolevq72','#H&@*#r%#3','member-student',4,1,'Crosby Stangoe','1996-05-17'),(146,'njqumcyjd23','!','member-student',5,1,'Virge Sabater','1978-09-22'),(147,'bbdlbqgh97','-*-@*x-**_','member-student',4,1,'Lenore Gardiner','1994-02-03'),(148,'rofmzq27','%&','member-student',5,1,'Kerri Tarn','1994-08-17'),(149,'jebyewwai54','9!+%O-&$','manager',4,1,'Angelique Giacopetti','1987-08-14'),(150,'dkzub44','%%&=kH-H=j','member-student',3,1,'Deena Blanchard','1986-07-18'),(151,'dplikpiyrq98','2*^Z*J!%&*#','member-student',5,1,'Georgina Vlasenko','1985-04-22'),(152,'xlanb90','x@=^9l-3+','member-student',4,1,'Cissy Herrieven','1998-08-29'),(153,'gkuqzqcrfa64','6_0=','member-teacher',5,1,'Valerye Sparham','1991-01-30'),(154,'saurtx11','@L','member-student',2,1,'Elna Ablitt','1984-10-21'),(155,'ajnuxf71','@j&=','member-student',3,1,'Skippy Tuffey','1996-07-24'),(156,'cdjdzo03','$','member-teacher',3,1,'Sylvia Genney','1983-05-16'),(157,'zxtei65','!K','member-teacher',4,1,'Reamonn Lorkins','1986-08-23'),(158,'kdpjlosz32','X','manager',3,1,'Margaret Valett','1997-08-14'),(159,'toxaxwfsgi12','+^@^=U6%','member-student',2,1,'Rita Brunn','2004-05-04'),(160,'civhvni30','^&^_%*','member-student',3,1,'Jess Jeenes','1982-03-06'),(161,'uqxnviy29','_-!_^-^Y%7#$','manager',5,1,'Welsh Moggach','1995-11-23'),(162,'gmknebop37','=Q&&O','manager',1,1,'Nedda Silverston','1978-06-24'),(163,'luacrmm50','$#!^%-!+#','manager',1,1,'Andree Craythorne','2003-02-09'),(164,'eokxan21','_@-@','member-student',3,1,'Caressa Bennet','1983-06-28'),(165,'lioctag17','^g+7__$!&*+%','member-student',5,1,'Clarke Jenks','1978-06-03'),(166,'oboqv98','@==$&','manager',2,1,'Rickie Druce','1982-12-26'),(167,'qriwwe01','$&##2^v^o=&B','member-teacher',5,1,'Elinor Jekel','1989-12-20'),(168,'snshc50','yKrd','member-teacher',1,1,'Domingo LaBastida','1989-09-18'),(169,'hhyxjjwpen30','%t_+!_','member-student',4,1,'Pincus Collimore','2001-08-22'),(170,'ekbdh88','+@=*=*!$-','member-student',3,1,'Phoebe Arney','1979-08-19'),(171,'wolsxp10','=%Z2!%#^@','member-student',2,1,'Shauna Bottell','1993-08-18'),(172,'rzpfqxq04','#!=2aq%s@7-&','member-student',3,1,'Galvin McDougall','1992-03-04'),(173,'huybjlvkmc90','=!*Jg*4#-xq','member-student',4,1,'Chev Borer','1984-11-15'),(174,'valcbvnec79','$##+^','member-teacher',3,1,'Leslie Huddles','1981-10-23'),(175,'mzdnlduqdy63','&+#s=#_=&_#-','member-teacher',3,1,'Alexander Gunter','2004-02-21'),(176,'cfkzasqa99','+$*','manager',2,1,'Rogers Balm','1993-11-11'),(177,'qynjpasct44','_@$$','manager',1,1,'Peyton Hasson','2002-02-19'),(178,'jfpcuvm04','^-b=Q=!=__I&','member-student',3,1,'Hilary Dreschler','1981-10-19'),(179,'lqirpfvsk69','=+','member-teacher',2,1,'Cordy Charpin','1995-12-03'),(180,'fctwy19','+!#E=_@$-','member-teacher',3,1,'Ludvig MacElroy','1989-06-08'),(181,'uhwyjf74','___#%','member-student',1,0,'Giustina Stonhewer','1984-08-30'),(182,'brubkyhfi28','^&=_&+$','manager',4,1,'Annaliese Luis','1996-10-24'),(183,'plrrhe51','3$=%&^%%-*b','member-teacher',1,1,'Huntlee Spuner','1988-01-27'),(184,'gwoeqvrxuv06','4%','member-teacher',2,1,'Florencia Faber','1997-12-28'),(185,'vtaswmjzzk59','T%','member-student',4,1,'Osmond Brimilcombe','2000-09-03'),(186,'pweuezgdl88','_J$','member-teacher',4,1,'Sophronia Marshman','1977-10-22'),(187,'ivkqwm68','_&@d%&__&^-','member-student',4,1,'Derek Goodier','1986-04-04'),(188,'kamhitpgf75','z+q&&&!','manager',3,1,'Ricca Laycock','1991-11-11'),(189,'ruuryi91','*v+o@%%i-','manager',1,1,'Huntley Han','1995-01-07'),(190,'oyxtytvulr85','nl','member-teacher',1,1,'Payton McKeighen','2003-06-24'),(191,'dpiao57','&r%=o+#+@+@','member-teacher',4,1,'Devora Dodge','1984-06-10'),(192,'nayayjtp83','$','member-teacher',3,1,'Berkeley Trumble','1977-04-15'),(193,'lxgetjaxdd22','-^^@_$$%#-','member-teacher',1,1,'Merrile Heugh','1983-02-25'),(194,'uokvwxtg93','=K@_#-&*','member-teacher',4,1,'Hillary Edmand','2003-08-13'),(195,'wnzmuoqz93','&#$!p','manager',5,1,'Tatiania Lumbers','1997-03-31'),(196,'yqphc71','@','member-student',1,1,'Marylin Skaid','1992-06-25'),(197,'xxibe43','!+%^!E%','member-student',2,1,'Jennine Winborn','2001-11-03'),(198,'ypwpm59','^^!^6$_@*','manager',5,1,'Llewellyn Bartolomucci','1991-03-16'),(199,'imjchgp64','=$*!=%=2!','member-teacher',1,1,'Reinald Escale','1979-11-29'),(200,'sbfndzkxgn48','!f_@5','member-teacher',4,1,'Yancy Synder','1975-12-18'),(201,'admin','admin','admin',NULL,1,'Admin','2000-01-01'),(202,'manager1','manager1','manager',1,1,'Manager 1','1970-01-01'),(203,'member-teacher1','member-teacher1','member-teacher',1,1,'Teacher 1','1983-01-01'),(204,'member-student1','member-student1','member-student',1,1,'Student 1','2006-01-01');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-03 20:07:05
