-- This script updates the databases structure before migrating the data from
-- version 1.8.6 to version 1.8.6.1
-- it is intended as a standalone script, however, because of the multiple
-- databases related difficulties, it should be parsed by a PHP script in
-- order to connect to and update the right databases.
-- There is one line per query, allowing the PHP function file() to read
-- all lines separately into an array. The xxMAINxx-type markers are there
-- to tell the PHP script which database we're talking about.
-- By always using the keyword "TABLE" in the queries, we should be able
-- to retrieve and modify the table name from the PHP script if needed, which
-- will allow us to deal with the unique-database-type installations
--
-- This first part is for the main database
-- xxMAINxx
INSERT INTO settings_current (variable, subkey, type, category, selected_value, title, comment, scope, subkeytext) VALUES ('allow_use_sub_language', NULL, 'radio', 'Platform', 'false', 'AllowUseSubLanguageTitle', 'AllowUseSubLanguageComment', NULL, NULL);
INSERT INTO settings_options (variable, value, display_text) VALUES ('allow_use_sub_language', 'true', 'Yes');
INSERT INTO settings_options (variable, value, display_text) VALUES ('allow_use_sub_language', 'false', 'No');
ALTER TABLE language ADD COLUMN parent_id tinyint unsigned;
ALTER TABLE language ADD INDEX idx_dokeos_folder(dokeos_folder);
INSERT INTO settings_current (variable, subkey, type, category, selected_value, title, comment, scope, subkeytext) VALUES ('show_glossary_in_documents', NULL, 'radio', 'Course', 'none', 'ShowGlossaryInDocumentsTitle', 'ShowGlossaryInDocumentsComment', NULL, NULL);
INSERT INTO settings_options (variable, value, display_text) VALUES ('show_glossary_in_documents', 'none', 'ShowGlossaryInDocumentsIsNone');
INSERT INTO settings_options (variable, value, display_text) VALUES ('show_glossary_in_documents', 'ismanual', 'ShowGlossaryInDocumentsIsManual');
INSERT INTO settings_options (variable, value, display_text) VALUES ('show_glossary_in_documents', 'isautomatic', 'ShowGlossaryInDocumentsIsAutomatic');
-- xxSTATSxx

-- xxUSERxx

-- xxCOURSExx
ALTER TABLE wiki CHANGE title title varchar(255), CHANGE reflink reflink varchar(255), ADD time_edit datetime NOT NULL default '0000-00-00 00:00:00' AFTER is_editing, ADD INDEX (title), ADD INDEX (reflink), ADD INDEX (group_id), ADD INDEX (page_id);
ALTER TABLE wiki_conf DROP id, ADD fprogress3 varchar(3) NOT NULL AFTER feedback3, ADD fprogress2 varchar(3) NOT NULL AFTER feedback3, ADD fprogress1 varchar(3) NOT NULL AFTER feedback3, ADD INDEX(page_id);