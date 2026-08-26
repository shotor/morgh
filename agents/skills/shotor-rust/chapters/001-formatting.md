# Formatting

## `rustfmt`

Always start from this formatting config. Never fight the formatter. `rustfmt` always wins.

```toml
edition = "2024"

max_width = 100
tab_spaces = 2
use_small_heuristics = "Default"

newline_style = "Unix"

reorder_imports = true
reorder_modules = true
```

## General spacing principle

Favor dense code when the code is simple. Add whitespace as complexity increases.

Blank lines separate semantic steps. Code without a blank line should read as one logical unit.

Use exactly one blank line between steps. If multiple rules apply to the same boundary, they do not stack.

## Blank line before the final expression

The final expression of a body gets a blank line before it when the body contains any multi-line sibling.

Exceptions:

1. All preceding siblings are single-line.
2. The body consists only of the final expression.
3. If a comment introduces the final expression, put the blank line before the comment instead.

The goal is for a function body to read as a sequence of clear steps. A complex body should visually separate its result from the work that produces it.

```rust
// bad - the body contains a multi-line sibling, but the final expression
// runs into the previous step
fn total(items: &[Item]) -> Money {
  let subtotal = items
    .iter()
    .map(|item| item.price)
    .sum();

  let tax = subtotal * TAX;
  subtotal + tax
}

// good
fn total(items: &[Item]) -> Money {
  let subtotal = items
    .iter()
    .map(|item| item.price)
    .sum();

  let tax = subtotal * TAX;

  subtotal + tax
}

// good - all preceding siblings are single-line
fn total(items: &[Item]) -> Money {
  let subtotal = items.iter().map(|item| item.price).sum();
  let tax = subtotal * TAX;
  subtotal + tax
}

// good - the body is only the final expression
fn label(&self) -> String {
  format!("{} ({})", self.name, self.code)
}

// good - the comment belongs to the final expression,
// so the blank line goes before the comment
fn total(items: &[Item]) -> Money {
  let subtotal = items
    .iter()
    .map(|item| item.price)
    .sum();

  // Tax is applied once, on the whole subtotal.
  subtotal + subtotal * TAX
}
```

## Group consecutive `let`s, but separate multi-line ones

Consecutive single-line `let` bindings that form one setup step stay together.

A multi-line `let` binding is its own step. Put a blank line before and after it when neighboring siblings exist.

Two multi-line `let` bindings should never run directly into each other.

```rust
// good - simple setup stays dense
fn build(&self, ctx: &Ctx) -> Result<Row> {
  let db = ctx.db()?;
  let now = ctx.now();

  let row = db
    .find(self.id, now)
    .await
    .map_err(|e| err(ctx, e))?;

  Ok(row)
}

// bad - two multi-line declarations run together
fn build(&self, ctx: &Ctx) -> Result<Row> {
  let scope = match self.scope {
    Some(scope) => Some(parse(ctx, scope)?),
    None => None,
  };
  let row = db
    .find(self.id, scope)
    .await
    .map_err(|e| err(ctx, e))?;

  Ok(row)
}

// good - each multi-line declaration is its own step
fn build(&self, ctx: &Ctx) -> Result<Row> {
  let scope = match self.scope {
    Some(scope) => Some(parse(ctx, scope)?),
    None => None,
  };

  let row = db
    .find(self.id, scope)
    .await
    .map_err(|e| err(ctx, e))?;

  Ok(row)
}
```

## Blank lines around control flow

Control-flow statements get a blank line before and after when adjacent to non-control-flow siblings.

This applies to:

- `if`
- `if let`
- `let ... else`
- loops
- standalone `match`
- `match` used inside an assignment

Consecutive control-flow siblings stay grouped without blank lines between them.

Do not mechanically add blank lines inside nested blocks. A nested block should stay as dense as its local complexity allows.

```rust
// good - the consecutive if-lets form one control-flow step
fn patch(&mut self, input: Input) -> Result<()> {
  let mut row = self.load(input.id)?;

  if let Some(name) = input.name {
    row.name = name;
  }
  if let Some(rate) = input.rate {
    row.rate = rate;
  }

  self.save(row)?;

  Ok(())
}

// good - match assignment is separated from neighboring setup/result steps,
// while the nested match body stays dense
fn scope(&self, ctx: &Ctx, raw: Option<Id>) -> Result<Option<Scope>> {
  let db = ctx.db()?;

  let scope = match raw {
    Some(id) => {
      let parsed = parse(ctx, id)?;
      require_access(ctx, parsed)?;
      Some(parsed)
    }
    None => None,
  };

  Ok(scope)
}

// good - consecutive control-flow siblings stay together
fn validate(input: &Input) -> Result<()> {
  let name = input.name.trim();

  if name.is_empty() {
    return Err(Error::MissingName);
  }
  if name.len() > MAX_NAME_LEN {
    return Err(Error::NameTooLong);
  }

  Ok(())
}
```

## Blank lines around standalone operations between declarations

A standalone operation among declarations is a semantic break.

Examples include:

- authorization checks
- validation
- side effects
- mutation
- logging
- persistence

When such an operation appears between `let` bindings, isolate it with a blank line before and after.

```rust
// good
fn update(&self, ctx: &Ctx, input: Input) -> Result<Row> {
  let db = ctx.db()?;
  let id = parse(&input.id)?;

  require_access(ctx, id).await?;

  let row = db
    .update(id, input.into())
    .await
    .map_err(|e| err(ctx, e))?;

  Ok(row)
}
```

## `if` statements

Never write single-line `if` statements.

Always use braces, with the body on its own lines. The same applies to `else` and `else if`.

```rust
// bad
if !ok { return Ok(()); }

// good
if !ok {
  return Ok(());
}
```

Keep short conditions compact when `rustfmt` does so naturally. Do not add manual line breaks purely to make an `if` look larger.

```rust
// good
if user.is_admin() && request.is_safe() {
  execute(request)?;
}
```
