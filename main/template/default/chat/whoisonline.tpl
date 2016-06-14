<div class="user-connected">
    <div id="user-online-scroll" class="user-online">
        <div class="title">{{ 'Users'|get_lang }} {{ 'Connected'|get_lang }}</div>
        <div class="scrollbar">
            <div class="track">
                <div class="thumb">
                    <div class="end"></div>
                </div>
            </div>
        </div>
        <div class="scrollbar-inner viewport">
            <div id="hidden" class="overview">
                <ul class="profile list-group">
                    {% for user in users %}
                        <li class="list-group-item">
                            <img src="{{ user.file_url }}" border="0" width="50" alt="" class="user-image-chat"/>
                            <div class="user-name">
                                <a href="{{ user.profile_url }}" target="_blank">{{ user.complete_name }}</a>
                                {{ user.status == 1 ? 'teacher.png'|img(16, 'Teacher'|get_lang) : 'user.png'|img(16, 'Student'|get_lang) }}
                            </div>
                            <div class="user-email">{{ user.username }}</div>
                        </li>
                    {% endfor %}
                </ul>
            </div>
        </div>
    </div>
</div>
