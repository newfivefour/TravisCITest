# Get the latest app uploads
curl -H "X-HockeyAppToken: $HOCKEYAPP_TOKEN" \
"https://rink.hockeyapp.net/api/2/apps/e1e4c963ad144f23a8787ac79c3d1954/app_versions?page=1" | \
# Put every property on a separate line
sed 's/,/\n/g' | \
# Remove all the quotation marks
sed 's/"//g' | \
# Look at only the notes properties
grep notes | \
# Look at the first one, i.e. the latest app upload
head -n 1 | \
# Find the commit information at the bottom of the notes
sed -n 's/.*(commit:\([^)]*\)).*/\1/p' | \
# Let's find all the logs since that commit
xargs -I '{}' git log {}..HEAD --pretty=format:'%s' --no-merges | \
# Turn this newlines into <br>s since we need to pass this all as one line
sed ':a;N;$!ba;s/\n/<br><br>* /g'
# The end of the revision log must have the latest commit
# This is so later we can do the above again
echo -n "<br>(commit:" 
git rev-parse HEAD | xargs echo -n
echo -n ')'
