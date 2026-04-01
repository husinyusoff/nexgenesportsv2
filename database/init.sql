-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2026 at 08:09 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trial_nexgenesports`
--

-- --------------------------------------------------------

--
-- Table structure for table `archivedteam`
--

CREATE TABLE `archivedteam` (
  `teamID` int(11) NOT NULL,
  `teamName` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `logoURL` varchar(255) DEFAULT NULL,
  `createdBy` varchar(50) NOT NULL,
  `createdAt` datetime NOT NULL,
  `disbandedAt` datetime DEFAULT NULL,
  `status` enum('Active','Disbanded') NOT NULL,
  `archivedAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `archived_teammember`
--

CREATE TABLE `archived_teammember` (
  `teamID` int(11) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `status` enum('Pending','Active','Declined') NOT NULL,
  `teamRole` enum('Leader','Co-Leader','Member') NOT NULL,
  `joinedAt` datetime NOT NULL,
  `roleAssignedAt` datetime NOT NULL,
  `leftAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archived_teammember`
--

INSERT INTO `archived_teammember` (`teamID`, `userID`, `status`, `teamRole`, `joinedAt`, `roleAssignedAt`, `leftAt`) VALUES
(2, 'amirul_rahman', 'Active', 'Co-Leader', '2025-06-25 22:24:09', '2025-07-01 08:19:37', '2025-07-01 16:19:48'),
(4, 'mohd_faizal', 'Active', 'Leader', '2025-06-26 09:29:05', '2025-06-26 16:09:06', '2025-06-27 02:24:01');

-- --------------------------------------------------------

--
-- Table structure for table `auditlog`
--

CREATE TABLE `auditlog` (
  `logID` bigint(20) NOT NULL,
  `entityType` varchar(50) NOT NULL,
  `entityID` varchar(50) NOT NULL,
  `actionType` varchar(50) NOT NULL,
  `performedBy` varchar(50) NOT NULL,
  `ts` datetime NOT NULL DEFAULT current_timestamp(),
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auditlog`
--

INSERT INTO `auditlog` (`logID`, `entityType`, `entityID`, `actionType`, `performedBy`, `ts`, `details`) VALUES
(1, 'Team', '1', 'Created', 'husinyusoff', '2025-06-24 17:08:52', '{\"teamName\":\"funtart\"}'),
(2, 'TeamMember', '1:user02', 'RoleChanged', 'husinyusoff', '2025-06-25 18:06:25', '{\"newRole\":\"Co-Leader\"}'),
(3, 'TeamMember', '1:user02', 'RoleChanged', 'husinyusoff', '2025-06-25 18:06:58', '{\"newRole\":\"Member\"}'),
(4, 'TeamMember', '1:user02', 'Removed', 'husinyusoff', '2025-06-25 18:06:59', NULL),
(5, 'TeamMember', '1:user03', 'RoleChanged', 'husinyusoff', '2025-06-25 19:26:33', '{\"newRole\":\"Co-Leader\"}'),
(6, 'TeamMember', '1:user03', 'RoleChanged', 'husinyusoff', '2025-06-25 19:27:04', '{\"newRole\":\"Member\"}'),
(7, 'TeamMember', '1:husinyusoff', 'RoleChanged', 'husinyusoff', '2025-06-25 19:46:26', '{\"newRole\":\"Member\"}'),
(8, 'TeamMember', '1:user03', 'RoleChanged', 'husinyusoff', '2025-06-25 21:01:40', '{\"newRole\":\"Leader\"}'),
(9, 'TeamMember', '1:husinyusoff', 'LeftTeam', 'husinyusoff', '2025-06-25 21:46:17', NULL),
(10, 'Team', '5', 'Created', 'husinyusoff', '2025-06-26 01:27:02', '{\"teamName\":\"EsportsUMT Pro\",\"capacity\":10}'),
(11, 'TeamMember', '4:user4', 'RoleChanged', 'husinyusoff', '2025-06-26 01:54:51', '{\"newRole\":\"Co-Leader\"}'),
(12, 'TeamMember', '1:husinyusoff', 'LeftTeam', 'husinyusoff', '2025-06-26 16:05:25', NULL),
(13, 'TeamMember', '4:user4', 'RoleChanged', 'husinyusoff', '2025-06-26 16:09:06', '{\"newRole\":\"Leader\"}'),
(14, 'TeamMember', '5:user1', 'RoleChanged', 'husinyusoff', '2025-06-26 18:00:02', '{\"newRole\":\"Leader\"}'),
(15, 'TeamMember', '5:husinyusoff', 'LeftTeam', 'husinyusoff', '2025-06-26 18:00:02', NULL),
(16, 'TeamMember', '6:user07', 'RoleChanged', 'farid_zahazan', '2025-06-26 18:12:45', '{\"newRole\":\"Co-Leader\"}'),
(17, 'TeamMember', '6:user07', 'RoleChanged', 'farid_zahazan', '2025-06-26 18:13:06', '{\"newRole\":\"Leader\"}'),
(18, 'TeamMember', '6:user06', 'LeftTeam', 'farid_zahazan', '2025-06-26 18:13:06', NULL),
(19, 'TeamMember', '4:husinyusoff', 'RoleChanged', 'mohd_faizal', '2025-06-26 18:24:01', '{\"newRole\":\"Leader\"}'),
(20, 'TeamMember', '4:user04', 'LeftTeam', 'mohd_faizal', '2025-06-26 18:24:01', NULL),
(21, 'JoinRequest', '1', 'Submitted', 'husinyusoff', '2025-06-27 04:05:10', NULL),
(22, 'JoinRequest', '2', 'Submitted', 'husinyusoff', '2025-06-27 04:14:23', NULL),
(23, 'JoinRequest', '3', 'Submitted', 'husinyusoff', '2025-06-27 04:15:22', NULL),
(24, 'JoinRequest', '4', 'Submitted', 'husinyusoff', '2025-06-27 04:15:29', NULL),
(25, 'JoinRequest', '5', 'Submitted', 'husinyusoff', '2025-06-27 04:15:34', NULL),
(26, 'JoinRequest', '4', 'Accepted', 'amirul_rahman', '2025-06-27 09:26:26', NULL),
(27, 'JoinRequest', '2', 'Accepted', 'amirul_rahman', '2025-06-27 09:29:31', NULL),
(28, 'JoinRequest', '3', 'Accepted', 'nur_fatihah', '2025-06-27 09:36:02', NULL),
(29, 'TeamMember', '6:husinyusoff', 'Removed', 'nur_fatihah', '2025-06-27 09:37:58', NULL),
(30, 'JoinRequest', '3', 'Accepted', 'nur_fatihah', '2025-06-27 09:38:04', NULL),
(31, 'JoinRequest', '6', 'Submitted', 'husinyusoff', '2025-06-27 10:16:19', NULL),
(32, 'JoinRequest', '7', 'Submitted', 'husinyusoff', '2025-06-27 10:16:48', NULL),
(33, 'JoinRequest', '8', 'Submitted', 'husinyusoff', '2025-06-27 10:16:56', NULL),
(34, 'JoinRequest', '9', 'Submitted', 'husinyusoff', '2025-06-27 10:17:02', NULL),
(35, 'JoinRequest', '8', 'Rejected', 'amirul_rahman', '2025-06-27 10:23:22', NULL),
(36, 'JoinRequest', '6', 'Rejected', 'amirul_rahman', '2025-06-27 10:23:24', NULL),
(37, 'JoinRequest', '10', 'Submitted', 'nurul_huda', '2025-06-30 06:45:00', NULL),
(38, 'JoinRequest', '10', 'Accepted', 'amirul_rahman', '2025-06-30 06:45:11', NULL),
(39, 'JoinRequest', '11', 'Submitted', 'siti_aminah', '2025-06-30 06:48:57', NULL),
(40, 'JoinRequest', '11', 'Accepted', 'amirul_rahman', '2025-06-30 06:49:10', NULL),
(41, 'JoinRequest', '12', 'Submitted', 'farid_zahazan', '2025-06-30 06:49:34', NULL),
(42, 'JoinRequest', '12', 'Accepted', 'amirul_rahman', '2025-06-30 06:49:44', NULL),
(43, 'TeamMember', '2:farid_zahazan', 'RoleChanged', 'amirul_rahman', '2025-07-01 08:19:37', '{\"newRole\":\"Leader\"}'),
(44, 'TeamMember', '2:amirul_rahman', 'LeftTeam', 'amirul_rahman', '2025-07-01 08:19:48', NULL),
(45, 'Team', '9', 'Created', 'amirul_rahman', '2025-07-01 08:21:39', '{\"teamName\":\"esport\",\"capacity\":4}');

-- --------------------------------------------------------

--
-- Table structure for table `bracket`
--

CREATE TABLE `bracket` (
  `bracket_id` int(11) NOT NULL,
  `prog_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `format` enum('SINGLE_ELIM','DOUBLE_ELIM','ROUND_ROBIN','LEADERBOARD') NOT NULL DEFAULT 'SINGLE_ELIM',
  `created_by` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bracket_match`
--

CREATE TABLE `bracket_match` (
  `match_id` int(11) NOT NULL,
  `bracket_id` int(11) NOT NULL,
  `participant1_id` bigint(20) NOT NULL,
  `participant2_id` bigint(20) NOT NULL,
  `score1` int(11) DEFAULT NULL,
  `score2` int(11) DEFAULT NULL,
  `winner_id` bigint(20) DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bracket_referee`
--

CREATE TABLE `bracket_referee` (
  `id` int(11) NOT NULL,
  `bracket_id` int(11) NOT NULL,
  `referee_id` varchar(50) DEFAULT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `business_config`
--

CREATE TABLE `business_config` (
  `config_key` varchar(50) NOT NULL,
  `config_value` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_config`
--

INSERT INTO `business_config` (`config_key`, `config_value`, `description`) VALUES
('closing_hour', 23, 'Absolute closing hour'),
('happy_end_hour', 19, 'Absolute hour when HappyHour ends'),
('happy_start_offset', 0, 'Offset from opening when HappyHour begins'),
('team.join.limit', 4, 'Maximum number of teams a user may join'),
('weekday_open', 14, 'Weekday opening hour (0–23)'),
('weekend_open', 15, 'Fri/Sat opening hour');

-- --------------------------------------------------------

--
-- Table structure for table `challonge_participant`
--

CREATE TABLE `challonge_participant` (
  `id` bigint(20) NOT NULL,
  `tp_id` bigint(20) NOT NULL,
  `tournament` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `challonge_tournament`
--

CREATE TABLE `challonge_tournament` (
  `prog_id` int(11) NOT NULL,
  `challonge_id` varchar(100) DEFAULT NULL,
  `challonge_url` varchar(255) DEFAULT NULL,
  `state` enum('pending','underway','complete','cancelled') NOT NULL DEFAULT 'pending',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT NULL,
  `last_sync_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `club_benefits`
--

CREATE TABLE `club_benefits` (
  `id` int(11) NOT NULL,
  `sessionId` varchar(50) NOT NULL,
  `benefitOrder` int(11) NOT NULL,
  `benefitText` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `club_benefits`
--

INSERT INTO `club_benefits` (`id`, `sessionId`, `benefitOrder`, `benefitText`) VALUES
(1, 'ESUMT_24/25', 1, 'Receive 5% discount on all online purchases.'),
(2, 'ESUMT_24/25', 2, 'Eligible to nominate for the Esports Club Executive Council.'),
(3, 'ESUMT_24/25', 3, 'Eligible to vote in Supreme Council nominations.'),
(4, 'ESUMT_24/25', 4, 'Member of the Game Community.'),
(5, 'ESUMT_24/25', 5, 'Represent UMT Esports Club in external tournaments.'),
(6, 'ESUMT_24/25', 6, 'Access to training platforms and scrimmages.'),
(7, 'ESUMT_24/25', 7, 'Member pricing for all major UMT Esports events.'),
(8, 'ESUMT_24/25', 8, 'Opportunity to serve on Esports Club committees.'),
(9, 'ESUMT_24/25', 9, 'Privileged access to the Esports Gaming Room.');

-- --------------------------------------------------------

--
-- Table structure for table `game`
--

CREATE TABLE `game` (
  `gameID` int(11) NOT NULL,
  `gameName` varchar(100) NOT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `game`
--

INSERT INTO `game` (`gameID`, `gameName`, `genre`, `created_at`, `updated_at`, `deleted_flag`) VALUES
(3, 'PUBG', 'BATTLE ROYALE', '2025-06-28 11:15:54', '2025-06-28 11:15:54', 0),
(4, 'MOBILE LEGENDS BANG BANG', 'multiplayer online battle arena (MOBA)', '2025-06-29 08:42:20', '2025-06-29 08:42:20', 0);

-- --------------------------------------------------------

--
-- Table structure for table `gamingstation`
--

CREATE TABLE `gamingstation` (
  `stationID` varchar(50) NOT NULL,
  `stationName` varchar(100) NOT NULL,
  `normalPrice1Player` decimal(10,2) NOT NULL,
  `normalPrice2Player` decimal(10,2) DEFAULT NULL,
  `happyHourPrice1Player` decimal(10,2) NOT NULL,
  `happyHourPrice2Player` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gamingstation`
--

INSERT INTO `gamingstation` (`stationID`, `stationName`, `normalPrice1Player`, `normalPrice2Player`, `happyHourPrice1Player`, `happyHourPrice2Player`) VALUES
('PS4', 'PlayStation 4', 4.00, 6.00, 3.00, 5.00),
('PS5A', 'PlayStation 5 A', 6.00, 10.00, 5.00, 8.00),
('PS5B', 'PlayStation 5 B', 6.00, 10.00, 5.00, 8.00),
('RSM', 'Racing Simulator', 13.00, NULL, 11.00, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gamingstationbooking`
--

CREATE TABLE `gamingstationbooking` (
  `bookingID` int(11) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `stationID` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `startTime` time NOT NULL,
  `endTime` time NOT NULL,
  `status` enum('Confirmed','Cancelled','Completed','No-Show','Blocked') NOT NULL DEFAULT 'Confirmed',
  `priceType` enum('Normal','HappyHour') NOT NULL DEFAULT 'Normal',
  `playerCount` tinyint(4) NOT NULL DEFAULT 1,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `paymentStatus` enum('PENDING','PAID','FAILED') NOT NULL DEFAULT 'PENDING',
  `paymentReference` int(11) DEFAULT NULL,
  `hourCount` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gamingstationbooking`
--

INSERT INTO `gamingstationbooking` (`bookingID`, `userID`, `stationID`, `date`, `startTime`, `endTime`, `status`, `priceType`, `playerCount`, `price`, `paymentStatus`, `paymentReference`, `hourCount`) VALUES
(1, 'husinyusoff', 'PS5B', '2025-06-13', '15:00:00', '17:59:00', 'Confirmed', 'HappyHour', 1, 15.00, 'PAID', NULL, 3),
(2, 'husinyusoff', 'PS5A', '2025-06-21', '15:00:00', '17:59:00', 'Confirmed', 'HappyHour', 1, 15.00, 'PAID', NULL, 3),
(3, 'husinyusoff', 'RSM', '2025-06-12', '14:00:00', '17:59:00', 'Confirmed', 'HappyHour', 1, 44.00, 'PAID', NULL, 4),
(4, 'husinyusoff', 'RSM', '2025-06-06', '15:00:00', '17:59:00', 'Confirmed', 'HappyHour', 1, 33.00, 'PAID', NULL, 3),
(5, 'husinyusoff', 'PS5A', '2025-06-06', '15:00:00', '16:59:00', 'Confirmed', 'HappyHour', 1, 10.00, 'PAID', NULL, 2),
(6, 'husinyusoff', 'RSM', '2025-06-14', '15:00:00', '17:59:00', 'Confirmed', 'HappyHour', 1, 33.00, 'PAID', NULL, 3),
(16, 'husinyusoff', 'RSM', '2025-06-25', '14:00:00', '15:59:00', 'Confirmed', 'HappyHour', 1, 22.00, 'PENDING', NULL, 2),
(17, 'husinyusoff', 'PS5A', '2025-06-26', '14:00:00', '15:59:00', 'Confirmed', 'HappyHour', 2, 16.00, 'PENDING', NULL, 2),
(18, 'husinyusoff', 'PS5B', '2025-06-26', '14:00:00', '16:59:00', 'Confirmed', 'HappyHour', 1, 15.00, 'PENDING', NULL, 3),
(19, 'amirul_rahman', 'RSM', '2025-07-02', '15:00:00', '16:59:00', 'Confirmed', 'HappyHour', 1, 22.00, 'PENDING', NULL, 2),
(20, 'alif_muhammad', 'PS5B', '2025-07-04', '15:00:00', '17:59:00', 'Confirmed', 'HappyHour', 2, 24.00, 'PENDING', NULL, 3);

--
-- Triggers `gamingstationbooking`
--
DELIMITER $$
CREATE TRIGGER `trg_before_insert_booking` BEFORE INSERT ON `gamingstationbooking` FOR EACH ROW BEGIN
  DECLARE lookupPrice DECIMAL(10,2);

  IF NEW.priceType='Normal' AND NEW.playerCount=1 THEN
    SELECT normalPrice1Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSEIF NEW.priceType='Normal' AND NEW.playerCount=2 THEN
    SELECT normalPrice2Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSEIF NEW.priceType='HappyHour' AND NEW.playerCount=1 THEN
    SELECT happyHourPrice1Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSEIF NEW.priceType='HappyHour' AND NEW.playerCount=2 THEN
    SELECT happyHourPrice2Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSE
    SET lookupPrice = 0.00;
  END IF;

  SET NEW.price = IFNULL(lookupPrice * NEW.hourCount, 0.00);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_before_update_booking` BEFORE UPDATE ON `gamingstationbooking` FOR EACH ROW BEGIN
  DECLARE lookupPrice DECIMAL(10,2);

  IF NEW.priceType='Normal' AND NEW.playerCount=1 THEN
    SELECT normalPrice1Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSEIF NEW.priceType='Normal' AND NEW.playerCount=2 THEN
    SELECT normalPrice2Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSEIF NEW.priceType='HappyHour' AND NEW.playerCount=1 THEN
    SELECT happyHourPrice1Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSEIF NEW.priceType='HappyHour' AND NEW.playerCount=2 THEN
    SELECT happyHourPrice2Player INTO lookupPrice
      FROM GamingStation
     WHERE stationID=NEW.stationID;
  ELSE
    SET lookupPrice = 0.00;
  END IF;

  SET NEW.price = IFNULL(lookupPrice * NEW.hourCount, 0.00);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `join_request`
--

CREATE TABLE `join_request` (
  `requestID` int(11) NOT NULL,
  `teamID` int(11) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `requestedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('Pending','Accepted','Rejected') NOT NULL DEFAULT 'Pending',
  `respondedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `join_request`
--

INSERT INTO `join_request` (`requestID`, `teamID`, `userID`, `requestedAt`, `status`, `respondedAt`) VALUES
(6, 5, 'husinyusoff', '2025-06-27 10:16:19', 'Rejected', '2025-06-27 10:23:24'),
(7, 6, 'husinyusoff', '2025-06-27 10:16:48', 'Pending', NULL),
(8, 2, 'husinyusoff', '2025-06-27 10:16:56', 'Rejected', '2025-06-27 10:23:22'),
(9, 1, 'husinyusoff', '2025-06-27 10:17:02', 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `membershipsessions`
--

CREATE TABLE `membershipsessions` (
  `sessionId` varchar(50) NOT NULL,
  `sessionName` varchar(100) NOT NULL,
  `startMembershipDate` date NOT NULL,
  `endMembershipDate` date NOT NULL,
  `fee` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `capacity_limit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `membershipsessions`
--

INSERT INTO `membershipsessions` (`sessionId`, `sessionName`, `startMembershipDate`, `endMembershipDate`, `fee`, `is_active`, `capacity_limit`) VALUES
('ESUMT_24/25', 'Esports Club Member 24/25', '2024-08-01', '2025-07-31', 10.00, 1, NULL),
('ESUMT_25/26', 'Esports Club Member 25/26', '2025-08-01', '2026-07-31', 10.00, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `merit_level`
--

CREATE TABLE `merit_level` (
  `merit_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category` enum('Program','Tournament') NOT NULL,
  `scope` enum('Club','University','State','National','International') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `merit_level`
--

INSERT INTO `merit_level` (`merit_id`, `name`, `description`, `category`, `scope`) VALUES
(28, 'Club Program Participant', 'Participant in club-level program', 'Program', 'Club'),
(29, 'University Program Participant', 'Participant in university-level program', 'Program', 'University'),
(30, 'State Program Participant', 'Participant in state-level program', 'Program', 'State'),
(31, 'National Program Participant', 'Participant in national-level program', 'Program', 'National'),
(32, 'International Program Participant', 'Participant in international-level program', 'Program', 'International'),
(33, 'University Tournament', 'Tournament rankings at university level', 'Tournament', 'University'),
(34, 'State Tournament', 'Tournament rankings at state level', 'Tournament', 'State'),
(35, 'National Tournament', 'Tournament rankings at national level', 'Tournament', 'National'),
(36, 'International Tournament', 'Tournament rankings at international level', 'Tournament', 'International'),
(37, 'Club Tournament', 'Tournament rankings at club level', 'Tournament', 'Club');

-- --------------------------------------------------------

--
-- Table structure for table `merit_score`
--

CREATE TABLE `merit_score` (
  `score_id` int(11) NOT NULL,
  `merit_id` int(11) NOT NULL,
  `rank` varchar(50) NOT NULL,
  `points` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `merit_score`
--

INSERT INTO `merit_score` (`score_id`, `merit_id`, `rank`, `points`) VALUES
(1, 28, 'Participant', 5),
(2, 29, 'Participant', 10),
(3, 30, 'Participant', 20),
(4, 31, 'Participant', 30),
(5, 32, 'Participant', 50),
(6, 33, 'First Place', 60),
(7, 33, 'Fourth Place', 10),
(8, 33, 'Second Place', 40),
(9, 33, 'Third Place', 20),
(10, 34, 'First Place', 80),
(11, 34, 'Fourth Place', 20),
(12, 34, 'Second Place', 60),
(13, 34, 'Third Place', 40),
(14, 35, 'First Place', 150),
(15, 35, 'Fourth Place', 30),
(16, 35, 'Second Place', 100),
(17, 35, 'Third Place', 60),
(18, 36, 'First Place', 300),
(19, 36, 'Fourth Place', 100),
(20, 36, 'Second Place', 200),
(21, 36, 'Third Place', 150),
(22, 37, 'First Place', 30),
(23, 37, 'Fourth Place', 5),
(24, 37, 'Second Place', 20),
(25, 37, 'Third Place', 10);

-- --------------------------------------------------------

--
-- Table structure for table `monthlygamingpasstiers`
--

CREATE TABLE `monthlygamingpasstiers` (
  `tierId` int(11) NOT NULL,
  `tierName` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discountRate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `monthlygamingpasstiers`
--

INSERT INTO `monthlygamingpasstiers` (`tierId`, `tierName`, `price`, `discountRate`) VALUES
(1, 'Essential', 30.00, 10),
(2, 'Extra', 60.00, 30),
(3, 'Premium', 110.00, 50);

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `page_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `url` varchar(255) NOT NULL,
  `inherit_permission` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`page_id`, `name`, `url`, `inherit_permission`) VALUES
(1, 'Login', '/login.jsp', 1),
(2, 'Register', '/register.jsp', 1),
(3, 'Stylesheet', '/styles.css', 1),
(4, 'LoginServlet', '/LoginServlet', 1),
(5, 'RegisterServlet', '/RegisterServlet', 1),
(6, 'Dashboard', '/dashboard.jsp', 1),
(7, 'Book Station', '/bookStation.jsp', 0),
(8, 'Manage Own', '/manageBooking.jsp', 1),
(9, 'Manage Stations', '/manageStations.jsp', 1),
(10, 'Manage All', '/manageAllBooking.jsp', 1),
(12, 'Select Station', '/selectStation.jsp', 0),
(14, 'Payment Success', '/paymentSuccess.jsp', 0),
(15, 'Join tournament / Program', '/joinTourProg.jsp', 0),
(16, 'Permission Control', '/manageRBAC.jsp', 0),
(17, 'Mock Payment Gateway', '/paymentGateway.jsp', 0),
(19, 'View Membership & Pass Servlet', '/membershipPass', 0),
(40, 'Confirm Payment Mockup', '/confirmPayment', 1),
(41, 'Manage Membership & Pass', '/manageMembership.jsp', 0),
(42, 'Checkout Membership & Pass', '/checkout.jsp', 0),
(43, 'Manage Membership & Pass Servlet', '/manageMembership', 1),
(44, 'Select Station', '/selectStation', 0),
(45, 'Manage My Booking', '/manageBooking', 1),
(46, 'Manage All Booking', '/manageBookings', 1),
(47, 'Add Station', '/stations/add', 1),
(48, 'Edit Station', '/stations/edit', 1),
(49, 'Delete Station', '/stations/delete', 1),
(50, 'List Stations', '/manageStations', 1),
(54, 'Book Station Servlet', '/bookStation', 1),
(55, 'Redirect to Payment Gateway', '/redirectToPayment', 1),
(56, 'Checkout Servlet', '/checkout', 0),
(57, 'Pay Membership', '/payMembership', 1),
(58, 'Payment Gaming Pass', '/payPass', 1),
(59, 'Payment Callback from Payment Gateway', '/paymentCallback', 1),
(60, 'Manage Profile Servlet', '/manageProfile', 1),
(61, 'Game List', '/games', 1),
(62, 'Game Details', '/games/details', 1),
(63, 'New Game', '/games/new', 0),
(64, 'Edit Game', '/games/edit', 0),
(65, 'Delete Game', '/games/delete', 0),
(66, 'List Teams', '/team', 1),
(67, 'Create Team', '/team/create', 0),
(68, 'Invitation Inbox', '/team/invitations', 0),
(69, 'Send Team Invitation', '/team/invite', 0),
(70, 'Respond to Invitation', '/team/invitation/respond', 0),
(71, 'Change Team Role', '/team/changeRole', 0),
(72, 'Leave Team', '/team/leave', 0),
(73, 'Team Detail', '/team/detail', 1),
(74, 'Manage Team', '/team/manage', 1),
(75, 'Team List', '/team/list', 1),
(76, 'Submit Join Request', '/team/joinRequest', 1),
(77, 'Join Request Accept/reject', '/team/joinRequests', 1),
(78, 'Programs & Tournaments', '/programs', 1),
(79, 'Program Details', '/programs/*', 1),
(80, 'Create Program', '/programs/new', 0),
(81, 'Save Program', '/programs/save', 0),
(82, 'Edit Program', '/programs/edit', 0),
(83, 'Delete Program', '/programs/delete', 0),
(84, 'Approve Program', '/programs/approve', 0),
(85, 'Reject Program', '/programs/reject', 0),
(86, 'Join Program', '/programs/join', 0),
(87, 'Sync Program with Challonge', '/programs/sync', 0),
(88, 'Change Program Status', '/programs/changeStatus', 0),
(90, 'Pay Tournament Registration', '/programs/pay', 1),
(91, 'Select Team', '/programs/selectTeam', 0),
(92, 'Preview Team Registration', '/programs/previewRegistration', 1),
(93, 'RBAC Servlet', '/admin/rbac', 1),
(94, 'Save RBAC setting', '/admin/rbac/save', 1),
(95, 'Program Details', '/programs/detail', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pass_benefits`
--

CREATE TABLE `pass_benefits` (
  `id` int(11) NOT NULL,
  `tierId` int(11) NOT NULL,
  `benefitOrder` int(11) NOT NULL,
  `benefitText` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pass_benefits`
--

INSERT INTO `pass_benefits` (`id`, `tierId`, `benefitOrder`, `benefitText`) VALUES
(1, 1, 1, '10%'),
(2, 1, 2, '✗'),
(3, 1, 3, '✗'),
(4, 1, 4, '✗'),
(5, 1, 5, '✗'),
(6, 2, 1, '30%'),
(7, 2, 2, '✓'),
(8, 2, 3, '✓'),
(9, 2, 4, '1 Hour'),
(10, 2, 5, '✗'),
(11, 3, 1, '50%'),
(12, 3, 2, '✓'),
(13, 3, 3, '✓'),
(14, 3, 4, '2 Hours'),
(15, 3, 5, '1 Guest Free/Session');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `rp_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`rp_id`, `page_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 12),
(1, 14),
(1, 15),
(1, 17),
(1, 19),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 44),
(1, 45),
(1, 46),
(1, 54),
(1, 55),
(1, 56),
(1, 57),
(1, 58),
(1, 59),
(1, 60),
(1, 61),
(1, 62),
(1, 66),
(1, 67),
(1, 68),
(1, 69),
(1, 70),
(1, 71),
(1, 72),
(1, 73),
(1, 74),
(1, 75),
(1, 76),
(1, 77),
(1, 78),
(1, 79),
(1, 86),
(1, 90),
(1, 91),
(1, 92),
(1, 95),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 44),
(2, 45),
(2, 46),
(2, 61),
(2, 62),
(2, 66),
(2, 78),
(2, 79),
(2, 80),
(2, 81),
(2, 82),
(2, 83),
(2, 88),
(2, 95),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 47),
(3, 48),
(3, 49),
(3, 50),
(3, 61),
(3, 62),
(3, 66),
(3, 80),
(3, 81),
(3, 82),
(3, 83),
(3, 85),
(3, 87),
(3, 95),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 9),
(4, 10),
(4, 16),
(4, 47),
(4, 48),
(4, 49),
(4, 50),
(4, 61),
(4, 62),
(4, 63),
(4, 64),
(4, 65),
(4, 66),
(4, 67),
(4, 68),
(4, 69),
(4, 70),
(4, 71),
(4, 72),
(4, 73),
(4, 80),
(4, 81),
(4, 82),
(4, 83),
(4, 84),
(4, 85),
(4, 87),
(4, 93),
(4, 94),
(4, 95),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(5, 61),
(5, 62),
(5, 66),
(5, 95);

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE `positions` (
  `position` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`position`) VALUES
('president'),
('secretary'),
('treasurer'),
('vice_president');

-- --------------------------------------------------------

--
-- Table structure for table `program_tournament`
--

CREATE TABLE `program_tournament` (
  `prog_id` int(11) NOT NULL,
  `creator_id` varchar(50) NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `program_name` varchar(200) NOT NULL,
  `program_type` enum('PROGRAM','TOURNAMENT') NOT NULL DEFAULT 'PROGRAM',
  `merit_id` int(11) DEFAULT NULL,
  `place` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `prog_fee` decimal(10,2) DEFAULT 0.00,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `prize_pool` decimal(10,2) DEFAULT NULL,
  `max_capacity` int(11) NOT NULL DEFAULT 1,
  `max_team_member` int(11) DEFAULT 1,
  `min_team_member` int(11) NOT NULL DEFAULT 1,
  `status` enum('PENDING_APPROVAL','APPROVED','OPEN','CLOSED','COMPLETED','CANCELLED','REJECTED') NOT NULL DEFAULT 'PENDING_APPROVAL',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  `bracket_format` enum('SINGLE_ELIM','DOUBLE_ELIM','ROUND_ROBIN','LEADERBOARD') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `program_tournament`
--

INSERT INTO `program_tournament` (`prog_id`, `creator_id`, `game_id`, `program_name`, `program_type`, `merit_id`, `place`, `description`, `prog_fee`, `start_date`, `end_date`, `start_time`, `end_time`, `prize_pool`, `max_capacity`, `max_team_member`, `min_team_member`, `status`, `created_at`, `updated_at`, `deleted_flag`, `bracket_format`) VALUES
(6, 'husinyusoff', 4, 'PUBG newcoming', 'TOURNAMENT', 36, 'ONLINE', '123', 100.00, '2025-07-03', '2025-06-30', '05:00:00', '20:00:00', 1000.00, 12, 5, 3, 'OPEN', '2025-06-30 01:08:23', '2025-06-30 14:38:27', 0, 'SINGLE_ELIM'),
(7, 'amirul_rahman', 4, 'Hotlink MLBB Challenge', 'TOURNAMENT', 36, 'Kompleks Siswa', 'Collab with hotlink', 30.00, '2025-07-03', '2025-07-05', '08:00:00', '22:00:00', 3000.00, 30, 4, 1, 'PENDING_APPROVAL', '2025-07-01 15:19:16', '2025-07-01 15:19:16', 0, 'ROUND_ROBIN');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role`) VALUES
('athlete'),
('executive_council'),
('high_council'),
('referee');

-- --------------------------------------------------------

--
-- Table structure for table `role_positions`
--

CREATE TABLE `role_positions` (
  `id` int(11) NOT NULL,
  `role` varchar(50) NOT NULL,
  `position` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_positions`
--

INSERT INTO `role_positions` (`id`, `role`, `position`) VALUES
(1, 'athlete', NULL),
(2, 'executive_council', NULL),
(3, 'high_council', NULL),
(4, 'high_council', 'president'),
(5, 'referee', NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `rp_permissions_full`
-- (See below for the actual view)
--
CREATE TABLE `rp_permissions_full` (
`role` varchar(50)
,`position` varchar(50)
,`page_id` int(11)
,`page_name` varchar(100)
,`page_url` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `teamID` int(11) NOT NULL,
  `teamName` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `logoURL` varchar(255) DEFAULT NULL,
  `leader` varchar(64) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `disbandedAt` datetime DEFAULT NULL,
  `status` enum('Active','Disbanded') NOT NULL DEFAULT 'Active',
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team`
--

INSERT INTO `team` (`teamID`, `teamName`, `description`, `logoURL`, `leader`, `createdAt`, `disbandedAt`, `status`, `capacity`) VALUES
(1, 'Fun Art', 'entah', '/NexGenEsportsv2/uploads/2023-08-25-18-04-31-658(1).jpg', 'husinyusoff', '2025-06-24 17:08:52', NULL, 'Active', 2),
(2, 'Beta Squad', 'Second test team', '/uploads/logo2.png', 'farid_zahazan', '2025-06-25 22:23:15', NULL, 'Active', 6),
(4, 'Mantoul', 'Competitive gaming group', '/images/mantoul.png', 'husinyusoff', '2025-06-25 22:18:57', NULL, 'Active', 20),
(5, 'EsportsUMT Pro', 'Mantap bosskur', '/NexGenEsportsv2/uploads/Screenshot 2025-06-25 162828.png', 'amirul_rahman', '2025-06-26 01:27:02', NULL, 'Active', 10),
(6, 'Alpha Squad', 'A team of pioneers', '/images/alpha.png', 'nur_fatihah', '2025-06-27 10:00:00', NULL, 'Active', 3),
(7, 'Bravo Team', 'The bravo unit', '/images/bravo.png', 'nur_fatihah', '2025-06-27 10:30:00', NULL, 'Active', 4),
(8, 'Charlie Crew', 'Elite Charlie crew', '/images/charlie.png', 'mohd_zaki', '2025-06-27 11:00:00', NULL, 'Active', 2),
(9, 'esport', '1', NULL, 'amirul_rahman', '2025-07-01 08:21:39', NULL, 'Active', 4);

-- --------------------------------------------------------

--
-- Table structure for table `teammember`
--

CREATE TABLE `teammember` (
  `teamID` int(11) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `status` enum('Pending','Active','Declined') NOT NULL DEFAULT 'Pending',
  `teamRole` enum('Leader','Co-Leader','Member') NOT NULL DEFAULT 'Member',
  `joinedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `roleAssignedAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teammember`
--

INSERT INTO `teammember` (`teamID`, `userID`, `status`, `teamRole`, `joinedAt`, `roleAssignedAt`) VALUES
(1, 'nurul_huda', 'Active', 'Leader', '2025-06-25 22:24:09', '2025-06-25 21:01:40'),
(2, 'farid_zahazan', 'Active', 'Leader', '2025-06-30 06:49:44', '2025-07-01 08:19:37'),
(2, 'mohd_faizal', 'Active', 'Member', '2025-06-25 22:24:09', '2025-06-25 22:24:09'),
(2, 'nurul_huda', 'Active', 'Member', '2025-06-30 06:45:11', '2025-06-30 06:45:11'),
(2, 'siti_aminah', 'Active', 'Member', '2025-06-30 06:49:10', '2025-06-30 06:49:10'),
(4, 'husinyusoff', 'Active', 'Leader', '2025-06-26 01:27:02', '2025-06-26 18:24:01'),
(4, 'siti_aminah', 'Active', 'Member', '2025-06-26 09:28:47', '2025-06-26 09:28:47'),
(5, 'amirul_rahman', 'Active', 'Leader', '2025-06-26 09:41:08', '2025-06-26 18:00:02'),
(6, 'michaella_qila', 'Active', 'Member', '2025-06-27 10:10:00', '2025-06-27 10:10:00'),
(6, 'nur_fatihah', 'Active', 'Leader', '2025-06-27 10:05:00', '2025-06-26 18:13:06'),
(7, 'farid_zahazan', 'Active', 'Member', '2025-06-27 10:40:00', '2025-06-27 10:40:00'),
(7, 'michaella_qila', 'Active', 'Member', '2025-06-27 10:45:00', '2025-06-27 10:45:00'),
(7, 'mohd_zaki', 'Active', 'Co-Leader', '2025-06-27 10:35:00', '2025-06-27 10:35:00'),
(7, 'nur_fatihah', 'Active', 'Leader', '2025-06-27 10:30:00', '2025-06-27 10:30:00'),
(8, 'michaella_qila', 'Active', 'Member', '2025-06-27 11:05:00', '2025-06-27 11:05:00'),
(8, 'mohd_zaki', 'Active', 'Leader', '2025-06-27 11:00:00', '2025-06-27 11:00:00'),
(9, 'amirul_rahman', 'Active', 'Leader', '2025-07-01 08:21:39', '2025-07-01 08:21:39');

--
-- Triggers `teammember`
--
DELIMITER $$
CREATE TRIGGER `after_member_insert_clear_join_requests` AFTER INSERT ON `teammember` FOR EACH ROW BEGIN
  DELETE FROM join_request
   WHERE teamID = NEW.teamID
     AND userID = NEW.userID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `team_summary`
-- (See below for the actual view)
--
CREATE TABLE `team_summary` (
`teamID` int(11)
,`teamName` varchar(100)
,`leader` varchar(64)
,`createdAt` datetime
,`capacity` int(11)
,`activeCount` bigint(21)
,`memberList` mediumtext
);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_participant`
--

CREATE TABLE `tournament_participant` (
  `id` bigint(20) NOT NULL,
  `prog_id` int(11) NOT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `role` enum('MAIN','SUB') NOT NULL DEFAULT 'MAIN',
  `status` enum('PENDING','PAID','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `paymentReference` varchar(100) DEFAULT NULL,
  `joined_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `userclubmemberships`
--

CREATE TABLE `userclubmemberships` (
  `id` int(11) NOT NULL,
  `userId` varchar(50) NOT NULL,
  `sessionId` varchar(50) NOT NULL,
  `purchaseDate` datetime NOT NULL DEFAULT current_timestamp(),
  `expiryDate` date NOT NULL,
  `status` enum('PENDING','ACTIVE','EXPIRED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `payment_reference` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userclubmemberships`
--

INSERT INTO `userclubmemberships` (`id`, `userId`, `sessionId`, `purchaseDate`, `expiryDate`, `status`, `payment_reference`) VALUES
(17, 'husinyusoff', 'ESUMT_25/26', '2025-06-23 16:39:17', '2026-07-29', 'ACTIVE', 'SIM-1750696758276'),
(18, 'farid_zahazan', 'ESUMT_24/25', '2025-07-01 04:19:50', '2025-07-29', 'ACTIVE', 'SIM-1751343591643'),
(19, 'alif_muhammad', 'ESUMT_24/25', '2025-07-01 08:10:00', '2025-07-29', 'ACTIVE', 'SIM-1751357403057');

-- --------------------------------------------------------

--
-- Table structure for table `usergamingpasses`
--

CREATE TABLE `usergamingpasses` (
  `id` int(11) NOT NULL,
  `userId` varchar(50) NOT NULL,
  `tierId` int(11) NOT NULL,
  `purchaseDate` datetime NOT NULL DEFAULT current_timestamp(),
  `expiryDate` date NOT NULL,
  `status` enum('PENDING','ACTIVE','EXPIRED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `paymentReference` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usergamingpasses`
--

INSERT INTO `usergamingpasses` (`id`, `userId`, `tierId`, `purchaseDate`, `expiryDate`, `status`, `paymentReference`) VALUES
(17, 'husinyusoff', 2, '2025-06-23 17:37:54', '2025-07-22', 'ACTIVE', 'SIM-1750700275781'),
(19, 'husinyusoff', 3, '2025-06-26 01:51:06', '2025-07-25', 'ACTIVE', 'SIM-1750902674915'),
(20, 'farid_zahazan', 3, '2025-07-01 04:19:59', '2025-07-30', 'ACTIVE', 'SIM-1751343602198'),
(21, 'alif_muhammad', 1, '2025-07-01 08:09:42', '2025-07-30', 'ACTIVE', 'SIM-1751357387252');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(60) NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `matricNumber` varchar(20) DEFAULT NULL,
  `ign` varchar(100) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `discordID` varchar(50) DEFAULT NULL,
  `registrationDate` datetime NOT NULL DEFAULT current_timestamp(),
  `password_reset_token` varchar(64) DEFAULT NULL,
  `password_reset_expiry` datetime DEFAULT NULL,
  `rp_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `name`, `email`, `password_hash`, `phoneNumber`, `matricNumber`, `registrationDate`, `rp_id`) VALUES
('alif_muhammad', 'Alif Muhammad', 'alif@student.umt.edu.my', '$2a$10$fTT.0D9muhHBrQ6.E/.RD.AQF9GW/rjsNt6Y9ug0GT.LBQcd3Fypu', '011-1242414135', NULL, '2025-06-20 10:00:00', 1),
('amirul_rahman', 'Amirul Rahman', 'amirul@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000002', NULL, '2025-06-20 10:05:00', 4),
('farid_zahazan', 'Farid Zahazan', 'farid@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000006', NULL, '2025-06-20 10:10:00', 1),
('husinyusoff', 'Husin Yusoff', 'husin@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01111194399', NULL, '2025-06-20 09:00:00', 4),
('michaella_qila', 'Michaella Qila', 'michaella@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000009', NULL, '2025-06-20 10:20:00', 4),
('mohd_faizal', 'Mohd Faizal', 'faizal@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000004', NULL, '2025-06-20 10:25:00', 4),
('mohd_zaki', 'Mohd Zaki', 'zaki@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000008', NULL, '2025-06-20 10:30:00', 3),
('nurul_huda', 'Nurul Huda', 'huda@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000003', NULL, '2025-06-20 10:35:00', 4),
('nur_fatihah', 'Nur Fatihah', 'fatihah@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000007', NULL, '2025-06-20 10:40:00', 2),
('siti_aminah', 'Siti Aminah', 'aminah@student.umt.edu.my', '$2a$10$pxVj02PtGQTd1Q25Av2anOogSfcr1c3Zr2d0LJT1hlemTdHMkEw8.', '01110000005', NULL, '2025-06-20 10:45:00', 4);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_merit_ui`
-- (See below for the actual view)
--
CREATE TABLE `v_merit_ui` (
`merit_id` int(11)
,`category` enum('Program','Tournament')
,`scope` enum('Club','University','State','National','International')
,`rank` varchar(50)
,`points` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `rp_permissions_full`
--
DROP TABLE IF EXISTS `rp_permissions_full`;

CREATE ALGORITHM=MERGE DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `rp_permissions_full`  AS SELECT `rp`.`role` AS `role`, `rp`.`position` AS `position`, `p`.`page_id` AS `page_id`, `pg`.`name` AS `page_name`, `pg`.`url` AS `page_url` FROM ((`permissions` `p` join `role_positions` `rp` on(`p`.`rp_id` = `rp`.`id`)) join `pages` `pg` on(`p`.`page_id` = `pg`.`page_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `team_summary`
--
DROP TABLE IF EXISTS `team_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `team_summary`  AS SELECT `t`.`teamID` AS `teamID`, `t`.`teamName` AS `teamName`, `t`.`leader` AS `leader`, `t`.`createdAt` AS `createdAt`, `t`.`capacity` AS `capacity`, count(`m`.`userID`) AS `activeCount`, group_concat(concat(`m`.`userID`,'(',`m`.`teamRole`,')') order by `m`.`joinedAt` ASC separator ', ') AS `memberList` FROM (`team` `t` left join `teammember` `m` on(`t`.`teamID` = `m`.`teamID` and `m`.`status` = 'Active')) GROUP BY `t`.`teamID`, `t`.`teamName`, `t`.`leader`, `t`.`createdAt`, `t`.`capacity` ;

-- --------------------------------------------------------

--
-- Structure for view `v_merit_ui`
--
DROP TABLE IF EXISTS `v_merit_ui`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_merit_ui`  AS SELECT `ml`.`merit_id` AS `merit_id`, `ml`.`category` AS `category`, `ml`.`scope` AS `scope`, `ms`.`rank` AS `rank`, `ms`.`points` AS `points` FROM (`merit_level` `ml` join `merit_score` `ms` on(`ml`.`merit_id` = `ms`.`merit_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `archived_teammember`
--
ALTER TABLE `archived_teammember`
  ADD PRIMARY KEY (`teamID`,`userID`,`leftAt`);

--
-- Indexes for table `auditlog`
--
ALTER TABLE `auditlog`
  ADD PRIMARY KEY (`logID`);

--
-- Indexes for table `bracket`
--
ALTER TABLE `bracket`
  ADD PRIMARY KEY (`bracket_id`),
  ADD KEY `idx_bracket_prog` (`prog_id`),
  ADD KEY `idx_bracket_user` (`created_by`);

--
-- Indexes for table `bracket_match`
--
ALTER TABLE `bracket_match`
  ADD PRIMARY KEY (`match_id`),
  ADD KEY `idx_bm_bracket` (`bracket_id`),
  ADD KEY `idx_bm_p1` (`participant1_id`),
  ADD KEY `idx_bm_p2` (`participant2_id`),
  ADD KEY `idx_bm_winner` (`winner_id`),
  ADD KEY `idx_bm_ref` (`updated_by`);

--
-- Indexes for table `bracket_referee`
--
ALTER TABLE `bracket_referee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_brref_bracket` (`bracket_id`),
  ADD KEY `idx_brref_user` (`referee_id`);

--
-- Indexes for table `business_config`
--
ALTER TABLE `business_config`
  ADD PRIMARY KEY (`config_key`);

--
-- Indexes for table `challonge_participant`
--
ALTER TABLE `challonge_participant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tp_id` (`tp_id`);

--
-- Indexes for table `challonge_tournament`
--
ALTER TABLE `challonge_tournament`
  ADD PRIMARY KEY (`prog_id`);

--
-- Indexes for table `club_benefits`
--
ALTER TABLE `club_benefits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessionId` (`sessionId`);

--
-- Indexes for table `game`
--
ALTER TABLE `game`
  ADD PRIMARY KEY (`gameID`),
  ADD KEY `idx_game_name` (`gameName`);

--
-- Indexes for table `gamingstation`
--
ALTER TABLE `gamingstation`
  ADD PRIMARY KEY (`stationID`);

--
-- Indexes for table `gamingstationbooking`
--
ALTER TABLE `gamingstationbooking`
  ADD PRIMARY KEY (`bookingID`),
  ADD KEY `idx_station_date` (`stationID`,`date`),
  ADD KEY `fk_booking_user` (`userID`);

--
-- Indexes for table `join_request`
--
ALTER TABLE `join_request`
  ADD PRIMARY KEY (`requestID`),
  ADD KEY `join_request_ibfk_1` (`teamID`);

--
-- Indexes for table `membershipsessions`
--
ALTER TABLE `membershipsessions`
  ADD PRIMARY KEY (`sessionId`);

--
-- Indexes for table `merit_level`
--
ALTER TABLE `merit_level`
  ADD PRIMARY KEY (`merit_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `merit_score`
--
ALTER TABLE `merit_score`
  ADD PRIMARY KEY (`score_id`),
  ADD UNIQUE KEY `uk_merit_score_merit_rank` (`merit_id`,`rank`),
  ADD KEY `idx_merit_score_merit_id` (`merit_id`);

--
-- Indexes for table `monthlygamingpasstiers`
--
ALTER TABLE `monthlygamingpasstiers`
  ADD PRIMARY KEY (`tierId`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`page_id`),
  ADD UNIQUE KEY `ux_pages_url` (`url`);

--
-- Indexes for table `pass_benefits`
--
ALTER TABLE `pass_benefits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tierId` (`tierId`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`rp_id`,`page_id`),
  ADD KEY `page_id` (`page_id`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`position`);

--
-- Indexes for table `program_tournament`
--
ALTER TABLE `program_tournament`
  ADD PRIMARY KEY (`prog_id`),
  ADD KEY `idx_pt_creator` (`creator_id`),
  ADD KEY `idx_pt_game` (`game_id`),
  ADD KEY `idx_pt_merit` (`merit_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role`);

--
-- Indexes for table `role_positions`
--
ALTER TABLE `role_positions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_role_position` (`role`,`position`),
  ADD KEY `position` (`position`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`teamID`),
  ADD UNIQUE KEY `ux_team_teamName` (`teamName`);

--
-- Indexes for table `teammember`
--
ALTER TABLE `teammember`
  ADD PRIMARY KEY (`teamID`,`userID`);

--
-- Indexes for table `tournament_participant`
--
ALTER TABLE `tournament_participant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tp_prog` (`prog_id`),
  ADD KEY `idx_tp_user` (`user_id`),
  ADD KEY `idx_tp_team` (`team_id`);

--
-- Indexes for table `userclubmemberships`
--
ALTER TABLE `userclubmemberships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ucm_user` (`userId`),
  ADD KEY `idx_ucm_session` (`sessionId`);

--
-- Indexes for table `usergamingpasses`
--
ALTER TABLE `usergamingpasses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkUgpUser` (`userId`),
  ADD KEY `fkUgpTier` (`tierId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `ux_users_email` (`email`),
  ADD UNIQUE KEY `ux_users_matric` (`matricNumber`),
  ADD KEY `rp_id` (`rp_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auditlog`
--
ALTER TABLE `auditlog`
  MODIFY `logID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `bracket`
--
ALTER TABLE `bracket`
  MODIFY `bracket_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bracket_match`
--
ALTER TABLE `bracket_match`
  MODIFY `match_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bracket_referee`
--
ALTER TABLE `bracket_referee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `club_benefits`
--
ALTER TABLE `club_benefits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `game`
--
ALTER TABLE `game`
  MODIFY `gameID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `gamingstationbooking`
--
ALTER TABLE `gamingstationbooking`
  MODIFY `bookingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `join_request`
--
ALTER TABLE `join_request`
  MODIFY `requestID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `merit_level`
--
ALTER TABLE `merit_level`
  MODIFY `merit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `merit_score`
--
ALTER TABLE `merit_score`
  MODIFY `score_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `monthlygamingpasstiers`
--
ALTER TABLE `monthlygamingpasstiers`
  MODIFY `tierId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `page_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `pass_benefits`
--
ALTER TABLE `pass_benefits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `program_tournament`
--
ALTER TABLE `program_tournament`
  MODIFY `prog_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `role_positions`
--
ALTER TABLE `role_positions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `team`
--
ALTER TABLE `team`
  MODIFY `teamID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tournament_participant`
--
ALTER TABLE `tournament_participant`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `userclubmemberships`
--
ALTER TABLE `userclubmemberships`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `usergamingpasses`
--
ALTER TABLE `usergamingpasses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bracket`
--
ALTER TABLE `bracket`
  ADD CONSTRAINT `bracket_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`userID`) ON DELETE SET NULL;

--
-- Constraints for table `bracket_match`
--
ALTER TABLE `bracket_match`
  ADD CONSTRAINT `bracket_match_ibfk_1` FOREIGN KEY (`bracket_id`) REFERENCES `bracket` (`bracket_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bracket_match_ibfk_2` FOREIGN KEY (`participant1_id`) REFERENCES `tournament_participant` (`id`),
  ADD CONSTRAINT `bracket_match_ibfk_3` FOREIGN KEY (`participant2_id`) REFERENCES `tournament_participant` (`id`),
  ADD CONSTRAINT `bracket_match_ibfk_4` FOREIGN KEY (`winner_id`) REFERENCES `tournament_participant` (`id`),
  ADD CONSTRAINT `bracket_match_ibfk_5` FOREIGN KEY (`updated_by`) REFERENCES `users` (`userID`);

--
-- Constraints for table `bracket_referee`
--
ALTER TABLE `bracket_referee`
  ADD CONSTRAINT `bracket_referee_ibfk_1` FOREIGN KEY (`bracket_id`) REFERENCES `bracket` (`bracket_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bracket_referee_ibfk_2` FOREIGN KEY (`referee_id`) REFERENCES `users` (`userID`) ON DELETE SET NULL;

--
-- Constraints for table `challonge_participant`
--
ALTER TABLE `challonge_participant`
  ADD CONSTRAINT `challonge_participant_ibfk_1` FOREIGN KEY (`tp_id`) REFERENCES `tournament_participant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `challonge_tournament`
--
ALTER TABLE `challonge_tournament`
  ADD CONSTRAINT `fk_challonge_prog` FOREIGN KEY (`prog_id`) REFERENCES `program_tournament` (`prog_id`) ON DELETE CASCADE;

--
-- Constraints for table `club_benefits`
--
ALTER TABLE `club_benefits`
  ADD CONSTRAINT `club_benefits_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `membershipsessions` (`sessionId`) ON DELETE CASCADE;

--
-- Constraints for table `gamingstationbooking`
--
ALTER TABLE `gamingstationbooking`
  ADD CONSTRAINT `fk_booking_station` FOREIGN KEY (`stationID`) REFERENCES `gamingstation` (`stationID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_user` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`);

--
-- Constraints for table `join_request`
--
ALTER TABLE `join_request`
  ADD CONSTRAINT `join_request_ibfk_1` FOREIGN KEY (`teamID`) REFERENCES `team` (`teamID`) ON DELETE CASCADE;

--
-- Constraints for table `merit_score`
--
ALTER TABLE `merit_score`
  ADD CONSTRAINT `merit_score_ibfk_1` FOREIGN KEY (`merit_id`) REFERENCES `merit_level` (`merit_id`) ON DELETE CASCADE;

--
-- Constraints for table `pass_benefits`
--
ALTER TABLE `pass_benefits`
  ADD CONSTRAINT `pass_benefits_ibfk_1` FOREIGN KEY (`tierId`) REFERENCES `monthlygamingpasstiers` (`tierId`) ON DELETE CASCADE;

--
-- Constraints for table `permissions`
--
ALTER TABLE `permissions`
  ADD CONSTRAINT `permissions_ibfk_1` FOREIGN KEY (`rp_id`) REFERENCES `role_positions` (`id`),
  ADD CONSTRAINT `permissions_ibfk_2` FOREIGN KEY (`page_id`) REFERENCES `pages` (`page_id`);

--
-- Constraints for table `program_tournament`
--
ALTER TABLE `program_tournament`
  ADD CONSTRAINT `program_tournament_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users` (`userID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `program_tournament_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `game` (`gameID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `program_tournament_ibfk_3` FOREIGN KEY (`merit_id`) REFERENCES `merit_level` (`merit_id`) ON DELETE SET NULL;

--
-- Constraints for table `role_positions`
--
ALTER TABLE `role_positions`
  ADD CONSTRAINT `role_positions_ibfk_1` FOREIGN KEY (`role`) REFERENCES `roles` (`role`),
  ADD CONSTRAINT `role_positions_ibfk_2` FOREIGN KEY (`position`) REFERENCES `positions` (`position`);

--
-- Constraints for table `teammember`
--
ALTER TABLE `teammember`
  ADD CONSTRAINT `fk_tm_team` FOREIGN KEY (`teamID`) REFERENCES `team` (`teamID`) ON DELETE CASCADE;

--
-- Constraints for table `tournament_participant`
--
ALTER TABLE `tournament_participant`
  ADD CONSTRAINT `fk_tp_program` FOREIGN KEY (`prog_id`) REFERENCES `program_tournament` (`prog_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tournament_participant_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`userID`) ON DELETE SET NULL,
  ADD CONSTRAINT `tournament_participant_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `team` (`teamID`) ON DELETE SET NULL;

--
-- Constraints for table `userclubmemberships`
--
ALTER TABLE `userclubmemberships`
  ADD CONSTRAINT `fk_ucm_session` FOREIGN KEY (`sessionId`) REFERENCES `membershipsessions` (`sessionId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ucm_user` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usergamingpasses`
--
ALTER TABLE `usergamingpasses`
  ADD CONSTRAINT `usergamingpasses_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usergamingpasses_ibfk_2` FOREIGN KEY (`tierId`) REFERENCES `monthlygamingpasstiers` (`tierId`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`rp_id`) REFERENCES `role_positions` (`id`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `ev_cleanup_pending_memberships` ON SCHEDULE EVERY 5 MINUTE STARTS '2025-06-23 22:31:38' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM userclubmemberships
 WHERE status = 'PENDING'
   AND purchaseDate < DATE_SUB(NOW(), INTERVAL 5 MINUTE)$$

CREATE DEFINER=`root`@`localhost` EVENT `ev_cleanup_pending_passes` ON SCHEDULE EVERY 5 MINUTE STARTS '2025-06-23 22:32:20' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM usergamingpasses
 WHERE status = 'PENDING'
   AND purchaseDate < DATE_SUB(NOW(), INTERVAL 5 MINUTE)$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
