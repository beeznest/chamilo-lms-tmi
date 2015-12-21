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
                <dt>{{ "Password" | get_lang }}</dt>
                <dd>*********</dd>
                
                {% for extra_field in user.extra %}
                    
                    {% if extra_field.value.field.visible == true %}
                    <dt>{{ extra_field.value.getField().getDisplayText() }}</dt>
                    <dd>
                        
                        {% if extra_field.option %}
                            {{ extra_field.option.getDisplayText() }}
                        {% else %}
                            {{ extra_field.value.getValue() }}
                        {% endif %}
                    </dd>
                    {% endif %}
                {% endfor %}
                
            </dl>
            <div class="tool-profile">
                <a href="{{ profile_edition_link }}" class="btn btn-press btn-sm">{{ "EditProfile" | get_lang }}</a>
            </div>
        </div>
    </div>
    <div class="col-md-5">
        <div class="profile-user">
            <div class="username">{{ user.complete_name }}</div>
            {{ socialAvatarBlock }}

            {% if gamification_points %}
                <div class="points">{{ 'XPoints'|get_lang|format(gamification_points) }}</div>
            {% endif %}
        </div>
    </div>
</div>
