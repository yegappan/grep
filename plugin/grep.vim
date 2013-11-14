" File: grep.vim
" Author: Yegappan Lakshmanan
" Version: 1.3
" Last Modified: June 11, 2002
" 
" Overview
" --------
" The grep.vim plugin script integrates the grep/fgrep/egrep/agrep tools with
" Vim. To use this script, you need the grep, fgrep, egrep, agrep, find and
" xargs utilities. For MS-Windows systems, you can download these tools from
" the http://unxutils.sourceforge.net site.
"
" Usage
" -----
" The grep.vim plugin script introduces the following commands:
"
" :Grep        - Grep for the specified pattern in the specified files
" :Rgrep       - Run recursive grep
" :GrepBuffer  - Grep for a pattern on all open buffers
" :GrepArgs    - Grep for a pattern on all the Vim argument filenames (:args)
" :Fgrep       - Run fgrep
" :Rfgrep      - Run recursive fgrep
" :Egrep       - Run egrep
" :Regrep      - Run recursive egrep
" :Agrep       - Run agrep
" :Ragrep      - Run recursive agrep
"
" When you run the one of the above commands, you will be prompted to enter
" the search pattern and the files in which to search for the pattern. By
" default, the keyword under the cursor will be displayed for the search
" pattern prompt.  Depending on the command, you may prompted for additional
" parameters like the directories to search for the pattern. The above
" commands will not accept the search pattern and the files as arguments.
"
" You can retrieve previously entered values for the Grep prompts using the up
" and down arrow keys. You can cancel the command by pressing the escape key.
" You can use CTRL-U to erase the default shown for the prompt and CTRL-W to
" erase the previous word in the prompt. For more information about editing
" the prompt, read :help cmdline-editing
"
" You can pass command-line options to the [fea]grep tools by appending them
" to the above commands. For example, to ignore case while searching for a
" pattern, you can use:
"
"       :Grep -i
"
" The output of the grep command will be listed in the Vim quickfix window.
" 1. You can select a line in the quickfix window and press <Enter> or double
"    click on a match to jump to that line.
" 2. You can use the ":cnext" and ":cprev" commands to the jump to the next or
"    previous output line.
" 3. You can use the ":colder" and ":cnewer" commands to go between multiple
"    grep quickfix output windows.
" 4. The quickfix window need not be opened always to use the grep output.
"    You can close the quickfix window and use the quickfix commands to jump
"    to the grep matches.  Use the ":copen" command to open the quickfix
"    window again.
"
" For more information about other quickfix commands read ":help quickfix"
" 
" Configuration
" -------------
" By changing the following variables you can configure the behavior of this
" script. Set the following variables in your .vimrc file using the 'let'
" command.
"
" By default, the '<F3>' key is mapped to run the ':Grep' command for the word
" under the cursor.  You can change this key by setting the 'Grep_Key'
" variable:
"
"       let Grep_Key = '<F9>'
"
" The 'Grep_Path' variable is used to locate the grep utility. By default,
" this is set to /usr/bin/grep. You can change this using the let command:
"
"       :let Grep_Path = 'd:\tools\grep.exe'
"
" The 'Fgrep_Path' variable is used to locate the fgrep utility. By default,
" this is set to /usr/bin/fgrep. You can change this using the let command:
"
"       :let Fgrep_Path = 'd:\tools\fgrep.exe'
"
" The 'Egrep_Path' variable is used to locate the egrep utility. By default,
" this is set to /usr/bin/egrep. You can change this using the let command:
"
"       :let Egrep_Path = 'd:\tools\egrep.exe'
"
" The 'Agrep_Path' variable is used to locate the agrep utility. By default,
" this is set to /usr/bin/agrep. You can change this using the let command:
"
"       :let Agrep_Path = 'd:\tools\agrep.exe'
"
" The 'Grep_Find_Path' variable is used to locate the find utility. By
" default, this is set to /usr/bin/find. You can change this using the let
" command:
"
"       :let Grep_Find_Path = 'd:\tools\find.exe'
"
" The 'Grep_Xargs_Path' variable is used to locate the xargs utility. By
" default, this is set to /usr/bin/xargs. You can change this using the let
" command:
"
"       :let Grep_Xargs_Path = 'd:\tools\xargs.exe'
"
" When running any one of the Grep commands, you will be prompted for the
" files in which to search for the pattern. The 'Grep_Default_Filelist'
" variable is used to specify to default for this prompt. By default, this
" variable is set to '*'. You can specify multiple matching patterns separated
" by spaces. You can change this settings using the let command:
"
"       :let Grep_Default_Filelist = '*.[chS]'
"
" The 'Grep_Default_Options' is used to pass default command line options to
" the grep/fgrep/egrep/agrep utilities. By default, this is set to an empty
" string. You can change this using the let command:
"
"       :let Grep_Default_Options = '-i'
"
" By default, when you invoke the Grep commands the quickfix window will be
" opened with the grep output.  You can disable opening the quickfix window,
" by setting the 'Grep_OpenQuickfixWindow' variable  to zero:
"
"       :let Grep_OpenQuickfixWindow = 0
"
" You can manually open the quickfix window using the :cwindow command.
"
" By default, for recursive searches, the find with the xargs utility is used.
" If you don't have the xargs utility or don't want to use the xargs utility,
" then you can set the 'Grep_Find_Use_Xargs' variable to zero. If this is set
" to zero, then only the find utility will be used to do recursive searches:
"
"       :let Grep_Find_Use_Xargs = 0
" 
" The 'Grep_Null_Device' variable specifies the name of the null device to
" pass to the grep commands. This is needed to force the grep commands to
" print the name of the file in which a match is found, if only one filename
" is specified. For Unix systems, this is set to /dev/null and for MS-Windows
" systems, this is set to NUL. You can modify this by using the let command:
"
"       :let Grep_Null_Device = '/dev/null'
"
" The 'Grep_Shell_Quote_Char' variable specifies the quote character to use
" for protecting patterns from being interpreted by the shell. For Unix
" systems, this is set to "'" and for MS-Window systems, this is set to an
" empty string.  You can change this using the let command:
"
"       :let Grep_Shell_Quote_Char = "'"
"
" The 'Grep_Shell_Escape_Char' variable specifies the escape character to use
" for protecting special characters from being interpreted by the shell.  For
" Unix systems, this is set to '\' and for MS-Window systems, this is set to
" an empty string.  You can change this using the let command:
"
"       :let Grep_Shell_Escape_Char = "'"
"
" The 'Grep_Skip_Dirs' variable specifies the list of directories to skip
" while doing recursive searches. By default, this is set to 'RCS CVS SCCS'.
" You can change this using the let command:
"
"       :let Grep_Skip_Dirs = 'dir1 dir2 dir3'
"
" The 'Grep_Skip_Files' variable specifies the list of files to skip while
" doing recursive searches. By default, this is set to '*~ *,v s.*'. You can
" change this using the let command:
"
"       :let Grep_Skip_Files = '*.bak *'
"
" --------------------- Do not modify after this line ---------------------
if exists("loaded_grep") || &cp
    finish
