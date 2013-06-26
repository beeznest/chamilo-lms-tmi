{% macro list(items, links) %}
    <a href="{{ url(links.create_link) }}">
        Add
    </a>
    <hr />
    {% for item in items %}
        <a href="{{ url(links.read_link, { id: item.id }) }}">
         {{ item.name }}
        </a>
        <a class="btn" href="{{ url(links.update_link, { id: item.id }) }}"> Edit</a>
        <a class="btn" href="{{ url(links.delete_link, { id: item.id }) }}"> Delete</a>
        <br />
    {% endfor %}
{% endmacro %}

{% macro add(form, links) %}
    <a href="{{ url(links.list_link) }}">
        List
    </a>
    <hr />
    <form action="{{ url(links.create_link) }}" method="post" {{ form_enctype(form) }}>
        {{ form_widget(form) }}
    </form>
{% endmacro %}

{% macro edit(form, links) %}
    <a href="{{ url(links.list_link) }}">
        List
    </a>
    <form action="{{ url(links.update_link, {id : item.id}) }}" method = "post" {{ form_enctype(form) }}>
        {{ form_widget(form) }}
    </form>
{% endmacro %}

{% macro read(item, links) %}
    <a href="{{ url(links.list_link) }}">
        List
    </a>
    <a href="{{ url(links.update_link, {id : item.id}) }}">
        Edit
    </a>
    <h2> {{ item.id  }}</h2>
    <p>{{ item.name }}</p>
{% endmacro %}

