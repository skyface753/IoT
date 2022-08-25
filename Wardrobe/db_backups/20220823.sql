-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Erstellungszeit: 23. Aug 2022 um 14:03
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
-- Tabellenstruktur für Tabelle `drawer`
--

CREATE TABLE `drawer` (
  `id` int(11) NOT NULL,
  `wardrobe_fk` int(11) NOT NULL,
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `drawer`
--

INSERT INTO `drawer` (`id`, `wardrobe_fk`, `position`) VALUES
(1, 2, 0),
(2, 2, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `drawer_product_XREF`
--

CREATE TABLE `drawer_product_XREF` (
  `drawer_fk` int(11) NOT NULL,
  `product_fk` int(11) NOT NULL,
  `number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `drawer_product_XREF`
--

INSERT INTO `drawer_product_XREF` (`drawer_fk`, `product_fk`, `number`) VALUES
(1, 1, 3),
(2, 1, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(250) NOT NULL,
  `stock` int(11) NOT NULL,
  `image_path` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `stock`, `image_path`) VALUES
(1, 'HDMI Kabel', '2m: HMDI -> HMDI Kabel', 5, '1');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `user`
--

INSERT INTO `user` (`id`, `username`, `password`) VALUES
(1, 'skyface', '$2b$10$klHvuF6ih6gz5UTZIg.6E.YRI2o5pbRaMiY6twXPid7zSefqQr1O.');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `wardrobe`
--

CREATE TABLE `wardrobe` (
  `id` int(11) NOT NULL,
  `fname` varchar(250) NOT NULL,
  `columns` int(11) NOT NULL,
  `rows` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `wardrobe`
--

INSERT INTO `wardrobe` (`id`, `fname`, `columns`, `rows`) VALUES
(2, 'Regal 1 (2C,4R)', 2, 4),
(3, 'Regal 1 (6C,3R)', 6, 3);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `drawer`
--
ALTER TABLE `drawer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wardrobe_fk` (`wardrobe_fk`);

--
-- Indizes für die Tabelle `drawer_product_XREF`
--
ALTER TABLE `drawer_product_XREF`
  ADD PRIMARY KEY (`drawer_fk`,`product_fk`),
  ADD KEY `product_fk` (`product_fk`);

--
-- Indizes für die Tabelle `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `drawer`
--
ALTER TABLE `drawer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `product`
--
ALTER TABLE `product`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `drawer`
--
ALTER TABLE `drawer`
  ADD CONSTRAINT `wardrobe_fk` FOREIGN KEY (`wardrobe_fk`) REFERENCES `wardrobe` (`id`);

--
-- Constraints der Tabelle `drawer_product_XREF`
--
ALTER TABLE `drawer_product_XREF`
  ADD CONSTRAINT `drawer_fk` FOREIGN KEY (`drawer_fk`) REFERENCES `drawer` (`id`),
  ADD CONSTRAINT `product_fk` FOREIGN KEY (`product_fk`) REFERENCES `product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
