#!/usr/bin/ruby


COLORS = {
    :black          => 0,
    :red            => 1,
    :green          => 2,
    :yellow         => 3,
    :blue           => 4,
    :magenta        => 5,
    :cyan           => 6,
    :white          => 7,
    :default        => 9,

    :light_black    => 10,
    :light_red      => 11,
    :light_green    => 12,
    :light_yellow   => 13,
    :light_blue     => 14,
    :light_magenta  => 15,
    :light_cyan     => 16,
    :light_white    => 17
}


MODES = {
    :default        => 0, # Turn off all attributes
    :bold           => 1, # Set bold mode
    :underline      => 4, # Set underline mode
    :blink          => 5, # Set blink mode
    :swap           => 7, # Exchange foreground and background colors
    :hide           => 8  # Hide text (foreground color would be the same as background)
}


GREEN =
def color(color=:white , mode=:default)
  "\e[0;#{COLORS[color]+30}m"
end

def color_reset
  "\e[m"
end


def show_stash
  count = `git stash list | wc -l`
  (count.to_i > 0) ? "#{color :red}{Stash: #{count.strip}}#{color :green}" : ''
end

def show_status
  `git status -s | cut -c-2 | sort | uniq -c | tr "\\n" ":" | tr -s " "`
end

def show_files
  gitstatussb_match = [`git status -sb`.match('\[(.*)\]')]
  gitstatussb_match && gitstatussb_match[0]
end

def show_rvm
  `rvm-prompt`
end

def show_branch
  `git rev-parse --abbrev-ref HEAD`
end

if Dir.exists?('.git')
  puts "#{color :green}#{show_rvm.chomp} (#{show_status.strip}) #{show_files} #{show_stash} (#{show_branch.strip})#{color_reset}".squeeze
else
  puts show_rvm.chomp
end
