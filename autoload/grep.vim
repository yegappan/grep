" File: grep.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 2.0
" Last Modified: Jan 23, 2018
" 
" Plugin to integrate grep utilities with Vim

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

" Default grep options
if !exists("Grep_Default_Options")
    let Grep_Default_Options = ''
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
" results in the background
if !exists('Grep_Run_Async')
    " Check whether we can run the grep command asynchronously.
    if v:version >= 800
	let Grep_Run_Async = 1
	" Check whether we can use the quickfix identifier to add the grep
	" output to a specific quickfix list
	if has('patch-8.0.1023')
	    let s:Grep_Use_QfID = 1
	else
	    let s:Grep_Use_QfID = 0
	endif
    else
	let Grep_Run_Async = 0
    endif
endif

" WarnMsg
" Display a warning message
function! s:WarnMsg(msg)
    echohl WarningMsg | echomsg a:msg | echohl None
endfunction

let s:grep_cmd_job = 0
let s:grep_tempfile = ''

" DeleteTempFile()
" Delete the temporary file created on MS-Windows to run the grep command
function! s:DeleteTempFile()
    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	if exists('s:grep_tempfile') && s:grep_tempfile != ''
	    " Delete the temporary cmd file created on MS-Windows
	    call delete(s:grep_tempfile)
	    let s:grep_tempfile = ''
	endif
    endif
endfunction

" grep#cmd_output_cb()
" Add output (single line) from a grep command to the quickfix list
function! grep#cmd_output_cb(qf_id, channel, msg)
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
	call WarnMsg('Error: Job not found in grep command output callback')
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
endfunction

" grep#chan_close_cb
" Close callback for the grep command channel. No more grep output is
" available.
function! grep#chan_close_cb(qf_id, channel)
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
	call WarnMsg('Error: Job not found in grep channel close callback')
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
endfunction

" grep#cmd_exit_cb()
" grep command exit handler
function! grep#cmd_exit_cb(qf_id, job, exit_status)
    " Process the exit status only if the grep cmd is not interrupted
    " by another grep invocation
    if s:grep_cmd_job == a:job
	let s:grep_cmd_job = 0
	call s:DeleteTempFile()
    endif
endfunction

" grep#runGrepCmdAsync
" Run the grep command asynchronously
function! grep#runGrepCmdAsync(cmd, pattern, action)
    if s:grep_cmd_job isnot 0
	" If the job is already running for some other search, stop it.
	call job_stop(s:grep_cmd_job)
	caddexpr '[Search command interrupted]'
    endif

    let title = '[Search results for ' . a:pattern . ']'
    if a:action == 'add'
	caddexpr title . "\n"
    else
	cexpr title . "\n"
    endif
    "caddexpr 'Search cmd: ' . a:cmd
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
	let cmd_list = ['/bin/sh', '-c', a:cmd]
    endif
    let s:grep_cmd_job = job_start(cmd_list,
		\ {'callback' : function('grep#cmd_output_cb', [qf_id]),
		\ 'close_cb' : function('grep#chan_close_cb', [qf_id]),
		\ 'exit_cb' : function('grep#cmd_exit_cb', [qf_id])})

    if job_status(s:grep_cmd_job) == 'fail'
	let s:grep_cmd_job = 0
	call s:WarnMsg('Error: Failed to start the grep command')
	call s:DeleteTempFile()
	return
    endif

    " Open the grep output window
    if g:Grep_OpenQuickfixWindow == 1
	" Open the quickfix window below the current window
	botright copen
    endif
endfunction

" RunGrepCmd()
" Run the specified grep command using the supplied pattern
function! grep#runGrepCmd(cmd, pattern, action)
    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	" Windows does not correctly deal with commands that have more than 1
	" set of double quotes.  It will strip them all resulting in:
	" 'C:\Program' is not recognized as an internal or external command
	" operable program or batch file.  To work around this, place the
	" command inside a batch file and call the batch file.
	" Do this only on Win2K, WinXP and above.
	let s:grep_tempfile = fnamemodify(tempname(), ':h') . '\mygrep.cmd'
	call writefile(['@echo off', a:cmd], s:grep_tempfile)

	if g:Grep_Run_Async
	    call grep#runGrepCmdAsync(s:grep_tempfile, a:pattern, a:action)
	    return
	endif
	let cmd_output = system('"' . s:grep_tempfile . '"')

	if exists('s:grep_tempfile')
	    " Delete the temporary cmd file created on MS-Windows
	    call delete(s:grep_tempfile)
	endif
    else
	if g:Grep_Run_Async
	    return grep#runGrepCmdAsync(a:cmd, a:pattern, a:action)
	endif
	let cmd_output = system(a:cmd)
    endif

    " Do not check for the shell_error (return code from the command).
    " Even if there are valid matches, grep returns error codes if there
    " are problems with a few input files.

    if cmd_output == ''
	call s:WarnMsg('Error: Pattern ' . a:pattern . ' not found')
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
endfunction

