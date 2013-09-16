#!/usr/bin/ruby
if Dir.exists?('.git') #|| system('git rev-parse')!='false'
  count = `git stash list | wc -l`
  if count.to_i >0
    puts " {Stash: #{count.strip}}"
  end
end
