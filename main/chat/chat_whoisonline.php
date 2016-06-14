<?php
/* For licensing terms, see /license.txt */
/**
 *	Shows the list of connected users
 *
 *	@author Olivier Brouckaert
 *	@package chamilo.chat
 */

define('FRAME', 'online');

require_once '../inc/global.inc.php';

api_protect_course_script(true);

require 'header_frame.inc.php';

$courseId = api_get_course_int_id();
$groupId = api_get_group_id();
$sessionId = api_get_session_id();
$userId = api_get_user_id();

if ($courseId) {
    $courseChat = new CourseChatUtils($courseId, $userId, $sessionId, $groupId);
    $users = $courseChat->getConnectedUsers();
    $usersInfo = [];

    foreach ($users as $user) {
        $userStatus = CourseManager::is_course_teacher($user->getId(), api_get_course_id()) ? COURSEMANAGER : STUDENT;

        $usersInfo[] = [
            'user_id' => $user->getId(),
            'status' => $sessionId ? $user->getStatus() : $userStatus,
            'file_url' => UserManager::getUserPicture($user->getId(), USER_IMAGE_SIZE_MEDIUM),
            'profile_url' => api_get_path(WEB_CODE_PATH) . 'social/profile.php?u=' . $user->getId(),
            'complete_name' => $user->getCompleteName(),
            'username' => $user->getUsername()
        ];
    }

    $view = new Template('', false, false, false, false, false, false);
    $view->assign('users', $usersInfo);
    $template = $view->get_template('chat/whoisonline.tpl');
    $view->display($template);
}

require 'footer_frame.inc.php';
