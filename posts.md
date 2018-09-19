---
layout: default
permalink: /posts
url: /posts
title: Posts
show_downloads: 0
---

{% for post in site.posts %}
<div class="post-container">
  <div>
    <span>
      <a href="{{ post.baseurl }}">{{ post.title }}</a>
      <small style="color:rgb(102, 102, 102);">written by {{ post.author }}</small>
    </span>
    <span style="float:right;">{{ post.date }}</span>
    <p>
      {{ post.excerpt | remove: '<p>' | remove: '</p>' }}
    </p>
  </div>
</div>
{% endfor %}

