{exec, spawn} = require 'child_process'

task 'compile', 'Compiles all coffee files', ->
  compile()

task 'watch', 'Watch for all coffee files change', ->
  watch()

task 'start', 'Start server', ->
  compile -> start()

task 'nperf', 'Start performance test', ->
  compile -> start -> nperf -> stop()


compile = (callback) ->
  exec 'coffee -c .', (err, stdout, stderr) ->
    if not err
      console.log "Compiled coffee files."
      console.log '%s%', stdout if stdout
    else
      console.log "Compilation performed with errors."
      console.log '%s%', stderr if stderr
    callback?()

watch = (callback) ->
  console.log "Watching for coffee files changes:"

  observer = spawn 'coffee', ['-w', '-c', '.'], cwd: process.cwd(), env: process.env
  observer.stdout.on 'data', (data) ->
    console.log 'Observer: %s', data

  observer.stderr.on 'data', (data) ->
    console.log 'Observer error: %s', data

  observer.on 'exit', (code) ->
    console.log 'Watching complete with code %s.', code

  callback?()

start = (callback) ->
  console.log "Start server:"

  server = spawn 'node', ['app'], cwd: process.cwd(), env: process.env
  server.stdout.on 'data', (data) ->
    console.log 'Server: %s', data

  server.stderr.on 'data', (data) ->
    console.log 'Server error: %s', data

  server.on 'exit', (code) ->
    console.log 'Server stopped with code %s.', code

  process.on 'exit', -> server.kill 'SIGHUP'

  callback?()

nperf = (callback) ->
  exec 'nperf -c 50 -n 500 http://localhost:3000/', (err, stdout, stderr) ->
    console.log 'Node-perf: %s', stdout
    throw console.log 'Node-perf errors: %s', stderr if stderr
    console.log "Node-perf test completed."
    callback?()

stop = (callback) ->
  process.exit 0