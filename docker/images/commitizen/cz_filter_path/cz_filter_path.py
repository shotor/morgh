import os
import subprocess

from commitizen import git
from commitizen.cz.conventional_commits.conventional_commits import ConventionalCommitsCz


class FilterPathCommitizen(ConventionalCommitsCz):
  def changelog_message_builder_hook(
    self,
    parsed_message: dict,
    commit: git.GitCommit,
  ) -> dict | list | None:
    path = os.environ.get("CZ_FILTER_PATH")

    if not path:
      path = self.config.settings.get("component_path")

    if not path:
      return parsed_message

    result = subprocess.run(
      [
        "git",
        "diff-tree",
        "--root",
        "--no-commit-id",
        "--name-only",
        "-r",
        commit.rev,
        "--",
        f":(top){path}",
      ],
      capture_output=True,
      text=True,
      check=True,
    )

    if not result.stdout.strip():
      return None

    return parsed_message
