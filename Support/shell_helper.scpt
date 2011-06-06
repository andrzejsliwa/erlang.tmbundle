tell application "System Events" to keystroke "§" using command down 
tell application "Terminal"
  activate
  
  set window_id to 0  
  set exists to 0
  -- get every window id
  set w_ids to (id of every window)

  -- with each window id...
  repeat with w_id in w_ids
      
    --set w_name to name of window id w_id  
    -- if w_name contains "Erlang Textmate Shell" then
    --   set window_id to w_id
    --   set exists to 1 
    -- end
    -- have we found our target window_id?    
    if window_id is equal to 0 then
      set window_id to w_id      
    end if
  end repeat

  -- if exists is equal to 0 then 
  --   do script "do script "echo -n -e \"\\033]0;Erlang Textmate Shell\\007\"" in window id window_id   
  -- end if 
  do script "ls" in window id window_id  
end tell
