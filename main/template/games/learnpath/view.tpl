<div class="container">
    <header>
        <div class="row">
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                    <!-- Brand and toggle get grouped for better mobile display -->
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#menu-bar-top">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <div class="navbar-brand" href="#">
                            {{ logo }}
                        </div>
                    </div>
                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse" id="menu-bar-top">
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="{{ _p.web_main ~ 'auth/courses.php' }}"> {{ "AdminCourses"|get_lang }} </a></li>
                            {% if user_notifications is not null %}
                                <li><a class="new-messages" href="{{ message_url }}">{{ user_notifications }}</a></li>
                            {% endif %}

                            {% if _u.logged == 0 %}
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
                                        Iniciar Sesión<span class="caret"></span>
                                    </a>
                                    <ul class="dropdown-menu" role="menu">
                                        <li class="login-menu">
                                            {# if user is not login show the login form #}
                                            {% block login_form %}

                                                {% include template ~ "/layout/login_form.tpl" %}

                                            {% endblock %}
                                        </li>
                                    </ul>
                                </li>
                            {% endif %}
                            {% if _u.logged == 1 %}
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
                                        {{ _u.complete_name }}<span class="caret"></span>
                                    </a>
                                    <ul class="dropdown-menu" role="menu">

                                        {% for item in list %}
                                            {% if item['key'] != 'my-space' and item['key'] != 'dashboard' and item['key'] != 'homepage' %}
                                                <li><a href="{{ item['url'] }}">{{ item['title'] }}</a></li>

                                            {% endif %}
                                        {% endfor %}
                                        {% include template ~ "/layout/menu.tpl" %}
                                        <li class="divider"></li>
                                        <li>
                                            <a title="{{ "Logout"|get_lang }}" href="{{ logout_link }}">
                                                <i class="fa fa-sign-out"></i>{{ "Logout"|get_lang }}
                                            </a>
                                        </li>
                                    </ul>
                                </li>
                            {% endif %}
                        </ul>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
        </div>
    </header>
</div>

<div id="learning_path_main" style="width:100%; height: 100%;">
    <button id="touch-button" class="btn-touch"></button>
    <div class="container">
        <div class="row">
            <div id="learning_path_left_zone" class="sidebar-scorm">
                <div id="scorm-info" class="panel panel-default">
                    <div id="panel-scorm" class="panel-body">
                        <div id="lp_navigation_elem" class="navegation-bar">
                            <div class="ranking-scorm" id="scorm-gamification">
                                {% if gamification_mode == 1 %}
                                    <div class="row">
                                        <div class="col-md-7">
                                            {% if gamification_stars > 0%}
                                                {% for i in 1..gamification_stars %}
                                                    <i class="fa fa-star level"></i>
                                                {% endfor %}
                                            {% endif %}
                                            {% if gamification_stars < 4 %}
                                                {% for i in 1..4 - gamification_stars %}
                                                    <i class="fa fa-star plomo"></i>
                                                {% endfor %}
                                            {% endif %}
                                        </div>
                                        <div class="col-md-5 text-points">
                                            {{ "XPoints"|get_lang|format(gamification_points) }}
                                        </div>
                                    </div>
                                {% endif %}
                            </div>
                            <div id="progress_bar">
                                {{ progress_bar }}
                            </div>

                        </div>
                    </div>
                </div>


                {# TOC layout #}
                <div id="toc_id" name="toc_name">
                    <div id="learning_path_toc" class="scorm-list">{{ lp_html_toc }}</div>
                </div>
                {# end TOC layout #}

            </div>

            {# <div id="hide_bar" class="scorm-toggle" style="display:inline-block; width: 25px; height: 1000px;"></div> #}

            {# right zone #}
            <div id="learning_path_right_zone" style="height:100%" class="content-scorm">
                {% if lp_mode == 'fullscreen' %}
                    <iframe id="content_id_blank" name="content_name_blank" src="blank.php" border="0" frameborder="0" style="width: 100%; height: 100%" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>
                {% else %}
                    <iframe id="content_id" name="content_name" src="{{ iframe_src }}" border="0" frameborder="0" style="display: block; width: 100%; height: 100%" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>
                {% endif %}
                <div id="panel-forum" class="panel-forum">
                    <div class="open-forum">
                        <h4 class="comments-title">{{ "Comments"|get_lang }}</h4>
                        <i class="fa fa-chevron-down"></i>
                    </div>
                    <div class="closed-forum" style="display: none;">
                        <h4 class="comments-title">{{ "Comments"|get_lang }}</h4>

                        <i class="fa fa-chevron-up"></i>
                    </div>
                    <div id="body-forum">
                        <div id="forum-container">
                            <div class="panel-body"></div>
                        </div>
                    </div>
                </div>
            </div>
            {# end right Zone #}

            {{ navigation_bar_bottom }}
        </div>
    </div>
</div>

<script>


    //Function heigth frame content document items
    function updateResizeFrame() {
        $("#content_id").load(function() {
            var iFrameId = document.getElementById('content_id');
            var heightFrame = iFrameId.contentWindow.document.body.scrollHeight;
            if (iFrameId) {
                $("#content_id").css("height", (heightFrame + 30).toString() + 'px');
            }
        });
    }

    $(document).ready(function () {
        updateResizeFrame();
        $('#touch-button').children().click(function () {
            updateResizeFrame();
        });
        $(window).resize(function () {
            updateResizeFrame();
        });
        $('#forum-container').hide();

        loadForumThead({{ lp_id }}, {{ lp_current_item_id }});

        $("#icon-down").click(function () {
            $("#icon-up").removeClass("hidden");
            $(this).addClass("hidden");
        });

        $("#icon-up").click(function () {
            $("#icon-down").removeClass("hidden");
            $(this).addClass("hidden");
        });

        $(".scorm-items-accordion .scorm_type_document").on('click', function () {
            updateResizeFrame();

        });
        $(".scorm-items-accordion .scorm_type_quiz").click(function () {
            updateResizeFrame();
        });

        $(".open-forum").click(function () {
            $('#body-forum').css("display", "block");
            $(".open-forum").css("display", "none");
            $(".closed-forum").css("display", "block");
            var iFrameId = document.getElementById('chamilo-disqus');
            var heightFrame = iFrameId.contentWindow.document.body.scrollHeight;
            if (iFrameId) {
                $("#chamilo-disqus").css("height", (heightFrame).toString() + 'px');
            }
        });
        $(".closed-forum").click(function () {
            $('#body-forum').css("display", "none");
            $(".closed-forum").css("display", "none");
            $(".open-forum").css("display", "block");
        });

        updateResizeFrame();

    });
</script>
