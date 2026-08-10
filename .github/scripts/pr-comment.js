module.exports = async ({ github, context, message }) => {
  const marker = '<!-- release-preview -->';

  const body = [
    marker,
    '## Release',
    '',
    '```text',
    message,
    '```',
  ].join('\n');

  const comments = await github.paginate(
    github.rest.issues.listComments,
    {
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: context.issue.number,
      per_page: 100,
    }
  );

  const existing = comments.find(
    comment =>
      comment.user.type === 'Bot' &&
      comment.body?.includes(marker)
  );

  if (existing) {
    await github.rest.issues.updateComment({
      owner: context.repo.owner,
      repo: context.repo.repo,
      comment_id: existing.id,
      body,
    });

    return;
  }

  await github.rest.issues.createComment({
    owner: context.repo.owner,
    repo: context.repo.repo,
    issue_number: context.issue.number,
    body,
  });
};
