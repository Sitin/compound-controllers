{exec, spawn} = require 'child_process'

task 'compile', 'Compiles all coffee files', ->
  compile()

task 'watch', 'Watch for all coffee files change', ->
  watch()

task 'start', 'Start server', ->
  compile -> start()

task 'nperf', 'Start performance test', ->
  compile -> start -> nperf -> stop()

task 'doc', 'Document CoffeeScript', ->
  doc()

task 'test', 'Test source code', ->
  compile -> test()

task 'clean', 'Remove compiled files (currently just removes all .js files)', ->
  compile -> clean()


compile = (callback) ->
  exec 'coffee -c .', (err, stdout, stderr) ->
    if not err
      console.log "Compiled coffee files."
      console.log '[compile:] %s%', stdout if stdout
    else
      console.log "Compilation performed with errors."
      console.log '[compile:error:] %s%', stderr if stderr
    callback?()


watch = (callback) ->
  console.log "Watching for coffee files changes:"

  observer = spawn 'coffee', ['-w', '-c', '.'], cwd: process.cwd(), env: process.env
  observer.stdout.on 'data', (data) ->
    console.log '[watch:] %s', data

  observer.stderr.on 'data', (data) ->
    console.log '[watch:error:] %s', data

  observer.on 'exit', (code) ->
    console.log 'Watching complete with code %s.', code

  callback?()


start = (callback) ->
  console.log "Start server:"

  server = spawn 'node', ['app'], cwd: process.cwd(), env: process.env
  server.stdout.on 'data', (data) ->
    console.log '[server:] %s', data

  server.stderr.on 'data', (data) ->
    console.log '[server:error:] %s', data

  server.on 'exit', (code) ->
    console.log 'Server stopped with code %s.', code

  process.on 'exit', -> server.kill 'SIGHUP'

  callback?()


nperf = (callback) ->
  exec 'nperf -c 50 -n 500 http://localhost:3000/', (err, stdout, stderr) ->
    console.log "[node-perf:]\n%s", stdout
    throw console.log "[node-perf:error:]\n%s", stderr if stderr
    callback?()


doc = (callback) ->
  exec 'codo', (err, stdout, stderr) ->
    console.log "[Codo:]\n%s", stdout
    throw console.log "[Codo:error:]\n%s", stderr if stderr
    callback?()


stop = (callback) ->
  process.exit 0


clean = (callback) ->
  exec 'find . -name "*.js" -maxdepth 2 -print -delete', (err, stdout, stderr) ->
    console.log "[Clean:]\n%s", stdout
    throw console.log "[Clean:error:]\n%s", stderr if stderr
    callback?()


test = (callback) ->
  console.log "Perform tests:"

  mocha = spawn './node_modules/.bin/mocha', ['test', '-u', 'bdd', '--recursive', '-c', '-R', 'spec'],
    cwd: process.cwd()
    env: process.env
    stdio: 'inherit'

  mocha.on 'exit', (code) ->
    console.log 'Tests performed with code %s.', code

  process.on 'exit', -> mocha.kill 'SIGHUP'

  callback?()