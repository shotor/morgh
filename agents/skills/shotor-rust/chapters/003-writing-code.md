# Writing Code

## Comments

Use comments to explain information that the code itself does not communicate clearly.

### Documentation comments

Add a doc comment (`///`) to a type or function when what it is, why it exists, or how to use it is not obvious from its name and signature.

Do not document wiring, mechanics, or information already expressed by the signature.

```rust
// bad - restates the signature
/// Returns the user with the given ID.
fn user(id: UserId) -> Result<User> {
  // ...
}

// good - explains behavior that is not obvious from the signature
/// Returns the visible user for the current request context.
///
/// Hidden users are treated as not found.
fn user(ctx: &Ctx, id: UserId) -> Result<User> {
  // ...
}
```

### Inline comments

Brief `//` comments inside bodies are appropriate for non-obvious reasoning, constraints, or intent.

Prefer comments that explain **why**, not comments that narrate **what** the next line does.

```rust
// bad - narrates the code
// Increment the retry count.
retries += 1;

// good - explains why this branch is special
// The provider may accept the request even when the connection closes early.
retries += 1;
```

Do not use comments as a substitute for clearer code. If naming or structure can make the intent obvious, prefer that.

### Security-relevant invariants

Never rely on a comment alone to preserve a security-relevant invariant.

When possible, pin the invariant with a test so an accidental change fails loudly.

```rust
const PASSWORD_HASH_COST: u32 = 12;

#[test]
fn password_hash_cost_does_not_drop() {
  assert!(PASSWORD_HASH_COST >= 12);
}
```

Comments may explain the reason for the invariant, but the test enforces it.

## Environment Variables

App-specific environment variables are prefixed with the app name.

```text
MYAPP_DATABASE_URL
MYAPP_APP_ENV
MYAPP_HTTP_PORT
```

Secret environment variables use an additional `SECRET` prefix after the app prefix.

```text
MYAPP_SECRET_DATABASE_PASSWORD
MYAPP_SECRET_API_KEY
MYAPP_SECRET_SESSION_KEY
```

Use this shape:

```text
<APP>_<NAME>
<APP>_SECRET_<NAME>
```

Environment variable names use uppercase `SCREAMING_SNAKE_CASE`.

Do not use the `SECRET` prefix merely because a value is configuration-sensitive. Reserve it for values that must be handled as secrets, such as passwords, private keys, credentials, and tokens.
