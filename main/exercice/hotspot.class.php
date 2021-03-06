<?php
/* For licensing terms, see /license.txt */

/**
 * Class HotSpot
 *
 *	This class allows to instantiate an object of type HotSpot (MULTIPLE CHOICE, UNIQUE ANSWER),
 *	extending the class question
 *
 *	@author Eric Marguin
 *	@package chamilo.exercise
 **/
class HotSpot extends Question
{
	static $typePicture = 'hotspot.png';
	static $explanationLangVar = 'HotSpot';

	public function __construct()
	{
		parent::__construct();
		$this -> type = HOT_SPOT;
	}

	public function display()
	{
	}

	/**
	 * @param FormValidator $form
	 * @param int $fck_config
	 */
	public function createForm (&$form, $fck_config=0)
	{
		parent::createForm($form, $fck_config);

		if (!isset($_GET['editQuestion'])) {
			$form->addElement('file','imageUpload',array('<img src="../img/hotspots.png" />', get_lang('UploadJpgPicture')) );

			// setting the save button here and not in the question class.php
			// Saving a question
			$form->addButtonSave(get_lang('GoToQuestion'), 'submitQuestion');
			//$form->addButtonSave(get_lang('GoToQuestion'), 'submitQuestion');
			$form->addRule('imageUpload', get_lang('OnlyImagesAllowed'), 'filetype', array ('jpg', 'jpeg', 'png', 'gif'));
			$form->addRule('imageUpload', get_lang('NoImage'), 'uploadedfile');
		} else {
			// setting the save button here and not in the question class.php
			// Editing a question
			$form->addButtonUpdate(get_lang('ModifyExercise'), 'submitQuestion');
		}
	}

	/**
	 * @param FormValidator $form
	 * @param null $objExercise
	 * @return bool
	 */
	public function processCreation($form, $objExercise = null)
	{
		$file_info = $form->getSubmitValue('imageUpload');
		$_course = api_get_course_info();
		parent::processCreation($form, $objExercise);

		if(!empty($file_info['tmp_name'])) {
			$this->uploadPicture($file_info['tmp_name'], $file_info['name']);
			$documentPath  = api_get_path(SYS_COURSE_PATH).$_course['path'].'/document';
			$picturePath   = $documentPath.'/images';

			// fixed width ang height
			if (file_exists($picturePath.'/'.$this->picture)) {
				list($width,$height) = @getimagesize($picturePath.'/'.$this->picture);
				if ($width > $height) {
					$this->resizePicture('width', 545);
				} else {
					$this->resizePicture('height', 350);
				}
				$this->save();
			} else {
				return false;
			}
		}
	}

	function createAnswersForm ($form)
	{
		// nothing
	}

	function processAnswersCreation ($form)
	{
		// nothing
	}
}

/**
 * Class HotSpotDelineation
 */
class HotSpotDelineation extends HotSpot
{
	static $typePicture = 'hotspot_delineation.gif';
	static $explanationLangVar = 'HotspotDelineation';

	function __construct()
	{
		parent::__construct();
		$this -> type = HOT_SPOT_DELINEATION;

	}

	function createForm (&$form, $fck_config=0)
	{
		parent::createForm ($form, $fck_config);
	}

	function processCreation ($form, $objExercise = null)
	{
		$file_info = $form -> getSubmitValue('imageUpload');
		parent::processCreation ($form, $objExercise);
	}

	function createAnswersForm ($form)
	{
		parent::createAnswersForm ($form);
	}

	function processAnswersCreation ($form)
	{
		parent::processAnswersCreation ($form);
	}
}

