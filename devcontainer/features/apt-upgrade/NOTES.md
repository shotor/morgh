## Order

List it first among the features: the ones after it install onto the upgraded system. Features are installed in the order given (unless one declares `installsAfter`).

## Cache

A cached feature layer hands back the packages of the build that made it. Build without cache when the point is current packages, e.g. `devcontainer build --no-cache`.

## Release

`dist-upgrade` follows the apt sources, and Debian's images name the release there (`trixie`), not `stable`. So the image stays on its Debian release and moves within it: a new major release needs a new base tag.
