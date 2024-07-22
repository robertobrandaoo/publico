<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_wingroups()
{
    $commonObject = new ExtensionCommon;
        // Drop table first
        $commonObject -> sqlQuery("DROP TABLE `wingroups`;");

        $commonObject -> sqlQuery(
            "CREATE TABLE `wingroups` (
                `ID` INT(11) NOT NULL AUTO_INCREMENT,
                `HARDWARE_ID` INT(11) NOT NULL,
                `GROUPNAME` VARCHAR(255) DEFAULT NULL,
                `NAME` VARCHAR(255) DEFAULT NULL,
                `TYPE` VARCHAR(255) DEFAULT NULL,
                `SOURCE` VARCHAR(255) DEFAULT NULL,
                PRIMARY KEY  (`ID`,`HARDWARE_ID`)
            ) ENGINE=InnoDB ;"
        );
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_wingroups()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE `wingroups`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_wingroups()
{

}
