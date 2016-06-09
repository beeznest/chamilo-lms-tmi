{% set session_human_text_duration = '' %}

{% for extra_field in session_extra_fields %}
    {% if extra_field.value.getField().getVariable() == 'human_text_duration' %}
        {% set session_human_text_duration = extra_field.value.getValue() %}
    {% endif %}
{% endfor %}

<div id="about-session">
    {% if has_requirements and courses|length > 1 %}
        <div class="row">
            <div class="col-xs-12">
                <div class="panel panel-default">
                    <div class="panel-heading">{{ 'RequiredSessions'|get_lang }}</div>
                    <div class="panel-body">
                        <div class="row">
                            {% for sequence in sequences %}
                                <div class="col-md-4">
                                    <dl class="dl-horizontal">
                                        {% if sequence.requirements %}
                                            <dt>{{ sequence.name }}</dt>

                                            {% for requirement in sequence.requirements %}
                                                <dd>
                                                    <a href="{{ _p.web ~ 'session/' ~ requirement.getId ~ '/about/' }}">{{ requirement.getName }}</a>
                                                </dd>
                                            {% endfor %}
                                        {% endif %}
                                    </dl>
                                </div>
                            {% endfor %}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {% endif %}

    {% for course_data in courses %}
        {% set course_video = '' %}
        {% set course_level = '' %}

        {% for extra_field in course_data.extra_fields %}
            {% if extra_field.value.getField().getVariable() == 'video_url' %}
                {% set course_video = extra_field.value.getValue() %}
            {% elseif extra_field.value.getField().getVariable() == 'course_level' %}
                {% set course_level = extra_field.option.getDisplayText() %}
            {% endif %}
        {% endfor %}

        {% if courses|length > 1 %}
            <div class="row">
                <div class="col-xs-12">
                    <h2 class="text-uppercase">{{ course_data.course.getTitle }}</h2>
                </div>
            </div>
        {% endif %}

        <div class="row">
            {% if course_video %}
                <div class="col-sm-6 col-md-7">
                    <div class="embed-responsive embed-responsive-16by9">
                        {{ essence.replace(course_video) }}
                    </div>
                </div>
            {% endif %}

            <div class="{{ course_video ? 'col-sm-6 col-md-5' : 'col-sm-12' }}">
                <div class="block">
                    <div class="description-course">
                        
                        {{ course_data.description.getContent }}
                    </div>

                    {% if session_human_text_duration and courses|length == 1 %}
                        <div class="time-course">
                            <i class="fa fa-clock-o"></i> <span class="name">{{ 'MinHours'|get_lang }}</span> <span>{{ session_human_text_duration }}</span>
                        </div>
                    {% endif %}

                    {% if course_level %}
                        <div class="level-course">
                            <i class="fa fa-star-o"></i> <span class="name">{{ 'Level'|get_lang }}</span> <span>{{ course_level }}</span>
                        </div>
                    {% endif %}

                    {% if has_requirements and courses|length == 1 %}
                        <div class="sequence">
                            <i class="fa fa-check-square-o"></i> <span class="name">{{ 'RequiredSessions'|get_lang }}</span>
                            <div class="row">
                                {% for sequence in sequences %}
                                    {% if sequence.requirements %}
                                        <div class="col-md-6">
                                            <p class="title-sequence">{{ sequence.name }}</p>
                                            <ul>
                                                {% for requirement in sequence.requirements %}
                                                    <li>
                                                        <i class="fa fa-square"></i> <a href="{{ _p.web ~ 'session/' ~ requirement.getId ~ '/about/' }}">{{ requirement.getName }}</a>
                                                    </li>
                                                {% endfor %}
                                            </ul>
                                        </div>
                                    {% endif %}
                                {% endfor %}
                            </div>
                        </div>
                    {% endif %}

                    <div class="subscribe text-right">
                        {% if _u.logged %}
                            {% if is_subscribed %}
                                <a class="btn btn-primary" href="{{ _p.web_course ~ course_data.course.getCode ~ '/index.php?id_session=' ~ session.getId }}">
                                    <i class="fa fa-check-circle"> </i> {{ 'Continue'|get_lang }}
                                </a>
                            {% else %}
                                {{ subscribe_button }}
                            {% endif %}
                        {% else %}
                            {% if 'allow_registration'|get_setting == 'true' %}
                                <a href="{{ _p.web_main ~ 'auth/inscription.php?hide_headers=1' }}" class="btn btn-press ajax" data-title="{{ 'SignUp'|get_lang }}">
                                    <i class="fa fa-sign-in fa-fw"></i> {{ 'SignUp'|get_lang }}
                                </a>
                            {% endif %}
                        {% endif %}
                    </div>
                </div>
            </div>
        </div>
        <div class="row info-course">
            <div class="col-xs-12 col-md-12">
                <h4 class="title-section">{{ "CourseInformation"|get_lang }}</h4>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-md-7">

                <div class="panel-body">
                    {% if course_data.objectives %}
                        <div class="objective-course">
                            <h4 class="title-info"><i class="fa fa-square"></i> {{ "Objectives"|get_lang }}</h4>
                            <div class="block">
                                <div class="content-info">
                                    {{ course_data.objectives.getContent }}
                                </div>
                            </div>
                        </div>
                    {% endif %}
                    {% if course_data.topics %}
                        <div class="topics">
                            <h4 class="title-info"><i class="fa fa-square"></i> {{ "Topics"|get_lang }}</h4>
                            <div class="block">
                                <div class="content-info">
                                    {{ course_data.topics.getContent }}
                                </div>
                            </div>
                        </div>
                    {% endif %}
                </div>

            </div>

            <div class="col-xs-12 col-md-5">
                <div class="block top">
                    {% if course_data.coaches %}
                        <div class="teachers">
                            <div class="heading">
                                <h4>{{ "Coaches"|get_lang }}</h4>
                            </div>
                            <div class="panel-body">
                                {% for coach in course_data.coaches %}
                                    <div class="teachers-dates">
                                        <div class="row">
                                            <div class="col-xs-7 col-md-7">
                                                <h4><i class="fa fa-circle"></i> {{ coach.complete_name }}</h4>

                                                {% if not coach.extra_fields is empty %}
                                                    <ul class="list-unstyled">
                                                        {% set skype_account = '' %}
                                                        {% set linkedin_url = '' %}
                                                        {% for extra in coach.extra_fields %}
                                                            {% if extra.value.getField().getVariable() == 'skype' %}
                                                                {% set skype_account = extra.value.getValue() %}
                                                            {% endif %}

                                                            {% if extra.value.getField().getVariable() == 'linkedin_url' %}
                                                                {% set linkedin_url = extra.value.getValue() %}
                                                            {% endif %}
                                                        {% endfor %}

                                                        {% if 'allow_show_skype_account'|get_setting == 'true' and not skype_account is empty %}
                                                            <li class="item">
                                                                <a href="skype:{{ skype_account }}?chat">
                                                                    <span class="fa fa-skype fa-fw" aria-hidden="true"></span> {{ 'Skype'|get_lang }}
                                                                </a>
                                                            </li>
                                                        {% endif %}

                                                        {% if 'allow_show_linkedin_url'|get_setting == 'true' and not linkedin_url is empty %}
                                                            <li class="item">
                                                                <a href="{{ linkedin_url }}" target="_blank">
                                                                    <span class="fa fa-linkedin fa-fw" aria-hidden="true"></span> {{ 'LinkedIn'|get_lang }}
                                                                </a>
                                                            </li>
                                                        {% endif %}
                                                    </ul>
                                                {% endif %}
                                            </div>
                                            <div class="col-xs-5 col-md-5">
                                                <div class="text-center">
                                                    <img class="img-circle" src="{{ coach.image }}" alt="{{ coach.complete_name }}">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                {% endfor %}
                            </div>
                        </div>
                        <hr>
                    {% endif %}

                    {% if course_data.tags %}
                        <div class="categories">
                            <div class="heading"><h4>{{ 'Tags'|get_lang }}</h4></div>
                            <div class="cat-body">
                                <ul class="list-inline">
                                    {% for tag in course_data.tags %}
                                        <li>
                                            <span>{{ tag.getTag }}</span>
                                        </li>
                                    {% endfor %}
                                </ul>
                            </div>
                        </div>
                                <hr>
                    {% endif %}

                    <div class="social-share">
                        <div class="heading"><h4>¡{{ "ShareWithYourFriends"|get_lang }}!</h4></div>
                        <div class="panel-body">
                            <div class="icons-social">
                                <a href="https://www.facebook.com/sharer/sharer.php?{{ {'u': pageUrl}|url_encode }}" target="_blank"  class="btn-social">
                                    <i class="fa fa-facebook"></i>
                                </a>
                                <a href="https://twitter.com/home?{{ {'status': session.getName() ~ ' ' ~ pageUrl}|url_encode }}" target="_blank" class="btn-social">
                                    <i class="fa fa-twitter"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 col-md-offset-4 subscribe">
                {% if _u.logged and not is_subscribed %}
                    <div class="text-center">
                        {{ subscribe_button }}
                    </div>
                {% elseif not _u.logged %}
                    {% if 'allow_registration'|get_setting == 'true' %}
                        <a href="{{ _p.web_main ~ 'auth/inscription.php?hide_headers=1' }}" class="btn btn-press ajax" data-title="{{ 'SignUp'|get_lang }}">
                            <i class="fa fa-sign-in fa-fw"></i> {{ 'SignUp'|get_lang }}
                        </a>
                    {% endif %}
                {% endif %}
            </div>
        </div>
    {% endfor %}
</div>
