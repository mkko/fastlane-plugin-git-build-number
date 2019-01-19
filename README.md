# git_build_versioning plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-git_build_versioning)


## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-git_build_versioning`, add it to your project by running:

```bash
fastlane add_plugin git_build_versioning
```

## About git_build_versioning

Use git for tagging build numbers for distributed sequential builds.

This plugin will store build numbers as tags in the git repository. This makes it possible to create unique but reproducible builds in a distributed system. Storing build numbers in the git repository has several benefits over the traditional bump commits: each build is guaranteed to always have unique build number, the build numbers don't cause merge conflicts, it is very lightweight (when comparing to bump commits) and finally, it is highly visual as you can see your builds in the git history."

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```
build_number = reserve_build_number_from_git(
    prefix: 'build/', # optional
    version: '2.0.1', # optional
)
```

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
build_number = reserve_build_number_from_git(
    prefix: 'build/', # optional
    version: '2.0.1', # optional
)
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
