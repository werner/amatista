# Amatista [![Build Status](https://travis-ci.org/werner/amatista.png)](https://travis-ci.org/werner/amatista) [![docrystal.org](http://www.docrystal.org/badge.svg?style=round)](http://www.docrystal.org/github.com/werner/amatista)

This is a web framework build in [Crystal](https://github.com/manastech/crystal) to create quick applications.

### Projectfile

```crystal
deps do
  github "werner/amatista"
end
```

### Basic Usage

```crystal
require "amatista"

class HelloWorldController < Amatista::Controller
  get "/" do
    html = %(<h1> Hello World </h1>)
    respond_to(:html, html)
  end
end

class Main < Amatista::Base
  configure do |conf|
    conf[:secret_key] = "secret"
  end
end

app = Main.new

app.run 3000
```

### View System

```crystal

class HelloWorldController < Amatista::Controller
  get "/tasks" do
    tasks = Task.all
    # You're going to need a LayoutView class as 
    # a layout for set_view method to work
    respond_to(:html, IndexView.new(tasks).set_view)
  end
  
  get "/tasks.json" do
    tasks = Task.all
    respond_to(:json, tasks.to_s.to_json)
  end
end

class LayoutView < Amatista::BaseView
  def initialize(@include)
  end

  set_ecr "layout"
end

class IndexView < Amatista::BaseView
  def initialize(@tasks)
  end

  def tasks_count
    @tasks.count
  end

  set_ecr "index"
end

#Views: 
#layout.ecr
<html>
  <head>
    <title>Todo App</title>
    <link rel="stylesheet" type="text/css" href="/app/assets/stylesheets/bootstrap-theme.min.css" media="all">
    <link rel="stylesheet" type="text/css" href="/app/assets/stylesheets/bootstrap.min.css" media="all">
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-xs-8">
          <%= @include %>
        </div>
      </div>
    </div>
    <script src="/app/assets/javascripts/jquery-2.1.3.min.js"></script>
    <script src="/app/assets/javascripts/main.js"></script>
    <script src="/app/assets/javascripts/bootstrap.min.js"></script>
  </body>
</html>

#index.ecr
<div class="panel panel-success">
  <div class="panel-heading">
    <h2 class="panel-title">Todo Tasks</h2>
  </div>

  <div class="panel-body">
    <table class="table">
      <tbody>
      <% @tasks.each do |task| %>
        <tr>
          <td>
            <%= check_box_tag(:task, "id#{task[0]}", task[0], task[2], { class: "checkTask" }) %>
            <%= label_tag("task_id#{task[0]}", task[1].to_s) %>
          </td>
          <td>
            <%= link_to("Edit", "/tasks/edit/#{task[0]}", { class: "btn btn-success btn-xs" }) %>
          </td>
          <td>
            <%= link_to("Delete", "/tasks/delete/#{task[0]}", { class: "del btn btn-danger btn-xs" }) %>
          </td>
        <tr>
      <% end %>
      <tbody>
    </table>
    <%= link_to("New Task", "/tasks/new", { class: "btn btn-info btn-xs" } ) %>
    <%= label_tag("total", "Total: #{tasks_count}" ) %>
  </div>
</div>

```
##### [Example](https://github.com/werner/todo_crystal)

## Contributing

1. Fork it ( https://github.com/[your-github-name]/project_prueba/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