endif
let loaded_grep = 1

" Location of the grep utility
if !exists("Grep_Path")
    "let Grep_Path = 'd:\unix_tools\grep.exe'
    let Grep_Path = '/usr/bin/grep'
endif

" Location of the fgrep utility
if !exists("Fgrep_Path")
    "let Fgrep_Path = 'd:\unix_tools\fgrep.exe'
    let Fgrep_Path = '/usr/bin/fgrep'
endif

" Location of the egrep utility
if !exists("Egrep_Path")
    "let Egrep_Path = 'd:\unix_tools\egrep.exe'
    let Egrep_Path = '/usr/bin/egrep'
endif

" Location of the agrep utility
if !exists("Agrep_Path")
    "let Agrep_Path = 'd:\unix_tools\agrep.exe'
    let Agrep_Path = '/usr/local/bin/agrep'
endif

" Location of the find utility
if !exists("Grep_Find_Path")
    "let Grep_Find_Path = 'd:\unix_tools\find.exe'
    let Grep_Find_Path = '/usr/bin/find'
endif

" Location of the xargs utility
if !exists("Grep_Xargs_Path")
    "let Grep_Xargs_Path = 'd:\unix_tools\xargs.exe'
    let Grep_Xargs_Path = '/usr/bin/xargs'
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

