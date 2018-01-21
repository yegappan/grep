" File: grep.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 1.12
" Last Modified: Jan 6, 2018
" 
" Plugin to integrate grep utilities with Vim
"
if exists("loaded_grep")
    finish
endif
let loaded_grep = 1

if v:version < 700
    finish
endif

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Define the set of grep commands
command! -nargs=* -complete=file Grep
	\ call grep#runGrep('Grep', 'grep', 'set', <f-args>)
command! -nargs=* -complete=file Rgrep
	\ call grep#runGrepRecursive('Rgrep', 'grep', 'set', <f-args>)
command! -nargs=* GrepBuffer
	\ call grep#runGrepSpecial('GrepBuffer', 'buffer', 'set', <f-args>)
command! -nargs=* Bgrep
	\ call grep#runGrepSpecial('Bgrep', 'buffer', 'set', <f-args>)
command! -nargs=* GrepArgs
	\ call grep#runGrepSpecial('GrepArgs', 'args', 'set', <f-args>)

command! -nargs=* -complete=file Fgrep
	\ call grep#runGrep('Fgrep', 'fgrep', 'set', <f-args>)
command! -nargs=* -complete=file Rfgrep
	\ call grep#runGrepRecursive('Rfgrep', 'fgrep', 'set', <f-args>)
command! -nargs=* -complete=file Egrep
	\ call grep#runGrep('Egrep', 'egrep', 'set', <f-args>)
command! -nargs=* -complete=file Regrep
	\ call grep#runGrepRecursive('Regrep', 'egrep', 'set', <f-args>)
command! -nargs=* -complete=file Agrep
	\ call grep#runGrep('Agrep', 'agrep', 'set', <f-args>)
command! -nargs=* -complete=file Ragrep
	\ call grep#runGrepRecursive('Ragrep', 'agrep', 'set', <f-args>)
command! -nargs=* -complete=file Ag
	    \ call grep#runGrep('Ag', 'ag', 'set', <f-args>)

" Commands to add to existing results list
command! -nargs=* -complete=file GrepAdd
	\ call grep#runGrep('GrepAdd', 'grep', 'add', <f-args>)
command! -nargs=* -complete=file RgrepAdd
	\ call grep#runGrepRecursive('RgrepAdd', 'grep', 'add', <f-args>)
command! -nargs=* GrepBufferAdd
	\ call grep#runGrepSpecial('GrepBufferAdd', 'buffer', 'add', <f-args>)
command! -nargs=* BgrepAdd
	\ call grep#runGrepSpecial('BgrepAdd', 'buffer', 'add', <f-args>)
command! -nargs=* GrepArgsAdd
	\ call grep#runGrepSpecial('GrepArgsAdd', 'args', 'add', <f-args>)

command! -nargs=* -complete=file FgrepAdd
	\ call grep#runGrep('FgrepAdd', 'fgrep', 'add', <f-args>)
command! -nargs=* -complete=file RfgrepAdd
	\ call grep#runGrepRecursive('RfgrepAdd', 'fgrep', 'add', <f-args>)
command! -nargs=* -complete=file EgrepAdd
	\ call grep#runGrep('EgrepAdd', 'egrep', 'add', <f-args>)
command! -nargs=* -complete=file RegrepAdd
	\ call grep#runGrepRecursive('RegrepAdd', 'egrep', 'add', <f-args>)
command! -nargs=* -complete=file AgrepAdd
	\ call grep#runGrep('AgrepAdd', 'agrep', 'add', <f-args>)
command! -nargs=* -complete=file RagrepAdd
	\ call grep#runGrepRecursive('RagrepAdd', 'agrep', 'add', <f-args>)
command! -nargs=* -complete=file AgAdd
	\ call grep#runGrep('AgAdd', 'ag', 'add', <f-args>)

" Add the Tools->Search Files menu
if has('gui_running')
    anoremenu <silent> Tools.Search.Current\ Directory<Tab>:Grep
                \ :Grep<CR>
    anoremenu <silent> Tools.Search.Recursively<Tab>:Rgrep
                \ :Rgrep<CR>
    anoremenu <silent> Tools.Search.Buffer\ List<Tab>:Bgrep
                \ :Bgrep<CR>
    anoremenu <silent> Tools.Search.Argument\ List<Tab>:GrepArgs
                \ :GrepArgs<CR>
endif

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

