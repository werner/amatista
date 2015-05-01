# Amatista [![Build Status](https://travis-ci.org/werner/amatista.png)](https://travis-ci.org/werner/amatista)

This is a web framework build in [Crystal](https://github.com/manastech/crystal) to create quick applications.

### Projectfile

```crystal
deps do
  github "werner/amatista"
end
```

### Usage

```
require "amatista"

class HelloWorldController < Amatista::Controller
  get "/" do
    html = %(<h1> Hello World </h1>)
    respond_to(:html, html)
  end
end

class Main < Amatista::Base
end

app = Main.new

app.run 3000

```
##### [Example](https://github.com/werner/todo_crystal)
