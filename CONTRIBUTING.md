# Contributing

Charmfile favors small, testable improvements over broad agent frameworks.

1. Open an issue describing the user problem and the smallest layer that should
   own it.
2. Keep skills focused and concise.
3. Add scripts only when deterministic behavior is necessary.
4. Preserve explicit approval for writes, live-account changes, and
   destructive actions.
5. Add third-party attribution before importing or adapting external work.
6. Run:

   ```sh
   ./scripts/validate-release.sh
   ```

7. Include the checks run and any remaining risk in the pull request.

Contributions must not contain secrets, customer data, raw transcripts,
personal hostnames, private vault content, or temporary account metrics.
