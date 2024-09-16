# Odin Raylib Starter

Based on @karl-zylinski's [template](https://github.com/karl-zylinski/odin-raylib-hot-reload-game-template).
Uses [task](https://github.com/go-task/task) for automation and is more
bare-bones, code-wise.

## Usage

### Development

```bash
# Creates a `build/dev` folder for executable and libraries,
# and copies vendor libraries to that folder too.
# With `-w`, it watches for changes in `lib/**/*.odin` files,
# and recompiles the game library on detection.
task dev:lib -w 
```

Then, in another terminal:

```bash
# Runs the development executable 
task dev:run
```

Modify game library code and watch the changes show up once recompilation is done.

### Release

To build and run:

```bash
task release:build && task release:run
```

### To-do

- [ ] Clean up old game libraries after we're done with `dev:lib -w`
- [ ] Include some assets and watch for changes there as well
