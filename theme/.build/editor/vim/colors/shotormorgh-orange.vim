highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'shotormorgh-orange'

if &background ==# 'light'
  let s:p = {
        \ 'bg': '#fdf7f3',
        \ 'fg': '#2f2419',
        \ 'surface': '#f0e8e1',
        \ 'selection': '#e6d0bb',
        \ 'muted': '#6e6155',
        \ 'accent': '#864e00',
        \ 'header': '#e39339',
        \ 'red': '#844642',
        \ 'green': '#3a673c',
        \ 'yellow': '#6a5a18',
        \ 'blue': '#385c8a',
        \ 'magenta': '#734975',
        \ 'cyan': '#006965',
        \ 'add': '#e4eddb',
        \ 'del': '#fae0d0',
        \ 'change': '#fdf0cd',
        \ }
  let s:terminal = ['#2f2419','#844642','#3a673c','#6a5a18','#385c8a','#734975','#006965','#f0e8e1','#6e6155','#844642','#3a673c','#6a5a18','#385c8a','#734975','#006965','#fdf7f3']
else
  let s:p = {
        \ 'bg': '#2c1b09',
        \ 'fg': '#f8ece1',
        \ 'surface': '#382614',
        \ 'selection': '#5a3b1a',
        \ 'muted': '#baa38e',
        \ 'accent': '#eab582',
        \ 'header': '#e39339',
        \ 'red': '#e9a29c',
        \ 'green': '#95c696',
        \ 'yellow': '#c8b778',
        \ 'blue': '#93baed',
        \ 'magenta': '#d4a5d6',
        \ 'cyan': '#72c9c3',
        \ 'add': '#35402c',
        \ 'del': '#53302a',
        \ 'change': '#4b3d24',
        \ }
  let s:terminal = ['#2c1b09','#e9a29c','#95c696','#c8b778','#93baed','#d4a5d6','#72c9c3','#f8ece1','#baa38e','#e9a29c','#95c696','#c8b778','#93baed','#d4a5d6','#72c9c3','#f8ece1']
endif

let s:indices = {}

function! s:index(hex) abort
  if has_key(s:indices, a:hex)
    return s:indices[a:hex]
  endif
  let rgb = map([1, 3, 5], 'str2nr(strpart(a:hex, v:val, 2), 16)')
  let steps = [0, 95, 135, 175, 215, 255]
  let best = 16
  let distance = 999999
  for i in range(16, 255)
    if i < 232
      let n = i - 16
      let candidate = [steps[n / 36], steps[(n / 6) % 6], steps[n % 6]]
    else
      let candidate = repeat([8 + (i - 232) * 10], 3)
    endif
    let delta = 0
    for j in range(3)
      let delta += (rgb[j] - candidate[j]) * (rgb[j] - candidate[j])
    endfor
    if delta < distance
      let distance = delta
      let best = i
    endif
  endfor
  let s:indices[a:hex] = best
  return best
endfunction