" GrepParseArgs()
" Parse arguments to the grep function
" grep command-line flags are specified using the "-flag" format
" the next argument is assumed to be the pattern
" and the next arguments are assumed to be filenames or file patterns
function! s:GrepParseArgs(args, grep_cmd)
    let grep_opt    = ''
    let pattern     = ''
    let filepattern = ''

    for one_arg in a:args
	if one_arg[0] == '-' && pattern == ''
	    " Process grep arguments at the beginning of the argument list
	    let grep_opt = grep_opt . ' ' . one_arg
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

    if grep_opt == ''
	let grep_opt = g:Grep_Default_Options
    endif

    if a:grep_cmd == 'ag' || a:grep_cmd == 'rg'
	let grep_opt = grep_opt . ' --vimgrep'
    elseif a:grep_cmd == 'ack'
	let grep_opt = grep_opt . ' -H --column --nofilter --nocolor --nogroup'
    else
	if a:grep_cmd != 'agrep'
	    " Don't display messages about non-existent files
	    " Agrep doesn't support the -s option
	    let grep_opt = grep_opt . ' -s'
	endif
	" In Silver searcher (ag) the -n option disables recursive search.
	" In other grep commands, it displays the line number of the match.
	let grep_opt = grep_opt . ' -n'
    endif

    return [grep_opt, pattern, filepattern]
endfunction

function! s:GrepCmdToOption(grep_cmd)
    " Get the program path and the option to specify the search pattern
    if has('win32')
	" On MS-Windows, convert the program pathname to 8.3 style pathname.
	" Otherwise, using a path with space characters causes problems.
	let g:Grep_Path = fnamemodify(g:Grep_Path, ':8')
	let g:Fgrep_Path = fnamemodify(g:Fgrep_Path, ':8')
	let g:Egrep_Path = fnamemodify(g:Egrep_Path, ':8')
	let g:Agrep_Path = fnamemodify(g:Agrep_Path, ':8')
    endif
    let cmd_to_option_map = {'grep':  [g:Grep_Path, '--'],
                           \ 'fgrep': [g:Fgrep_Path, '-e'],
                           \ 'egrep': [g:Egrep_Path, '-e'],
                           \ 'agrep': [g:Agrep_Path, ''],
			   \ 'ag' : [g:Ag_Path, ''],
			   \ 'rg' : [g:Rg_Path, '-e'],
			   \ 'ack' : [g:Ack_Path, '--match']}

    return cmd_to_option_map[a:grep_cmd]
endfunction

" GetListOfBufferNames()
" Get the file names of all the listed and valid buffer names 
function! s:GetListOfBufferNames()
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
endfunction

function! s:GetListOfArgFiles()
    let filenames = ''

    let arg_cnt = argc()
    if arg_cnt != 0
	for i in range(0, arg_cnt)
	    let filenames = filenames . ' ' . argv(i)
	endfor
    endif

    return filenames
endfunction

" RunGrepRecursive()
" Run specified grep command recursively
function! grep#runGrepRecursive(cmd_name, grep_cmd, action, ...)
    if a:0 > 0 && (a:1 == '-?' || a:1 == '-h')
	echo 'Usage: ' . a:cmd_name . ' [<grep_options>] [<search_pattern> ' .
		    \ '[<file_name(s)>]]'
	return
    endif

    " Parse the arguments and get the grep options, search pattern
    " and list of file names/patterns
    let [grep_opt, pattern, filenames] = s:GrepParseArgs(a:000, a:grep_cmd)

    " Get the program path and the option to specify the search pattern
    let [grep_path, grep_expr_option] = s:GrepCmdToOption(a:grep_cmd)

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

    if startdir == cwd
	let startdir = '.'
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
		    \ find_prune . ' ' . g:Grep_Shell_Escape_Char . ')'
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
	let cmd = g:Grep_Find_Path . ' "' . startdir . '"'
		    \ . ' ' . find_prune . " -prune -o"
		    \ . ' ' . find_skip_files
		    \ . ' ' . find_file_pattern
		    \ . " -print0 | "
		    \ . g:Grep_Xargs_Path . ' ' . g:Grep_Xargs_Options
		    \ . ' ' . grep_path . ' ' . grep_opt . ' '
		    \ . grep_expr_option . ' ' . pattern
		    \ . ' ' . g:Grep_Null_Device 
    else
	let cmd = g:Grep_Find_Path . ' ' . startdir
		    \ . ' ' . find_prune . " -prune -o"
		    \ . ' ' . find_skip_files
		    \ . ' ' . find_file_pattern
		    \ . " -exec " . grep_path . ' ' . grep_opt . ' '
		    \ . grep_expr_option . ' ' . pattern
		    \ . " {} " . g:Grep_Null_Device . ' ' .
		    \ g:Grep_Shell_Escape_Char . ';'
    endif

    call grep#runGrepCmd(cmd, pattern, a:action)
