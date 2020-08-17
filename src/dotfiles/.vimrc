" Vim
" An example for a gvimrc file.
" The commands in this are executed when the GUI is started.
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.gvimrc
"             for Amiga:  s:.gvimrc
"  for MS-DOS and Win32:  $VIM\_gvimrc
" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty
" set the X11 font to use. See 'man xlsfonts' on unix/linux
" set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1
"set guifont=8x13bold
"set guifont=9x15bold
"set guifont=7x14bold
"set guifont=7x13bold
"
" Highly recommended to set tab keys to 4 spaces
set tabstop=4
set shiftwidth=4
"
" The opposite is 'set wrapscan' while searching for strings....
"set nowrapscan
"
" The opposite is set noignorecase
set ignorecase
" 
" You may want to turn off the beep sounds (if you want quite) with visual bell
" set vb
" Source in your custom filetypes as given below -
" so $HOME/vim/myfiletypes.vim
" Make command line two lines high
"set ch=2
" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
" Only do this for Vim version 5.0 and later.
if version >= 500
  " I like highlighting strings inside C comments
  let c_comment_strings=1
  " Switch on syntax highlighting.
  syntax on
  " Switch on search pattern highlighting.
  set hlsearch
  " For Win32 version, have "K" lookup the keyword in a help file
  "if has("win32")
  "  let winhelpfile='windows.hlp'
  "  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  "endif
  " Hide the mouse pointer while typing
  set mousehide
  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green
  " Constants are not underlined but have a slightly lighter background
  highlight Normal guibg=grey90
  highlight Cursor guibg=Green guifg=NONE
  highlight NonText guibg=grey80
  highlight Constant gui=NONE guibg=grey95
  highlight Special gui=NONE guibg=grey95
endif
