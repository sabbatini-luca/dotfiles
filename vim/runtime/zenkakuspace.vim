"highlight link ZenkakuSpace Error
if has("gui_running") || has("gui_win32")
  "highlight link ZenkakuSpace Error
  highlight ZenkakuSpace guibg=#5F5F87
elseif &t_Co >255
  highlight ZenkakuSpace ctermbg=60
else
  highlight ZenkakuSpace ctermbg=darkgray
end
match ZenkakuSpace /　/
