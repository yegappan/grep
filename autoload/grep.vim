" File: grep.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 2.2
" Last Modified: June 14, 2020
" 
" Plugin to integrate grep like utilities with Vim
" Supported utilities are: grep, fgrep, egrep, agrep, findstr, ag, ack,
" ripgrep, git grep, sift, platinum searcher and universal code grep.
"
" License: MIT License
" Copyright (c) 2002-2020 Yegappan Lakshmanan
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

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Location of the grep utility
if !exists("Grep_Path")
    let Grep_Path = 'grep'
endif

" Location of the fgrep utility
if !exists("Fgrep_Path")
    let Fgrep_Path = 'fgrep'
endif

" Location of the egrep utility
if !exists("Egrep_Path")
    let Egrep_Path = 'egrep'
endif

" Location of the agrep utility
if !exists("Agrep_Path")
    let Agrep_Path = 'agrep'
endif

" Location of the Silver Searcher (ag) utility
if !exists("Ag_Path")
    let Ag_Path = 'ag'
endif

" Location of the Ripgrep (rg) utility
if !exists("Rg_Path")
    let Rg_Path = 'rg'
endif

" Location of the ack utility
if !exists("Ack_Path")
    let Ack_Path = 'ack'
endif

" Location of the findstr utility
if !exists("Findstr_Path")
    let Findstr_Path = 'findstr.exe'
endif

" Location of the git utility used by the git grep command
if !exists("Git_Path")
    let Git_Path = 'git'
endif

" Location of the sift utility
if !exists("Sift_Path")
    let Sift_Path = 'sift'
endif

" Location of the platinum searcher utility
if !exists("Pt_Path")
    let Pt_Path = 'pt'
endif

" Location of the Universal Code Grep (UCG) utility
if !exists("Ucg_Path")
    let Ucg_Path = 'ucg'
endif

" grep options
if !exists("Grep_Options")
    let Grep_Options = ''
endif

" fgrep options
if !exists("Fgrep_Options")
    let Fgrep_Options = ''
endif

" egrep options
if !exists("Egrep_Options")
    let Egrep_Options = ''
endif

" agrep options
if !exists("Agrep_Options")
    let Agrep_Options = ''
endif

" ag options
if !exists("Ag_Options")
    let Ag_Options = ''
endif

" ripgrep options
if !exists("Rg_Options")
    let Rg_Options = ''
endif

" ack options
if !exists("Ack_Options")
    let Ack_Options = ''
endif

" findstr options
if !exists("Findstr_Options")
    let Findstr_Options = ''
endif

" git grep options
if !exists("Gitgrep_Options")
    let Gitgrep_Options = ''
endif

" sift options
if !exists("Sift_Options")
    let Sift_Options = ''
endif

" pt options
if !exists("Pt_Options")
    let Pt_Options = ''
endif

" ucg options
if !exists("Ucg_Options")
    let Ucg_Options = ''
endif

" Location of the find utility
if !exists("Grep_Find_Path")
    let Grep_Find_Path = 'find'
endif

" Location of the xargs utility
if !exists("Grep_Xargs_Path")
    let Grep_Xargs_Path = 'xargs'
endif

" Open the Grep output window.  Set this variable to zero, to not open
" the Grep output window by default.  You can open it manually by using
" the :cwindow command.
if !exists("Grep_OpenQuickfixWindow")
    let Grep_OpenQuickfixWindow = 1
endif

" Default grep file list
if !exists("Grep_Default_Filelist")
    let Grep_Default_Filelist = '*'
endif

" Use the 'xargs' utility in combination with the 'find' utility. Set this
" to zero to not use the xargs utility.
if !exists("Grep_Find_Use_Xargs")
    let Grep_Find_Use_Xargs = 1
endif

" The command-line arguments to supply to the xargs utility
if !exists('Grep_Xargs_Options')
    let Grep_Xargs_Options = '-0'
endif

" The find utility is from the cygwin package or some other find utility.
if !exists("Grep_Cygwin_Find")
    let Grep_Cygwin_Find = 0
endif

" NULL device name to supply to grep.  We need this because, grep will not
" print the name of the file, if only one filename is supplied. We need the
" filename for Vim quickfix processing.
if !exists("Grep_Null_Device")
    if has('win32')
	let Grep_Null_Device = 'NUL'
    else
	let Grep_Null_Device = '/dev/null'
    endif
