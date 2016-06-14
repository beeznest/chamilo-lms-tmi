<?php
/* For licensing terms, see /license.txt */

/**
 *	Allows to type the messages that will be displayed on chat_chat.php
 *
 *	@author Olivier Brouckaert
 * 	Modified by Alex Aragón (BeezNest)
 *	@package chamilo.chat
 */
define('FRAME', 'message');

require_once '../inc/global.inc.php';

api_block_anonymous_users(true);
api_protect_course_script();

require 'header_frame.inc.php';

if (isset($_REQUEST['sent'])) {
    $courseChat = new CourseChatUtils(
        api_get_course_int_id(),
        api_get_user_id(),
        api_get_session_id(),
        api_get_group_id()
    );
    $courseChat->saveMessage($_POST['message']);
}

$view = new Template('', false, false, false, false, false, false);
$view->assign('emoji_smile', \Emojione\Emojione::toImage(':smile:'));
$view->assign('allow_open_chat_window', api_get_course_setting('allow_open_chat_window'));
$template = $view->get_template('chat/message.tpl');
$view->display($template);

require 'footer_frame.inc.php';
