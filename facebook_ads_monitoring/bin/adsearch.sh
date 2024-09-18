#!/bin/bash

search_value='"adArchiveID"'
file="/opt/splunk/etc/apps/facebook_ads_monitoring/local/output.txt"



IFS=','
tail -n +2 /opt/splunk/etc/apps/facebook_ads_monitoring/lookups/fb_keyword | grep "TRUE" | while IFS=',' read -r keyword monitoring status
do
modified_keyword=$(echo "$keyword" | sed 's/ /%20/g')







curl -k -s    'https://www.facebook.com/ads/library/async/search_ads/?q='"$modified_keyword"'&verify=acb11268&forward_cursor=AQHRUGC9ZvUIPGyScassjyubOt0KU9mDMC_HYyqxqYn65B4OlJt--wbzoRtDeXstmgPs&backward_cursor=&session_id=da32ff3a-6910-403d-8333-03fd47ae17a2&collation_token=30fff301-82e9-4105-9a4b-12becde8dd06&count=20&active_status=all&ad_type=all&countries\[0\]=AU&media_type=all&sort_data\[direction\]=desc&sort_data\[mode\]=relevancy_monthly_grouped&search_type=keyword_exact_phrase' \
  -H 'accept: */*' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'cookie: datr=EcAjZdXaY6de2bQ9-cpM8uim; sb=bQxfZf4GwJDjfOx09YU7CUmL; ps_n=0; dpr=1.25; locale=en_GB; fr=0T5LnXEKgJGigHCtr..BlqJKf..AAA.0.0.BmDghp.AWX77A0fCig; wd=747x1076' \
  -H 'dpr: 1.25' \
  -H 'origin: https://www.facebook.com' \
  -H 'referer: https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=AU&q='"$modified_keyword"'&sort_data[direction]=desc&sort_data[mode]=relevancy_monthly_grouped&search_type=keyword_exact_phrase&media_type=all' \
  -H 'sec-ch-prefers-color-scheme: light' \
  -H 'sec-ch-ua: "Google Chrome";v="123", "Not:A-Brand";v="8", "Chromium";v="123"' \
  -H 'sec-ch-ua-full-version-list: "Google Chrome";v="123.0.6312.106", "Not:A-Brand";v="8.0.0.0", "Chromium";v="123.0.6312.106"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-model: ""' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-ch-ua-platform-version: "10.0.0"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  -H 'viewport-width: 747' \
  -H 'x-asbd-id: 129477' \
  -H 'x-fb-lsd: AVql9nOLQRM' \
  --data-raw '__aaid=0&__user=0&__a=1&__req=6h&__hs=19818.BP%3ADEFAULT.2.0..0.0&dpr=1.5&__ccg=GOOD&__rev=1012541076&__s=wm278g%3Ad2zeb5%3Avez9fe&__hsi=7354174362370977666&__dyn=7xeUmxa3-Q8zo5ObwKBAgc9o9E6u5U4e1FxebzEdF8ixy7EiwvoWdwJwCwfW7oqx60Vo1upEK12wvk1bwbG78b87C2m3K2y11wBz81s8hwGwQwoE2LwBgao884y0Mo6i588Egze2a5E5afK1LwPxe3C0D8sKUbobEaUiyE725U4q0HUkyE1bobodEGdw46wbLwrU6C2-0z85C1Iwqo1187i&__csr=&lsd=AVql9nOLQRM&jazoest=2934&__spin_r=1012541076&__spin_b=trunk&__spin_t=1712277150&__jssesw=1' 
done  >  "$file"




sed -i 's/for (;;);{"__ar":1,"payload":/\n/g'  "$file"
sed -i 's/},{"adid":"0"/}\n{"adid":"0"/g'  "$file"
sed -i 's/}\],\[{/}\n{/g'  "$file"
cat "$file"
rm "$file"
