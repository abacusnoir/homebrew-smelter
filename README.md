# Homebrew Smelter

Official Homebrew tap for [Smelter](https://github.com/abacusnoir/smelter) - the type-safe scripting language with ~43ms startup.

## Installation

```bash
brew tap abacusnoir/smelter
brew install smelter
```

## What You Get

- `smt` command - The Smelter interpreter
- ~43ms startup time (faster than Ruby!)
- Full type safety at compile time
- ~20MB self-contained binary

## Quick Test

```bash
smt eval '(+ 2 3)'  # Returns: 5
smt --version       # Check version
smt repl            # Start interactive REPL
```

## Learn More

Visit [Smelter on GitHub](https://github.com/abacusnoir/smelter) for documentation and examples.
