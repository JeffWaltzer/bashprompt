#!/usr/bin/ruby

def show_stash
  count = `git stash list | wc -l`
  (count.to_i > 0) ? "{Stash: #{count.strip}}" : ''
end

def show_status
  `git status -s | cut -c-2 | sort | uniq -c | tr "\\n" ":" | tr -s " "`
end

def show_files
  gitstatussb_match = [`git status -sb`.match('\[(.*)\]')]
  gitstatussb_match && gitstatussb_match[0]
end

def show_rvm
  #`~/.rvm/bin/rvm-prompt`
  ''
end

def show_branch
  `git rev-parse --abbrev-ref HEAD`
end

if Dir.exists?('.git') #|| system('git rev-parse')!='false'
  puts "#{show_rvm.chomp} (#{show_status.strip}) #{show_files} #{show_stash} (#{show_branch.strip})".squeeze
else
  puts '(!git)'
end
