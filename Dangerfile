#!usr/bin/ruby
require 'set'

commit_lint.check warn: :all

swiftlint.config_file = 'Example/.swiftlint.yml'
swiftlint.lint_files inline_mode: true

xcode_summary.ignored_files = '**/Pods/**'
xcode_summary.report 'build/reports/errors.json'

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"
