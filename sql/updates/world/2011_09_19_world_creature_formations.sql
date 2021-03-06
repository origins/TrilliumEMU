DELETE FROM `command` WHERE `name`='npc add group';
INSERT INTO `command` (`name`, `security`, `help`) VALUES
('npc add group', 1, 'Syntax: .npc add group $leader $comment $groupType\r\nAdd selected creature to a leader\'s group with groupType.\r\nYou could also add a comment...');

DELETE FROM `command` WHERE `name`='npc add formation';
INSERT INTO `command` (`name`, `security`, `help`) VALUES
('npc add formation', 1, 'Syntax: .npc add formation $leader $comment $formationAI\r\nAdd selected creature to a leader\'s formation with formationAI.\r\nYou could also add a comment...');

ALTER TABLE `creature_formations` CHANGE `groupAI` `formationAI` int(11);
ALTER TABLE `creature_formations` RENAME `creature_formations_old`;
DROP TABLE IF EXISTS `creature_formations`;
CREATE TABLE `creature_formations` (
  `formationId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Formation Unique Identifier',
  `leaderGUID` int(11) unsigned NOT NULL COMMENT 'Formation Leader Creature',
  `formationAI` int(11) DEFAULT NULL COMMENT 'Formation AI',
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`formationId`,`leaderGUID`)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Creature Formation System';
INSERT INTO `creature_formations` (`leaderGUID`,`formationAI`) SELECT `leaderGUID`, `formationAI` FROM `creature_formations_old` WHERE `memberGUID` = `leaderGUID`;
DROP TABLE IF EXISTS `creature_formation_data`;
CREATE TABLE `creature_formation_data` (
  `formationId` int(10) unsigned NOT NULL COMMENT 'Formation Unique Identifier',
  `memberGUID` int(11) unsigned NOT NULL COMMENT 'Formation Member Creature',
  `dist` float unsigned NOT NULL COMMENT 'Formation Member Distance to Leader',
  `angle` float unsigned NOT NULL COMMENT 'Formation Member Angle to Leader',
  PRIMARY KEY (`memberGUID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Creature Formation System';
INSERT INTO `creature_formation_data` (`formationId`, `memberGUID`, `dist`, `angle`)
SELECT cf.`formationId`, cfo.`memberGUID`, cfo.`dist`, cfo.`angle` FROM `creature_formations` cf LEFT JOIN `creature_formations_old` cfo ON cf.`leaderGUID` = cfo.`leaderGUID`;
DROP TABLE IF EXISTS `creature_formations_old`;

DROP TABLE IF EXISTS `creature_group_data`;
CREATE TABLE `creature_group_data` (
  `groupId` int(10) unsigned NOT NULL,
  `memberGUID` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`memberGUID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `creature_groups`;
CREATE TABLE `creature_groups` (
  `groupId` int(10) unsigned NOT NULL auto_increment,
  `leaderGUID` int(10) unsigned NOT NULL,
  `groupType` int(11) default NULL,
  `comment` varchar(255) default NULL,
  PRIMARY KEY  (`groupId`,`leaderGUID`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;