" Key to invoke grep on the current word.  Modify this to whatever key
" you like
if !exists("Grep_Key")
    let Grep_Key = '<F3>'
endif

" NULL device name to supply to grep.  We need this because, grep will not
" print the name of the file, if only one filename is supplied. We need the
" filename for Vim quickfix processing.
if !exists("Grep_Null_Device")
    if has("win32") || has("win16") || has("win95")
        let Grep_Null_Device = 'NUL'
    else
        let Grep_Null_Device = '/dev/null'
    endif
endif

" Character to use to quote patterns and filenames before passing to grep.
if !exists("Grep_Shell_Quote_Char")
    if has("win32") || has("win16") || has("win95")
        let Grep_Shell_Quote_Char = ''
    else
        let Grep_Shell_Quote_Char = "'"
    endif
endif

" Character to use to escape special characters before passing to grep.
if !exists("Grep_Shell_Escape_Char")
    if has("win32") || has("win16") || has("win95")
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

" --------------------- Do not edit after this line ------------------------

" Map a key to invoke grep on a word under cursor.
exe "nnoremap <unique> <silent> " . Grep_Key . " :call <SID>RunGrep('grep')<CR>"

" RunGrepCmd()
" Run the specified grep command using the supplied pattern
function! s:RunGrepCmd(cmd, pattern)
    let cmd_output = system(a:cmd)

    if cmd_output == ""
        echohl WarningMsg | 
        \ echomsg "Error: Pattern " . a:pattern . " not found" | 
        \ echohl None
        return
    endif

    let tmpfile = tempname()

    exe "redir! > " . tmpfile
    silent echon cmd_output
    redir END

    let old_efm = &efm
    set efm=%f:%\\s%#%l:%m

    execute "silent! cfile " . tmpfile

    let &efm = old_efm

    " Open the grep output window
    if g:Grep_OpenQuickfixWindow == 1
        " Open the quickfix window below the current window
        botright copen
    endif

    " Jump to the first error
    cc

    call delete(tmpfile)
endfunction

