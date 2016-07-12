<div class="row">
    <div class="col-md-12">
        <div class="section-profile"><i class="fa fa-square"></i> {{ 'Profile'|get_lang }}</div>
    </div>
</div>
<div class="row">
    <div class="col-md-7">
        <div class="block">
            <dl class="dl-horizontal">
                <dt>{{ "Email" | get_lang }}</dt>
                <dd>{{ user.email}}</dd>
                {% if _u.id == user.id %}
                    <dt>{{ "Password" | get_lang }}</dt>
                    <dd>*********</dd>
                {% endif %}
                {% for extra_field in user.extra %}
                    <dt>{{ extra_field.value.getField().getDisplayText() }}</dt>
                    <dd>
                        {% if extra_field.option %}
                            {{ extra_field.option.getDisplayText() }}
                        {% else %}
                            {{ extra_field.value.getValue() }}
                        {% endif %}
                    </dd>
                {% endfor %}
            </dl>
            {% if _u.id == user.id %}
                <div class="tool-profile">
                    <a href="{{ profile_edition_link }}" class="btn btn-press btn-sm">{{ "EditProfile" | get_lang }}</a>
                </div>
            {% endif %}
        </div>
    </div>
    <div class="col-md-5">
        <div class="profile-user">
            <div class="username">{{ user.complete_name }}</div>
            {{ social_avatar_block }}

            {% if gamification_points %}
                <div class="points">{{ 'XPoints'|get_lang|format(gamification_points) }}</div>
            {% endif %}
        </div>
    </div>
</div>