endif

" Character to use to escape special characters before passing to grep.
if !exists("Grep_Shell_Escape_Char")
    if has('win32')
	let Grep_Shell_Escape_Char = ''
    else
	let Grep_Shell_Escape_Char = '\'
    endif
endif

" The list of directories to skip while searching for a pattern. Set this
" variable to '', if you don't want to skip directories.
if !exists("Grep_Skip_Dirs")
    let Grep_Skip_Dirs = 'RCS CVS SCCS'
endif

" The list of files to skip while searching for a pattern. Set this variable
" to '', if you don't want to skip any files.
if !exists("Grep_Skip_Files")
    let Grep_Skip_Files = '*~ *,v s.*'
endif

" Run the grep commands asynchronously and update the quickfix list with the
" results in the background. Needs Vim version 8.0 and above.
if !exists('Grep_Run_Async')
    " Check whether we can run the grep command asynchronously.
    if v:version >= 800
	let Grep_Run_Async = 1
	" Check whether we can use the quickfix identifier to add the grep
	" output to a specific quickfix list.
	if v:version >= 801 || has('patch-8.0.1023')
	    let s:Grep_Use_QfID = 1
	else
	    let s:Grep_Use_QfID = 0
	endif
    else
	let Grep_Run_Async = 0
    endif
endif

