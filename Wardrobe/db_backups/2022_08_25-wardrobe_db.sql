-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Erstellungszeit: 25. Aug 2022 um 09:15
-- Server-Version: 10.8.3-MariaDB-1:10.8.3+maria~jammy
-- PHP-Version: 8.0.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `wardrobe_db`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(250) NOT NULL,
  `image_fk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `image_fk`) VALUES
(1, 'HDMI Kabel', '2m', NULL),
(2, 'Monitor mit Bild', 'anfjqwf', 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `user_fk` int(11) NOT NULL,
  `origFilename` varchar(250) NOT NULL,
  `genFilename` varchar(250) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `product_images`
--

INSERT INTO `product_images` (`id`, `user_fk`, `origFilename`, `genFilename`, `timestamp`) VALUES
(1, 1, 'Bildschirmfoto-2022-05-01-um-23.43.54.png', 'uploads/2022-08-25T09:14:16.099ZBildschirmfoto-2022-05-01-um-23.43.54.png', '2022-08-25 09:14:16');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `user`
--

INSERT INTO `user` (`id`, `username`, `password`) VALUES
(1, 'skyface', '$2b$10$RHc9HhYPXZ3bqScW6PunPuP2SSxY1c8lnS8gmTtZHqtJ9RptqDgOm');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `wardrobe`
--

CREATE TABLE `wardrobe` (
  `id` int(11) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `columns` int(11) NOT NULL,
  `rows` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `wardrobe`
--

INSERT INTO `wardrobe` (`id`, `fname`, `columns`, `rows`) VALUES
(1, 'Regal 1', 2, 4),
(2, 'Regal 2', 6, 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `wardrobe_product_XREF`
--

CREATE TABLE `wardrobe_product_XREF` (
  `wardrobe_fk` int(11) NOT NULL,
  `product_fk` int(11) NOT NULL,
  `pos_column` int(11) NOT NULL,
  `pos_row` int(11) NOT NULL,
  `number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `wardrobe_product_XREF`
--

INSERT INTO `wardrobe_product_XREF` (`wardrobe_fk`, `product_fk`, `pos_column`, `pos_row`, `number`) VALUES
(1, 1, 1, 1, 1),
(1, 1, 1, 2, 3),
(2, 2, 1, 2, 1);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `image_fk` (`image_fk`);

--
-- Indizes für die Tabelle `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_fk` (`user_fk`);

--
-- Indizes für die Tabelle `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username_unique` (`username`);

--
-- Indizes für die Tabelle `wardrobe`
--
ALTER TABLE `wardrobe`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `wardrobe_product_XREF`
--
ALTER TABLE `wardrobe_product_XREF`
  ADD PRIMARY KEY (`wardrobe_fk`,`product_fk`,`pos_column`,`pos_row`),
  ADD KEY `product_fk` (`product_fk`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `wardrobe`
--
ALTER TABLE `wardrobe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `image_fk` FOREIGN KEY (`image_fk`) REFERENCES `product_images` (`id`);

--
-- Constraints der Tabelle `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `user_fk` FOREIGN KEY (`user_fk`) REFERENCES `user` (`id`);

--
-- Constraints der Tabelle `wardrobe_product_XREF`
--
ALTER TABLE `wardrobe_product_XREF`
  ADD CONSTRAINT `product_fk` FOREIGN KEY (`product_fk`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `wardrobe_fk` FOREIGN KEY (`wardrobe_fk`) REFERENCES `wardrobe` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
