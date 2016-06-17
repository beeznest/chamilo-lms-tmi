<?php
/* For licensing terms, see /license.txt */

/**
 * GamificationUtils class
 * Functions to manage the gamification mode
 * @package chamilo.library
 * @author Angel Fernando Quiroz Campos <angel.quiroz@beeznest.com>
 */
class GamificationUtils
{

    /**
     * Get the calculated points on session with gamification mode
     * @param int $userId The user ID
     * @param int $userStatus The user Status
     * @return float
     */
    public static function getTotalUserPoints($userId, $userStatus)
    {
        $points = 0;

        $sessions = SessionManager::getSessionsFollowedByUser(
            $userId,
            $userStatus
        );

        if (empty($sessions)) {
            return 0;
        }

        foreach ($sessions as $session) {
            $points += self::getSessionPoints($session['id'], $userId);
        }

        return round($points / count($sessions), 2);
    }

    /**
     * Get the achieved points for an user in a session
     * @param int $sessionId The session ID
     * @param int $userId The user ID
     *
     * @return int The count of points
     */
    public static function getSessionPoints($sessionId, $userId)
    {
        $totalPoints = 0;
        $courses = SessionManager::get_course_list_by_session_id($sessionId);

        if (empty($courses)) {
            return 0;
        }

        $cacheEnabled = function_exists('apcu_exists');
        $gameScoreVariable = 'chamilo_tademi_game_score_' . $userId . '_' . $sessionId;

        if ($cacheEnabled &&apcu_exists($gameScoreVariable)) {
            return apcu_fetch($gameScoreVariable);
        }

        foreach ($courses as $course) {
            $learnPathListObject = new LearnpathList(
                $userId,
                $course['code'],
                $sessionId
            );
            $learnPaths = $learnPathListObject->get_flat_list();

            if (empty($learnPaths)) {
                continue;
            }

            $score = 0;
            $countLP = 0;

            foreach ($learnPaths as $learnPathId => $learnPathInfo) {
                if (empty($learnPathInfo['seriousgame_mode'])) {
                    continue;
                }

                $learnPath = new learnpath(
                    $course['code'],
                    $learnPathId,
                    $userId
                );

                $score += $learnPath->getCalculateScore($sessionId);
                $countLP++;
            }

            $totalPoints += round($score / $countLP, 2);
        }

        $points = round($totalPoints / count($courses), 2);

        if ($cacheEnabled && !apcu_exists($gameScoreVariable)) {
            apcu_store($gameScoreVariable, $points, 300);
        }

        return $points;
    }

    /**
     * Get the calculated progress for an user in a session
     * @param int $sessionId The session ID
     * @param int $userId The user ID
     *
     * @return float The progress
     */
    public static function getSessionProgress($sessionId, $userId)
    {
        $courses = SessionManager::get_course_list_by_session_id($sessionId);
        $progress = 0;

        if (empty($courses)) {
            return 0;
        }

        foreach ($courses as $course) {
            $courseProgress = Tracking::get_avg_student_progress(
                $userId,
                $course['code'],
                [],
                $sessionId,
                false,
                true
            );

            if ($courseProgress === false) {
                continue;
            }

            $progress += $courseProgress;
        }

        return round($progress / count($courses), 2);
    }

    /**
     * Get the number of stars achieved for an user in a session
     * @param int $sessionId The session ID
     * @param int $userId The user ID
     *
     * @return int The number of stars
     */
    public static function getSessionStars($sessionId, $userId)
    {
        $totalStars = 0;
        $courses = SessionManager::get_course_list_by_session_id($sessionId);

        if (empty($courses)) {
            return 0;
        }

        foreach ($courses as $course) {
            $learnPathListObject = new LearnpathList(
                $userId,
                $course['code'],
                $sessionId
            );
            $learnPaths = $learnPathListObject->get_flat_list();

            if (empty($learnPaths)) {
                continue;
            }

            $stars = 0;
            $countLP = 0;

            foreach ($learnPaths as $learnPathId => $learnPathInfo) {
                if (empty($learnPathInfo['seriousgame_mode'])) {
                    continue;
                }

                $learnPath = new learnpath(
                    $course['code'],
                    $learnPathId,
                    $userId
                );

                $stars += $learnPath->getCalculateStars($sessionId);
                $countLP++;
            }

            $totalStars += round($stars / $countLP);
        }

        return round($totalStars / count($courses));
    }

    /**
     * Get the stars on sessions with gamification mode
     * @param int $userId The user ID
     * @param int $userStatus The user Status
     *
     * @return int
     */
    public static function getTotalUserStars($userId, $userStatus)
    {
        $stars = 0;

        $sessions = SessionManager::getSessionsFollowedByUser(
            $userId,
            $userStatus
        );

        if (empty($sessions)) {
            return 0;
        }

        foreach ($sessions as $session) {
            $stars += self::getSessionStars($session['id'], $userId);
        }

        return round($stars / count($sessions));
    }

    /**
     * Get the total progress on sessions with gamification mode
     * @param int $userId The user ID
     * @param int $userStatus The user Status
     *
     * @return float
     */
    public static function getTotalUserProgress($userId, $userStatus)
    {
        $progress = 0;

        $sessions = SessionManager::getSessionsFollowedByUser(
            $userId,
            $userStatus
        );

        if (empty($sessions)) {
            return 0;
        }

        foreach ($sessions as $session) {
            $progress += self::getSessionProgress($session['id'], $userId);
        }

        return round($progress / count($sessions), 2);
    }

    /**
     * Calculate the gamification ranking for a session
     * @param int $sessionId
     * @return array
     * @throws \Doctrine\ORM\ORMException
     * @throws \Doctrine\ORM\OptimisticLockException
     * @throws \Doctrine\ORM\TransactionRequiredException
     */
    public static function calcRankingPositions($sessionId)
    {
        $session = Database::getManager()
            ->find('ChamiloCoreBundle:Session', $sessionId);

        if (!$session) {
            return [];
        }

        $studentsSubscriptions = $session->getUserSubscriptionByStatus(0);
        $ranking = [];

        $cacheEnabled = function_exists('apcu_exists');

        foreach ($studentsSubscriptions as $subscription) {
            $user = $subscription->getUser();

            if (!$cacheEnabled) {
                $points = self::getSessionPoints($session->getId(), $user->getId());
            } else {
                $gameScoreVariable = 'chamilo_tademi_game_score_' . $user->getId() . '_' . $session->getId();

                if (apcu_exists($gameScoreVariable)) {
                    $points = apcu_fetch($gameScoreVariable);
                } else {
                    $points = self::getSessionPoints($session->getId(), $user->getId());
                    apcu_store($gameScoreVariable, $points, 300);
                }
            }

            $ranking[$user->getId()] = $points;
        }

        arsort($ranking);

        return array_keys($ranking);
    }

    /**
     * Get the user position in the gamification ranking for a session
     * @param int $userId
     * @param int $sessionId
     * @return int|string
     */
    public static function getUserRanking($userId, $sessionId)
    {
        $raking = self::calcRankingPositions($sessionId);

        foreach ($raking as $index => $id) {
            if ($id != $userId) {
                continue;
            }

            return $index + 1;
        }
    }
}
