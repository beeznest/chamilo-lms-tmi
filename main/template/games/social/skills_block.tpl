<div class="games-skill">
        {% if skills %}
            <ul class="list-badges">
                {% for skill in skills %}
                    <li>
                        <img title="{{ skill.name }}"
                             src="{{ skill.icon ? "#{_p.web_upload}badges/#{skill.icon}" : 'badges-default.png'|icon(128) }}"
                             alt="{{ skill.name }}" class="img-responsive">
                        <div class="badges-name">{{ skill.name }}</div>
                    </li>
                {% endfor %}
            </ul>
        {% else %}
            <p>{{ 'WithoutAchievedSkills'|get_lang }}</p>
        {% endif %}

</div>
