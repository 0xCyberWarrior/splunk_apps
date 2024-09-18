take_date=$(date +"%Y-%m-%d %H:%M:%S")

input_file="/opt/splunk/etc/apps/facebook_ads_monitoring/lookups/fb_adArchiveID.csv"
temp_file="/opt/splunk/etc/apps/facebook_ads_monitoring/bin/test.txt"
output_file="/opt/splunk/etc/apps/facebook_ads_monitoring/lookups/fb_takedown.csv"



IFS=','

tail -n +2 "$input_file" | while IFS=',' read -r adArchiveID title found_date isActive isRelated isTakendown takendown_date

do
if [[ "$isActive" == "true" ]] && [[ "$isRelated" == "true" ]] && [[ "$isTakendown" != "true" ]]; then
curl 'https://www.facebook.com/ads/library/?id='"$adArchiveID" \
  -H 'authority: www.facebook.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: datr=QXxtZDT9LjvE4D7O4sbTpFKP; dpr=1.25; fr=0I2pj3RUMXLmWF75o..BkbYqX.ac.AAA.0.0.BkbYqX.AWUgKutrogE; sb=l4ptZCA9XZPQLVsH-AaTuvb4; wd=1284x722' \
  -H 'sec-ch-ua: "Google Chrome";v="113", "Chromium";v="113", "Not-A.Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: none' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' \
  --compressed | if grep -q "isActive"; then

echo "$adArchiveID","$found_date","$isActive","$isRelated",,

else


echo "$adArchiveID","$found_date","$isActive","$isRelated","true","$take_date"

fi

fi

done   > "$temp_file"


#sed -i '1d' "$temp_file"
header="adArchiveID,found_date,isActive,isRelated,isTakendown,takendown_date"

{ echo "$header"; cat "$temp_file"; } > "$output_file"


#rm "$temp_file"

