# Minimum Viable Assets

This directory contains minimal assets that can be extracted and
assembled by the build tools.  These will be used in the test suites
to provide a strawman to feed to the tools.

These are stored in regular zip with the directories intact.  Once
extracted they can be assembled with assemble and then extracted with
extract.

The MVProject.project file requires all the other zip files to be
extracted before it can be used.  A project refers to Tokens,
Properties, and Macro Sets.