function! s:hi(group, fg, bg, attr) abort
  let fg = a:fg ==# 'NONE' ? 'NONE' : s:p[a:fg]
  let bg = a:bg ==# 'NONE' ? 'NONE' : s:p[a:bg]
  execute 'highlight' a:group 'guifg=' . fg 'guibg=' . bg 'gui=' . a:attr
        \ 'ctermfg=' . (fg ==# 'NONE' ? 'NONE' : s:index(fg))
        \ 'ctermbg=' . (bg ==# 'NONE' ? 'NONE' : s:index(bg)) 'cterm=' . a:attr
endfunction

call s:hi('Normal', 'fg', 'bg', 'NONE')
call s:hi('NormalNC', 'fg', 'bg', 'NONE')
call s:hi('NormalFloat', 'fg', 'surface', 'NONE')
call s:hi('FloatBorder', 'muted', 'surface', 'NONE')
call s:hi('Comment', 'muted', 'NONE', 'italic')
call s:hi('Constant', 'accent', 'NONE', 'NONE')
call s:hi('String', 'green', 'NONE', 'NONE')
call s:hi('Character', 'green', 'NONE', 'NONE')
call s:hi('Number', 'accent', 'NONE', 'NONE')
call s:hi('Boolean', 'accent', 'NONE', 'NONE')
call s:hi('Identifier', 'fg', 'NONE', 'NONE')
call s:hi('Function', 'blue', 'NONE', 'NONE')
call s:hi('Statement', 'magenta', 'NONE', 'NONE')
call s:hi('PreProc', 'cyan', 'NONE', 'NONE')
call s:hi('Type', 'yellow', 'NONE', 'NONE')
call s:hi('Special', 'cyan', 'NONE', 'NONE')
call s:hi('Operator', 'accent', 'NONE', 'NONE')
call s:hi('Delimiter', 'muted', 'NONE', 'NONE')
call s:hi('Underlined', 'blue', 'NONE', 'underline')
call s:hi('Ignore', 'muted', 'NONE', 'NONE')
call s:hi('Error', 'red', 'bg', 'bold')
call s:hi('Todo', 'bg', 'yellow', 'bold')
call s:hi('Cursor', 'bg', 'accent', 'NONE')
call s:hi('CursorLine', 'NONE', 'surface', 'NONE')
call s:hi('CursorColumn', 'NONE', 'surface', 'NONE')
call s:hi('ColorColumn', 'NONE', 'surface', 'NONE')
call s:hi('LineNr', 'muted', 'bg', 'NONE')
call s:hi('CursorLineNr', 'accent', 'surface', 'bold')
call s:hi('SignColumn', 'fg', 'bg', 'NONE')
call s:hi('FoldColumn', 'muted', 'bg', 'NONE')
call s:hi('Folded', 'muted', 'surface', 'NONE')
call s:hi('Visual', 'NONE', 'selection', 'NONE')
call s:hi('Search', 'bg', 'yellow', 'NONE')
call s:hi('IncSearch', 'bg', 'accent', 'bold')
call s:hi('CurSearch', 'bg', 'accent', 'bold')
call s:hi('MatchParen', 'accent', 'selection', 'bold')
call s:hi('StatusLine', 'fg', 'selection', 'bold')
call s:hi('StatusLineNC', 'muted', 'surface', 'NONE')
call s:hi('VertSplit', 'surface', 'bg', 'NONE')
call s:hi('WinSeparator', 'surface', 'bg', 'NONE')
call s:hi('Pmenu', 'fg', 'surface', 'NONE')
call s:hi('PmenuSel', 'fg', 'selection', 'bold')
call s:hi('PmenuSbar', 'NONE', 'surface', 'NONE')
call s:hi('PmenuThumb', 'NONE', 'muted', 'NONE')
call s:hi('TabLine', 'muted', 'surface', 'NONE')
call s:hi('TabLineFill', 'NONE', 'surface', 'NONE')
call s:hi('TabLineSel', 'accent', 'selection', 'bold')
call s:hi('Directory', 'blue', 'NONE', 'NONE')
call s:hi('Title', 'accent', 'NONE', 'bold')
call s:hi('NonText', 'muted', 'NONE', 'NONE')
call s:hi('SpecialKey', 'muted', 'NONE', 'NONE')
call s:hi('EndOfBuffer', 'bg', 'bg', 'NONE')
call s:hi('ErrorMsg', 'red', 'NONE', 'NONE')
call s:hi('WarningMsg', 'yellow', 'NONE', 'NONE')
call s:hi('MoreMsg', 'green', 'NONE', 'NONE')
call s:hi('Question', 'cyan', 'NONE', 'NONE')
call s:hi('DiffAdd', 'NONE', 'add', 'NONE')
call s:hi('DiffDelete', 'red', 'del', 'NONE')
call s:hi('DiffChange', 'NONE', 'change', 'NONE')
call s:hi('DiffText', 'fg', 'selection', 'bold')
call s:hi('SpellBad', 'red', 'NONE', 'underline')
call s:hi('SpellCap', 'blue', 'NONE', 'underline')
call s:hi('SpellRare', 'magenta', 'NONE', 'underline')
call s:hi('SpellLocal', 'cyan', 'NONE', 'underline')
call s:hi('DiagnosticError', 'red', 'NONE', 'NONE')
call s:hi('DiagnosticWarn', 'yellow', 'NONE', 'NONE')
call s:hi('DiagnosticInfo', 'blue', 'NONE', 'NONE')
call s:hi('DiagnosticHint', 'cyan', 'NONE', 'NONE')
call s:hi('DiagnosticUnderlineError', 'red', 'NONE', 'underline')
call s:hi('DiagnosticUnderlineWarn', 'yellow', 'NONE', 'underline')
call s:hi('DiagnosticUnderlineInfo', 'blue', 'NONE', 'underline')
call s:hi('DiagnosticUnderlineHint', 'cyan', 'NONE', 'underline')
call s:hi('Added', 'green', 'NONE', 'NONE')
call s:hi('Removed', 'red', 'NONE', 'NONE')
call s:hi('Changed', 'yellow', 'NONE', 'NONE')

let g:terminal_ansi_colors = s:terminal
if has('nvim')
  for s:i in range(16)
    let g:['terminal_color_' . s:i] = s:terminal[s:i]
  endfor
  highlight! link @comment Comment
  highlight! link @string String
  highlight! link @character Character
  highlight! link @number Number
  highlight! link @boolean Boolean
  highlight! link @constant Constant
  highlight! link @variable Identifier
  highlight! link @variable.builtin Special
  highlight! link @function Function
  highlight! link @function.call Function
  highlight! link @method Function
  highlight! link @keyword Statement
  highlight! link @operator Operator
  highlight! link @type Type
  highlight! link @property Identifier
  highlight! link @punctuation Delimiter
  highlight! link @markup.heading Title
  highlight! link @markup.link Underlined
  highlight! link @markup.raw String
  highlight! link @lsp.type.function Function
  highlight! link @lsp.type.method Function
  highlight! link @lsp.type.class Type
  highlight! link @lsp.type.parameter Identifier
endif
