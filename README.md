# Layer

A dead simple tool for pipelining sequences of commands that automatically cashes artifacts.

```sh
curl -L https://github.com/anana-s/layer/releases/latest/download/layer.tar.xz | tar x --zstd
```

## Requirements

`mktemp tar zstd`

## Usage

First create a base layer:

```sh
layer init base "sleep 5 && echo sweet! >> pineapple.txt"
```

Then we can execute the base layer or run commands:

```sh
./base
./base run "cat pineapple.txt"
# sweet!
```

Commands run this way are not persited.

We can stack new layers on top of existing ones:

```sh
./base to greet "cat pineapple.txt"
./greet
# sweet!
```
