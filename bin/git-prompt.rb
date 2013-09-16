def show_stash
  count = `git stash list | wc -l`
  (count.to_i > 0) ? " {Stash: #{count.strip}}" : "{}"
end

def show_status
  `git status -s | cut -c-2 | sort | uniq -c | tr "\\n" ":" | tr -s " "`
end

#!/usr/bin/ruby
if Dir.exists?('.git') #|| system('git rev-parse')!='false'
  puts show_stash + "(#{show_status.strip})"
end
#gtst
#rvm-prompt
