---
name: Swift Version Upgrade
about: Migrate to the next version of Swift
title: 'Update to Swift __'
labels: enhancement
assignees: vsanthanam

---

**Complete the following checklist**

- [ ] Change `swift-tools-version` in `Package.swift`
- [ ] Make necessary changes to framework source code.
- [ ] If applicable, change `platforms` in `Package.swift
- [ ] If applicable, update `@available` declarations
- [ ] Update README to include relevent information
- [ ] If applicable, update workflows to use updated runners
- [ ] Update workflow scripts to select the appropriate Xcode version
- [ ] Update Windows runners workflows to use latest version of Swift
- [ ] Update Ubuntu runners to use updated docker image