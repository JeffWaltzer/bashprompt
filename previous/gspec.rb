#TODO these need to be rewritten to quote the backtci

#alias gspec="rspec $(git diff --name-only master -- spec | egrep '_(spec|test).rb')"
#alias gcucumber="cucumber $(git diff --name-only master -- feature | egrep '.feature')"

specs = `git diff --name-only master -- spec`
puts '-' * 80
puts specs
