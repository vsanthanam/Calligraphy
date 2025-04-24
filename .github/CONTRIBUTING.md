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

## Questions?

Feel free to open an issue for any questions about contributing or the project's direction. 