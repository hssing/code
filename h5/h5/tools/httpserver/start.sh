dst=web/
dirs=`ls -l ../../egret/bin-release/web/  | grep -o "[[:digit:]]\{12\}$" | tail -n 1`
src=`echo ../../egret/bin-release/web/`${dirs}
rm -rf ${dst}
cp -rf ${src} ${dst}

dresource=`echo ../../egret/dresource/`
cp -rf ${dresource} ${dst}
node http.js
