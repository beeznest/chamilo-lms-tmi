<form
        id="formMessage"
        name="formMessage"
        method="post"
        action="{{ _p.web_self }}?{{ _p.web_cid_query }}"
        autocomplete="off"
>
    <input type="hidden" name="sent" value="1">
    <div class="message-form-chat">
        <div class="tabbable">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#tab1" data-toggle="tab">{{ 'Write'|get_lang }}</a>
                </li>
                <li>
                    <a href="#tab2" id="preview" data-toggle="tab">{{ 'Preview'|get_lang }}</a>
                </li>
                <li>
                    <a href="#tab3" id="emojis" data-toggle="tab">
                        {{ emoji_smile }}
                    </a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="tab1">
                    <textarea id="message" class="message-text" name="message" style="{{ allow_open_chat_window ? 'width: 350px; height: 80px;' : 'width: 450px; height: 35px;' }}"></textarea>
                    <div class="btn-group">
                        <button id="send" type="submit" value="{{ 'Send'|get_lang }}" class="btn btn-primary"> {{ 'Send'|get_lang }}
                        </button>
                    </div>
                </div>
                <div class="tab-pane" id="tab2">
                    <div id="html-preview" class="emoji-wysiwyg-editor-preview"></div>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
    $(document).on('ready', function () {
        {% if not _u.logged %}
            (function () {
                var chat_window = top.window.self;
                chat_window.opener = top.window.self;
                chat_window.top.close();
            })();
        {% endif %}

        $('form#formMessage').on('submit', function (e) {
            if (!$('textarea#message').val().trim().length) {
                e.preventDefault();
                alert("{{ 'TypeMessage'|get_lang }}");
                $('textarea#message').focus();
            }
        });
    });
</script>
