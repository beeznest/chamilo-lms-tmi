<div class="page-chat row">
    <div class="col-sm-4 col-md-5 col-lg-4">
        <h1 class="page-header">{{ 'Users'|get_lang }} {{ 'Connected'|get_lang }}</h1>
        <ul class="profile list-group" id="chat-users"></ul>
    </div>
    <div class="col-sm-8 col-md-7 col-lg-8">
        <div class="course-chat" id="chat-history"></div>
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
                    <li>
                        <button id="emojis" class="btn btn-link" type="button">
                            <span class="sr-only">{{ 'Emoji'|get_lang }}</span>{{ emoji_smile }}
                        </button>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab1">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <div class="col-sm-9">
                                    <span class="sr-only">{{ 'Message'|get_lang }}</span>
                                    <textarea id="chat-writer" name="message"></textarea>
                                </div>
                                <div class="col-sm-3">
                                    <button id="chat-send-message" type="button" class="btn btn-primary">{{ 'Send'|get_lang }}</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="tab-pane" id="tab2">
                        <div id="html-preview" class="emoji-wysiwyg-editor-preview"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<audio id="chat-alert">
    <source src="{{ _p.web_main }}/chat/sound/notification.wav" type="audio/wav"></source>
    <source src="{{ _p.web_main }}chat/sound/notification.ogg" type="audio/ogg"></source>
    <source src="{{ _p.web_main }}chat/sound/notification.mp3" type="audio/mpeg"></source>
</audio>
<script>
    $(document).on('ready', function () {
        var ChChat = {
            _ajaxUrl: '{{ _p.web_ajax }}course_chat.ajax.php?{{ _p.web_cid_query }}',
            _historySize: -1,
            usersOnline: 0,
            track: function () {
                return $
                    .get(ChChat._ajaxUrl, {
                        action: 'track',
                        size: ChChat._historySize,
                        users_online: ChChat.usersOnline
                    })
                    .done(function (response) {
                        if (response.data.chatIsDenied) {
                            alert("{{ 'ChatDenied'|get_lang }}");

                            return;
                        }

                        if (response.data.history) {
                            ChChat._historySize = response.data.oldFileSize;
                            ChChat.setHistory(response.data.history);
                        }

                        if (response.data.userList) {
                            ChChat.usersOnline = response.data.usersOnline;
                            ChChat.setConnectedUsers(response.data.userList);
                        }
                    });
            },
            setHistory: function (messageList) {
                $('#chat-history')
                        .html(messageList)
                        .prop('scrollTop', function () {
                            return this.scrollHeight;
                        });

                $('#chat-alert').get(0).play();
            },
            setConnectedUsers: function (userList) {
                var html = '';

                userList.forEach(function (user) {
                    var userIcon = '{{ 'user.png'|img(16, 'Student'|get_lang) }}';

                    if (user.status == 1) {
                        userIcon = '{{ 'teacher.png'|img(16, 'Teacher'|get_lang) }}';
                    }

                    html += '\
                        <li class="list-group-item chat-user">\
                            <img src="'+ user.image_url + '" width="50" alt="' + user.complete_name + '" class="user-image-chat"/>\
                            <div class="user-name">\
                                <a href="' + user.profile_url + '" target="_blank">' + user.complete_name + '</a>' + userIcon + '\
                            </div>\
                            <div class="user-email">' + user.username + '</div>\
                        </li>\
                    ';
                });

                $('#chat-users').html(html);
            },
            onPreviewListener: function () {
                $
                    .post(ChChat._ajaxUrl, {
                        action: 'preview',
                        'message': $('textarea#chat-writer').val()
                    })
                    .done(function (response) {
                        if (!response.status) {
                            return;
                        }

                        $('#html-preview').html(response.data.message);
                    });
            },
            onSendMessageListener: function (e) {
                e.preventDefault();

                $
                    .post(ChChat._ajaxUrl, {
                        'action': 'write',
                        'message': $('textarea#chat-writer').val()
                    })
                    .done(function (response) {
                        if (!response.status) {
                            return;
                        }

                        $('textarea#chat-writer').val('');
                        $(".emoji-wysiwyg-editor").html('');
                    });
            },
            onResetListener: function (e) {
                if (!confirm("{{ 'ConfirmReset'|get_lang }}")) {
                    e.preventDefault();

                    return;
                }

                $
                    .get(ChChat._ajaxUrl, {
                        action: 'reset'
                    })
                    .done(function (response) {
                        if (!response.status) {
                            return;
                        }

                        ChChat.setHistory(response.data);
                    });
            },
            init: function () {
                ChChat.track().done(function () {
                    ChChat.init();
                });
            }
        };

        hljs.initHighlightingOnLoad();

        emojione.ascii = true;
        emojione.imagePathPNG = '{{ _p.web_lib }}javascript/emojione/png/';
        emojione.imagePathSVG = '{{ _p.web_lib }}javascript/emojione/svg/';
        emojione.imagePathSVGSprites = '{{ _p.web_lib }}javascript/emojione/sprites/';

        var emojiStrategy = {{ emoji_strategy|json_encode }};

        $.emojiarea.path = '{{ _p.web_lib }}javascript/emojione/png/';
        $.emojiarea.icons = {{ icons|json_encode }};

        $('body').on('click', '#chat-reset', ChChat.onResetListener);

        $('#preview').on('click', ChChat.onPreviewListener);

        $('#emojis').on('click', function () {
            $('[data-toggle="tab"][href="#tab1"]')
                .show()
                .tab('show');
        });

        $('textarea#chat-writer').emojiarea({
            button: '#emojis'
        });
        $('textarea#chat-writer').textcomplete([
            {
                match: /\B:([\-+\w]*)$/,
                search: function (term, callback) {
                    var results = [];
                    var results2 = [];
                    var results3 = [];
                    $.each(emojiStrategy, function (shortname, data) {
                        if (shortname.indexOf(term) > -1) {
                            results.push(shortname);
                        } else {
                            if ((data.aliases !== null) && (data.aliases.indexOf(term) > -1)) {
                                results2.push(shortname);
                            } else if ((data.keywords !== null) && (data.keywords.indexOf(term) > -1)) {
                                results3.push(shortname);
                            }
                        }
                    });

                    if (term.length >= 3) {
                        results.sort(function (a, b) {
                            return (a.length > b.length);
                        });
                        results2.sort(function (a, b) {
                            return (a.length > b.length);
                        });
                        results3.sort();
                    }

                    var newResults = results.concat(results2).concat(results3);

                    callback(newResults);
                },
                template: function (shortname) {
                    return '<img class="emojione" src="{{ _p.web_lib }}javascript/emojione/png/'
                            + emojiStrategy[shortname].unicode
                            + '.png"> :' + shortname + ':';
                },
                replace: function (shortname) {
                    return ':' + shortname + ': ';
                },
                index: 1,
                maxCount: 10
            }
        ], {});

        $('button#chat-send-message').on('click', ChChat.onSendMessageListener);

        ChChat.init();
    });
</script>
