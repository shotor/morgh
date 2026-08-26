# File Structure

## Casing

Use these casing conventions consistently:

- File names use `snake_case`.
- Rust types and other named objects use `PascalCase`.
- Variables, functions, and modules use `snake_case`.
- URL paths use `kebab-case`.
- JSON fields use `camelCase`.

Prefer the convention of the target system at boundaries. For example, Rust fields may stay `snake_case` internally while serializing to `camelCase` JSON.

## Test files

Tests live beside the file they test in a sibling `__test.rs` file.

For a source file:

```text
name.rs
```

use:

```text
name__test.rs
```

Include the test module from the subject file:

```rust
#[cfg(test)]
#[path = "name__test.rs"]
mod name_test;
```

Keep the test module declaration near the end of the subject file unless another structural rule requires a different location.

Do not put substantial tests inline in the production file when they can live in the sibling test file.

```text
src/
├── user.rs
├── user__test.rs
├── order.rs
└── order__test.rs
```

```rust
// user.rs

pub struct User {
  // ...
}

#[cfg(test)]
#[path = "user__test.rs"]
mod user_test;
```

```rust
// user__test.rs

use super::*;

#[test]
fn creates_user() {
  // ...
}
```
