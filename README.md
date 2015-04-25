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

app = Amatista::Base.new

app.get "/" do
  %(Hello World)
end

app.run 3000

```
##### [Example](https://github.com/werner/todo_crystal)
