# Odin Raylib Starter

Based on @karl-zylinski's [template](https://github.com/karl-zylinski/odin-raylib-hot-reload-game-template).
Uses [task](https://github.com/go-task/task) for automation and is more
bare-bones, code-wise.

## Usage

### Development

```bash
task dev:lib -w 
# This will create a new `build/dev` folder, where your executable and libraries
# (including raylib) will live.
# It will also watch for changes in `.odin` files in the `lib` folder, and 
# recompile the game library on detection.
```

Then, in another terminal:

```bash
task dev:run
# This will run the development executable 
```

Modify game library code and watch the changes show up once recompilation is done.

### Release

```bash
task release:build
```

To run:

```bash
task release:run
```