" Table containing information about various grep commands.
"   command path, option prefix character, command options and the search
"   pattern expression option
let s:cmdTable = {
	    \   'grep' : {
	    \     'cmdpath' : g:Grep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-s -n',
	    \     'opts' : g:Grep_Options,
	    \     'expropt' : '--',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'fgrep' : {
	    \     'cmdpath' : g:Fgrep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-s -n',
	    \     'opts' : g:Fgrep_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'egrep' : {
	    \     'cmdpath' : g:Egrep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-s -n',
	    \     'opts' : g:Egrep_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'agrep' : {
	    \     'cmdpath' : g:Agrep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-n',
	    \     'opts' : g:Agrep_Options,
	    \     'expropt' : '',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'ag' : {
	    \     'cmdpath' : g:Ag_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--vimgrep',
	    \     'opts' : g:Ag_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   },
	    \   'rg' : {
	    \     'cmdpath' : g:Rg_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--vimgrep',
	    \     'opts' : g:Rg_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : ''
	    \   },
	    \   'ack' : {
	    \     'cmdpath' : g:Ack_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-H --column --nofilter --nocolor --nogroup',
	    \     'opts' : g:Ack_Options,
	    \     'expropt' : '--match',
	    \     'nulldev' : ''
	    \   },
	    \   'findstr' : {
	    \     'cmdpath' : g:Findstr_Path,
	    \     'optprefix' : '/',
	    \     'defopts' : '/N',
	    \     'opts' : g:Findstr_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   },
	    \   'git' : {
	    \     'cmdpath' : g:Git_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : 'grep --no-color -n',
	    \     'opts' : g:Gitgrep_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : ''
	    \   },
	    \   'sift' : {
	    \     'cmdpath' : g:Sift_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--no-color -n --filename --binary-skip',
	    \     'opts' : g:Sift_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : ''
	    \   },
	    \   'pt' : {
	    \     'cmdpath' : g:Pt_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--nocolor --nogroup',
	    \     'opts' : g:Pt_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   },
	    \   'ucg' : {
	    \     'cmdpath' : g:Ucg_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--nocolor',
	    \     'opts' : g:Ucg_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   }
	    \ }

" warnMsg
" Display a warning message
func! s:warnMsg(msg) abort
    echohl WarningMsg | echomsg a:msg | echohl None
endfunc

let s:grep_cmd_job = 0
let s:grep_tempfile = ''

" deleteTempFile()
" Delete the temporary file created on MS-Windows to run the grep command
func! s:deleteTempFile() abort
    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	if exists('s:grep_tempfile') && s:grep_tempfile != ''
	    " Delete the temporary cmd file created on MS-Windows
	    call delete(s:grep_tempfile)
	    let s:grep_tempfile = ''
	endif
    endif
endfunc

" grep#cmd_output_cb()
" Add output (single line) from a grep command to the quickfix list
func! grep#cmd_output_cb(qf_id, channel, msg) abort
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
	call s:warnMsg('Error: Job not found in grep command output callback')
	return
    endif

    " Check whether the quickfix list is still present
    if s:Grep_Use_QfID
	let l = getqflist({'id' : a:qf_id})
	if !has_key(l, 'id') || l.id == 0
	    " Quickfix list is not present. Stop the search.
	    call job_stop(job)
	    return
	endif

	call setqflist([], 'a', {'id' : a:qf_id,
		    \ 'efm' : '%f:%\\s%#%l:%c:%m,%f:%\s%#%l:%m',
		    \ 'lines' : [a:msg]})
    else
	let old_efm = &efm
	set efm=%f:%\\s%#%l:%c:%m,%f:%\\s%#%l:%m
	caddexpr a:msg . "\n"
	let &efm = old_efm
    endif
endfunc

" grep#chan_close_cb
" Close callback for the grep command channel. No more grep output is
" available.
func! grep#chan_close_cb(qf_id, channel) abort
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
	call s:warnMsg('Error: Job not found in grep channel close callback')
	return
    endif
    let emsg = '[Search command exited with status ' . job_info(job).exitval . ']'

    " Check whether the quickfix list is still present
    if s:Grep_Use_QfID
	let l = getqflist({'id' : a:qf_id})
	if has_key(l, 'id') && l.id == a:qf_id
	    call setqflist([], 'a', {'id' : a:qf_id,
			\ 'efm' : '%f:%\s%#%l:%m',
			\ 'lines' : [emsg]})
	endif
    else
	caddexpr emsg
    endif
endfunc

" grep#cmd_exit_cb()
" grep command exit handler
func! grep#cmd_exit_cb(qf_id, job, exit_status) abort
    " Process the exit status only if the grep cmd is not interrupted
    " by another grep invocation
    if s:grep_cmd_job == a:job
	let s:grep_cmd_job = 0
	call s:deleteTempFile()
    endif
endfunc

" runGrepCmdAsync()
" Run the grep command asynchronously
func! s:runGrepCmdAsync(cmd, pattern, action) abort
    if s:grep_cmd_job isnot 0
	" If the job is already running for some other search, stop it.
	call job_stop(s:grep_cmd_job)
	caddexpr '[Search command interrupted]'
    endif

    let title = '[Search results for ' . a:pattern . ']'
    if a:action == 'add'
	caddexpr title . "\n"
    else
	cgetexpr title . "\n"
    endif
    "caddexpr 'Search cmd: "' . a:cmd . '"'
    call setqflist([], 'a', {'title' : title})
    " Save the quickfix list id, so that the grep output can be added to
    " the correct quickfix list
    let l = getqflist({'id' : 0})
    if has_key(l, 'id')
	let qf_id = l.id
    else
	let qf_id = -1
    endif

    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	let cmd_list = [a:cmd]
    else
	let cmd_list = [&shell, &shellcmdflag, a:cmd]
    endif
    let s:grep_cmd_job = job_start(cmd_list,
		\ {'callback' : function('grep#cmd_output_cb', [qf_id]),
		\ 'close_cb' : function('grep#chan_close_cb', [qf_id]),
		\ 'exit_cb' : function('grep#cmd_exit_cb', [qf_id]),
		\ 'in_io' : 'null'})

    if job_status(s:grep_cmd_job) == 'fail'
	let s:grep_cmd_job = 0
	call s:warnMsg('Error: Failed to start the grep command')
	call s:deleteTempFile()
	return
    endif

    " Open the grep output window
    if g:Grep_OpenQuickfixWindow == 1
	" Open the quickfix window below the current window
	botright copen
    endif
endfunc

" runGrepCmd()
" Run the specified grep command using the supplied pattern
func! s:runGrepCmd(cmd, pattern, action) abort
    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	" Windows does not correctly deal with commands that have more than 1
	" set of double quotes.  It will strip them all resulting in:
	" 'C:\Program' is not recognized as an internal or external command
	" operable program or batch file.  To work around this, place the
	" command inside a batch file and call the batch file.
	" Do this only on Win2K, WinXP and above.
	let s:grep_tempfile = fnamemodify(tempname(), ':h:8') . '\mygrep.cmd'
	call writefile(['@echo off', a:cmd], s:grep_tempfile)

	if g:Grep_Run_Async
	    call s:runGrepCmdAsync(s:grep_tempfile, a:pattern, a:action)
	    return
	endif
	let cmd_output = system('"' . s:grep_tempfile . '"')

	if exists('s:grep_tempfile')
	    " Delete the temporary cmd file created on MS-Windows
	    call delete(s:grep_tempfile)
	endif
    else
	if g:Grep_Run_Async
	    return s:runGrepCmdAsync(a:cmd, a:pattern, a:action)
	endif
	let cmd_output = system(a:cmd)
    endif

    " Do not check for the shell_error (return code from the command).
    " Even if there are valid matches, grep returns error codes if there
    " are problems with a few input files.

    if cmd_output == ''
	call s:warnMsg('Error: Pattern ' . a:pattern . ' not found')
	return
    endif

    let tmpfile = tempname()

    let old_verbose = &verbose
    set verbose&vim

    exe 'redir! > ' . tmpfile
    silent echon '[Search results for pattern: ' . a:pattern . "]\n"
    silent echon cmd_output
    redir END

    let &verbose = old_verbose

    let old_efm = &efm
    set efm=%f:%\\s%#%l:%c:%m,%f:%\\s%#%l:%m

    if a:action == 'add'
	execute 'silent! caddfile ' . tmpfile
    else
	execute 'silent! cgetfile ' . tmpfile
    endif

    let &efm = old_efm

    " Open the grep output window
    if g:Grep_OpenQuickfixWindow == 1
	" Open the quickfix window below the current window
	botright copen
    endif

    call delete(tmpfile)
endfunc

" parseArgs()
" Parse arguments to the grep command. The expected order for the various
" arguments is:
" 	<grep_option[s]> <search_pattern> <file_pattern[s]>
" grep command-line flags are specified using the "-flag" format.
" the next argument is assumed to be the pattern.
" and the next arguments are assumed to be filenames or file patterns.
func! s:parseArgs(cmd_name, args) abort
    let cmdopt = ''
    let pattern = ''
    let filepattern = ''

    let optprefix = s:cmdTable[a:cmd_name].optprefix

    for one_arg in a:args
	if one_arg[0] == optprefix && pattern == ''
	    " Process grep arguments at the beginning of the argument list
	    let cmdopt = cmdopt . ' ' . one_arg
	elseif pattern == ''
	    " Only one search pattern can be specified
	    let pattern = shellescape(one_arg)
	else
	    " More than one file patterns can be specified
	    if filepattern != ''
		let filepattern = filepattern . ' ' . one_arg
	    else
		let filepattern = one_arg
	    endif
	endif
    endfor

    return [cmdopt, pattern, filepattern]
endfunc

" recursive_search_cmd
" Returns TRUE if a command recursively searches by default.
func! s:recursive_search_cmd(cmd_name) abort
    return a:cmd_name == 'ag' ||
		\ a:cmd_name == 'rg' ||
		\ a:cmd_name == 'ack' ||
		\ a:cmd_name == 'git' ||
		\ a:cmd_name == 'pt' ||
		\ a:cmd_name == 'ucg'
endfunc

" formFullCmd()
" Generate the full command to run based on the user supplied command name,
" options, pattern and file names.
func! s:formFullCmd(cmd_name, useropts, pattern, filenames) abort
    if !has_key(s:cmdTable, a:cmd_name)
	call s:warnMsg('Error: Unsupported command ' . a:cmd_name)
	return ''
    endif

    if has('win32')
	" On MS-Windows, convert the program pathname to 8.3 style pathname.
	" Otherwise, using a path with space characters causes problems.
	let s:cmdTable[a:cmd_name].cmdpath =
		    \ fnamemodify(s:cmdTable[a:cmd_name].cmdpath, ':8')
    endif

    let cmdopt = s:cmdTable[a:cmd_name].defopts
    if s:cmdTable[a:cmd_name].opts != ''
	let cmdopt = cmdopt . ' ' . s:cmdTable[a:cmd_name].opts
    endif
    if a:useropts != ''
	let cmdopt = cmdopt . ' ' . a:useropts
    endif
    if s:cmdTable[a:cmd_name].expropt != ''
	let cmdopt = cmdopt . ' ' . s:cmdTable[a:cmd_name].expropt
    endif

    let fullcmd = s:cmdTable[a:cmd_name].cmdpath . ' ' .
		\ cmdopt . ' ' .
		\ a:pattern

    if a:filenames != ''
	let fullcmd = fullcmd . ' ' . a:filenames
    endif

    if s:cmdTable[a:cmd_name].nulldev != ''
	let fullcmd = fullcmd . ' ' . s:cmdTable[a:cmd_name].nulldev
    endif

    return fullcmd
endfunc

" getListOfBufferNames()
" Get the file names of all the listed and valid buffer names 
func! s:getListOfBufferNames() abort
    let filenames = ''

    " Get a list of all the buffer names
    for i in range(1, bufnr("$"))
	if bufexists(i) && buflisted(i)
	    let fullpath = fnamemodify(bufname(i), ':p')
	    if filereadable(fullpath)
		if v:version >= 702
		    let filenames = filenames . ' ' . fnameescape(fullpath)
		else
		    let filenames = filenames . ' ' . fullpath
		endif
	    endif
	endif
    endfor

    return filenames
endfunc

" getListOfArgFiles()
" Get the names of all the files in the argument list
func! s:getListOfArgFiles() abort
    let filenames = ''

    let arg_cnt = argc()
    if arg_cnt != 0
	for i in range(0, arg_cnt - 1)
	    let filenames = filenames . ' ' . argv(i)
	endfor
    endif

    return filenames
endfunc

" grep#runGrepRecursive()
" Run specified grep command recursively
func! grep#runGrepRecursive(cmd_name, grep_cmd, action, ...) abort
    if a:0 > 0 && (a:1 == '-?' || a:1 == '-h')
	echo 'Usage: ' . a:cmd_name . ' [<options>] [<search_pattern> ' .
		    \ '[<file_name(s)>]]'
	return
    endif

    " Parse the arguments and get the grep options, search pattern
    " and list of file names/patterns
    let [opts, pattern, filenames] = s:parseArgs(a:grep_cmd, a:000)

    " No argument supplied. Get the identifier and file list from user
    if pattern == '' 
	let pattern = input('Search for pattern: ', expand('<cword>'))
	if pattern == ''
	    return
	endif
	let pattern = shellescape(pattern)
	echo "\r"
    endif

    let cwd = getcwd()
    if g:Grep_Cygwin_Find == 1
	let cwd = substitute(cwd, "\\", "/", 'g')
    endif
    let startdir = input('Start searching from directory: ', cwd, 'dir')
    if startdir == ''
	return
    endif
    echo "\r"

    if !isdirectory(startdir)
	call s:warnMsg('Error: Directory ' . startdir . " doesn't exist")
	return
    endif

    " To compare against the current directory, convert to full path
    let startdir = fnamemodify(startdir, ':p:h')

    if startdir == cwd
	let startdir = '.'
    else
	" On MS-Windows, convert the directory name to 8.3 style pathname.
	" Otherwise, using a path with space characters causes problems.
	if has('win32')
	    let startdir = fnamemodify(startdir, ':8')
	endif
    endif

    if filenames == ''
	let filenames = input('Search in files matching pattern: ', 
		    \ g:Grep_Default_Filelist)
	if filenames == ''
	    return
	endif
	echo "\r"
    endif

    let find_file_pattern = ''
    for one_pattern in split(filenames, ' ')
	if find_file_pattern != ''
	    let find_file_pattern = find_file_pattern . ' -o'
	endif
	let find_file_pattern = find_file_pattern . ' -name ' .
		    \ shellescape(one_pattern)
    endfor
    let find_file_pattern = g:Grep_Shell_Escape_Char . '(' .
		\ find_file_pattern . ' ' . g:Grep_Shell_Escape_Char . ')'

    let find_prune = ''
    if g:Grep_Skip_Dirs != ''
	for one_dir in split(g:Grep_Skip_Dirs, ' ')
	    if find_prune != ''
		let find_prune = find_prune . ' -o'
	    endif
	    let find_prune = find_prune . ' -name ' .
			\ shellescape(one_dir)
	endfor

	let find_prune = '-type d ' . g:Grep_Shell_Escape_Char . '(' .
		    \ find_prune . ' ' . g:Grep_Shell_Escape_Char . ')' .
		    \ ' -prune -o'
    endif

    let find_skip_files = '-type f'
    for one_file in split(g:Grep_Skip_Files, ' ')
	let find_skip_files = find_skip_files . ' ! -name ' .
		    \ shellescape(one_file)
    endfor

    " On MS-Windows, convert the find/xargs program path to 8.3 style path
    if has('win32')
	let g:Grep_Find_Path = fnamemodify(g:Grep_Find_Path, ':8')
	let g:Grep_Xargs_Path = fnamemodify(g:Grep_Xargs_Path, ':8')
    endif

    if g:Grep_Find_Use_Xargs == 1
	let grep_cmd = s:formFullCmd(a:grep_cmd, opts, pattern, '')
	let cmd = g:Grep_Find_Path . ' "' . startdir . '"'
		    \ . ' ' . find_prune
		    \ . ' ' . find_skip_files
		    \ . ' ' . find_file_pattern
		    \ . " -print0 | "
		    \ . g:Grep_Xargs_Path . ' ' . g:Grep_Xargs_Options
		    \ . ' ' . grep_cmd
    else
	let grep_cmd = s:formFullCmd(a:grep_cmd, opts, pattern, '{}')
	let cmd = g:Grep_Find_Path . ' ' . startdir
		    \ . ' ' . find_prune . " -prune -o"
		    \ . ' ' . find_skip_files
		    \ . ' ' . find_file_pattern
		    \ . " -exec " . grep_cmd . ' ' .
		    \ g:Grep_Shell_Escape_Char . ';'
    endif

    call s:runGrepCmd(cmd, pattern, a:action)
endfunc

" grep#runGrepSpecial()
" Search for a pattern in all the opened buffers or filenames in the
" argument list
func! grep#runGrepSpecial(cmd_name, which, action, ...) abort
    if a:0 > 0 && (a:1 == '-?' || a:1 == '-h')
	echo 'Usage: ' . a:cmd_name . ' [<options>] [<search_pattern>]'
	return
    endif

    " Search in all the Vim buffers
    if a:which == 'buffer'
	let filenames = s:getListOfBufferNames()
	" No buffers
	if filenames == ''
	    call s:warnMsg('Error: Buffer list is empty')
	    return
	endif
    elseif a:which == 'args'
	" Search in all the filenames in the argument list
	let filenames = s:getListOfArgFiles()
	" No arguments
	if filenames == ''
	    call s:warnMsg('Error: Argument list is empty')
	    return
	endif
    endif

    if has('win32') && !has('win32unix')
	" On Windows-like systems, use 'findstr' to search in buffers/arglist
	let grep_cmd = 'findstr'
    else
	" On all other systems, use 'grep' to search in buffers/arglist
	let grep_cmd = 'grep'
    endif

    " Parse the arguments and get the command line options and pattern.
    " Filenames are not be supplied and should be ignored.
    let [opts, pattern, temp] = s:parseArgs(grep_cmd, a:000)

    if pattern == ''
	" No argument supplied. Get the identifier and file list from user
	let pattern = input('Search for pattern: ', expand('<cword>'))
	if pattern == ''
	    return
	endif
	echo "\r"
    endif

    " Form the complete command line and run it
    let cmd = s:formFullCmd(grep_cmd, opts, pattern, filenames)
    call s:runGrepCmd(cmd, pattern, a:action)
endfunc

" grep#runGrep()
" Run the specified grep command
func! grep#runGrep(cmd_name, grep_cmd, action, ...) abort
    if a:0 > 0 && (a:1 == '-?' || a:1 == '-h')
	echo 'Usage: ' . a:cmd_name . ' [<options>] [<search_pattern> ' .
		    \ '[<file_name(s)>]]'
	return
    endif

    " Parse the arguments and get the grep options, search pattern
    " and list of file names/patterns
    let [opts, pattern, filenames] = s:parseArgs(a:grep_cmd, a:000)

    " Get the identifier and file list from user
    if pattern == '' 
	let pattern = input('Search for pattern: ', expand('<cword>'))
	if pattern == ''
	    return
	endif
	let pattern = shellescape(pattern)
	echo "\r"
    endif

    if filenames == '' && !s:recursive_search_cmd(a:grep_cmd)
	let filenames = input('Search in files: ', g:Grep_Default_Filelist,
		    \ 'file')
	if filenames == ''
	    return
	endif
	echo "\r"
    endif

    " Form the complete command line and run it
    let cmd = s:formFullCmd(a:grep_cmd, opts, pattern, filenames)
    call s:runGrepCmd(cmd, pattern, a:action)
endfunc

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save
