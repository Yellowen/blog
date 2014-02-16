desc "Deploy _site/ to gh-pages branch"
task :deploy do
  system("git branch -D gh-pages")
  system("git checkout --orphan gh-pages")
  system("git rm . -rf")
  system("cp _site/* ./ -r")
  system("git add .")
  system("git commit -a -m \"Release at #{Time.now.utc}\"")
  system("git push origin gh-pages -f")
  system("git checkout master")
end

task :default => :deploy
