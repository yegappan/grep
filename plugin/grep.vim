" File: grep.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 2.2
" Last Modified: May 26, 2018
" 
" Plugin to integrate grep like utilities with Vim
" Supported utilities are: grep, fgrep, egrep, agrep, findstr, ag, ack,
" ripgrep, git grep, sift, platinum searcher and universal code grep
"
" License: MIT License
" Copyright (c) 2002-2018 Yegappan Lakshmanan
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
" =======================================================================
if exists("loaded_grep")
    finish
endif
let loaded_grep = 1

if v:version < 700
    " Needs vim version 7.0 and above
    finish
endif

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Define the commands for invoking various grep utilities

" grep commands
command! -nargs=* -complete=file Grep
	\ call grep#runGrep('Grep', 'grep', 'set', <f-args>)
command! -nargs=* -complete=file Rgrep
	\ call grep#runGrepRecursive('Rgrep', 'grep', 'set', <f-args>)
command! -nargs=* -complete=file GrepAdd
	\ call grep#runGrep('GrepAdd', 'grep', 'add', <f-args>)
command! -nargs=* -complete=file RgrepAdd
	\ call grep#runGrepRecursive('RgrepAdd', 'grep', 'add', <f-args>)

" fgrep commands
command! -nargs=* -complete=file Fgrep
	\ call grep#runGrep('Fgrep', 'fgrep', 'set', <f-args>)
command! -nargs=* -complete=file Rfgrep
	\ call grep#runGrepRecursive('Rfgrep', 'fgrep', 'set', <f-args>)
command! -nargs=* -complete=file FgrepAdd
	\ call grep#runGrep('FgrepAdd', 'fgrep', 'add', <f-args>)
command! -nargs=* -complete=file RfgrepAdd
	\ call grep#runGrepRecursive('RfgrepAdd', 'fgrep', 'add', <f-args>)

" egrep commands
command! -nargs=* -complete=file Egrep
	\ call grep#runGrep('Egrep', 'egrep', 'set', <f-args>)
command! -nargs=* -complete=file Regrep
	\ call grep#runGrepRecursive('Regrep', 'egrep', 'set', <f-args>)
command! -nargs=* -complete=file EgrepAdd
	\ call grep#runGrep('EgrepAdd', 'egrep', 'add', <f-args>)
command! -nargs=* -complete=file RegrepAdd
	\ call grep#runGrepRecursive('RegrepAdd', 'egrep', 'add', <f-args>)

" agrep commands
command! -nargs=* -complete=file Agrep
	\ call grep#runGrep('Agrep', 'agrep', 'set', <f-args>)
command! -nargs=* -complete=file Ragrep
	\ call grep#runGrepRecursive('Ragrep', 'agrep', 'set', <f-args>)
command! -nargs=* -complete=file AgrepAdd
	\ call grep#runGrep('AgrepAdd', 'agrep', 'add', <f-args>)
command! -nargs=* -complete=file RagrepAdd
	\ call grep#runGrepRecursive('RagrepAdd', 'agrep', 'add', <f-args>)

" Silver Searcher (ag) commands
command! -nargs=* -complete=file Ag
	    \ call grep#runGrep('Ag', 'ag', 'set', <f-args>)
command! -nargs=* -complete=file AgAdd
	\ call grep#runGrep('AgAdd', 'ag', 'add', <f-args>)

" Ripgrep (rg) commands
command! -nargs=* -complete=file Rg
	    \ call grep#runGrep('Rg', 'rg', 'set', <f-args>)
command! -nargs=* -complete=file RgAdd
	\ call grep#runGrep('RgAdd', 'rg', 'add', <f-args>)

" ack commands
command! -nargs=* -complete=file Ack
	    \ call grep#runGrep('Ack', 'ack', 'set', <f-args>)
command! -nargs=* -complete=file AckAdd
	\ call grep#runGrep('AckAdd', 'ack', 'add', <f-args>)

" git grep commands
command! -nargs=* -complete=file Gitgrep
	    \ call grep#runGrep('Gitgrep', 'git', 'set', <f-args>)
command! -nargs=* -complete=file GitgrepAdd
	\ call grep#runGrep('GitgrepAdd', 'git', 'add', <f-args>)

" sift commands
command! -nargs=* -complete=file Sift
	    \ call grep#runGrep('Sift', 'sift', 'set', <f-args>)
command! -nargs=* -complete=file SiftAdd
	\ call grep#runGrep('SiftAdd', 'sift', 'add', <f-args>)

" Platinum Searcher commands
command! -nargs=* -complete=file Ptgrep
	    \ call grep#runGrep('Ptgrep', 'pt', 'set', <f-args>)
command! -nargs=* -complete=file PtgrepAdd
	\ call grep#runGrep('PtgrepAdd', 'pt', 'add', <f-args>)

" Universal Code Grep commands
command! -nargs=* -complete=file Ucgrep
	    \ call grep#runGrep('Ucgrep', 'ucg', 'set', <f-args>)
command! -nargs=* -complete=file UcgrepAdd
	\ call grep#runGrep('UcgrepAdd', 'ucg', 'add', <f-args>)


" findstr commands
if has('win32')
    command! -nargs=* -complete=file Findstr
		\ call grep#runGrep('Findstr', 'findstr', 'set', <f-args>)
    command! -nargs=* -complete=file FindstrAdd
	    \ call grep#runGrep('FindstrAdd', 'findstr', 'add', <f-args>)
endif

" Buffer list grep commands
command! -nargs=* GrepBuffer
	\ call grep#runGrepSpecial('GrepBuffer', 'buffer', 'set', <f-args>)
command! -nargs=* Bgrep
	\ call grep#runGrepSpecial('Bgrep', 'buffer', 'set', <f-args>)
command! -nargs=* GrepBufferAdd
	\ call grep#runGrepSpecial('GrepBufferAdd', 'buffer', 'add', <f-args>)
command! -nargs=* BgrepAdd
	\ call grep#runGrepSpecial('BgrepAdd', 'buffer', 'add', <f-args>)

" Argument list grep commands
command! -nargs=* GrepArgs
	\ call grep#runGrepSpecial('GrepArgs', 'args', 'set', <f-args>)
command! -nargs=* GrepArgsAdd
	\ call grep#runGrepSpecial('GrepArgsAdd', 'args', 'add', <f-args>)

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

