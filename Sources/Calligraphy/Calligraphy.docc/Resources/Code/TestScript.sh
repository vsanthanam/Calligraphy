$ mkdir SiteGenerator
$ cd SiteGenerator
$ swift package init --name SiteGenerator --type executable

Creating executable package: SiteGenerator
Creating Package.swift
Creating .gitignore
Creating Sources/
Creating Sources/main.swift

$ touch sitegenerator
$ chmod +x sitegenerator
$ ./sitegenerator

+ swift run --package-path . -- SiteGenerator
Building for debugging...
[1/1] Write swift-version--58304C5D6DBC2206.txt
Build of product 'SiteGenerator' complete! (0.13s)
Hello, world!
