#!/usr/bin/env python

import subprocess
import sys

from commitizen import bump, factory, git
from commitizen.config import read_cfg


def main() -> None:
    path = sys.argv[1]
    tag = sys.argv[2]

    config = read_cfg()
    cz = factory.committer_factory(config)

    delimiter = "----------commit-delimiter----------"
    log_format = f"%H%n%P%n%s%n%an%n%ae%n%b{delimiter}"

    result = subprocess.run(
        [
            "git",
            "-c",
            "log.showSignature=False",
            "log",
            f"--pretty={log_format}",
            f"{tag}..HEAD",
            "--",
            f":(top){path}",
        ],
        check=True,
        capture_output=True,
        text=True,
    )

    commits = [
        git.GitCommit.from_rev_and_commit(entry)
        for entry in result.stdout.split(f"{delimiter}\n")
        if entry.strip()
    ]

    increment = bump.find_increment(
        commits,
        regex=cz.bump_pattern,
        increments_map=cz.bump_map,
    )

    if increment:
        print(increment)


if __name__ == "__main__":
    main()
