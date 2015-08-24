#!/usr/bin/ruby

COLORS = {
  :black => 30,
  :red => 31,
  :green => 32,
  :yellow => 33,
  :blue => 34,
  :magenta => 35,
  :cyan => 36,
  :white => 37,
  :default => 39,

  :light_black => 90,
  :light_red => 91,
  :light_green => 92,
  :light_yellow => 93,
  :light_blue => 94,
  :light_magenta => 95,
  :light_cyan => 96,
  :light_white => 97
}

MODES = {
  :default => 0, # Turn off all attributes
  :bold => 1, # Set bold mode
  :underline => 4, # Set underline mode
  :blink => 5, # Set blink mode
  :swap => 7, # Exchange foreground and background colors
  :hide => 8 # Hide text (foreground color would be the same as background)
}


def color(color=:white, mode=:default)
  "\e[#{MODES[mode].to_s};#{(COLORS[color]).to_s}m"
end

def color_reset
  "\e[m"
end

def blink(mode=:on)
  "\e[#{mode==:on ? MODES[:blink].to_s : "0"}m"
end

def show_stash
  count = `git stash list | wc -l`
  (count.to_i > 0) ? "#{color :light_cyan, :blink}{Stash: #{count.strip}}#{color :green}" : ''
end

def show_status
  s=`git status -s | cut -c-2 | sort | uniq -c | tr "\\n" ":" | tr -s " "`
  s.size==0 ? '' : "(#{color :magenta}#{s.strip}#{color :green})"
end

def show_files
  gitstatussb_match = [`git status -sb`.match('\[(.*)\]')]
  gitstatussb_match && gitstatussb_match[0]
end

def show_ruby_version
  `ruby --version`.split[1]
end

def show_branch
  "#{color :light_blue}(#{`git rev-parse --abbrev-ref HEAD`.strip})#{color :green}"
end

def master_diff(branch='')
  remote_changed = `git diff master #{branch} --name-only | wc -l`.strip
end

def show_master_diff
  files_changed = master_diff
  remote_changed = master_diff('origin/master')
  "#{color(:red)}#{files_changed}:#{remote_changed}#{color(:green)}"
end

if system('git rev-parse 2> /dev/null > /dev/null')
  puts color(:green) +
         [
           show_ruby_version,
           show_status,
           show_master_diff,
           show_files,
           show_stash,
           show_branch,
         ].
             join(' ').
             gsub('   ', ' ').
             gsub('  ', ' ').
             gsub('/', '//') +
          color_reset
else
  puts "no git #{color(:light_green)}ruby #{show_ruby_version}#{color_reset}"
end
