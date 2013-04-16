#!/usr/bin/env coffee

$ = require 'jquery'
Request = require 'request'
Util = require 'util'


# FILL THIS IN!!!
COOKIE = "_gh_sess=XXXXXXXXXX; path=/; expires=Sun, 01-Jan-2023 00:00:00 GMT; secure; HttpOnly"


make_request = (url, sel, cb) =>
  opts =
    url: url
    headers:
      'Cookie': COOKIE
  Request opts, (err, res, body) =>
    throw err if err
    repos = ($(node).attr('href') for node in $(body).find(sel))
    cb(repos.sort())

if true
  make_request 'https://github.com/wavii', '.private h3 a', (repos) ->
    #console.log "Found #{repos.length} repos"
    all_repos = [].concat(repos)
    for repo in repos
      console.log repo
      do (repo) ->
        make_request "https://github.com#{repo}/network/members", '.repo a:last-child', (forks) ->
          all_repos.concat forks
          console.log fork for fork in forks
          #console.log "Found #{forks.length} forks for #{repo}"

if true
  make_request 'https://github.com/wavii', '.public h3 a', (repos) ->
    make_request 'https://github.com/wavii?tab=members', '[itemprop=members]', (users) ->
      #console.log "Found #{repos.length} repos"
      all_repos = [].concat(repos)
      for repo in repos
        console.log repo
        do (repo) ->
          make_request "https://github.com#{repo}/network/members", '.repo a:last-child', (forks) ->
            console.log fork for fork in forks when users.indexOf("/#{fork.split('/')[1]}") >= 0
            #console.log "Found #{forks.length} forks for #{repo}"



