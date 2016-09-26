#!/usr/bin/ruby

require 'net/http'

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
  s=`git status -s | cut -c-2 | sort | uniq -c | tr "\\n" ":" | tr -s " "`.strip
  s.size==0 ? '' : "(#{color :magenta}#{s.strip}#{color :green})".strip
end

def show_files
  gitstatussb_match = [`git status -sb`.match('\[(.*)\]')]
  gitstatussb_match && gitstatussb_match[0]
end

def show_ruby_version
  `ruby --version`.split[1]
end

def show_branch
  "#{color :light_blue}#{`git rev-parse --abbrev-ref HEAD`.strip}#{color :green}"
end

def master_diff(branch='', parent = 'master')
  remote_changed = `git diff #{parent} #{branch} --name-only  2> /dev/null | wc -l`.strip
end

def show_master_diff
  files_changed = master_diff.to_i
  if files_changed
    "#{color(:red)}#{files_changed}#{color(:green)}"
  end
end


def show_parent_diff
  files_changed = master_diff('', '@{u}').to_i
  if files_changed>0
    "\{#{color(:red)}#{files_changed}#{color(:green)}\}"
  end
end


def show_host
    `curl -sS -m 0.3 http://jeffwaltzer.com/hostname.rhtml 2>/dev/null `.strip
#     begin
#         host='jeffwaltzer.com'
#         port = 80
# 
#         http = Net::HTTP.new(host, port)
#         http.read_timeout = 0.2
# 
#         http.get('/hostname.rhtml').body.strip
#     rescue Error => e
#         return e
#     end
end


def have_upstream
    `git rev-parse --symbolic-full-name HEAD@{u} 2> /dev/null` != ''  ?
         ' ' :
         "#{color(:red, :blink)}no upsream#{color(:green)}"
end

if system('git rev-parse 2> /dev/null > /dev/null')
  puts color(:green) +
         [
           # show_ruby_version,
           show_master_diff,
           show_parent_diff,
           show_branch,
           show_files,
           show_status,
           show_stash,
             have_upstream,
            ' ' 
         ].
             join(' ').
             gsub('   ', ' ').
             gsub('  ', ' ')+
          color_reset
else
  puts "#{color(:light_green)}ruby #{show_ruby_version}#{color(:light_red)} #{show_host}#{color_reset} ".gsub(/ +/,' ')
end
