<?php
/* For licensing terms, see /license.txt */

use Michelf\MarkdownExtra;

/**
 * Class CourseChat
 * Manage the chat for a course
 */
class CourseChatUtils
{
    private $groupId;
    private $courseId;
    private $sessionId;
    private $userId;

    /**
     * CourseChat constructor.
     * @param int $courseId
     * @param int $userId
     * @param int $sessionId
     * @param int $groupId
     */
    public function __construct($courseId, $userId, $sessionId = 0, $groupId = 0)
    {
        $this->courseId = intval($courseId);
        $this->userId = intval($userId);
        $this->sessionId = intval($sessionId);
        $this->groupId = intval($groupId);
    }

    /**
     * Get the connected users for a chat
     * @return array
     */
    public function getConnectedUsers()
    {
        $date = new DateTime(api_get_utc_datetime(), new DateTimeZone('UTC'));
        $date->modify('-5 minutes');

        $extraCondition = null;

        if ($this->groupId) {
            $extraCondition = 'AND ccc.toGroupId = ' . intval($this->groupId);
        } else {
            $extraCondition = 'AND ccc.sessionId = ' . intval($this->sessionId);
        }

        return Database::getManager()
            ->createQuery("
                SELECT u FROM ChamiloCourseBundle:CChatConnected ccc
                INNER JOIN ChamiloUserBundle:User u WITH ccc.userId = u
                WHERE ccc.lastConnection > :date AND ccc.cId = :course $extraCondition
            ")
            ->setParameters([
                'date' => $date,
                'course' => $this->courseId
            ])
            ->getResult();
    }

    /**
     * Prepare a message. Clean and insert emojis
     * @param string $message The message to prepare
     * @return string
     */
    public static function prepareMessage($message)
    {
        if (empty($message)) {
            return '';
        }

        Emojione\Emojione::$imagePathPNG = api_get_path(WEB_LIBRARY_PATH) . 'javascript/emojione/png/';
        Emojione\Emojione::$ascii = true;

        $message = trim($message);
        // Parsing emojis
        $message = Emojione\Emojione::toImage($message);
        // Parsing text to understand markdown (code highlight)
        $message = MarkdownExtra::defaultTransform($message);
        // Security XSS
        $message = Security::remove_XSS($message);

        return $message;
    }

    /**
     * Save a chat message in a HTML file
     * @param string $message
     * @return bool
     * @throws \Doctrine\ORM\ORMException
     * @throws \Doctrine\ORM\OptimisticLockException
     * @throws \Doctrine\ORM\TransactionRequiredException
     */
    public function saveMessage($message)
    {
        if (empty($message)) {
            return false;
        }

        $em = Database::getManager();
        $user = $em->find('ChamiloUserBundle:User', $this->userId);
        $courseInfo = api_get_course_info_by_id($this->courseId);
        $isMaster = (bool) api_is_course_admin();
        $document_path = api_get_path(SYS_COURSE_PATH) . $courseInfo['path'] . '/document';
        $basepath_chat = '/chat_files';

        if (!$this->groupId) {
            $group_info = GroupManager::get_group_properties($this->groupId);
            $basepath_chat = $group_info['directory'] . '/chat_files';
        }

        $chat_path = $document_path . $basepath_chat . '/';

        if (!is_dir($chat_path)) {
            if (is_file($chat_path)) {
                @unlink($chat_path);
            }
        }

        $date_now = date('Y-m-d');
        $timeNow = date('d/m/y H:i:s');
        $basename_chat = 'messages-' . $date_now;

        if ($this->groupId) {
            $basename_chat = 'messages-' . $date_now . '_gid-' . $this->groupId;
        } elseif ($this->sessionId) {
            $basename_chat = 'messages-' . $date_now . '_sid-' . $this->sessionId;
        }

        $message = self::prepareMessage($message);

        $fileTitle = $basename_chat . '.log.html';
        $filePath = $basepath_chat . '/' . $fileTitle;
        $absoluteFilePath = $chat_path . $fileTitle;

        if (!file_exists($absoluteFilePath)) {
            $doc_id = add_document($courseInfo, $filePath, 'file', 0, $fileTitle);
            $documentLogTypes = ['DocumentAdded', 'invisible'];

            foreach ($documentLogTypes as $logType) {
                api_item_property_update(
                    $courseInfo,
                    TOOL_DOCUMENT,
                    $doc_id,
                    $logType,
                    $this->userId,
                    $this->groupId,
                    null,
                    null,
                    null,
                    $this->sessionId
                );
            }

            item_property_update_on_folder($courseInfo, $basepath_chat, $this->userId);
        } else {
            $doc_id = DocumentManager::get_document_id($courseInfo, $filePath);
        }

        $fp = fopen($absoluteFilePath, 'a');
        $userPhoto = UserManager::getUserPicture($this->userId, USER_IMAGE_SIZE_MEDIUM);

        if ($isMaster) {
            $fileContent = '
                <div class="message-teacher">
                    <div class="content-message">
                        <div class="chat-message-block-name">' . $user->getCompleteName() . '</div>
                        <div class="chat-message-block-content">' . $message . '</div>
                        <div class="message-date">' . $timeNow . '</div>
                    </div>
                    <div class="icon-message"></div>
                    <img class="chat-image" src="' . $userPhoto . '">
                </div>
            ';
        } else {
            $fileContent = '
                <div class="message-student">
                    <img class="chat-image" src="' . $userPhoto . '">
                    <div class="icon-message"></div>
                    <div class="content-message">
                        <div class="chat-message-block-name">' . $user->getCompleteName() . '</div>
                        <div class="chat-message-block-content">' . $message . '</div>
                        <div class="message-date">' . $timeNow . '</div>
                    </div>
                </div>
            ';
        }

        fputs($fp, $fileContent);
        fclose($fp);

        $chat_size = filesize($absoluteFilePath);

        update_existing_document($courseInfo, $doc_id, $chat_size);
        item_property_update_on_folder($courseInfo, $basepath_chat, $this->userId);

        return true;
    }

    /**
     * Disconnect a user from course chats
     * @param $userId
     */
    public static function exitChat($userId)
    {
        $listCourse = CourseManager::get_courses_list_by_user_id($userId);

        foreach ($listCourse as $course) {
            Database::getManager()
                ->createQuery('
                    DELETE FROM ChamiloCourseBundle:CChatConnected ccc
                    WHERE ccc.cId = :course AND ccc.userId = :user
                ')
                ->execute([
                    'course' => intval($course['real_id']),
                    'user' => intval($userId)
                ]);
        }
    }

    /**
     * Disconnect users who are more than 5 seconds inactive
     */
    public function disconnectInactiveUsers()
    {
        $em = Database::getManager();
        $extraCondition = "AND ccc.toGroupId = {$this->groupId}";

        if (empty($this->groupId)) {
            $extraCondition = "AND ccc.sessionId = {$this->sessionId}";
        }

        $connectedUsers = $em
            ->createQuery("
                SELECT ccc FROM ChamiloCourseBundle:CChatConnected ccc
                WHERE ccc.cId = :course $extraCondition
            ")
            ->setParameter('course', $this->courseId)
            ->getResult();

        $now = new DateTime(api_get_utc_datetime(), new DateTimeZone('UTC'));
        $cd_count_time_seconds = $now->getTimestamp();

        foreach ($connectedUsers as $connection) {
            $date_count_time_seconds = $connection->getLastConnection()->getTimestamp();

            if (strcmp($now->format('Y-m-d'), $connection->getLastConnection()->format('Y-m-d')) !== 0) {
                continue;
            }

            if (($cd_count_time_seconds - $date_count_time_seconds) <= 5) {
                continue;
            }

            $em
                ->createQuery('
                    DELETE FROM ChamiloCourseBundle:CChatConnected ccc
                    WHERE ccc.cId = :course AND ccc.userId = :user AND ccc.toGroupId = :group
                ')
                ->execute([
                    'course' => $this->courseId,
                    'user' => $connection->getUserId(),
                    'group' => $this->groupId
                ]);
        }
    }

    /**
     * Keep registered to a user as connected
     * @throws \Doctrine\ORM\NonUniqueResultException
     */
    public function keepUserAsConnected()
    {
        $em = Database::getManager();
        $extraCondition = null;

        if ($this->groupId) {
            $extraCondition = 'AND ccc.toGroupId = ' . intval($this->groupId);
        } else {
            $extraCondition = 'AND ccc.sessionId = ' . intval($this->sessionId);
        }

        $currentTime = new DateTime(api_get_utc_datetime(), new DateTimeZone('UTC'));

        $connection = $em
            ->createQuery("
                SELECT ccc FROM ChamiloCourseBundle:CChatConnected ccc
                WHERE ccc.userId = :user AND ccc.cId = :course $extraCondition 
            ")
            ->setParameters([
                'user' => $this->userId,
                'course' => $this->courseId
            ])
            ->getOneOrNullResult();

        if ($connection) {
            $connection->setLastConnection($currentTime);
            $em->merge($connection);
            $em->flush();

            return;
        }

        $connection = new \Chamilo\CourseBundle\Entity\CChatConnected();
        $connection
            ->setCId($this->courseId)
            ->setUserId($this->userId)
            ->setLastConnection($currentTime)
            ->setSessionId($this->sessionId)
            ->setToGroupId($this->groupId);

        $em->persist($connection);
        $em->flush();
    }

    /**
     * Check if the connection is denied for chat
     * @return bool
     * @throws \Doctrine\ORM\ORMException
     * @throws \Doctrine\ORM\OptimisticLockException
     * @throws \Doctrine\ORM\TransactionRequiredException
     */
    public function isChatDenied()
    {
        if (ChamiloSession::read('origin', null) !== 'whoisonline') {
            return false;
        }

        $talkTo = ChamiloSession::read('target', 0);

        if (!$talkTo) {
            return true;
        }

        $em = Database::getManager();
        $user = $em->find('ChamiloUserBundle:User', $talkTo);

        if ($user->getChatcallText() === 'DENIED') {
            $user
                ->setChatcallDate(null)
                ->setChatcallUserId(null)
                ->setChatcallText(null);

            $em->merge($user);
            $em->flush();

            return true;
        }

        return false;
    }
}