endfunction

" RunGrepSpecial()
" Search for a pattern in all the opened buffers or filenames in the
" argument list
function! grep#runGrepSpecial(cmd_name, which, action, ...)
    if a:0 > 0 && (a:1 == '-?' || a:1 == '-h')
	echo 'Usage: ' . a:cmd_name . ' [<grep_options>] [<search_pattern>]'
	return
    endif

    " Search in all the Vim buffers
    if a:which == 'buffer'
	let filenames = s:GetListOfBufferNames()
	" No buffers
	if filenames == ''
	    call s:WarnMsg('Error: Buffer list is empty')
	    return
	endif
    elseif a:which == 'args'
	" Search in all the filenames in the argument list
	let filenames = s:GetListOfArgFiles()
	" No arguments
	if filenames == ''
	    call s:WarnMsg('Error: Argument list is empty')
	    return
	endif
    endif

    let grep_opt = ''
    let pattern = ''

    " Get the list of optional grep command-line options (if present)
    " supplied by the user. All the grep options will be preceded
    " by a '-'
    for one_arg in a:000
	if one_arg !~ '^-'
	    break
	endif

	let grep_opt = grep_opt . ' ' . one_arg
    endfor

    " If the user didn't specify the option, then use the defaults
    if grep_opt == ''
	let grep_opt = g:Grep_Default_Options
    endif

    " Don't display messages about non-existent files
    let grep_opt = grep_opt . ' -s'

    " The last argument specified by the user is the pattern
    let pattern = get(a:000, -1, '')
    if pattern =~ '^-'
	let pattern = ''
    endif

    if pattern == ''
	" No argument supplied. Get the identifier and file list from user
	let pattern = input('Search for pattern: ', expand('<cword>'))
	if pattern == ''
	    return
	endif
	echo "\r"
    endif

    let pattern = shellescape(pattern)

    " Add /dev/null to the list of filenames, so that grep print the
    " filename and linenumber when grepping in a single file
    let filenames = filenames . ' ' . g:Grep_Null_Device
    let cmd = g:Grep_Path . ' ' . grep_opt . ' -n -- '
    let cmd = cmd . pattern . ' ' . filenames

    call grep#runGrepCmd(cmd, pattern, a:action)
endfunction

" RunGrep()
" Run the specified grep command
function! grep#runGrep(cmd_name, grep_cmd, action, ...)
    if a:0 > 0 && (a:1 == '-?' || a:1 == '-h')
	echo 'Usage: ' . a:cmd_name . ' [<grep_options>] [<search_pattern> ' .
		    \ '[<file_name(s)>]]'
	return
    endif

    " Parse the arguments and get the grep options, search pattern
    " and list of file names/patterns
    let [grep_opt, pattern, filenames] = s:GrepParseArgs(a:000, a:grep_cmd)

    " Get the program path and the option to specify the search pattern
    let [grep_path, grep_expr_option] = s:GrepCmdToOption(a:grep_cmd)

    " Get the identifier and file list from user
    if pattern == '' 
	let pattern = input('Search for pattern: ', expand('<cword>'))
	if pattern == ''
	    return
	endif
	let pattern = shellescape(pattern)
	echo "\r"
    endif

    if filenames == ''
	let filenames = input('Search in files: ', g:Grep_Default_Filelist,
		    \ 'file')
	if filenames == ''
	    return
	endif
	echo "\r"
    endif

    " Add /dev/null to the list of filenames, so that grep prints the
    " filename and line number when grepping in a single file
    if a:grep_cmd != 'ag' && a:grep_cmd != 'rg' && a:grep_cmd != 'ack'
	let filenames = filenames . ' ' . g:Grep_Null_Device
    endif

    let cmd = grep_path . ' ' . grep_opt . ' ' .
		\ grep_expr_option . ' ' . pattern . ' ' . filenames

    call grep#runGrepCmd(cmd, pattern, a:action)
endfunction

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save