" RunGrepRecursive()
" Run specified grep command recursively
function! s:RunGrepRecursive(grep_cmd, ...)
    if a:0 == 0 || a:1 == ''
        " No options are specified. Use the default grep options
        let grep_opt = g:Grep_Default_Options
    else
        " Use the specified grep options
        let grep_opt = a:1
    endif

    if a:grep_cmd == 'grep'
        let grep_path = g:Grep_Path
        let grep_expr_option = '--'
    elseif a:grep_cmd == 'fgrep'
        let grep_path = g:Fgrep_Path
        let grep_expr_option = '-e'
    elseif a:grep_cmd == 'egrep'
        let grep_path = g:Egrep_Path
        let grep_expr_option = '-e'
    elseif a:grep_cmd == 'agrep'
        let grep_path = g:Agrep_Path
        let grep_expr_option = '-e'
    else
        return
    endif

    " No argument supplied. Get the identifier and file list from user
    let pattern = input("Grep for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let pattern = g:Grep_Shell_Quote_Char . pattern . g:Grep_Shell_Quote_Char

    let startdir = input("Start searching from directory: ", getcwd())
    if startdir == ""
        return
    endif

    let filepattern = input("Grep in files matching pattern: ", 
                                      \ g:Grep_Default_Filelist)
    if filepattern == ""
        return
    endif
    echo "\n"

    let txt = filepattern . ' '
    let find_file_pattern = ''
    while txt != ''
        let one_pattern = strpart(txt, 0, stridx(txt, ' '))
        if find_file_pattern != ''
            let find_file_pattern = find_file_pattern . ' -o'
        endif
        let find_file_pattern = find_file_pattern . ' -name ' .
              \ g:Grep_Shell_Quote_Char . one_pattern . g:Grep_Shell_Quote_Char
        let txt = strpart(txt, stridx(txt, ' ') + 1)
    endwhile
    let find_file_pattern = g:Grep_Shell_Escape_Char . '(' .
                    \ find_file_pattern . ' ' . g:Grep_Shell_Escape_Char . ')'

    let txt = g:Grep_Skip_Dirs
    let find_prune = ''
    if txt != ''
        let txt = txt . ' '
        while txt != ''
            let one_dir = strpart(txt, 0, stridx(txt, ' '))
            if find_prune != ''
                let find_prune = find_prune . ' -o'
            endif
            let find_prune = find_prune . ' -name ' . one_dir
            let txt = strpart(txt, stridx(txt, ' ') + 1)
        endwhile
        let find_prune = '-type d ' . g:Grep_Shell_Escape_Char . '(' .
                         \ find_prune
        let find_prune = find_prune . ' ' . g:Grep_Shell_Escape_Char . ')'
    endif

    let txt = g:Grep_Skip_Files
    let find_skip_files = '-type f'
    if txt != ''
        let txt = txt . ' '
        while txt != ''
            let one_file = strpart(txt, 0, stridx(txt, ' '))
            let find_skip_files = find_skip_files . ' ! -name ' .
                                  \ g:Grep_Shell_Quote_Char . one_file .
                                  \ g:Grep_Shell_Quote_Char
            let txt = strpart(txt, stridx(txt, ' ') + 1)
        endwhile
    endif

    if g:Grep_Find_Use_Xargs == 1
        let cmd = g:Grep_Find_Path . " " . startdir
        let cmd = cmd . " " . find_prune . " -prune -o"
        let cmd = cmd . " " . find_skip_files
        let cmd = cmd . " " . find_file_pattern
        let cmd = cmd . " -print | " . g:Grep_Xargs_Path . " " . grep_path
        let cmd = cmd . " " . grep_opt . " -n "
        let cmd = cmd . grep_expr_option . " " . pattern
    else
        let cmd = g:Grep_Find_Path . " " . startdir
        let cmd = cmd . " " . find_prune . " -prune -o"
        let cmd = cmd . " " . find_skip_files
        let cmd = cmd . " " . find_file_pattern
        let cmd = cmd . " -exec " . grep_path . " " . grep_opt . " -n "
        let cmd = cmd . grep_expr_option . " " . pattern
        let cmd = cmd . " {} " . g:Grep_Null_Device . ' ' .
                         \ g:Grep_Shell_Escape_Char . ';'
    endif

    call s:RunGrepCmd(cmd, pattern)
endfunction

" RunGrepBuffer()
" Grep for a pattern in all the opened buffers
function! s:RunGrepBuffer(...)
    " Get a list of all the buffer names
    let last_bufno = bufnr("$")

    let i = 1
    let filenames = ""

    while i <= last_bufno
        if bufexists(i) && buflisted(i)
            let filenames = filenames . " " . bufname(i)
        endif
        let i = i + 1
    endwhile

    " No buffers
    if filenames == ""
        return
    endif

    if a:0 == 0 || a:1 == ''
        let grep_opt = g:Grep_Default_Options
    else
        let grep_opt = a:1
    endif

    " No argument supplied. Get the identifier and file list from user
    let pattern = input("Grep for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let pattern = g:Grep_Shell_Quote_Char . pattern . g:Grep_Shell_Quote_Char

    echo "\n"

    " Add /dev/null to the list of filenames, so that grep print the
    " filename and linenumber when grepping in a single file
    let filenames = filenames . " " . g:Grep_Null_Device
    let cmd = g:Grep_Path . " " . grep_opt . " -n -- "
    let cmd = cmd . pattern . " " . filenames

    call s:RunGrepCmd(cmd, pattern)
endfunction

" RunGrepArgs()
" Grep for a pattern in all the argument filenames
function! s:RunGrepArgs(...)
    let arg_cnt = argc()

    if arg_cnt == 0
        echohl WarningMsg | 
        \ echomsg "Error: No filenames specified in the argument list " |
        \ echohl None
        return
    endif

    let i = 0
    let filenames = ""

    while i < arg_cnt
        let filenames = filenames . " " . argv(i)
        let i = i + 1
    endwhile

    " No arguments
    if filenames == ""
        echohl WarningMsg | 
        \ echomsg "Error: No filenames specified in the argument list " |
        \ echohl None
        return
    endif

    if a:0 == 0 || a:1 == ''
        let grep_opt = g:Grep_Default_Options
    else
        let grep_opt = a:1
    endif

    " No argument supplied. Get the identifier and file list from user
    let pattern = input("Grep for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let pattern = g:Grep_Shell_Quote_Char . pattern . g:Grep_Shell_Quote_Char

    echo "\n"

    " Add /dev/null to the list of filenames, so that grep print the
    " filename and linenumber when grepping in a single file
    let filenames = filenames . " " . g:Grep_Null_Device
    let cmd = g:Grep_Path . " " . grep_opt . " -n -- "
    let cmd = cmd . pattern . " " . filenames

    call s:RunGrepCmd(cmd, pattern)
endfunction

" RunGrep()
" Run the specified grep command
function! s:RunGrep(grep_cmd, ...)
    if a:0 == 0 || a:1 == ''
        " No options are specified. Use the default grep options
        let grep_opt = g:Grep_Default_Options
    else
        " Use the specified grep options
        let grep_opt = a:1
    endif

    if a:grep_cmd == 'grep'
        let grep_path = g:Grep_Path
        let grep_expr_option = '--'
    elseif a:grep_cmd == 'fgrep'
        let grep_path = g:Fgrep_Path
        let grep_expr_option = '-e'
    elseif a:grep_cmd == 'egrep'
        let grep_path = g:Egrep_Path
        let grep_expr_option = '-e'
    elseif a:grep_cmd == 'agrep'
        let grep_path = g:Agrep_Path
        let grep_expr_option = '-e'
    else
        return
    endif

    " No argument supplied. Get the identifier and file list from user
    let pattern = input("Grep for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let pattern = g:Grep_Shell_Quote_Char . pattern . g:Grep_Shell_Quote_Char

    let filenames = input("Grep in files: ", g:Grep_Default_Filelist)
    if filenames == ""
        return
    endif

    echo "\n"

    " Add /dev/null to the list of filenames, so that grep print the
    " filename and linenumber when grepping in a single file
    let filenames = filenames . " " . g:Grep_Null_Device
    let cmd = grep_path . " " . grep_opt . " -n "
    let cmd = cmd . grep_expr_option . " " . pattern
    let cmd = cmd . " " . filenames

    call s:RunGrepCmd(cmd, pattern)
endfunction

" Define the set of grep commands
command! -nargs=* Grep call s:RunGrep('grep', <q-args>)
command! -nargs=* Rgrep call s:RunGrepRecursive('grep', <q-args>)
command! -nargs=* GrepBuffer call s:RunGrepBuffer(<q-args>)
command! -nargs=* GrepArgs call s:RunGrepArgs(<q-args>)

command! -nargs=* Fgrep call s:RunGrep('fgrep', <q-args>)
command! -nargs=* Rfgrep call s:RunGrepRecursive('fgrep', <q-args>)
command! -nargs=* Egrep call s:RunGrep('egrep', <q-args>)
command! -nargs=* Regrep call s:RunGrepRecursive('egrep', <q-args>)
command! -nargs=* Agrep call s:RunGrep('agrep', <q-args>)
command! -nargs=* Ragrep call s:RunGrepRecursive('agrep', <q-args>)

