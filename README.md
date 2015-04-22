# Amatista

This is a web framework build in [Crystal](https://github.com/manastech/crystal) for building quick applications.

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
##### [Check](http://localhost:3000)
