# Contributing to Calligraphy

Thank you for your interest in contributing to Calligraphy! This document outlines our guidelines for contributing to this project.

## Design Principles

Write code that of the quality you believe would belong in the Swift Standard Library

- Clear and intuitive that leverages the latest Swift langauge features where appropriate
- Thoroughly documented with no dangled symbols.
- Consistent with Swift's standard library patterns
- Do not use names that are too general

## Platform Compatability

All code should be written with cross-platform compatibility in mind, but does not necessarily need to prioritize older versions of Swift

- Target the latest Swift toolchains.
- Avoid platform-specific APIs unless absolutely necessary.
- Use Swift standard library APIs in favor of Foundation APIs when possible.
- Keep in mind that CI for this project targets Linux and Windows. Apple platforms are most important, but we want to support as many other as we can when possible, without compromising features or the API.
- Document any platform-specific requirements or limitations, or wrap them with compiler flags when appropriate.

## External Dependencies

Avoid non-Apple third-party dependencies unless they are absolutely necessary. Most PRs that add additional dependencies are likely to not be approved without clear justification for why the dependency is necessary.

## Releasing

Releases are made by four workflows, each run by hand from `main` in the Actions tab. They act as the project's release app, which may push to `main` and to release branches.

- **Release** cuts a new version from `main`. It sets the version with `mise run set-version`, pushes that commit to `main`, creates the branch `release/X.Y.Z`, and publishes the tag and GitHub release `X.Y.Z`. Publishing the release deploys the website and attaches the documentation archive.
- **Hotfix** patches an existing release. Give it the release to patch and the commits or pull requests from `main` to cherry-pick. It applies them to that release's branch, builds and tests the result, and publishes the next patch version from the same branch. A hotfix to `3.2.0` is released as `3.2.1` on `release/3.2.0`, so the next release cut from `main` must use a higher number.
- **Set Version** changes the version on `main` or a release branch without releasing anything.
- **Kill Release** deletes a GitHub release and its tag, and optionally its release branch. It does not change the version on `main` or redeploy the website.

Release and Hotfix accept a dry run, which prepares everything and reports what would happen without pushing or publishing.

The version appears in the README, the setup article, the website configuration, and the tutorial project. `mise run version` prints it, `mise run set-version X.Y.Z` changes every copy, and `mise lint` fails if they disagree.

## Questions?

Feel free to open an issue for any questions about contributing or the project's direction. 