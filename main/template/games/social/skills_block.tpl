<div class="games-skill">
        {% if skills %}
            <ul class="list-badges">
                {% for skill in skills %}
                    <li>
                        {% if skill.icon %}
                            <img title="{{ skill.name }}" src="{{ "#{_p.web_upload}badges/#{skill.icon}" }}" alt="{{ skill.name }}">
                        {% else %}
                            <img title="{{ skill.name }}" src="{{ 'badges-default.png'|icon(128) }}" alt="{{ skill.name }}">
                        {% endif %}
                        <div class="badges-name">{{ skill.name }}</div>
                    </li>
                {% endfor %}
            </ul>
        {% else %}
            <p>{{ 'WithoutAchievedSkills'|get_lang }}</p>
        {% endif %}

</div>
