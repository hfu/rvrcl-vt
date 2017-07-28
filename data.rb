require 'find'
require 'json'

def report(count, dict)
  #print "[#{name}]"
  #return
  dict.keys.sort{|a, b| dict[b] <=> dict[a]}.each {|k|
    print "#{k}: #{dict[k]}\n"
  }
  print "\n"
end

w = File.open('data.ndjson', 'w')
count = 0
dict = Hash.new{|h, k| h[k] = 0}
name = ''
Find.find('/Volumes/Extreme 900/experimental_rvrcl') {|path|
  next unless path.end_with?('geojson')
  begin
    JSON::parse(File.read(path))['features'].each {|f|
      dict[f["properties"]["rivCtg"]] += 1
      tippecanoe = {
        "minzoom" => {
          "細河川（通常部）" => 12,
          "河川中心線（通常部）" => 10, #10?
          "人工水路（地下）" => 0,
          "用水路" => 12,
          "人工水路（空間）" => 0,
          "細河川（枯れ川部）" => 12,
          "河川中心線（枯れ川部）" => 10 #10?
        }[f["properties"]["type"]]
      }
      tippecanoe = 8 if f["properties"]["rivCtg"] == '一級河川'
      tippecanoe = 9 if f["properties"]["rivCtg"] == '二級河川'
      f["tippecanoe"] = tippecanoe
      f["properties"].delete("rID")
      f["properties"].delete("lfSpanFr")
      f["properties"].delete("lfSpanTo")
      w.print JSON::dump(f), "\n"
      count += 1
      report(count, dict) if count % 10000 == 0
    }
  rescue
    print "\nerror in #{path}: #{$!}\n"
  end
}
w.close
