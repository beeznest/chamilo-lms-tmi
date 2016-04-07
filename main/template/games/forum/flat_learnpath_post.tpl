{% if post_data.post.text %}
    <div class="post-media" data-post="{{ post_data.post.id }}">
        <div class="row">

        <div class="col-xs-1">
            <div class="thumbnail">
                {{ post_data.user.image }}
            </div>
            <div class="info-disqus">
                <h4>
                    {{ post_data.user.link }}
                    <span class="small">•</span>
                    <span class="time timeago" title="{{ post_data.post.date }}">{{ post_data.post.date }}</span>
                </h4>
            </div>
        </div>

        <div class="col-xs-11">
            <div class="username-disqus">
                <h4>
                    {{ post_data.user.link }}
                    {% if post_data.post.reply_to %}
                        <small><i class="fa fa-share"></i> {{ post_data.post.reply_to }}</small>
                    {% endif %}
                    <span class="small">•</span>
                    <span class="time timeago" title="{{ post_data.post.date }}">{{ post_data.post.date }}</span>
                </h4>
            </div>
            <div class="description-disqus">
                {{ post_data.post.text }}
                <div class="tools-disqus">
                    {% if allow_reply %}
                        <a data-parent-post="{{ post_data.post.id }}" href="#" class="btn btn-primary btn-xs reply-disqus btn-reply-post">
                            <i class="fa fa-reply"></i> {{ "Reply"|get_lang }}
                        </a>

                        <a data-parent-post="{{ post_data.post.id }}" href="#" class="btn btn-success btn-xs quote-disqus btn-quote-post">
                            <i class="fa fa-quote-left"></i> {{ "Quote"|get_lang }}
                        </a>
                    {% endif %}

                    {% if is_allowed_to_session_edit %}
                        {% if not locked %}
                            {% if post_data.user.id == _u.id %}
                                <div class="btn-group btn-group-xs" role="toolbar">
                                    
                                    <a id="{{ post_data.post.id }}" href="#" class="btn btn-default" onclick="javascript:if (!confirm('{{ delete_confirm_message }}')) return false;">
                                        <i class="fa fa-trash-o"></i>&nbsp;
                                    </a>
                                    <script>
                                        $(document).ready(function() {
                                            $( "#{{ post_data.post.id }}" ).click(function() {
                                                $.ajax({
                                                    url: '{{ _p.web_self ~ '?' ~ _p.web_cid_query ~ '&' ~ {'a': 'delete_post', 'id': post_data.post.id}|url_encode }}',
                                                    type: 'POST',
                                                    success: function() {
                                                        location.reload();
                                                    }
                                                })
                                            });
                                        });
                                    </script>
                                </div>
                            {% endif %}
                        {% endif %}
                    {% endif %}
                </div>
            </div>

            <div id="form-reply-to-post-{{ post_data.post.id }}"></div>
        </div>
        </div>
        <div class="post-disqus"></div>
    </div>
{% endif %}

