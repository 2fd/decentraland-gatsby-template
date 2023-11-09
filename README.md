# Decentraland Gatsby Template for Projects

![Decentraland Cover](https://decentraland.org/og.jpg)

## How to start

In order to start with the template, clone the project in your local an execute `npm run init` in your mac. You'll need to write if you want a docker or workers template, the project name, then it will remove the `.git` folder and init with a new git with an initial commit.

After that add the remote repository with `git remote add {repository}`.
Then execute `npm run husky-setup` to setup the husky script.

This is a template that works with Cloudflare, so in order to work with that service you'll need to add the project into there.

## Repository structure

Folders inside `src`

- src/@types
- src/api
- src/components
- src/config
- src/hooks
- src/images
- src/intl
- src/migrations
- src/modules
- src/pages
- src/utils
- src/worker
