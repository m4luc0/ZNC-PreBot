--
-- Table structure for table `releases`
--

CREATE TABLE IF NOT EXISTS `releases` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pretime` int(11) NOT NULL,
  `release` varchar(200) NOT NULL,
  `section` varchar(20) NOT NULL,
  `files` int(5) NOT NULL DEFAULT '0',
  `size` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` int(1) NOT NULL DEFAULT '0',
  `reason` varchar(255) NOT NULL DEFAULT '',
  `group` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `release` (`release`),
  KEY `grp` (`group`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5175955 ;
