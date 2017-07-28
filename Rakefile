task :default do
  sh "ruby data.rb"
  sh "../tippecanoe/tippecanoe --drop-smallest-as-needed --minimum-zoom=0 --maximum-zoom=14 -P -B14 -f --layer=rvrcl -o data.mbtiles data.ndjson"
  #sh "ruby fan-out.rb"
  #sh "git add -v ."
  #sh "git commit -m 'update'"
  #sh "git push -v origin master"
end
