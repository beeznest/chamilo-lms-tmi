<?php
/* For licensing terms, see /license.txt */

namespace Chamilo\CoreBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Gedmo\Mapping\Annotation as Gedmo;
use Sylius\Component\Attribute\Model\AttributeValue as BaseAttributeValue;

/**
 * Class ExtraFieldValues
 *
 * @ORM\Table(name="extra_field_values")
 * @ORM\Entity(repositoryClass="Chamilo\CoreBundle\Entity\Repository\ExtraFieldValuesRepository")
 * @ORM\MappedSuperclass
 */
class ExtraFieldValues extends BaseAttributeValue
{
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer", nullable=false, unique=false)
     * @ORM\Id
     * @ORM\GeneratedValue()
     */
    protected $id;

    /**
     * @var string
     * @ORM\Column(name="value", type="string", nullable=true, unique=false)
     */
    protected $value;

    /**
     * @ORM\ManyToOne(targetEntity="Chamilo\CoreBundle\Entity\ExtraField")
     * @ORM\JoinColumn(name="field_id", referencedColumnName="id")
     **/
    protected $field;

    /**
     * @var string
     * @ORM\Column(name="item_id", type="integer", nullable=false, unique=false)
     */
    protected $itemId;

    /**
     * @var \DateTime $created
     *
     * @Gedmo\Timestampable(on="create")
     * @ORM\Column(name="created_at", type="datetime")
     */
    protected $createdAt;

    /**
     * @var \DateTime $updated
     *
     * @Gedmo\Timestampable(on="update")
     * @ORM\Column(name="updated_at", type="datetime")
     */
    protected $updatedAt;

    /**
     * @var string
     * @ORM\Column(name="comment", type="text", nullable=true, unique=false)
     */
    protected $comment;

    /**
     * Constructor
     */
    public function __construct()
    {

    }

    /**
     * @return mixed
     */
    public function getField()
    {
        return $this->field;
    }

    /**
     * @param mixed $field
     *
     * @return ExtraFieldValues
     */
    public function setField($field)
    {
        $this->field = $field;

        return $this;
    }

    /**
     * @return string
     */
    public function getItemId()
    {
        return $this->itemId;
    }

    /**
     * @param string $itemId
     *
     * @return ExtraFieldValues
     */
    public function setItemId($itemId)
    {
        $this->itemId = $itemId;

        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getCreatedAt()
    {
        return $this->createdAt;
    }

    /**
     * @param \DateTime $createdAt
     *
     * @return $this
     */
    public function setCreatedAt($createdAt)
    {
        $this->createdAt = $createdAt;

        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getUpdatedAt()
    {
        return $this->updatedAt;
    }

    /**
     * @param \DateTime $updatedAt
     *
     * @return $this
     */
    public function setUpdatedAt($updatedAt)
    {
        $this->updatedAt = $updatedAt;

        return $this;
    }

     /**
     * Set comment
     *
     * @param string $comment
      *
     * @return ExtraFieldValues
     */
    public function setComment($comment)
    {
        $this->comment = $comment;

        return $this;
    }

    /**
     * Get comment
     *
     * @return string
     */
    public function getComment()
    {
        return $this->comment;
    }

    /**
     * Get id
     *
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }
}
