-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 03, 2023 at 07:40 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `projectdatabase`
--

-- --------------------------------------------------------

--
-- Table structure for table `Coupon`
--

CREATE TABLE `Coupon` (
  `CouponID` int(11) NOT NULL,
  `CouponCode` text NOT NULL,
  `CouponDiscount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Coupon`
--

INSERT INTO `Coupon` (`CouponID`, `CouponCode`, `CouponDiscount`) VALUES
(1, 'WELCOME15', '0.85');

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `ItemID` int(11) NOT NULL,
  `ItemName` mediumtext NOT NULL,
  `ItemPrice` decimal(10,2) NOT NULL,
  `MadeIn` varchar(255) DEFAULT NULL,
  `DeptCode` int(11) DEFAULT NULL,
  `Picture_URL` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`ItemID`, `ItemName`, `ItemPrice`, `MadeIn`, `DeptCode`, `Picture_URL`) VALUES
(1, 'T-Shirt', '19.99', 'Canada', 12, '1.webp'),
(2, 'Sweatshirt', '24.99', 'Canada', 12, '2.jpg'),
(3, 'Puffer Jacket', '299.90', 'Canada', 13, '3.webp');

-- --------------------------------------------------------

--
-- Table structure for table `order_info`
--

CREATE TABLE `order_info` (
  `OrderID` int(11) NOT NULL,
  `DateIssued` datetime NOT NULL DEFAULT current_timestamp(),
  `DateReceived` datetime DEFAULT NULL,
  `Subtotal` decimal(10,2) NOT NULL,
  `PaymentCode` int(11) DEFAULT NULL,
  `UserID` int(11) NOT NULL,
  `TripID` int(11) DEFAULT NULL,
  `CouponID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_info`
--

INSERT INTO `order_info` (`OrderID`, `DateIssued`, `DateReceived`, `Subtotal`, `PaymentCode`, `UserID`, `TripID`, `CouponID`) VALUES
(1, '2023-03-28 20:25:07', NULL, '24.99', 1, 6, 1, NULL),
(8, '2023-04-03 01:35:05', NULL, '49.98', 1, 6, 7, NULL),
(9, '2023-04-03 01:38:05', NULL, '319.89', 1, 6, 8, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `shopping`
--

CREATE TABLE `shopping` (
  `ReceiptID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `StoreID` int(11) NOT NULL,
  `ItemID` int(11) NOT NULL,
  `OrderQuantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shopping`
--

INSERT INTO `shopping` (`ReceiptID`, `OrderID`, `StoreID`, `ItemID`, `OrderQuantity`) VALUES
(1, 1, 2, 1, 1),
(11, 1, 2, 2, 1),
(12, 8, 1, 2, 2),
(13, 9, 1, 1, 1),
(14, 9, 1, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `shopping_cart`
--

CREATE TABLE `shopping_cart` (
  `UserID` int(11) NOT NULL,
  `ItemID` int(11) NOT NULL,
  `Quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE `store` (
  `StoreID` int(2) NOT NULL,
  `StoreName` text NOT NULL,
  `StoreAddress` text NOT NULL,
  `StoreCity` text NOT NULL,
  `StoreProvince` varchar(2) NOT NULL,
  `StorePhone` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `store`
--

INSERT INTO `store` (`StoreID`, `StoreName`, `StoreAddress`, `StoreCity`, `StoreProvince`, `StorePhone`) VALUES
(1, 'Queen St W', '', 'Toronto', 'ON', '4161283280'),
(2, 'CF Markville', '5000 Highway 7', 'Markham', 'ON', '4161241199'),
(3, 'Square One Shopping Centre', '100 City Centre Dr', 'Mississauga', 'ON', '4169275682');

-- --------------------------------------------------------

--
-- Table structure for table `trip`
--

CREATE TABLE `trip` (
  `TripID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `StoreID` int(2) NOT NULL,
  `DestAddress` text DEFAULT NULL,
  `DestCity` text NOT NULL,
  `DestProvince` varchar(2) NOT NULL,
  `DestPostcode` varchar(7) NOT NULL,
  `Distance` decimal(10,2) DEFAULT NULL,
  `TruckID` int(11) DEFAULT NULL,
  `TotalPrice` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trip`
--

INSERT INTO `trip` (`TripID`, `OrderID`, `StoreID`, `DestAddress`, `DestCity`, `DestProvince`, `DestPostcode`, `Distance`, `TruckID`, `TotalPrice`) VALUES
(1, 1, 2, '3', '', '', '', '45.00', 1, '123.20'),
(7, 8, 1, '1 Toronto St', 'Toronto', 'ON', 'M1C 3A2', NULL, NULL, NULL),
(8, 9, 1, '1 Toronto St', 'Toronto', 'ON', 'M1C 3A2', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `truck`
--

CREATE TABLE `truck` (
  `TruckID` int(11) NOT NULL,
  `TruckCode` int(11) NOT NULL,
  `AvailabilityCode` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `truck`
--

INSERT INTO `truck` (`TruckID`, `TruckCode`, `AvailabilityCode`) VALUES
(1, 2, 3);

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `UserID` int(11) NOT NULL,
  `UserName` mediumtext DEFAULT NULL,
  `Phone` varchar(10) DEFAULT NULL,
  `Email` varchar(255) NOT NULL,
  `UserAddress` mediumtext DEFAULT NULL,
  `CityCode` varchar(7) DEFAULT NULL,
  `LoginID` varchar(255) DEFAULT NULL,
  `PW` varchar(255) NOT NULL,
  `Balance` decimal(10,2) DEFAULT NULL,
  `Administrator` char(1) NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`UserID`, `UserName`, `Phone`, `Email`, `UserAddress`, `CityCode`, `LoginID`, `PW`, `Balance`, `Administrator`) VALUES
(1, 'Adam Whittington', '1234567890', 'adam.whittington@torontomu.ca', NULL, NULL, 'adam.whittington', '$2y$10$aBkrMy5Pv/XcfORtX7DuguU75axjS0XRLajVI3N8G6NNcNAVvRDqC', NULL, 'Y'),
(2, 'Adam Whittington', '1111111111', 'adam.whittington@ryerson.ca', '1, 1, 1 A1A 1A1', '0', '', 'password1', NULL, 'Y'),
(3, 'Bill', '6471234567', 'bill@bill.ca', '122 Street Road', 'L3R 9E2', NULL, 'abcd1234', NULL, 'N'),
(5, 'Asd', '1230994949', 'dsfds@gmail.com', '', 'l3r8e8', NULL, '1234asdf', NULL, 'N'),
(6, 'asdasd', '3242342343', 'a@b.com', '', 'l4g0j8', NULL, 'asdf1234', NULL, 'N'),
(10, 'Andrew', '4161112222', 'andrew@email.com', '1 Andrew Road', 'A1A 0A0', NULL, 'andrew123', NULL, 'N');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Coupon`
--
ALTER TABLE `Coupon`
  ADD PRIMARY KEY (`CouponID`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`ItemID`);

--
-- Indexes for table `order_info`
--
ALTER TABLE `order_info`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `TripID` (`TripID`),
  ADD KEY `CouponID` (`CouponID`);

--
-- Indexes for table `shopping`
--
ALTER TABLE `shopping`
  ADD PRIMARY KEY (`ReceiptID`),
  ADD KEY `StoreID` (`StoreID`) USING BTREE,
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `ItemID` (`ItemID`);

--
-- Indexes for table `shopping_cart`
--
ALTER TABLE `shopping_cart`
  ADD PRIMARY KEY (`UserID`,`ItemID`),
  ADD KEY `ItemID` (`ItemID`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`StoreID`);

--
-- Indexes for table `trip`
--
ALTER TABLE `trip`
  ADD PRIMARY KEY (`TripID`),
  ADD KEY `TruckID` (`TruckID`),
  ADD KEY `OrderID` (`OrderID`) USING BTREE,
  ADD KEY `StoreID` (`StoreID`) USING BTREE;

--
-- Indexes for table `truck`
--
ALTER TABLE `truck`
  ADD PRIMARY KEY (`TruckID`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`UserID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Coupon`
--
ALTER TABLE `Coupon`
  MODIFY `CouponID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `ItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `order_info`
--
ALTER TABLE `order_info`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `shopping`
--
ALTER TABLE `shopping`
  MODIFY `ReceiptID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `store`
--
ALTER TABLE `store`
  MODIFY `StoreID` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `trip`
--
ALTER TABLE `trip`
  MODIFY `TripID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `truck`
--
ALTER TABLE `truck`
  MODIFY `TruckID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_info`
--
ALTER TABLE `order_info`
  ADD CONSTRAINT `order_info_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user_info` (`UserID`),
  ADD CONSTRAINT `order_info_ibfk_4` FOREIGN KEY (`TripID`) REFERENCES `trip` (`TripID`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_info_ibfk_5` FOREIGN KEY (`CouponID`) REFERENCES `Coupon` (`CouponID`);

--
-- Constraints for table `shopping`
--
ALTER TABLE `shopping`
  ADD CONSTRAINT `shopping_ibfk_1` FOREIGN KEY (`StoreID`) REFERENCES `store` (`StoreID`),
  ADD CONSTRAINT `shopping_ibfk_3` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`),
  ADD CONSTRAINT `shopping_ibfk_4` FOREIGN KEY (`OrderID`) REFERENCES `order_info` (`OrderID`);

--
-- Constraints for table `shopping_cart`
--
ALTER TABLE `shopping_cart`
  ADD CONSTRAINT `shopping_cart_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user_info` (`UserID`),
  ADD CONSTRAINT `shopping_cart_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`);

--
-- Constraints for table `trip`
--
ALTER TABLE `trip`
  ADD CONSTRAINT `trip_ibfk_1` FOREIGN KEY (`TruckID`) REFERENCES `truck` (`TruckID`),
  ADD CONSTRAINT `trip_ibfk_2` FOREIGN KEY (`StoreID`) REFERENCES `store` (`StoreID`),
  ADD CONSTRAINT `trip_ibfk_3` FOREIGN KEY (`OrderID`) REFERENCES `order_info` (`OrderID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
